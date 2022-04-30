import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Calculator {
  //todo DateTime zaman biçimini --> Stringe formatlayıp çeviren metot
  //todo DateTime --> TimeStamp
  //todo TimeStamp --> DaTetime

  static String dateTimeToString(DateTime dateTime) {
    var formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    return formattedDate;
  }

  static Timestamp dateTimeToTimestamp(DateTime dateTime) {
    return Timestamp.fromMillisecondsSinceEpoch(
        dateTime.millisecondsSinceEpoch);
  }

  static DateTime timestampToDateTime(Timestamp timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(
        timestamp.millisecondsSinceEpoch);
  }
}
