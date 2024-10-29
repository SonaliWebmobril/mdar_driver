import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static late SharedPreferences prefs;

  static RxBool isCurrentLoading = false.obs;

  static String keyUserToken = "UserToken";
  static String keyUserId = "UserId";
  static String keyUserMobile = "UserMobile";
  static String keyUserCountryCode = "UserCountryCode";
  static String keyUserName = "UserName";
  static String keyUserEmail = "UserEmail";
  static String keyUserGender = "UserGender";
  static String keyUserProfile = "UserProfile";
  static String keyUserCriminalRecord = "UserCriminalRecord";
  static String keyUserRating = "UserAverageRating";
  static String keyUserStatus = "UserStatus";
  static String keyRideType = "RideType";
  static String keySecurityAmt = "SecurityAmt";
  static String keyCurrentBookingStatus = "CurrentBookingStatus";
  static String keyCurrentBookingId = "CurrentBookingId";
  static String keyOnline = "IsOnline";
  static String keyLocalLng = "LocaleLng";
  static String keyLocalIndex = "LocaleIndex";
  static String keyIsLoggedIn = "IsUserloggedIn";
  static String keyCurrentLat = "CurrentLat";
  static String keyCurrentLng = "CurrentLng";
  static String currentBookingLastLat = "CurrentBookingLastLat";
  static String currentBookingLastLong = "CurrentBookingLastLong";
  static String currentRideTotalKm = "TotalKm";
  static String notifyStatus = "isNotify";
  static String currencySymbol = "currencySymbol";
  static String currencyCode = "currencyCode";
  static String currencyPosition = "currencyPosition";
  static String tax = "tax";
  static String nightTimeStart = "nightTimeStart";
  static String nightTimeEnd = "nightTimeEnd";
  static String isDialogOpen = "ConnectionDialog";

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static setStringInSession(String key, String value) {
    prefs.setString(key, value);
  }

  static String? getStringFromSession(String key) {
    String? stringValue = prefs.getString(key);
    return stringValue;
  }

  static setIntInSession(String key, int value) {
    prefs.setInt(key, value);
  }

  static int? getIntFromSession(String key) {
    int? stringValue = prefs.getInt(key);
    return stringValue;
  }

  static setBoolInSession(String key, bool value) {
    prefs.setBool(key, value);
  }

  static bool? getBoolFromSession(String key) {
    bool? stringValue = prefs.getBool(key);
    return stringValue;
  }

  static setDoubleInSession(String key, double value) {
    prefs.setDouble(key, value);
  }

  static double getDoubleInSession(String key) {
    double? doubleValue = prefs.getDouble(key);
    return doubleValue ?? 0.0;
  }

  static setLng(String key, String value) {
    prefs.setString(key, value);
  }

  static String getLng(String key) {
    String? stringValue = prefs.getString(key);
    return stringValue ?? "en";
  }

  static setLngIndex(String key, int value) {
    prefs.setInt(key, value);
  }

  static int getLngIndex(String key) {
    int? intValue = prefs.getInt(key);
    return intValue ?? 0;
  }

  static clearSession() {
    print("clear session..1.. ");
    prefs.remove(UserSession.keyUserToken);
    prefs.remove(UserSession.keyUserId);
    prefs.remove(UserSession.keyUserMobile);
    prefs.remove(UserSession.keyUserCountryCode);
    prefs.remove(UserSession.keyUserName);
    prefs.remove(UserSession.keyUserGender);
    prefs.remove(UserSession.keyUserEmail);
    prefs.remove(UserSession.keyUserProfile);
    prefs.remove(UserSession.keyUserCriminalRecord);
    prefs.remove(UserSession.keyUserRating);
    prefs.remove(UserSession.keyUserStatus);
    prefs.remove(UserSession.keySecurityAmt);
    prefs.remove(UserSession.keyCurrentBookingStatus);
    prefs.remove(UserSession.keyOnline);
    prefs.remove(UserSession.keyIsLoggedIn);
    print("clear session..2.. ");
    prefs.remove(UserSession.keyCurrentBookingId);
  }
}
