
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../api/api_end_points.dart';
import '../../constants/img_font_color_string.dart';
import 'chat_route_screen.dart';

class PartnerModel{
  String? name;
  String? userprofile;
  String? email;
  String? token;
  String? status;

  PartnerModel({
    this.name,
    this.userprofile,
    this.email,
    this.token,
    this.status
  });
}

class BookingChatScreen extends StatefulWidget {
  const BookingChatScreen({Key? key, required this.documentID, required this.userId}) : super(key: key);
  final String  documentID;
  final String userId;

  @override
  State<BookingChatScreen> createState() => _BookingChatScreenState();
}

class _BookingChatScreenState extends State<BookingChatScreen> with WidgetsBindingObserver {
 final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 final ScrollController _scrollController = ScrollController();
  
  var messageController = TextEditingController();
  bool isClicked = false;
  late CameraPosition _cameraPosition;
   GoogleMapController? _controller;

  String partnerName = "";
  
  Rx<PartnerModel> _partnermodel = PartnerModel().obs;
  Rx<PartnerModel> _customerModel = PartnerModel().obs;

  @override
  void initState() {
    super.initState();
    getPartnerName();
    _cameraPosition = const CameraPosition(target: LatLng(21.2012298, 72.793696), zoom: 18.0);
  }

  Future getcustomerToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    await messaging.getToken().then((value) async {
      if (value != null) {
        await _firestore.collection(BookingCollectionName()).doc(widget.documentID).update({'customerToken': value.toString()});
      }
    });
  }

  getCustomerName () async {
    var checking = await  _firestore.collection(BookingCollectionName()).doc(widget.documentID).get();
    Map<String,dynamic> itemData = checking.data() as Map<String,dynamic>;
    //debugPrint("Custpmer Data ::: ${itemData['customerPhone']}\n ${itemData['customerName']} \n ${itemData['cutsomerProfile']}\n ${itemData['booking_status']} \n ${itemData['customerToken']}");
    _customerModel.value = PartnerModel(
      email: itemData['customerPhone'],
      name: itemData['customerName'],
      userprofile: itemData['cutsomerProfile'],
      token: itemData['customerToken'],
      status:itemData["booking_status"]
    );
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);  
    }
  }

  getPartnerName () async {
    var checking = await  _firestore.collection(BookingCollectionName()).doc(widget.documentID).get();
    Map<String,dynamic> itemData = checking.data() as Map<String,dynamic>;
    // debugPrint("GET DATA :::: $itemData");
    
     _partnermodel.value = PartnerModel(
      email: itemData['partnerPhone'],
      name: itemData['partnerName'],
      userprofile: itemData['partnerProfile'],
      token: itemData['partnerToken'],
      status:itemData['booking_status']
    );
    getCustomerName();
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
  
  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    _scrollController.dispose();
  }
  
  readMessageFunction() async {
    //debugPrint("CHAT DOCUMENT ID ::: ${widget.documentID}");
    //debugPrint("PRovider ID ::: ${widget.documentID.split("_")[2]}");
    // debugPrint("CHAT USER ID ::: ${widget.userId}");
   // debugPrint("LEngth ::: ${collection.where('isRead', isNotEqualTo: "true")}");
    var collection = _firestore.collection(BookingCollectionName()).doc(widget.documentID).collection("chats");
    var querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      var itemData = doc.data();
      if (itemData['sendBy'] == widget.documentID.split("_")[2].toString() && itemData['isRead'] == "false") {
      //  debugPrint("MAtched ::: ${doc.id} ::: ${itemData['sendBy']} ::: ${itemData['isRead']}");
        collection.doc(doc.id).update({"isRead": "true"});
      } 

      int partnercount = 0;
      int customerCount = 0;

      final QuerySnapshot qSnap = await collection.where('isRead', isNotEqualTo: "true").get();
      final int documents = qSnap.docs.length;
      
    //  debugPrint("GET Legth Customer ::: $documents");
      
      if (itemData['sendBy'] == widget.userId) {
        customerCount = 0;
      } else {
        partnercount = documents;
        _firestore.collection(BookingCollectionName()).doc(widget.documentID).update({
        "partner_last_msg": partnercount.toString(),
        "customer_last_msg": customerCount.toString()
      });
      }
     
    }
  }

  sendnotification(String id,String title,String body) async {
    var  serverKey = "AAAA4eH5VG4:APA91bFYlpKuYG97vJTPjJ8SZ7sws_Ao-COfUv4ZQW1w9ktsuieZz4Vj0sQ8-azRoqS3k-ZxnYeEG7buyi2ZgLRM0wYQuUzpGPCQAla5aheoc_GOFGxlLuCXoC_XWRzutiI9NYWkj5jT";
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            "collapse_key": title,
           // "group_id": id,
           // "group_name": title,
           'payload': body,
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': id,
              'status': _partnermodel.value.status,
            },
            "to": _partnermodel.value.token,
          },
        )
      );
    } catch (e) {
      debugPrint("error push notification $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_partnermodel.value.status == "complete" || _partnermodel.value.status == "review" || _partnermodel.value.status ==  "reviewed") {
      debugPrint("Status ::: ${_partnermodel.value.status}");
      Get.back();
    } else {
      debugPrint("Else Status :: ${_partnermodel.value.status}");
    }
    readMessageFunction();
    var size = MediaQuery.of(context).size;
    
    return Obx(()=>
      Scaffold(
        backgroundColor: custWhite,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
            title: Text(_partnermodel.value.name ?? "", style: const TextStyle(color: Color(0xff292929))),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              // PopupMenuButton(
              //   itemBuilder: (context)=> [
              //     const PopupMenuItem(
              //       child: Text("Hello"),
              //       value: '/hello',
              //     )
              //   ],
              //   icon: Icon(Icons.more_vert_outlined,color: custBlack),
              // ), 
              // Padding(
              //   padding: const EdgeInsets.only(right: 10.0),
              //   child: IconButton(
              //     onPressed: ()=> profiledialog(size,_partnermodel),
              //     icon: Icon(Icons.account_circle,color: custBlack,size: 33)
              //   ),
              // )
              Padding(
                padding: const EdgeInsets.only(right: 10.0,top: 3,bottom: 3),
                child: GestureDetector(
                  onTap: ()=> {FocusScope.of(context).unfocus(),profiledialog(size,_partnermodel.value)},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _partnermodel.value.userprofile ?? "",
                      width: 50,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        ImgName.imgPlaceholder,
                        width: 50,
                        fit: BoxFit.fill
                      )
                    )
                  )
                )
              )
            ]
        ),
        bottomNavigationBar: SafeArea(child: messageCommonWidget(size)),
        body: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection(BookingCollectionName()).doc(widget.documentID).collection("chats").orderBy("time",descending: false).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return GroupedListView<QueryDocumentSnapshot,dynamic>(
                  elements: snapshot.data!.docs,
                 groupBy: (element) {
                  if (element['time'] == null) {
                    return DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
                  } else {
                    return DateTime((element['time'] as Timestamp).toDate().year,(element['time'] as Timestamp).toDate().month,(element['time'] as Timestamp).toDate().day);
                  }
                },
                groupSeparatorBuilder: (groupByValue) {
                  var previousDate = DateFormat("dd-MM-yyyy").format(DateTime.now().subtract(const Duration(days: 1)));
                  var staticString = "";
                  if (groupByValue != null) {
                    if (DateFormat("dd-MM-yyyy").format(groupByValue) == DateFormat("dd-MM-yyyy").format(DateTime.now())) {
                      staticString = "Today";
                    } else if (DateFormat("dd-MM-yyyy").format(groupByValue) == previousDate) {
                      staticString  = "Yesterday"; 
                    } else if (groupByValue.isBefore(DateTime.now())) {
                      staticString = DateFormat("dd-MM-yyyy").format(groupByValue).toString();
                    } else if (groupByValue.isAfter(DateTime.now())) {
                      staticString = DateFormat("dd-MM-yyyy").format(groupByValue)..toString();
                    } else {
                      staticString = DateFormat("dd-MM-yyyy").format(groupByValue).toString();
                    }
                  }
                  return ActionChip(
                      disabledColor: custGrey.withOpacity(0.1),
                      backgroundColor: custGrey.withOpacity(0.1),
                      padding: EdgeInsets.zero,
                      onPressed: null,
                      label: Text(
                        "  $staticString  ", 
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: 'Montserrat', 
                          fontSize: 11,
                          color: custBlack,
                          fontWeight: FontWeight.w500
                        )
                      ) 
                    );
                  },
                 controller: _scrollController,
                  reverse: false,
                  shrinkWrap: true,
                  useStickyGroupSeparators: true, // optional
                  floatingHeader: true, 
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  itemBuilder: (context, element) {
                    Map<String,dynamic> itemData = element.data() as Map<String,dynamic>;
                    return messageTile(size, itemData);
                  },          
                );
              }
            }
          )
      ),
    );
  }

  profiledialog (Size size ,model) {
    //debugPrint("Profile PIC ::: ${model.userprofile}");
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
         title: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: ()=> Navigator.pop(context), child: Icon(Icons.cancel,color: custGrey.withOpacity(0.5))
          ),
         ),
         content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                  model.userprofile ?? "",
                  height: 100,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    ImgName.imgPlaceholder,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.02),

            SizedBox(
              width: double.infinity,
              child: Text(
                StaticString.name,
                textAlign: TextAlign.left,
                style: TextStyle(fontFamily: 'Montserrat', color: custlightBlack, fontSize: 15),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Container(
              width: double.infinity,
              // margin: const EdgeInsets.only(left: 33, right: 33),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10, right: 10),
              height: 60.0,
              decoration: BoxDecoration(
                color: const Color(0xffF6F6F6),
                borderRadius: BorderRadius.circular(12.0)
              ),
              child: TextFormField(
                readOnly: true,
                initialValue: model.name ?? "",
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            SizedBox(
              width: double.infinity,
              child: Text(
                StaticString.phoneNo,
                textAlign: TextAlign.left,
                style: TextStyle(fontFamily: 'Montserrat', color: custlightBlack, fontSize: 15),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Container(
              width: double.infinity,
              // margin: const EdgeInsets.only(left: 33, right: 33),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10, right: 10),
              height: 60.0,
              decoration: BoxDecoration(
                color: const Color(0xffF6F6F6),
                borderRadius: BorderRadius.circular(12.0)
              ),
              child: TextFormField(
                readOnly: true,
                initialValue: model.email ?? "",
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                )
              )
            )
          ]
        )
      ),
    );
  }

  Widget messageCommonWidget(Size size) {
    return AnimatedPadding(
      duration: const Duration(milliseconds:400),      
      padding: MediaQuery.of(context).viewInsets,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutBack,
         height: size.height * 0.06,
      //  alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: size.height * 0.015),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
         //color: Colors.amber.shade300,
          color: const Color(0xffF6F6F6),
          border: Border.all(color: Colors.black54, width: 0.0),
          borderRadius: BorderRadius.circular(size.width * 0.01)
        ),
        child:
         Row(
          children: [
            Expanded(
              child: TextField(
                controller: messageController,
                textInputAction: TextInputAction.newline,
                enableInteractiveSelection: true,
                autocorrect: true,
                //autofocus: true,
                minLines: 1,
                maxLines: null,
                decoration: const InputDecoration(
                //  filled: true,
                 // fillColor: const Color(0xffF6F6F6),
                  //contentPadding: EdgeInsets.all(size.height * 0.01),
                  // border: OutlineInputBorder(
                  //   borderSide: const BorderSide(color: Colors.black54,width: 0.0),
                  //   borderRadius: BorderRadius.circular(size.width * 0.01)
                  // ),
                  // focusedBorder: OutlineInputBorder(
                  //   borderSide: const BorderSide(color: Colors.black54,width: 0.0),
                  //   borderRadius: BorderRadius.circular(size.width * 0.01)
                  // ),

                  // enabledBorder: OutlineInputBorder(
                  //   borderSide: const BorderSide(color: Colors.black54,width: 0.0),
                  //   borderRadius: BorderRadius.circular(size.width * 0.01)
                  // ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  // contentPadding: EdgeInsets.only(left: 15, right: 15),
                  hintText: "Type your message",
                ),    
                scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                onTap: (){
                 //_scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                    if (!(_scrollController.offset == _scrollController.position.maxScrollExtent)) {
                      _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds:400),
                      curve: Curves.easeInOut
                    );
                  }                        
                }
              ),
            ),
            InkWell(
              onTap:() {
                if (!isClicked){
                  isClicked = true;
                  onMessageSend().then((value) => isClicked = false);
                }
              },
              child: Icon(Icons.send,color: custlightBlue, size: size.height * 0.03)
            ),
          ],
        ),
     
     
        // ListTile(
        //   title: TextField(
        //     controller: messageController,
        //     textInputAction: TextInputAction.newline,
        //    minLines: 5,
        //     maxLines: null,
        //     decoration: const InputDecoration(
        //       border: InputBorder.none,
        //       focusedBorder: InputBorder.none,
        //       enabledBorder: InputBorder.none,
        //       errorBorder: InputBorder.none,
        //       disabledBorder: InputBorder.none,
        //       // contentPadding: EdgeInsets.only(left: 15, right: 15),
        //       hintText: "Type your message"
        //     ),
        //   ),
        //   trailing: InkWell(
        //     onTap:() {
        //        if (!isClicked){
        //           isClicked = true;
        //           onMessageSend().then((value) => isClicked = false);
        //         }
        //     },
        //     child: Icon(Icons.send,color: custlightBlue,size: size.height * 0.03)
        //   ),
        // ),
      ),
    );
  }

  Future onMessageSend() async {
    if (messageController.text.trim().isNotEmpty) {
      Map<String,dynamic> message = {                                                          
        "sendBy" : widget.userId,
        "message": messageController.text.trim(),
        "type": "text",
        "isRead": "false",
        "time": FieldValue.serverTimestamp(),
      }; 
      await _firestore.collection(BookingCollectionName()).doc(widget.documentID).collection("chats").add(message);
      sendnotification(widget.documentID, _customerModel.value.name ?? widget.documentID,messageController.text);
      messageController.clear();
      FocusScope.of(context).unfocus();
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 800), curve: Curves.fastOutSlowIn);
    } 
    // else {
    //   Get.snackbar(
    //     "Alert", // title
    //     "Please type your message", // message
    //     backgroundColor:const Color(0xffFFCC00),
    //     colorText: Colors.white,
    //     icon: const Icon(Icons.error,
    //       color:  Colors.white,
    //     ),
    //     onTap: (_) {},
    //     shouldIconPulse: true,
    //     barBlur: 10,
    //     isDismissible: true,
    //     duration: const Duration(seconds: 3),
    //   );
    // }
  }

  Widget messageTile(Size size, Map<String,dynamic> chatmap) {
    var currentUser = widget.userId;
    var radius20 = const Radius.circular(20);
    var custgreyCustom = custGrey.withOpacity(0.2);
    var changetext = chatmap["message"].toString().replaceAll("[NEWLINE]","\n");
    return Builder(builder: (_){
      if (chatmap["type"] ==  "text") {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              Container(
                width: size.width,
                alignment: chatmap['sendBy'] == currentUser ? Alignment.centerRight : Alignment.centerLeft,
                margin: const EdgeInsets.all(5.0),
                child: Container(
                  margin: EdgeInsets.only(left: chatmap['sendBy'] == currentUser ? 40 : 0,
                  right:  chatmap['sendBy'] == currentUser ? 0 : 40),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color:chatmap['sendBy'] == currentUser ? custlightBlue : custgreyCustom,
                    borderRadius: BorderRadius.only(
                      topLeft: radius20,
                      topRight: radius20,
                      bottomLeft: chatmap['sendBy'] == currentUser ? radius20 : Radius.zero,
                      bottomRight: chatmap['sendBy'] == currentUser ? Radius.zero : radius20,
                    ),
                  ),
                  child: Text(
                    changetext,
                    style: TextStyle(
                      fontWeight:chatmap['sendBy'] == currentUser ? FontWeight.w500 : FontWeight.w400,
                      fontFamily: 'Montserrat', 
                      color:chatmap['sendBy'] == currentUser ? custWhite : custLightBlack, 
                      fontSize: 16
                    )
                ),
                ), 
              ),
              if (chatmap['time'] != null) ...[
                // Align(
                //   alignment:  chatmap['sendBy'] == currentUser ? Alignment.centerRight :Alignment.centerLeft,
                //   child: Text(
                //     "    ${DateFormat('hh:mm a').format(((chatmap['time'] as Timestamp).toDate()))}    ",
                //     style: TextStyle(fontFamily: 'Montserrat', fontSize: 11,color: custGrey)
                //   ),
                // ),
                Row(
                 mainAxisAlignment: chatmap['sendBy'] == currentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Text(
                      "    ${DateFormat('hh:mm a').format(((chatmap['time'] as Timestamp).toDate()))}    ",
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 11,color: custGrey)
                    ),
                    
                    if (chatmap['sendBy'] == currentUser)...[
                      if (chatmap['isRead'] == "true") ...[
                        Icon( Icons.done_all,color: custlightBlue, size: 18)
                      ] else if (chatmap['isRead'] == "false" )...[
                        Icon( Icons.done_all,color: custGrey, size: 18)
                      ] else...[
                        Icon(Icons.done,color: custGreyDark, size: 18)
                      ],
                    ],
                  ],
                ),
              ]
            ],
          ),
        );
      } else if (chatmap["type"] == "img") {
        return Container(
        //  width: size.width * 0.50,
          height: size.height * 0.25,
          alignment: chatmap['sendBy'] == currentUser ? Alignment.centerRight : Alignment.centerLeft,
          margin: const EdgeInsets.all(5.0),
          child: Container(
            width: size.width * 0.50,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.blue.shade300,),
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child:  Image.network(chatmap["message"],fit: BoxFit.cover,),
            ),
          ), 
        );
      } else if (chatmap["type"] == "notify") {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: Divider(color: custgreyCustom,thickness: 1)),
              Container(
               //height: size.height * 0.0,
               padding: const EdgeInsets.all(8.0),
               margin: const EdgeInsets.symmetric(horizontal: 8.0),
                //  color: Colors.grey,
                decoration: BoxDecoration(
                  border: Border.all(color: custgreyCustom),
                  borderRadius: BorderRadius.circular(size.height * 0.03)
                ),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      chatmap['message'],
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 12,color: custGrey)),
                    if (chatmap['time'] != null) ...[
                    Text(
                      DateFormat('hh:mm a').format(((chatmap['time'] as Timestamp).toDate())),
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 11,color: custGrey)
                      )
                    ]
                  ],
                ),
                //  Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Expanded(child: DottedLine(dashColor: custGrey,)),
                //     Padding(
                //       padding: const EdgeInsets.symmetric(horizontal:8.0),
                //       child: Column(
                //         children: [
                //           Text(chatmap['message'],style: TextStyle(fontFamily: 'Montserrat', fontSize: 12,color: custGrey)),
                //           if (chatmap['time'] != null) ...[
                //           Text(
                //             "    ${DateFormat('hh:mm a').format(((chatmap['time'] as Timestamp).toDate()))}    ",
                //               style: TextStyle(fontFamily: 'Montserrat', fontSize: 11,color: custGrey)
                //             )
                //           ]
                //         ],
                //       ),
                //     ),
                //     Expanded(child: DottedLine(dashColor: custGrey,)),
                //   ],
                // ),
       
              ),
              Expanded(child: Divider(color: custgreyCustom,thickness: 1)),
            ],
          ),
        );
      } else if (chatmap["type"] == "map") {
        _cameraPosition = CameraPosition(target: LatLng(
        double.parse(chatmap["message"].toString().split("query=").last.split(',').first), 
        double.parse(chatmap["message"].toString().split("query=").last.split(',').last)),zoom: 18.0);
       
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              Align(
                alignment: chatmap['sendBy'] == currentUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  height:  size.height * 0.20,
                  width: size.width * 0.75,
                  decoration: BoxDecoration(
                    color: chatmap['sendBy'] == currentUser ? custlightBlue : custgreyCustom,
                    borderRadius: BorderRadius.only(
                      topLeft: radius20,
                      topRight: radius20,
                      bottomLeft: chatmap['sendBy'] == currentUser ? radius20 : Radius.zero,
                      bottomRight: chatmap['sendBy'] == currentUser ? Radius.zero : radius20,
                    ),
                  ),
                 padding: const EdgeInsets.all(8.0),
                  child: _cameraPosition != null || (_cameraPosition.target.latitude != null && _cameraPosition.target.longitude != null) ? GestureDetector(
                    onTap: () async{
                   // var iniitLatLng =  LatLng(
                      // double.parse(chatmap["message"].toString().split("query=").last.split(',').first), 
                      // double.parse(chatmap["message"].toString().split("query=").last.split(',').last)
                      // );
                      debugPrint("Latutude ::: ${_cameraPosition.target.latitude}}");
                      debugPrint("Longitude ::: ${_cameraPosition.target.longitude}");
                   //  Get.to(()=> ChatRouteScreen(latitude:_cameraPosition.target.latitude,longitude: _cameraPosition.target.longitude));
                      var url = "https://www.google.com/maps/search/?api=1&query=${_cameraPosition.target.latitude},${_cameraPosition.target.longitude}";
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else {
                        Get.snackbar(
                          "Alert",
                          "Something went wrong",
                          backgroundColor:Colors.amber.shade600,
                          colorText: Colors.white,
                          icon: const Icon(Icons.error,color:  Colors.white),
                          shouldIconPulse: true,
                          barBlur: 10,
                          isDismissible: true,
                          duration: const Duration(seconds: 2)
                        );
                      }

                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(radius20),
                      child: AbsorbPointer(
                        absorbing: true,
                        child:GoogleMap(
                          initialCameraPosition: _cameraPosition,
                          zoomControlsEnabled: false,
                          onMapCreated: (GoogleMapController controller) {
                            _controller = controller;
                            _controller?.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                          },
                          markers: Set.of({
                            Marker(
                              markerId: const MarkerId("1"),
                              position: LatLng(_cameraPosition.target.latitude, _cameraPosition.target.longitude))}),
                        )
                      )
                    ),
                  )
                  : Container(
                    decoration: BoxDecoration(
                    color: chatmap['sendBy'] == currentUser ? custlightBlue : Colors.grey,
                    borderRadius: BorderRadius.all(radius20),
                  ),
                  ),
                ),
              ),
              if (chatmap['time'] != null) ...[
                // Align(
                //   alignment: chatmap['sendBy'] == currentUser ? Alignment.centerRight : Alignment.centerLeft,
                //   child: Text(
                //     "    ${DateFormat('hh:mm a').format(((chatmap['time'] as Timestamp).toDate()))}    ",
                //       style: TextStyle(fontFamily: 'Montserrat', fontSize: 11,color: custGrey)
                //     ),
                //   )

                  Row(
                    mainAxisAlignment: chatmap['sendBy'] == currentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Text(
                        "    ${DateFormat('hh:mm a').format(((chatmap['time'] as Timestamp).toDate()))}    ",
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 11,color: custGrey)
                      ),

                      if (chatmap['sendBy'] == currentUser)...[
                        if (chatmap['isRead'] == "true") ...[
                          Icon( Icons.done_all,color: custlightBlue, size: 18)
                        ] else if (chatmap['isRead'] == "false" )...[
                          Icon( Icons.done_all,color: custGrey, size: 18)
                        ] else...[
                          Icon( Icons.done,color: custGreyDark, size: 18)
                        ],
                      ]
                    ],
                  ),
                ]
           
            ],
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}