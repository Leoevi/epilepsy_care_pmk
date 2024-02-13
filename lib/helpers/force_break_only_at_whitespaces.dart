/// In the home page, the user's name at the profile icon can break
/// at the middle of the name, this is undesirable as we want the
/// name to be break only at the whitespace (like the English language)
///
/// So we deal with this by inserting ZERO WIDTH NO-BREAK SPACE
/// between every character except the actual space character.
///
/// (from: https://stackoverflow.com/questions/63300348/flutter-text-only-break-lines-at-whitespaces)
String forceBreakOnlyAtWhiteSpace(String text) {
  return text.split('').join('\ufeff').replaceAll('\ufeff \ufeff', ' ');
}