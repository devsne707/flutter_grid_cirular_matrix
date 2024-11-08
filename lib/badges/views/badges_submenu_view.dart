import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqs_content_portal/constants/constants.dart';
import 'package:mqs_content_portal/features/badges/badges.dart';
import 'package:mqs_content_portal/helper/validators.dart';
import 'package:mqs_content_portal/service/mongo_db_service/mongo_db_service.dart';
import 'package:mqs_content_portal/widgets/widgets.dart';
import 'package:super_extensions/super_extensions.dart';

class BadgesSubMenuView extends StatefulWidget {
  const BadgesSubMenuView({super.key});

  @override
  State<BadgesSubMenuView> createState() => _BadgesSubMenuViewState();
}

class _BadgesSubMenuViewState extends State<BadgesSubMenuView> {
  @override
  void initState() {
    super.initState();
    context.read<BadgesBloc>().add(const GetListBadgesEvent());
  }

  late MqsBadge badge;

  @override
  Widget build(BuildContext context) {
    return BlocListener<BadgesBloc, BadgesState>(
      listenWhen: (previous, current) =>
          (previous.errorMsg != current.errorMsg ||
              previous.isShowingSnackBar != current.isShowingSnackBar),
      listener: (context, state) {
        if (state.status == BadgesStatus.failure) {
          context.showSnackBar(MqsSnackBar(
            message: state.errorMsg,
            backgroundColor: ColorConstants.kG5AppPaletteGreen,
          ));
        }
        if (state.isShowingSnackBar == true &&
            state.isShowingSnackBarMsg.isNotEmpty) {
          context.showSnackBar(MqsSnackBar(
            message: state.matchId.isNotEmpty
                ? StringConstants.changesSaved(
                    context.read<BadgesBloc>().state.badgeName)
                : "Successfully ${state.isShowingSnackBarMsg} ${state.badgesActivityId} ${StringConstants.badges.toLowerCase()}.",
            backgroundColor: ColorConstants.kG5AppPaletteGreen,
          ));
        }
      },
      child: BlocBuilder<BadgesBloc, BadgesState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.badgesList != current.badgesList,
        builder: (context, snapshot) {
          if (snapshot.status == BadgesStatus.success) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MqsAppBar(
                  message: snapshot.selectMenu,
                  automaticallyImplyLeading: false,
                  appBarTextStyle: StyleConstants.kAppButtonNBGTextStyle
                      .copyWith(
                          color: ColorConstants.kG4AppPaletteGreen,
                          fontSize: 20),
                  actions: [
                    MQSAddButton(
                      onPressed: () {
                        if (context.read<BadgesBloc>().state.updateOnTaped ==
                            StringConstants.update) {
                          badgesUpdateDialog(
                              context, context.read<BadgesBloc>());
                        } else {
                          context.read<BadgesBloc>().add(
                              UpdateBadgeIDControllerEvent(
                                  badgeID: customIDValueSet(
                                      name: 'BG',
                                      idValue: (context
                                              .read<BadgesBloc>()
                                              .state
                                              .totalBadges +
                                          1))));
                          context.read<BadgesBloc>().add(
                              const UpdateBadgeNameControllerEvent(
                                  badgeName: ""));
                          context.read<BadgesBloc>().add(
                              const UpdateBadgeDescriptionControllerEvent(
                                  badgeDescription: ""));
                          context.read<BadgesBloc>().add(
                              const UpdateBadgeImgControllerEvent(
                                  badgeImg: ""));
                          context.read<BadgesBloc>().add(
                              const UpdateBadgeAboutControllerEvent(
                                  aboutBadge: ""));
                          context.read<BadgesBloc>().add(
                              const ChangeBadgeAssignedEvent(
                                  changed: BadgesAssign.badgesNotAssigned));
                          context.read<BadgesBloc>().add(
                              const UpdateBtnChangedBadgesEvent(
                                  updateChanged: StringConstants.add));
                        }
                        context
                            .read<BadgesBloc>()
                            .add(const MatchedBadgeIdEvent(matchedId: ""));
                      },
                    )
                  ],
                ),
                Expanded(
                  child: snapshot.badgesList.isEmpty
                      ? Center(
                          child: Text(
                              StringConstants.noDataFound(
                                  StringConstants.badges),
                              style: StyleConstants.kAppTextFieldText,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                              horizontal: context.screenHeight * 0.01),
                          itemCount: snapshot.badgesList.length,
                          separatorBuilder: (context, index) => Padding(
                              padding:
                                  EdgeInsets.all(context.screenHeight * 0.006)),
                          itemBuilder: (context, index) {
                            var item = snapshot.badgesList[index];
                            return MQSListTileWidget(
                              leadingText: item.id,
                              titleText: item.mqsBadgeName,
                              editOnPressed: () {
                                commonFunction() {
                                  context.read<BadgesBloc>().add(
                                      UpdateBadgeIDControllerEvent(
                                          badgeID: item.id));
                                  context.read<BadgesBloc>().add(
                                      UpdateBadgeNameControllerEvent(
                                          badgeName: item.mqsBadgeName));
                                  context.read<BadgesBloc>().add(
                                      UpdateBadgeDescriptionControllerEvent(
                                          badgeDescription:
                                              item.mqsBadgeDescription));
                                  context.read<BadgesBloc>().add(
                                      UpdateBadgeImgControllerEvent(
                                          badgeImg: item.mqsBadgeImage));
                                  context.read<BadgesBloc>().add(
                                      UpdateBadgeAboutControllerEvent(
                                          aboutBadge: item.aboutBadge));
                                  context.read<BadgesBloc>().add(
                                      ChangeBadgeAssignedEvent(
                                          changed: item.mqsBadgeAssigned == true
                                              ? BadgesAssign.badgesAssigned
                                              : BadgesAssign
                                                  .badgesNotAssigned));
                                  context.read<BadgesBloc>().add(
                                      UpdateBtnChangedBadgesEvent(
                                          updateChanged: StringConstants.update,
                                          badgeActivity: item));
                                }

                                if (context
                                    .read<BadgesBloc>()
                                    .state
                                    .matchId
                                    .isNotEmpty) {
                                  if (context
                                          .read<BadgesBloc>()
                                          .state
                                          .matchId ==
                                      item.id) {
                                    if (context
                                            .read<BadgesBloc>()
                                            .state
                                            .updateOnTaped ==
                                        StringConstants.add) {
                                      badgesAddDialog(context, item,
                                          context.read<BadgesBloc>());
                                    } else {
                                      commonFunction();
                                    }
                                  } else {
                                    var blocData =
                                        context.read<BadgesBloc>().state;
                                    var test = MqsBadge(
                                        id: blocData.badgesActivityId,
                                        mqsBadgeAssigned:
                                            blocData.badgeChangeRadio ==
                                                    BadgesAssign.badgesAssigned
                                                ? true
                                                : false,
                                        mqsBadgeName: blocData.badgeName,
                                        mqsBadgeImage: blocData.badgeImage,
                                        mqsBadgeDescription:
                                            blocData.badgeDescription,
                                        aboutBadge: blocData.aboutBadge);
                                    badgeUpdateSaveDialog(
                                            context,
                                            context
                                                .read<BadgesBloc>()
                                                .state
                                                .matchId,
                                            test,
                                            item,
                                            context.read<BadgesBloc>())
                                        .then((value) => badge = item);
                                  }
                                } else {
                                  context.read<BadgesBloc>().add(
                                      MatchedBadgeIdEvent(matchedId: item.id));
                                  badge = item;
                                  commonFunction();
                                }
                              },
                              deleteOnPressed: () {
                                context.read<BadgesBloc>().add(
                                    const MatchedBadgeIdEvent(matchedId: ""));
                                context.read<BadgesBloc>().add(
                                    const UpdateBadgeNameControllerEvent(
                                        badgeName: ""));
                                context.read<BadgesBloc>().add(
                                    const UpdateBadgeDescriptionControllerEvent(
                                        badgeDescription: ""));
                                context.read<BadgesBloc>().add(
                                    const UpdateBadgeImgControllerEvent(
                                        badgeImg: ""));
                                context.read<BadgesBloc>().add(
                                    const UpdateBadgeAboutControllerEvent(
                                        aboutBadge: ""));
                                context.read<BadgesBloc>().add(
                                    const ChangeBadgeAssignedEvent(
                                        changed: BadgesAssign.badgesAssigned));
                                context.read<BadgesBloc>().add(
                                    UpdateBtnChangedBadgesEvent(
                                        updateChanged: StringConstants.delete,
                                        badgeActivity: item));
                                badgesDeleteDialog(
                                    context, item, context.read<BadgesBloc>());
                              },
                              displayOnPressed: () {
                                context.read<BadgesBloc>().add(
                                    const MatchedBadgeIdEvent(matchedId: ""));
                                context.read<BadgesBloc>().add(
                                    UpdateBtnChangedBadgesEvent(
                                        updateChanged: StringConstants.display,
                                        badgeActivity: item));
                              },
                            );
                          },
                        ),
                )
              ],
            );
          } else if (snapshot.status == BadgesStatus.failure) {
            return MqsErrorWidget(msg: snapshot.errorMsg);
          } else if (snapshot.status == BadgesStatus.loading) {
            return const MqsLoadingWidget();
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
