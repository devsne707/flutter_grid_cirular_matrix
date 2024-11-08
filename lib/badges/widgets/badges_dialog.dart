import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mqs_content_portal/constants/constants.dart';
import 'package:mqs_content_portal/features/badges/badges.dart';
import 'package:mqs_content_portal/features/badges/bloc/badges_bloc.dart';
import 'package:mqs_content_portal/helper/validators.dart';
import 'package:mqs_content_portal/service/service.dart';
import 'package:mqs_content_portal/widgets/widgets.dart';
import 'package:super_extensions/super_extensions.dart';

///Delete Dialog
Future badgesDeleteDialog(
    BuildContext context, MqsBadge item, BadgesBloc bloc) {
  final GlobalKey<FormState> badgeKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
          backgroundColor: ColorConstants.kW0White,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.screenHeight * .01),
          ),
          title: Text(
            StringConstants.badges,
            style: StyleConstants.kAppTextFieldText.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorConstants.kAppBoilerPlateColor),
          ),
          content: Form(
            key: badgeKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text.rich(
                    maxLines: 2,
                    TextSpan(
                      text: StringConstants.deleteDialogTxt,
                      //(StringConstants.badgeName),
                      style: StyleConstants.kAppTextFieldText.copyWith(
                        color: ColorConstants.kAppBoilerPlateColor,
                      ),
                      children: [
                        TextSpan(
                          text: item.mqsBadgeName,
                          style: StyleConstants.kAppTextFieldText.copyWith(
                              color: ColorConstants.kG4AppPaletteGreen,
                              fontWeight: FontWeight.bold),
                        ),
                        // TextSpan(
                        //   text: '?',
                        //   style: StyleConstants.kAppTextFieldText.copyWith(
                        //     color: ColorConstants.kAppBoilerPlateColor,
                        //   ),
                        // ),
                      ],
                    )),
                const SizedBox(height: 8.0),
                MqsTextField(
                  width: context.screenWidth * .5,
                  controller: titleController,
                  hintText: StringConstants.activityTitle,
                  validator: (value) {
                    if (value != item.mqsBadgeName) {
                      return "Invalid ${StringConstants.activityTitle}";
                    }
                    return null;
                  },
                )
              ],
            ),
          ),
          actions: [
            MqsElevatedButton(
              onPressed: () {
                context.pop();
              },
              backgroundColor: ColorConstants.kG4AppPaletteGreen,
              child: Text(
                StringConstants.cancel,
                style: StyleConstants.kAppTextFieldText
                    .copyWith(color: ColorConstants.kW0White),
              ),
            ),
            MqsElevatedButton(
              onPressed: () {
                if (badgeKey.currentState!.validate()) {
                  bloc.add(
                    DeleteBadgesEvent(badge: item),
                  );
                  context.pop();
                }
              },
              backgroundColor: ColorConstants.kAppAccent,
              child: Text(
                StringConstants.delete,
                style: StyleConstants.kAppTextFieldText.copyWith(
                  color: ColorConstants.kW0White,
                ),
              ),
            ),
          ]);
    },
  );
}

Future badgesUpdateDialog(BuildContext context, BadgesBloc bloc) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
          backgroundColor: ColorConstants.kW0White,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.screenHeight * .01),
          ),
          title: Text(
            StringConstants.badges,
            style: StyleConstants.kAppTextFieldText.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorConstants.kAppBoilerPlateColor),
          ),
          content: Text.rich(
              maxLines: 2,
              TextSpan(
                text: StringConstants.updateDialogTxt,
                style: StyleConstants.kAppTextFieldText.copyWith(
                  color: ColorConstants.kAppBoilerPlateColor,
                ),
                children: [
                  TextSpan(
                    text: bloc.state.badgesActivityId,
                    style: StyleConstants.kAppTextFieldText.copyWith(
                        color: ColorConstants.kG4AppPaletteGreen,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '?',
                    style: StyleConstants.kAppTextFieldText.copyWith(
                      color: ColorConstants.kAppBoilerPlateColor,
                    ),
                  ),
                ],
              )),
          actions: [
            MqsElevatedButton(
              onPressed: () {
                bloc.add(UpdateBadgeIDControllerEvent(
                    badgeID: customIDValueSet(
                        name: 'BG', idValue: (bloc.state.totalBadges + 1))));
                bloc.add(const UpdateBadgeNameControllerEvent(badgeName: ""));
                bloc.add(const UpdateBadgeDescriptionControllerEvent(
                    badgeDescription: ""));
                bloc.add(const UpdateBadgeImgControllerEvent(badgeImg: ""));
                bloc.add(const UpdateBadgeAboutControllerEvent(aboutBadge: ""));
                bloc.add(const ChangeBadgeAssignedEvent(
                    changed: BadgesAssign.badgesAssigned));
                bloc.add(const UpdateBtnChangedBadgesEvent(
                    updateChanged: StringConstants.add));
                context.pop();
              },
              backgroundColor: ColorConstants.kAppAccent,
              child: Text(
                StringConstants.no,
                style: StyleConstants.kAppTextFieldText
                    .copyWith(color: ColorConstants.kW0White),
              ),
            ),
            MqsElevatedButton(
              onPressed: () {
                context.pop();
              },
              backgroundColor: ColorConstants.kG4AppPaletteGreen,
              child: Text(
                StringConstants.yes,
                style: StyleConstants.kAppTextFieldText.copyWith(
                  color: ColorConstants.kW0White,
                ),
              ),
            ),
          ]);
    },
  );
}

Future badgeUpdateSaveDialog(BuildContext context, String badgesId,
    MqsBadge oldBadges, MqsBadge item, BadgesBloc bloc) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
          backgroundColor: ColorConstants.kW0White,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.screenHeight * .01),
          ),
          title: Text(
            StringConstants.badges,
            style: StyleConstants.kAppTextFieldText.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorConstants.kAppBoilerPlateColor),
          ),
          content: Text.rich(
              maxLines: 2,
              TextSpan(
                text: StringConstants.updateSaveTxt,
                style: StyleConstants.kAppTextFieldText.copyWith(
                  color: ColorConstants.kAppBoilerPlateColor,
                ),
              )),
          actions: [
            MqsElevatedButton(
              onPressed: () {
                bloc.add(UpdateBadgeIDControllerEvent(badgeID: item.id));
                bloc.add(UpdateBadgeNameControllerEvent(
                    badgeName: item.mqsBadgeName));
                bloc.add(UpdateBadgeDescriptionControllerEvent(
                    badgeDescription: item.mqsBadgeDescription));
                bloc.add(UpdateBadgeImgControllerEvent(
                    badgeImg: item.mqsBadgeImage));
                bloc.add(UpdateBadgeAboutControllerEvent(
                    aboutBadge: item.aboutBadge));
                bloc.add(ChangeBadgeAssignedEvent(
                    changed: item.mqsBadgeAssigned == true
                        ? BadgesAssign.badgesAssigned
                        : BadgesAssign.badgesNotAssigned));
                bloc.add(UpdateBtnChangedBadgesEvent(
                    updateChanged: StringConstants.update,
                    badgeActivity: item));
                context.pop();
              },
              backgroundColor: ColorConstants.kAppAccent,
              child: Text(
                StringConstants.discard,
                style: StyleConstants.kAppTextFieldText
                    .copyWith(color: ColorConstants.kW0White),
              ),
            ),
            MqsElevatedButton(
              onPressed: () {
                bloc.add(
                    UpdateBadgesEvent(badgesActivity: oldBadges, id: badgesId));

                Timer(const Duration(seconds: 1), () {
                  bloc.add(UpdateBadgeIDControllerEvent(badgeID: item.id));
                  bloc.add(UpdateBadgeNameControllerEvent(
                      badgeName: item.mqsBadgeName));
                  bloc.add(UpdateBadgeDescriptionControllerEvent(
                      badgeDescription: item.mqsBadgeDescription));
                  bloc.add(UpdateBadgeImgControllerEvent(
                      badgeImg: item.mqsBadgeImage));
                  bloc.add(UpdateBadgeAboutControllerEvent(
                      aboutBadge: item.aboutBadge));
                  bloc.add(ChangeBadgeAssignedEvent(
                      changed: item.mqsBadgeAssigned == true
                          ? BadgesAssign.badgesAssigned
                          : BadgesAssign.badgesNotAssigned));
                  context.pop();
                });
              },
              backgroundColor: ColorConstants.kG4AppPaletteGreen,
              child: Text(
                StringConstants.save,
                style: StyleConstants.kAppTextFieldText.copyWith(
                  color: ColorConstants.kW0White,
                ),
              ),
            ),
          ]);
    },
  ).then((value) => bloc.add(MatchedBadgeIdEvent(matchedId: item.id)));
}

Future badgesAddDialog(BuildContext context, MqsBadge item, BadgesBloc bloc) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
          backgroundColor: ColorConstants.kW0White,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.screenHeight * .01),
          ),
          title: Text(
            StringConstants.badges,
            style: StyleConstants.kAppTextFieldText.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorConstants.kAppBoilerPlateColor),
          ),
          content: Text(
            StringConstants.addDialogTxt,
            style: StyleConstants.kAppTextFieldText.copyWith(
              color: ColorConstants.kAppBoilerPlateColor,
            ),
          ),
          actions: [
            MqsElevatedButton(
              onPressed: () {
                bloc.add(UpdateBadgeIDControllerEvent(badgeID: item.id));
                bloc.add(UpdateBadgeNameControllerEvent(
                    badgeName: item.mqsBadgeName));
                bloc.add(UpdateBadgeDescriptionControllerEvent(
                    badgeDescription: item.mqsBadgeDescription));
                bloc.add(UpdateBadgeImgControllerEvent(
                    badgeImg: item.mqsBadgeImage));
                bloc.add(UpdateBadgeAboutControllerEvent(
                    aboutBadge: item.aboutBadge));
                bloc.add(UpdateBtnChangedBadgesEvent(
                    updateChanged: StringConstants.update,
                    badgeActivity: item));
                bloc.add(ChangeBadgeAssignedEvent(
                    changed: item.mqsBadgeAssigned == true
                        ? BadgesAssign.badgesAssigned
                        : BadgesAssign.badgesNotAssigned));
                context.pop();
              },
              backgroundColor: ColorConstants.kAppAccent,
              child: Text(
                StringConstants.no,
                style: StyleConstants.kAppTextFieldText
                    .copyWith(color: ColorConstants.kW0White),
              ),
            ),
            MqsElevatedButton(
              onPressed: () => context.pop(),
              backgroundColor: ColorConstants.kG4AppPaletteGreen,
              child: Text(
                StringConstants.yes,
                style: StyleConstants.kAppTextFieldText.copyWith(
                  color: ColorConstants.kW0White,
                ),
              ),
            ),
          ]);
    },
  );
}
