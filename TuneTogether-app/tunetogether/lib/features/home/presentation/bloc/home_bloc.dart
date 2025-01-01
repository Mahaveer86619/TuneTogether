import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    // on<HomeEvent>(_onGetAll);
  }

  // Future<void> _onGetAll(
  //   SignInEvent event,
  //   Emitter<HomeState> emit,
  // ) async {}
}
