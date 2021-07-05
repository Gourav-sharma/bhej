import 'package:shared_preferences/shared_preferences.dart';
class SessionManager {
  static SessionManager _sessionManager = SessionManager._();
  static SharedPreferences _preferences = SharedPreferences as SharedPreferences ;



  static final String TOKEN = "Token";
  /*static final String SEND_TOKEN = "SEND_TOKEN";*/
  static final String ISLOGIN = "ISLOGIN";
  static final String ISPIN = "ISPIN";
  static final String pinValue = "pinValue";
  static final String distValue = "distValue";
  static final String dateValue = "dateValue";
  static final String selectedAge = "selectedAge";
  static final String selectedBrand = "selectedBrand";
  static final String selectedFee = "selectedFee";
  static final String selectedDose = "selectedDose";
  static final String age = "age";
  static final String brand = "brand";
  static final String fee = "fee";
  static final String dose = "dose";
  static const String USER_DATA = "user_data";
  static const String USER_CONTACTS = "user_contacts";




  static Future getInstance() async {
    if (_sessionManager == null) {
      var secureStorage = SessionManager._();
      await secureStorage._init();
      _sessionManager = secureStorage;
    }
    return _sessionManager;
  }
  SessionManager._();
  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// ----------------------------------------------------------
  /// Method that String value and Get String
  /// ----------------------------------------------------------

  static String getString(String key, {String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences.getString(key) ?? defValue;
  }



  /// ----------------------------------------------------------
  /// Method that Boolean value and Get Boolean
  /// ----------------------------------------------------------


  static bool getBoolean(String key, {bool defValue = false}) {
    if (_preferences == null) return defValue;
    return _preferences.getBool(key) ?? defValue;
  }

  /// ----------------------------------------------------------
  /// Method that saves All Type of value and Get All
  /// ----------------------------------------------------------

  static saveSession(String key, dynamic value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPrefs.setBool(key, value);
    } else if (value is String) {
      sharedPrefs.setString(key, value);
    } else if (value is int) {
      sharedPrefs.setInt(key, value);
    } else if (value is double) {
      sharedPrefs.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPrefs.setStringList(key, value);
    }
  }



}