const interactionOptions = [
  {
    "title": "Pyramid Breathing",
    "image": "assets/images/pyramid_icon.png",
    "description": "Discover relaxation and mental clarity with Pyramid Breathing. Choose from two easy options—12-9-6-3 or 12-6 breathing patterns—to calm your mind and boost focus, anytime, anywhere.",
  },
  {
    "title": "Fire Breathing",
    "image": "assets/images/fire_icon.png",
    "description": "Release toxins and chemicals from the cells in your body. Enhance mental clarity. Start your day with this powerful activator.  Do it anytime you need a boost of energy. Fire Breathing is an intense rapid breathing exercises done through the nose.  Inhale deeply through your nose and exhale forcefully through your nose in a continuous steady pace.  At the end of the set hold your breath and recover",
  },
  {
    "title": "DNA Breathing",
    "image": "assets/images/dna_icon.png",
    "description": "Powerful breathing technique that will energize and renew you at a cellular level, releasing stuck emotions and past trauma.  Breathe deeply and continuously through your mouth and hold your breath at the end of each set. ",
  },
  {
    "title": "Pineal Gland Activation",
    "image": "assets/images/pineal_icon.png",
    "description": "Activate your pineal gland with this powerful breath.  Start by squeezing your buttocks, genitals and perineum and pulling your abdominals back to your spine.  Put the tip of your tongue on the roof of your mouth, the rough spot right behind your 2 top center teeth.  Keep your focus in the center of your brain and back slightly, in your pineal gland.   As you breath in through your nose, pull the platinum light from mother earth’s heart from your perineum up your spine and into your crown. Hold as long as you can.  Release the squeeze and exhale gently through the mouth.",
  },
];


//~ for pyramid
const breathingStepGuide = [
  {
    "title": "4-Step Pyramid Breathing (12-9-6-3)",
    "description": "Relax step by step. Inhale deeply and hold for 12, 9, 6, and 3 counts, exhaling after each. A great way to unwind progressively.",
    "instruction" : "Ensure you’re in a safe and quiet space. If you’re new to this, consider having someone supervise your practice. Start in a comfortable seated position. Keep a steady pace and avoid rushing. If you have any medical conditions, are pregnant, or experience discomfort, it’s essential to consult a healthcare professional. Regular practice can lead to noticeable results, but don’t push yourself if you’re feeling unwell. The most important thing is to enjoy your practice and pay attention to how your body feels."
  },
  {
    "title": "2-Step Pyramid Breathing (12-6)",
    "description": "Simplify your breathing practice. Hold for 12 counts, then 6 counts, with a full exhale in between. Quick and effective for instant calm.",
    "instruction" : "Ensure you’re in a safe and quiet space. If you’re new to this, consider having someone supervise your practice. Start in a comfortable seated position. Keep a steady pace and avoid rushing. If you have any medical conditions, are pregnant, or experience discomfort, it’s essential to consult a healthcare professional. Regular practice can lead to noticeable results, but don’t push yourself if you’re feeling unwell. The most important thing is to enjoy your practice and pay attention to how your body feels."
  }
];

String pinealBeforeYourSessionText = "Ensure you are in a safe and quite space.  Start in an upright seated position or lying down on the floor with your back straight.  Only do it standing up if you have experience as your can get dizzy and fall.  To connect with mother earth’s heart and her magnetic energy, say: “I connect to the platinum light of mother earth’s heart and bring that light into my perineum”.  Each time you breath in, pull that platinum light up your spine into your crown. Challenge yourself to hold for longer each time.  Consult a healthcare professional if you have any medical conditions, experience extreme discomfort or are pregnant.  Regular practice can lead to noticeable results. Don’t push yourself if you’re feeling unwell. The most important this is to enjoy your practice and pay attention to how your body feels.";

String fireBeforeYourSessionText = "Start slow and work your way to a faster pace with practice. You can do fire breathing standing, sitting or lying down. Remember to always keep your spine straight.  Consult a healthcare professional if you have any medical conditions, experience extreme discomfort or are pregnant.  Regular practice can lead to noticeable results. Don’t push yourself if you’re feeling unwell. The most important this is to enjoy your practice and pay attention to how your body feels.";

String dnaBeforeYourSessionText = "Ensure you are in a safe and quite space.  Start in an upright seated position or lying down on the floor with your back straight. Keep a steady continuous pace. Allow your belly to inflate as you inhale.  If your body gets cold, or your muscles contract or hurt, it is okay, keep breathing through it.  With long sessions, it is possible to go on a journey and get a feeling you are no longer breathing.  It is okay. You are in the frequency. Challenge yourself to go a bit further and hold a bit longer each time.  Consult a healthcare professional if you have any medical conditions, experience extreme discomfort or are pregnant.  Regular practice can lead to noticeable results. Don’t push yourself if you’re feeling unwell. The most important this is to enjoy your practice and pay attention to how your body feels.";

List<String> musicList = ['None','Music 1', 'Music 2'] ;

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
    return '$seconds sec';
  } else {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return remainingSeconds > 0
        ? '$minutes m $remainingSeconds s'
        : '$minutes min';
  }
}