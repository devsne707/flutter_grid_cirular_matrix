import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqs_content_portal/constants/constants.dart';
import 'package:mqs_content_portal/service/service.dart';

part 'badges_event.dart';
part 'badges_state.dart';

class BadgesBloc extends Bloc<BadgesEvent, BadgesState> {
  final MongoDbService mongoDbService;
  final FilePickerService filePickerService;
  final StorageService storageService;

  BadgesBloc({
    required this.mongoDbService,
    required this.filePickerService,
    required this.storageService,
  }) : super(BadgesState.initial()) {
    on<GetListBadgesEvent>(_onGetBadgesListEvent);
    on<InsertBadgesEvent>(_onInsertBadgesListEvent);
    on<UpdateBadgesEvent>(_onUpdateBadgesListEvent);
    on<DeleteBadgesEvent>(_onDeleteBadgesEvent);

    on<UpdateBtnChangedBadgesEvent>(_onUpdateButtonChangedBadgesEvent);

    ///Controller OnChanged event
    on<UpdateBadgeIDControllerEvent>(_onUpdateBadgeIDControllerEvent);
    on<UpdateBadgeNameControllerEvent>(_onUpdateBadgeNameControllerEvent);
    on<UpdateBadgeImgControllerEvent>(_onUpdateBadgeImgControllerEvent);
    on<UpdateBadgeDescriptionControllerEvent>(
        _onUpdateBadgeDescriptionControllerEvent);
    on<UpdateBadgeAboutControllerEvent>(_onUpdateBadgeAboutControllerEvent);

    on<ShowSnackBarBadgesEvent>(_onShowSnackBarBadgesEvent);
    on<ChangeBadgeAssignedEvent>(_onChangeBadgeAssignedEvent);
    on<SelectBadgeImageEvent>(_onSelectBadgeImageEvent);
    on<ClearBadgeImageEvent>(_onClearBadgeImageEvent);
    on<MatchedBadgeIdEvent>(_onMatchedBadgeIdEvent);
  }

  void _onSelectBadgeImageEvent(
    SelectBadgeImageEvent event,
    Emitter<BadgesState> emit,
  ) async {
    final file = await filePickerService.pickImage();
    if (file != null) {
      emit(state.copyWith(badgeImageFileName: file.path));
      final imageUrl = await storageService.uploadFile(
        file: file,
        filePath: file.path,
        databaseName: DatabaseConstants.mqsBadges,
      );
      emit(state.copyWith(badgeImage: imageUrl));
    }
  }

  void _onClearBadgeImageEvent(
    ClearBadgeImageEvent event,
    Emitter<BadgesState> emit,
  ) async {
    emit(state.copyWith(badgeImage: "", badgeImageFileName: ""));
  }

  void _onGetBadgesListEvent(
      GetListBadgesEvent event, Emitter<BadgesState> emit) async {
    emit(state.copyWith(status: BadgesStatus.loading));
    await mongoDbService
        .getBadges()
        .then(
          (data) => emit(
            state.copyWith(
              badgesList: data,
              totalBadges: (data.isEmpty)
                  ? 0
                  : int.tryParse(data.last.id
                      .toString()
                      .replaceAll(RegExp(r'[^0-9]'), '')
                      .replaceFirst(RegExp(r'^0+'), "")),
              status: BadgesStatus.success,
            ),
          ),
        )
        .catchError((error) => emit(state.copyWith(
            errorMsg: error.toString(), status: BadgesStatus.failure)));
  }

  void _onInsertBadgesListEvent(
      InsertBadgesEvent event, Emitter<BadgesState> emit) async {
    emit(state.copyWith(
        status: BadgesStatus.loading,
        isShowingSnackBarMsg: "",
        isShowingSnackBar: false));
    await mongoDbService.insertBadge(mqsBadge: event.badgesActivity).catchError(
        (error) => emit(state.copyWith(
            errorMsg: error.toString(), status: BadgesStatus.failure)));
    if (!event.dialogShowing) {
      add(const GetListBadgesEvent());
    }
    emit(
      state.copyWith(
          badgesActivity: event.badgesActivity,
          status: BadgesStatus.success,
          isShowingSnackBar: true,
          isShowingSnackBarMsg: StringConstants.added),
    );
  }

  void _onUpdateBadgesListEvent(
      UpdateBadgesEvent event, Emitter<BadgesState> emit) async {
    emit(state.copyWith(
        status: BadgesStatus.loading,
        isShowingSnackBarMsg: "",
        isShowingSnackBar: false));
    await mongoDbService
        .updateBadge(mqsBadge: event.badgesActivity, id: event.id)
        .catchError((error) => emit(state.copyWith(
            errorMsg: error.toString(), status: BadgesStatus.failure)));
    add(const GetListBadgesEvent());
    emit(state.copyWith(
        badgesActivity: event.badgesActivity,
        badgesActivityId: event.id,
        status: BadgesStatus.success,
        isShowingSnackBar: true,
        isShowingSnackBarMsg: StringConstants.updated));
  }

  void _onDeleteBadgesEvent(
      DeleteBadgesEvent event, Emitter<BadgesState> emit) async {
    emit(state.copyWith(
        status: BadgesStatus.loading,
        isShowingSnackBarMsg: "",
        isShowingSnackBar: false));
    await mongoDbService.deleteBadge(badge: event.badge).catchError((error) =>
        emit(state.copyWith(
            errorMsg: error.toString(), status: BadgesStatus.failure)));
    add(const GetListBadgesEvent());
    emit(state.copyWith(
        badgesActivityId: event.badge.id,
        status: BadgesStatus.success,
        isShowingSnackBar: true,
        isShowingSnackBarMsg: StringConstants.deleted));
  }

  void _onUpdateButtonChangedBadgesEvent(
      UpdateBtnChangedBadgesEvent event, Emitter<BadgesState> emit) async {
    emit(state.copyWith(status: BadgesStatus.loading));
    emit(state.copyWith(
        updateOnTaped: event.updateChanged,
        badgesActivity: event.badgeActivity,
        status: BadgesStatus.success));
  }

  void _onUpdateBadgeIDControllerEvent(
      UpdateBadgeIDControllerEvent event, Emitter<BadgesState> emit) async {
    emit(state.copyWith(badgesActivityId: event.badgeID));
  }

  void _onUpdateBadgeNameControllerEvent(
      UpdateBadgeNameControllerEvent event, Emitter<BadgesState> emit) async {
    emit(state.copyWith(badgeName: event.badgeName));
  }

  void _onUpdateBadgeImgControllerEvent(
      UpdateBadgeImgControllerEvent event, Emitter<BadgesState> emit) async {
    emit(state.copyWith(
      badgeImage: event.badgeImg,
      badgeImageFileName: event.badgeImg,
    ));
  }

  void _onUpdateBadgeDescriptionControllerEvent(
      UpdateBadgeDescriptionControllerEvent event,
      Emitter<BadgesState> emit) async {
    emit(state.copyWith(badgeDescription: event.badgeDescription));
  }

  void _onUpdateBadgeAboutControllerEvent(
      UpdateBadgeAboutControllerEvent event, Emitter<BadgesState> emit) async {
    emit(state.copyWith(aboutBadge: event.aboutBadge));
  }

  void _onShowSnackBarBadgesEvent(
      ShowSnackBarBadgesEvent event, Emitter<BadgesState> emit) async {
    emit(state.copyWith(
        isShowingSnackBar: event.showingSnackBar,
        isShowingSnackBarMsg: event.showingSnackMsg));
  }

  void _onChangeBadgeAssignedEvent(
      ChangeBadgeAssignedEvent event, Emitter<BadgesState> emit) async {
    emit(state.copyWith(status: BadgesStatus.initial));
    emit(state.copyWith(
        badgeChangeRadio: event.changed, status: BadgesStatus.success));
  }

  void _onMatchedBadgeIdEvent(
      MatchedBadgeIdEvent event, Emitter<BadgesState> emit) async {
    emit(state.copyWith(matchId: event.matchedId));
  }
}
