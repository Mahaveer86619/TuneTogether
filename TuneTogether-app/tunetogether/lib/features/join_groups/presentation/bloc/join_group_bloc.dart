import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'join_group_event.dart';
part 'join_group_state.dart';

class JoinGroupBloc extends Bloc<JoinGroupEvent, JoinGroupState> {
  JoinGroupBloc() : super(JoinGroupInitial()) {
    on<JoinGroupEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
