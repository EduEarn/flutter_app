class AmountFormatter {
  static String formatAmount(String amount) {
    int numericAmount = int.tryParse(amount.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    if (numericAmount >= 1000 && numericAmount < 1000000) {
      return '${(numericAmount / 1000).toStringAsFixed(0)}k';
    } else {
      return amount;
    }
  }
}
