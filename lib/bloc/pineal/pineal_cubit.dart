import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'pineal_state.dart';

class PinealCubit extends Cubit<PinealState> {
  PinealCubit() : super(PinealInitial());
}
