part of 'badges_bloc.dart';

enum BadgesStatus {
  initial,
  loading,
  success,
  failure,
}

enum BadgesAssign { badgesAssigned, badgesNotAssigned }

class BadgesState extends Equatable {
  const BadgesState(
      {required this.status,
      required this.selectMenu,
      required this.badgesList,
      required this.errorMsg,
      required this.selectedIndex,
      required this.badgesActivity,
      required this.badgesActivityId,
      required this.updateOnTaped,
      required this.totalBadges,
      required this.badgeImage,
      required this.badgeImageFileName,
      required this.badgeName,
      required this.badgeDescription,
      required this.aboutBadge,
      required this.isShowingSnackBar,
      required this.isShowingSnackBarMsg,
      required this.badgeChangeRadio,
      required this.matchId});
  factory BadgesState.initial() => BadgesState(
      status: BadgesStatus.initial,
      selectMenu: StringConstants.badges,
      badgesList: const [],
      errorMsg: "",
      selectedIndex: 0,
      updateOnTaped: "",
      matchId: "",
      badgesActivity: MqsBadge(
        id: "",
        mqsBadgeName: "",
        mqsBadgeImage: "",
        aboutBadge: "",
        mqsBadgeDescription: "",
        mqsBadgeAssigned: false,
      ),
      badgesActivityId: "",
      totalBadges: 0,
      badgeImage: "",
      badgeImageFileName: "",
      badgeName: "",
      badgeDescription: "",
      aboutBadge: "",
      isShowingSnackBar: false,
      isShowingSnackBarMsg: "",
      badgeChangeRadio: BadgesAssign.badgesNotAssigned);

  BadgesState copyWith(
      {BadgesStatus? status,
      String? selectMenu,
      List<String>? leftMenuList,
      String? errorMsg,
      List<MqsBadge>? badgesList,
      MqsBadge? badgesActivity,
      int? selectedIndex = 0,
      String? badgesActivityId,
      String? updateOnTaped,
      int? totalBadges,
      String? badgeImage,
      String? badgeImageFileName,
      String? badgeName,
      String? badgeDescription,
      String? aboutBadge,
      String? matchId,
      bool? isShowingSnackBar,
      String? isShowingSnackBarMsg,
      BadgesAssign? badgeChangeRadio}) {
    return BadgesState(
        status: status ?? this.status,
        selectMenu: selectMenu ?? this.selectMenu,
        errorMsg: errorMsg ?? this.errorMsg,
        selectedIndex: selectedIndex ?? this.selectedIndex,
        badgesList: badgesList ?? this.badgesList,
        badgesActivity: badgesActivity ?? this.badgesActivity,
        badgesActivityId: badgesActivityId ?? this.badgesActivityId,
        updateOnTaped: updateOnTaped ?? this.updateOnTaped,
        totalBadges: totalBadges ?? this.totalBadges,
        badgeImage: badgeImage ?? this.badgeImage,
        badgeImageFileName: badgeImageFileName ?? this.badgeImageFileName,
        badgeName: badgeName ?? this.badgeName,
        badgeDescription: badgeDescription ?? this.badgeDescription,
        aboutBadge: aboutBadge ?? this.aboutBadge,
        matchId: matchId ?? this.matchId,
        isShowingSnackBar: isShowingSnackBar ?? this.isShowingSnackBar,
        isShowingSnackBarMsg: isShowingSnackBarMsg ?? this.isShowingSnackBarMsg,
        badgeChangeRadio: badgeChangeRadio ?? this.badgeChangeRadio);
  }

  final BadgesStatus status;
  final String selectMenu;
  final String errorMsg;
  final int selectedIndex;
  final List<MqsBadge> badgesList;
  final MqsBadge badgesActivity;
  final String badgesActivityId;
  final String updateOnTaped;
  final int totalBadges;
  final String badgeImage;
  final String badgeImageFileName;
  final String badgeName;
  final String badgeDescription;
  final String aboutBadge;
  final bool isShowingSnackBar;
  final String isShowingSnackBarMsg;
  final BadgesAssign badgeChangeRadio;
  final String matchId;

  bool get isLoading => status == BadgesStatus.loading;
  @override
  List<Object?> get props => [
        status,
        selectMenu,
        errorMsg,
        selectedIndex,
        badgesList,
        badgesActivity,
        badgesActivityId,
        updateOnTaped,
        totalBadges,
        badgeName,
        badgeImage,
        badgeDescription,
        aboutBadge,
        matchId,
        isShowingSnackBar,
        isShowingSnackBarMsg,
        badgeChangeRadio,
        badgeImageFileName,
      ];
}
