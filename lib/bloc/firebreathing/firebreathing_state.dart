part of 'firebreathing_cubit.dart';

@immutable
sealed class FirebreathingState {}

final class FirebreathingInitial extends FirebreathingState {}
final class NavigateToWaitingScreen extends FirebreathingState {}
final class CloseWaitingScreen extends FirebreathingState {}

final class FirebreathingUpdateSetDuration extends FirebreathingState {}
final class FirebreathingUpdateSetNumber extends FirebreathingState {}
final class FirebreathingToggleRecoveryBreath extends FirebreathingState {}
final class FirebreathingToggleHolding extends FirebreathingState {}
final class FirebreathingToggleJerryVoice extends FirebreathingState {}
final class FirebreathingTogglePineal extends FirebreathingState {}
final class FirebreathingToggleBreathHoldChoice extends FirebreathingState {}
final class FirebreathingToggleMusic extends FirebreathingState {}
final class FirebreathingToggleChimes extends FirebreathingState {}

final class FirebreathingToggleSave extends FirebreathingState {}
final class FireBreathworkFetched extends FirebreathingState {}
