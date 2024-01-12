String getTimeAgo(DateTime? dateTime) {
  if (dateTime == null) {
    return '';
  }

  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 365) {
    return '${dateTime.year} thg ${dateTime.month} ${dateTime.day}, ${dateTime.hour}:${dateTime.minute} ${dateTime.hour < 12 ? "SA" : "CH"}';
  } else if (difference.inDays > 2) {
    return 'thg ${dateTime.month} ${dateTime.day}, ${dateTime.hour}:${dateTime.minute} ${dateTime.hour < 12 ? "SA" : "CH"}';
  } else if (difference.inDays >= 1) {
    return 'hôm qua, ${dateTime.hour}:${dateTime.minute} ${dateTime.hour < 12 ? "SA" : "CH"}';
  } else if (difference.inHours >= 1) {
    return 'khoảng ${difference.inHours} giờ trước';
  } else if (difference.inMinutes >= 1) {
    return 'khoảng ${difference.inMinutes} phút trước';
  } else {
    return 'vừa xong';
  }
}
