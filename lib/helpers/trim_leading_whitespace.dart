import 'dart:convert';

/// Used to remove indentation whitespaces from multiline String literals.
/// intend for long paragraphs of text
///
/// (from: https://github.com/dart-lang/language/issues/559)
String trimLeadingWhitespace(String text) {
  var lines = LineSplitter.split(text);
  String commonWhitespacePrefix(String a, String b) {
    int i = 0;
    for (; i < a.length && i < b.length; i++) {
      int ca = a.codeUnitAt(i);
      int cb = b.codeUnitAt(i);
      if (ca != cb) break;
      if (ca != 0x20 /* spc */ && ca != 0x09 /* tab */) break;
    }
    return a.substring(0, i);
  }
  var prefix = lines.reduce(commonWhitespacePrefix);
  var prefixLength = prefix.length;
  return lines.map((s) => s.substring(prefixLength)).join("\n");
}