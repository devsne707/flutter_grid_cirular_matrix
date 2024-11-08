import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqs_content_portal/constants/constants.dart';
import 'package:mqs_content_portal/features/badges/badges.dart';
import 'package:mqs_content_portal/helper/validators.dart';
import 'package:mqs_content_portal/service/service.dart';
import 'package:mqs_content_portal/widgets/widgets.dart';
import 'package:super_extensions/super_extensions.dart';

//ignore: must_be_immutable
class AddBadgesFormWidget extends StatelessWidget {
  AddBadgesFormWidget({super.key, this.dialogShowing = false});
  final bool dialogShowing;

  final GlobalKey<FormState> _lAFormKey = GlobalKey<FormState>();

  TextEditingController badgeIdController = TextEditingController();
  final badgeIdFocusNode = FocusNode();

  TextEditingController nameController = TextEditingController();
  final nameFocusNode = FocusNode();

  final imageFocusNode = FocusNode();

  TextEditingController descriptionController = TextEditingController();
  final descriptionFocusNode = FocusNode();

  TextEditingController aboutController = TextEditingController();
  final aboutFocusNode = FocusNode();

  changeRadioBtn(BadgesAssign? badgesAssign, BuildContext context) {
    if (badgesAssign != null) {
      context
          .read<BadgesBloc>()
          .add(ChangeBadgeAssignedEvent(changed: badgesAssign));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BadgesBloc, BadgesState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        badgeIdController.text = state.badgesActivityId;
        nameController.text = state.badgeName;
        descriptionController.text = state.badgeDescription;
        aboutController.text = state.aboutBadge;
        return FocusScope(
          onKey: (node, event) {
            if (HardwareKeyboard.instance
                .isLogicalKeyPressed(LogicalKeyboardKey.tab)) {
              if (node.hasFocus && badgeIdFocusNode.hasFocus) {
                nameFocusNode.requestFocus();
              } else if (node.hasFocus && nameFocusNode.hasFocus) {
                imageFocusNode.requestFocus();
              } else if (node.hasFocus && imageFocusNode.hasFocus) {
                descriptionFocusNode.requestFocus();
              } else if (node.hasFocus && descriptionFocusNode.hasFocus) {
                aboutFocusNode.requestFocus();
              } else {
                FocusScope.of(context).unfocus();
              }
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: Form(
            key: _lAFormKey,
            child: ListBody(
              children: [
                const SizedBox(height: 20),
                Text(
                    (state.updateOnTaped.isNotEmpty &&
                            state.updateOnTaped == StringConstants.update)
                        ? StringConstants.updateDialogText(
                            StringConstants.badges)
                        : StringConstants.addDialogText(StringConstants.badges),
                    style: StyleConstants.kAppTextFieldText),
                const SizedBox(height: 20),
                MqsTextField(
                  width: context.screenWidth / 3,
                  readOnly: true,
                  isRounded: false,
                  controller: badgeIdController,
                  focusNode: badgeIdFocusNode,
                  hintText: StringConstants.badgeId,
                ),
                const SizedBox(height: 20),
                MqsTextField(
                  width: context.screenWidth / 3,
                  isRounded: false,
                  controller: nameController,
                  focusNode: nameFocusNode,
                  hintText: StringConstants.badgeName,
                  validator: (value) => commonEmptyField(value,
                      "${StringConstants.pleaseEnterText} ${StringConstants.badgeName}"),
                  onChanged: (value) {
                    context.read<BadgesBloc>().add(
                        (UpdateBadgeNameControllerEvent(badgeName: value)));
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<BadgesBloc, BadgesState>(
                  builder: (context, state) {
                    return UploadFileWidget(
                      hintText: StringConstants.badgeImg,
                      fileName: state.badgeImageFileName,
                      fileUrl: state.badgeImage,
                      isLoading: state.badgeImage.isEmpty &&
                          state.badgeImageFileName.isNotEmpty,
                      validator: (value) => commonEmptyField(value,
                          "${StringConstants.pleaseSelectText} ${StringConstants.badgeImg}"),
                      onTap: () {
                        context
                            .read<BadgesBloc>()
                            .add(const SelectBadgeImageEvent());
                      },
                      onClearPressed: () {
                        context
                            .read<BadgesBloc>()
                            .add(const ClearBadgeImageEvent());
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                MqsTextField(
                  width: context.screenWidth / 3,
                  isRounded: false,
                  controller: descriptionController,
                  focusNode: descriptionFocusNode,
                  maxLength: 500,
                  showCounter: true,
                  hintText: StringConstants.badgeDescription,
                  maxLines: 10,
                  validator: (value) => commonEmptyField(value,
                      "${StringConstants.pleaseEnterText} ${StringConstants.badgeDescription}"),
                  onChanged: (value) {
                    context.read<BadgesBloc>().add(
                        (UpdateBadgeDescriptionControllerEvent(
                            badgeDescription: value)));
                  },
                ),
                const SizedBox(height: 20),
                MqsTextField(
                  width: context.screenWidth / 3,
                  isRounded: false,
                  controller: aboutController,
                  focusNode: aboutFocusNode,
                  hintText: StringConstants.badgeAbout,
                  maxLength: 400,
                  maxLines: 10,
                  showCounter: true,
                  onChanged: (value) {
                    context.read<BadgesBloc>().add(
                        (UpdateBadgeAboutControllerEvent(aboutBadge: value)));
                  },
                ),
                // const SizedBox(height: 20),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Text(
                //       StringConstants.badgeAssign,
                //       style: StyleConstants.kAppHeaderTextStyle.copyWith(
                //         color: Colors.grey.shade600,
                //         fontSize: 16,
                //       ),
                //     ),
                //     SizedBox(
                //       width: context.screenWidth * .2,
                //       child: RadioListTile<BadgesAssign>(
                //         title: Text(
                //           StringConstants.yes,
                //           style: StyleConstants.kAppSubtitleTextStyle
                //               .copyWith(fontSize: 14, color: Colors.grey),
                //         ),
                //         value: BadgesAssign.badgesAssigned,
                //         groupValue: state.badgeChangeRadio,
                //         onChanged: (value) => changeRadioBtn(value, context),
                //       ),
                //     ),
                //     SizedBox(
                //       width: context.screenWidth * .2,
                //       child: RadioListTile<BadgesAssign>(
                //         title: Text(
                //           StringConstants.no,
                //           style: StyleConstants.kAppSubtitleTextStyle
                //               .copyWith(fontSize: 14, color: Colors.grey),
                //         ),
                //         value: BadgesAssign.badgesNotAssigned,
                //         groupValue: state.badgeChangeRadio,
                //         onChanged: (value) => changeRadioBtn(value, context),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MqsElevatedButton(
                      onPressed: () {
                        context.read<BadgesBloc>().add(
                            const UpdateBtnChangedBadgesEvent(
                                updateChanged: ""));
                        context
                            .read<BadgesBloc>()
                            .add(const MatchedBadgeIdEvent(matchedId: ""));
                        if (dialogShowing) {
                          context.pop();
                        }
                      },
                      backgroundColor: ColorConstants.kAppAccent,
                      child: Text(StringConstants.cancel,
                          style: StyleConstants.kAppButtonNBGTextStyle
                              .copyWith(color: ColorConstants.kW0White)),
                    ),
                    BlocBuilder<BadgesBloc, BadgesState>(
                      builder: (context, state) {
                        return MqsElevatedButton(
                          onPressed: () {
                            if (_lAFormKey.currentState?.validate() ?? true) {
                              var commonData = MqsBadge(
                                  id: badgeIdController.text,
                                  mqsBadgeAssigned: state.badgeChangeRadio ==
                                          BadgesAssign.badgesAssigned
                                      ? true
                                      : false,
                                  mqsBadgeName: nameController.text,
                                  mqsBadgeImage: state.badgeImage,
                                  mqsBadgeDescription:
                                      descriptionController.text,
                                  aboutBadge: aboutController.text);
                              if (state.updateOnTaped.isNotEmpty &&
                                  state.updateOnTaped ==
                                      StringConstants.update) {
                                context.read<BadgesBloc>().add(
                                    UpdateBadgesEvent(
                                        badgesActivity: commonData,
                                        id: badgeIdController.text));
                                context.read<BadgesBloc>().add(
                                    const UpdateBtnChangedBadgesEvent(
                                        updateChanged: ""));
                              } else {
                                context.read<BadgesBloc>().add(
                                    InsertBadgesEvent(
                                        badgesActivity: commonData,
                                        dialogShowing: dialogShowing));
                                context.read<BadgesBloc>().add(
                                    const UpdateBtnChangedBadgesEvent(
                                        updateChanged: ""));
                                if (dialogShowing) {
                                  context.pop();
                                }
                              }
                              context.read<BadgesBloc>().add(
                                  const MatchedBadgeIdEvent(matchedId: ""));
                            }
                          },
                          backgroundColor: ColorConstants.kG4AppPaletteGreen,
                          child: Text(
                              (state.updateOnTaped.isNotEmpty &&
                                      state.updateOnTaped ==
                                          StringConstants.update)
                                  ? StringConstants.update
                                  : StringConstants.save,
                              style: StyleConstants.kAppButtonNBGTextStyle
                                  .copyWith(color: ColorConstants.kW0White)),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
