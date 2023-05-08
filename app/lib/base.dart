bool isArabic(String text) {
  // Regular expression to match Arabic Unicode characters
  final arabicRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDCF\uFDF0-\uFDFF\uFE70-\uFEFF]');
  return arabicRegex.hasMatch(text);
}
