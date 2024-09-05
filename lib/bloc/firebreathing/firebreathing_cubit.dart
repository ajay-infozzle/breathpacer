import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'firebreathing_state.dart';

class FirebreathingCubit extends Cubit<FirebreathingState> {
  FirebreathingCubit() : super(FirebreathingInitial());
}
