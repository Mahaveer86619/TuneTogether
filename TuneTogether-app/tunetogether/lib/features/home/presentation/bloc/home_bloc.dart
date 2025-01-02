import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:tunetogether/common/app_user_cubit/app_user_cubit.dart';
import 'package:tunetogether/common/helpers/data_state.dart';
import 'package:tunetogether/features/auth/domain/entities/user_entity.dart';
import 'package:tunetogether/features/home/domain/entities/group_entity.dart';
import 'package:tunetogether/features/home/domain/usecases/get_joined_groups_details_by_id_usecase.dart';
import 'package:tunetogether/features/home/domain/usecases/get_user_details_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final Logger _logger;
  final AppUserCubit _appUserCubit;

  final GetUserDetailsUsecase _getUserDetailsEvent;
  final GetJoinedGroupsDetailsByIdUsecase _getJoinedGroupsEvent;

  HomeBloc({
    required Logger logger,
    required AppUserCubit appUserCubit,
    required GetUserDetailsUsecase getUserDetailsEvent,
    required GetJoinedGroupsDetailsByIdUsecase getJoinedGroupsEvent,
  })  : _logger = logger,
        _appUserCubit = appUserCubit,
        _getUserDetailsEvent = getUserDetailsEvent,
        _getJoinedGroupsEvent = getJoinedGroupsEvent,
        super(HomeInitial()) {
    on<GetJoinedGroupsEvent>(_onRetriveUserEvent);
    on<LogOutEvent>(_onLogOutEvent);
  }

  Future<void> _onRetriveUserEvent(
    GetJoinedGroupsEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(HomeLoading());

      final userJSON = await _appUserCubit.getUser();
      final token = await _appUserCubit.getToken();

      final userDetails = await _getUserDetailsEvent.execute(
        params: GetUserDetailsUsecaseParams(
          userId: userJSON!['id'],
          token: token!,
        ),
      );

      if (userDetails is DataFailure) {
        _logger.e(userDetails.message!);
        emit(HomeError(userDetails.message!));
        return;
      }

      final user = userDetails.data;
      if (user == null) {
        emit(HomeError('No user found'));
        return;
      }

      emit(HomeJoinedGroupsLoading(user));

      final joinedGroups = user.joinedGroups;

      final joinedGroupsDetails = await _getJoinedGroupsEvent.execute(
        params: GetJoinedGroupsDetailsByIdUsecaseParams(
          groupIds: joinedGroups,
          token: token,
        ),
      );

      if (joinedGroupsDetails is DataFailure) {
        _logger.e(joinedGroupsDetails.message!);
        emit(HomeError(joinedGroupsDetails.message!));
        return;
      }

      if (joinedGroupsDetails.data == null) {
        emit(HomeError('error data is null'));
        return;
      }

      if (joinedGroupsDetails.data!.isEmpty) {
        emit(HomeJoinedGroupsLoaded([], user));
        return;
      }

      emit(HomeJoinedGroupsLoaded(joinedGroupsDetails.data!, user));
    } catch (e) {
      _logger.e(e.toString());
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onLogOutEvent(
    LogOutEvent event,
    Emitter<HomeState> emit,
  ) async {
    await _appUserCubit.signOut();
  }
}
