import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'dna_state.dart';

class DnaCubit extends Cubit<DnaState> {
  DnaCubit() : super(DnaInitial());
}
