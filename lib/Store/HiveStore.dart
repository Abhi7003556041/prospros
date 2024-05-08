import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'vm.dart';

class Keys {
  static const String accessToken = "accessToken";
  static const String profileImage = "profileImage";
  // static const String fcmToken = "fcmToken";
  static const String userName = "userName";
  static const String userNumber = "userNumber";
  static const String userEmail = "userEmail";
  static const String userCountryCode = "userCountryCode";
  static const String hasUserLogged = "hasUserLogged";
  // static const String userRole = "userRole";
  // static const String currentLat = "currentLat";
  // static const String currentLng = "currentLng";

  static const String userDetails = "userDetails";
  static const String hasUserCompletedAllRequiredStepsWhileLogin =
      "hasUserCompletedAllRequiredStepsWhileLogin";
  static const String hasProfilePictureUpdated = "hasProfilePictureUpdated";
  static const String currentPostId = "currentPostId";
  static const String currentUserId = "currentUserId";
  static const String userId = "userId";
  static const String userCatgory = "userCategory";
  static const String filteredSubCat = "filteredSubCat";
  static const String isFilteredEnabled = "isFilterEnabled";
  static const String filteredCountry = "filteredCountry";
  static const String fcmToken = "fcmToken";
  static const String activePlanId = "activePlanId";
  static const String country = "country";
}

class HiveStore {
  //Singleton Class
  static final HiveStore _default = new HiveStore._internal();
  static Box? defBox;

  factory HiveStore() {
    return _default;
  }

  HiveStore._internal();

  static getInstance() {
    return _default;
  }

  initBox() async {
    defBox = await openBox();
  }

  //Object Storage
  Future<void> put(String key, Object value) async {
    await defBox?.put(key, value);
    print("HiveStored : Key:$key, Value:$value");
  }

  get(String key) {
    print("Box is Open? ${defBox!.isOpen}");
    print("HiveRetrive : Key:$key, Value:${defBox!.get(key)}");
    return defBox!.get(key);
  }

  clear() {
    defBox!.clear();
  }

  delete(String key) async {
    defBox!.delete(key);
  }

  Future openBox() async {
    if (!isBrowser) {
      var dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
    }
    return await Hive.openBox('Store');
  }
}
