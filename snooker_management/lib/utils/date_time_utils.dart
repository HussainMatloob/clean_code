import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static String extractTimeFromTimestamp(Timestamp timestamp) {
    // Convert Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format DateTime to get the time in 12-hour format with AM/PM
    String formattedTime = DateFormat('hh:mm:ss a').format(dateTime);

    return formattedTime;
  }

  static String getCurrentTime() {
    // Get the current time
    DateTime now = DateTime.now();

    // Format the time in HH:mm:ss a (AM/PM format)
    String formattedTime = DateFormat('hh:mm:ss a').format(now);

    return formattedTime;
  }

  static String calculateTimeDifference(Timestamp start) {
    // Convert Timestamps to DateTime
    DateTime now = DateTime.now();
    Timestamp end = Timestamp.fromDate(now);

    DateTime startTime = start.toDate();
    DateTime endTime = end.toDate();

    // Extract only the time components and convert to Duration
    Duration startDuration = Duration(
      hours: startTime.hour,
      minutes: startTime.minute,
      seconds: startTime.second,
    );
    Duration endDuration = Duration(
      hours: endTime.hour,
      minutes: endTime.minute,
      seconds: endTime.second,
    );

    // Calculate the total duration difference
    Duration difference;
    if (endDuration >= startDuration) {
      difference = endDuration - startDuration;
    } else {
      // Handle case where end time is on the next day
      const Duration oneDay = Duration(hours: 24);
      difference = (oneDay - startDuration) + endDuration;
    }

    // Extract hours, minutes, and seconds from the difference
    int hours = difference.inHours;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;

    // Format the output as HH:mm:ss
    String formattedTime = [
      hours.toString().padLeft(2, '0'), // Ensure 2 digits for hours
      minutes.toString().padLeft(2, '0'), // Ensure 2 digits for minutes
      seconds.toString().padLeft(2, '0') // Ensure 2 digits for seconds
    ].join(':');

    return formattedTime; // Return the formatted time
  }

  static String formatDate(Timestamp timestamp) {
    // Convert Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format DateTime to 'yyyy-MM-dd'
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }
}
