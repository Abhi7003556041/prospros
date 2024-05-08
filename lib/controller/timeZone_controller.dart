import 'package:get/get.dart';
import 'package:prospros/util/app_util.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class TimeZoneController extends GetxController {
  String userTimeZone = "Africa/Abidjan"; //default time zone is set for +00:00
  late tz.Location userTimeZoneLocation;
  Future<void> initializeTimeZone() async {
    tz.initializeTimeZones();
    try {
      userTimeZone = await FlutterTimezone.getLocalTimezone();
      if (userTimeZone == "Asia/Calcutta") {
        userTimeZone = "Asia/Kolkata";
      }
    } catch (err) {
      userTimeZone = "Africa/Abidjan";
    }

    userTimeZoneLocation = tz.getLocation(userTimeZone);
  }

  String getLocalTimeFromUTC(String utcTime) {
    try {
      DateTime? dt = DateTime.tryParse(utcTime);
      int localTIme =
          tz.TZDateTime.from(dt!, userTimeZoneLocation).millisecondsSinceEpoch;
      return (Apputil.strToDateTimeV2(
          DateTime.fromMillisecondsSinceEpoch(localTIme).toString()));
    } catch (err) {
      return utcTime;
    }
  }
}
