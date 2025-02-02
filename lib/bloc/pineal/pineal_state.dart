part of 'pineal_cubit.dart';

@immutable
sealed class PinealState {}

final class PinealInitial extends PinealState {}
final class NavigateToWaitingScreen extends PinealState {}
final class CloseWaitingScreen extends PinealState {}

final class PinealBreathingUpdate extends PinealState {}
final class PinealHoldUpdate extends PinealState {}
final class PinealRecoveryUpdate extends PinealState {}
final class PinealToggleJerryVoice extends PinealState {}
final class PinealToggleMusic extends PinealState {}
final class PinealToggleSkipIntro extends PinealState {}
final class PinealToggleChimes extends PinealState {}
final class PinealToggleSave extends PinealState {}
final class PinealBreathworkFetched extends PinealState {}

final class ResumeHoldCounter extends PinealState {}
