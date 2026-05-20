String txt2filename(String txt) {

  final specialCharacters = [
    "@",
    "#",
    r"$",
    "*",
    "&",
    "<",
    ">",
    "/",
    "\b",
    "|",
    "?",
    "CON",
    "PRN",
    "AUX",
    "NUL",
    "COM0",
    "COM1",
    "COM2",
    "COM3",
    "COM4",
    "COM5",
    "COM6",
    "COM7",
    "COM8",
    "COM9",
    "LPT0",
    "LPT1",
    "LPT2",
    "LPT3",
    "LPT4",
    "LPT5",
    "LPT6",
    "LPT7",
    "LPT8",
    "LPT9",
    ":",
    '"',
    "'",
  ];

  String normalString = txt;

  for (final sc in specialCharacters) {
    normalString =
        normalString.replaceAll(sc, "");
  }

  return normalString;
}