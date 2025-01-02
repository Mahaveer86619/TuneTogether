
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:tunetogether/common/app_user_cubit/app_user_cubit.dart';
import 'package:tunetogether/common/helpers/data_state.dart';
import 'package:tunetogether/features/home/domain/entities/group_entity.dart';
import 'package:tunetogether/features/join_groups/domain/usecases/get_public_groups_usecase.dart';

part 'join_group_event.dart';
part 'join_group_state.dart';

class JoinGroupBloc extends Bloc<JoinGroupEvent, JoinGroupState> {
  final Logger _logger;
  final AppUserCubit _appUserCubit;

  final GetPublicGroupsUsecase _getPublicGroupsUsecase;

  JoinGroupBloc({
    required Logger logger,
    required AppUserCubit appUserCubit,
    required GetPublicGroupsUsecase getPublicGroupsUsecase,
  }) : _appUserCubit = appUserCubit,
       _logger = logger,
       _getPublicGroupsUsecase = getPublicGroupsUsecase,
  super(JoinGroupInitial()) {
    on<GetPublicGroups>(_onGetPublicGroups);
  }

  Future<void> _onGetPublicGroups(
    GetPublicGroups event,
    Emitter<JoinGroupState> emit,
  ) async {
    try {
      final token = await _appUserCubit.getToken();

      if (token == null) {
        emit(JoinGroupError('Token not found'));
        return;
      }

      final response = await _getPublicGroupsUsecase.execute(
        params: GetPublicGroupsUsecaseParams(
          token: token,
        ),
      );

      if (response is DataFailure) {
        _logger.e(response.message!);
        emit(JoinGroupError(response.message!));
        return;
      }

      if (response.data == null) {
        emit(JoinGroupError('No data found'));
        return;
      }

      emit(PublicGroupsLoaded(response.data!));
    } catch (e) {
      _logger.e(e.toString());
      emit(JoinGroupError(e.toString()));
    }
  }
}
