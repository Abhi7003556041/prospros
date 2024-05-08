extension toNormalString on bool {
  String toYesNo() {
    if (this == true)
      return "yes";
    else
      return "no";
  }
}
