part of 'badges_bloc.dart';

abstract class BadgesEvent extends Equatable {
  const BadgesEvent();

  @override
  List<Object?> get props => [];
}

class InsertBadgesEvent extends BadgesEvent {
  const InsertBadgesEvent(
      {required this.badgesActivity, this.dialogShowing = false});
  final MqsBadge badgesActivity;
  final bool dialogShowing;

  @override
  List<Object?> get props => [badgesActivity, dialogShowing];
}

class UpdateBadgesEvent extends BadgesEvent {
  const UpdateBadgesEvent({required this.badgesActivity, required this.id});
  final MqsBadge badgesActivity;
  final String id;

  @override
  List<Object?> get props => [id, badgesActivity];
}

class DeleteBadgesEvent extends BadgesEvent {
  const DeleteBadgesEvent({required this.badge});
  final MqsBadge badge;

  @override
  List<Object?> get props => [badge];
}

class GetListBadgesEvent extends BadgesEvent {
  const GetListBadgesEvent();
  @override
  List<Object?> get props => [];
}

class GetBadgesEvent extends BadgesEvent {
  const GetBadgesEvent({required this.id});
  final String id;

  @override
  List<Object?> get props => [id];
}

class UpdateBtnChangedBadgesEvent extends BadgesEvent {
  const UpdateBtnChangedBadgesEvent(
      {required this.updateChanged, this.badgeActivity});
  final String updateChanged;
  final MqsBadge? badgeActivity;

  @override
  List<Object?> get props => [updateChanged, badgeActivity];
}

class UpdateBadgeIDControllerEvent extends BadgesEvent {
  const UpdateBadgeIDControllerEvent({required this.badgeID});
  final String badgeID;

  @override
  List<Object?> get props => [badgeID];
}

class UpdateBadgeNameControllerEvent extends BadgesEvent {
  const UpdateBadgeNameControllerEvent({required this.badgeName});
  final String badgeName;

  @override
  List<Object?> get props => [badgeName];
}

class UpdateBadgeImgControllerEvent extends BadgesEvent {
  const UpdateBadgeImgControllerEvent({required this.badgeImg});
  final String badgeImg;

  @override
  List<Object?> get props => [badgeImg];
}

class UpdateBadgeDescriptionControllerEvent extends BadgesEvent {
  const UpdateBadgeDescriptionControllerEvent({required this.badgeDescription});
  final String badgeDescription;

  @override
  List<Object?> get props => [badgeDescription];
}

class UpdateBadgeAboutControllerEvent extends BadgesEvent {
  const UpdateBadgeAboutControllerEvent({required this.aboutBadge});
  final String aboutBadge;

  @override
  List<Object?> get props => [aboutBadge];
}

class ShowSnackBarBadgesEvent extends BadgesEvent {
  const ShowSnackBarBadgesEvent(
      {required this.showingSnackBar, required this.showingSnackMsg});
  final bool showingSnackBar;
  final String showingSnackMsg;
  @override
  List<Object?> get props => [showingSnackBar, showingSnackMsg];
}

class ChangeBadgeAssignedEvent extends BadgesEvent {
  const ChangeBadgeAssignedEvent({required this.changed});
  final BadgesAssign changed;

  @override
  List<Object?> get props => [changed];
}

class SelectBadgeImageEvent extends BadgesEvent {
  const SelectBadgeImageEvent();
  @override
  List<Object?> get props => [];
}

class ClearBadgeImageEvent extends BadgesEvent {
  const ClearBadgeImageEvent();
  @override
  List<Object?> get props => [];
}

class MatchedBadgeIdEvent extends BadgesEvent {
  const MatchedBadgeIdEvent({required this.matchedId});
  final String matchedId;
  @override
  List<Object?> get props => [matchedId];
}
