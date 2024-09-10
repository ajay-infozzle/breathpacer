part of 'dna_cubit.dart';

@immutable
sealed class DnaState {}

final class DnaInitial extends DnaState {}

final class DnaUpdateSetNumber extends DnaState {}
final class DnaUpdateBreathNumber extends DnaState {}
final class DnaUpdateBreathTime extends DnaState {}
final class DnaUpdateBreathingApproach extends DnaState {}
final class DnaToggleRecoveryBreath extends DnaState {}
final class DnaToggleHolding extends DnaState {}
final class DnaToggleJerryVoice extends DnaState {}
final class DnaTogglePineal extends DnaState {}
final class DnaToggleMusic extends DnaState {}
final class DnaToggleChimes extends DnaState {}
final class DnaToggleBreathHoldChoice extends DnaState {}
