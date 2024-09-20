part of 'pyramid_cubit.dart';

@immutable
sealed class PyramidState {}

final class PyramidInitial extends PyramidState {}
final class NavigateToWaitingScreen extends PyramidState {}

final class PyramidToggleJerryVoice extends PyramidState {}
final class PyramidToggleMusic extends PyramidState {}
final class PyramidToggleChimes extends PyramidState {}
final class PyramidToggleBreathHold extends PyramidState {}


final class PyramidToggleSave extends PyramidState {}
final class PyramidBreathworkFetched extends PyramidState {}