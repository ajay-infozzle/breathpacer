enum JerryVoiceEnum {
  breatheIn,
  breatheOut,
  breatheBoth,
  hold,
  pineal,
  pinealSqeez,
  closeEyes
}

String jerryVoiceOver(JerryVoiceEnum voice) {
  switch (voice) {
    case JerryVoiceEnum.breatheIn:
      return "audio/breathe_in.mp3";
    case JerryVoiceEnum.breatheOut:
      return "audio/breathe_out.mp3";
    case JerryVoiceEnum.breatheBoth:
      return "audio/breathe_both.mp3";
    case JerryVoiceEnum.hold:
      return "audio/hold.mp3";
    case JerryVoiceEnum.pineal:
      return "audio/pineal.mp3";
    case JerryVoiceEnum.pinealSqeez:
      return "audio/pineal_sqeez_breathing.mp3";
    case JerryVoiceEnum.closeEyes:
      return "audio/close_eyes.mp3";
    default:
      return "audio/breathe_in.mp3";
  }
}
