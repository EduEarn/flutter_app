class DateFormatter {
  static String formatDate(DateTime postDate,String text) {
    DateTime currentDate = DateTime.now();

    Duration difference = currentDate.difference(postDate);

    if (difference.inSeconds < 60) {
      return '$text ${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '$text ${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '$text ${difference.inHours} hours ago';
    } else {
      int daysDifference = difference.inDays;
      if (daysDifference == 1) {
        return '$text 1 day ago';
      } else {
        return '$text $daysDifference days ago';
      }
    }
  }
}
