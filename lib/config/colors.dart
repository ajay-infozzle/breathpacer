import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@immutable
class AppColors {
  // -----------------------------------------------------------------------------
  // Colors
  // -----------------------------------------------------------------------------
  final lightBlueButton = const Color(0xFF59CFFD);
  final appBarColor = const Color(0xFF41C1F4);
  final primaryColor = const Color(0xFF5777D5);
  final meditationColor = const Color(0xFF6F7AE6);
  final downloadButton = const Color(0xFF42BFF4);
  final eventPrimary = const Color(0xFFec047f);
  final tabBlue = const Color(0xFF9EDDFD);
  final leaderboardPurple = const Color(0xFF757AFE);
  final challengePurple = const Color(0xFF9F7DDD);
  final transparentGrey = const Color(0x50CFCFCF);
  final linearLoading = const LinearGradient(
      begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xFFEEEEEE), Color(0x4D808080)]);
  final linearEvent = const LinearGradient(
      begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xFFEC047F), Color(0xFF2EC5D8)]);
  final linearLeaderboard = const LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFF66BDA), Color(0xFF757AFE)]);
  final linearChallenge = const LinearGradient(
      begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [Color(0xFF9CF8F6), Color(0xFF9F7DDD)]);
  final linearPlaylist = const LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF7489E7), Color(0x0042C1F4)]);
  final transparentGradient = const LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x00FFFFFF), Color(0x00FFFFFF)]);

  // -----------------------------------------------------------------------------
  // Breathpacer Colors
  // -----------------------------------------------------------------------------
  final pinkButton = const Color(0xFFFE60D4);
  final blueSlider = const Color(0xFF6A55E3);
  final blueSchool = const Color(0xFF496CC9);
  final thumbColor = const Color(0xFF7085EB);
  final blueNotChosen = const Color(0xFF3742BB);
  final restartChallengeBg = const Color(0xFF7489E7);
  final pinkAnalytics = const Color(0xFFF66BDA);
  final bluePineal = const Color(0xFF79DAFB);
  final linearGradient = const LinearGradient(
      // Default linear gradient
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF79DAFB), Color(0xFF72A1EF), Color(0xFF6F80EA), Color(0xFF6A55E3)]);

  const AppColors();
}
