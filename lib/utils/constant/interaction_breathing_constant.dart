const interactionOptions = [
  {
    "title": "Pyramid Breathing",
    "image": "assets/images/pyramid_icon.png",
    "description": "This exercise is a simplified version of the Pyramid Breathing technique, designed to energize the body and find mental balance. It involves a two-step pattern of deep breaths, starting with 12 deep breaths",
  },
  {
    "title": "Fire Breathing",
    "image": "assets/images/fire_icon.png",
    "description": "This exercise is a powerful technique that involves a three-step cycle: Fire Breathing, Rest, and Recovery Breathing. In the Fire Breathing phase, users perform a series of forceful exhalations...",
  },
  {
    "title": "DNA Breathing",
    "image": "assets/images/dna_icon.png",
    "description": "DNA Breathing is a personalized exercise designed to manage stress and release tension. It consists of a series of breathing sets, each with an inbreathe and outbreathe phase. ",
  },
  {
    "title": "Pineal Gland Activation",
    "image": "assets/images/pineal_icon.png",
    "description": "This exercise is a powerful technique that involves a three-step cycle: Fire Breathing, Rest, and Recovery Breathing. In the Fire Breathing phase, users perform a series of forceful exhalations",
  },
];


//~ for pyramid
const breathingStepGuide = [
  {
    "title": "4 step breathing(12-9-6-3 breathing)",
    "description": "Four-step pyramid breathing is a structured breathing exercise that can help reduce stress and promote relaxation. It involves four step each.",
    "instruction" : "Ensure you’re in a safe and quiet space. If you’re new to this, consider having someone supervise your practice. Start in a comfortable seated position. Keep a steady pace and avoid rushing. If you have any medical conditions, are pregnant, or experience discomfort, it’s essential to consult a healthcare professional. Regular practice can lead to noticeable results, but don’t push yourself if you’re feeling unwell. The most important thing is to enjoy your practice and pay attention to how your body feels."
  },
  {
    "title": "2 step breathing(12-6 breathing)",
    "description": "Two-step pyramid breathing is a simpler version of the pyramid breathing technique. It focuses on two main steps: inhalation and exhalation, with varying counts that form a pyramid shape.",
    "instruction" : "Ensure you’re in a safe and quiet space. If you’re new to this, consider having someone supervise your practice. Start in a comfortable seated position. Keep a steady pace and avoid rushing. If you have any medical conditions, are pregnant, or experience discomfort, it’s essential to consult a healthcare professional. Regular practice can lead to noticeable results, but don’t push yourself if you’re feeling unwell. The most important thing is to enjoy your practice and pay attention to how your body feels."
  }
];


String getTotalTimeString(List<int> timeList) {
  if (timeList.isEmpty) return '0 secs';

  int totalSeconds = timeList.reduce((a, b) => a + b);

  int hours = totalSeconds ~/ 3600;
  int minutes = (totalSeconds % 3600) ~/ 60;
  int seconds = totalSeconds % 60;

  String timeString = '';

  if (hours > 0) {
    timeString += '$hours hr';
    if (hours > 1) timeString += 's';
  }

  if (minutes > 0) {
    if (timeString.isNotEmpty) timeString += ' ';
    timeString += '$minutes min';
    if (minutes > 1) timeString += 's';
  }

  if (seconds > 0 || timeString.isEmpty) {
    if (timeString.isNotEmpty) timeString += ' ';
    timeString += '$seconds sec';
    if (seconds > 1) timeString += 's';
  }

  return timeString;
}

String getFormattedTime(int seconds) {
  if (seconds < 60) {
    return '$seconds secs';
  } else {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return remainingSeconds > 0
        ? '$minutes min $remainingSeconds sec'
        : '$minutes mins';
  }
}