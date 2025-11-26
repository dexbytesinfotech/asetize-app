import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
    } catch (e) {
      debugPrint("$e");
    }
  }

  static Future<bool> isFingerprintEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFingerprintEnabled') ?? false;
  }
  Future<void> remove(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      debugPrint("Error removing key $key: $e");
    }
  }


  static Future<void> setFingerprintEnabled(bool enabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFingerprintEnabled', enabled);
  }

  static Future<bool> authenticateWithBiometrics() async {
    final LocalAuthentication auth = LocalAuthentication();///

    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access the dashboard',
        options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true
        ),
      );
      return authenticated;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //********** Int value **************
  Future<int> readInt(keys) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = keys;
      final value = prefs.getInt(key) ?? -1;
      return value;
    } catch (e) {
      debugPrint("$e");
      return -1;
    }
  }

  saveInt(keys, values) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = keys;
      final value = values;
      prefs.setInt(key, value);
    } catch (e) {
      debugPrint("$e");
    }
  }

  //********** String value **************
  Future<String> readStr(keys) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = keys;
      final value = prefs.getString(key) ?? "";
      return value;
    } catch (e) {
      debugPrint("$e");
      return "";
    }
  }

  Future<String> readStrT(keys) async {
    try {
      /*final prefs = await SharedPreferences.getInstance();
      final key = keys;*/
      //final value = prefs.getString(key) ?? null;
      const value =
          "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImRjOGIwMTk1NTZiMDMxMjYyNGM3MDQyMDJjYzc4ZjA3OThmYmFmOWU2MjY5NjgwYzk2MjM5YjkxN2RlNDM0YTU4NWI0NzQ5NDc4ZmUyM2Y1In0.eyJhdWQiOiIyIiwianRpIjoiZGM4YjAxOTU1NmIwMzEyNjI0YzcwNDIwMmNjNzhmMDc5OGZiYWY5ZTYyNjk2ODBjOTYyMzliOTE3ZGU0MzRhNTg1YjQ3NDk0NzhmZTIzZjUiLCJpYXQiOjE1Njc0MTMzNjcsIm5iZiI6MTU2NzQxMzM2NywiZXhwIjoxNTk5MDM1NzY3LCJzdWIiOiIxOTMiLCJzY29wZXMiOlsiKiJdfQ.gnTpLP3C3Rxj1Jf35W3iGgfNZRVqn-kn3P0y9iGwYtOL_EpjJ4j2Ai4Sm78_rX3AgUUwLsKM8Nj2SDR9rsNntN7LHaooWUCo9_Pj_tZSfF3i4wnOix5Xn4EWiTUWhkajA4J9Uvt8OqCHNDdInDLWIFUZQdIcA-s1X2TxAI0wvTasI-obpZkPki9EAq-MMdpClR1fromWdS-3SHxko5KuMpzCrca9bP6mg0KuKDoslkP48-K60gxPlkEeNWJXSg6oUZjj1vGImTFtkdusYHA6Mk1zP2vy2lteR8WCKQW8rRA5XBL1rqwr1G-S9aoU2oqBwCVFgLDmtwXVCkkOm7vlYjNgUuJrrMVrJuhQZAfDYtvoP8UtXpk2ZVGBGuA7sMRiS4Q7JKk8CJq28dpUdUU1IzvwZxMO2bznzt2VVyXTsUTDmBav7AAPavlh8TOZ5295ST2Mx-QmxM5H6aLhS19-IoTky_EEu1QwGNo7t3lzfDRc_Hac8RBKkx8JCd93lSgaT405ceE2tvlfCKN1BZFJ_P0rM672MkyjbgderpwYhftEhJUrOsboJfKNc4_p-Hcbx_m_XC8J7NQS8pt_HY3ZJRFfH_4zDN-YWzFcgszDE85CVnv1bjMpGWe3VUCVXFaTLYnKliOI-DXX20DoXKZP69q-pJh07cpN1IalQUCz5LM";
      return value;
    } catch (e) {
      debugPrint("$e");
      return "";
    }
  }

  Future<bool> saveStr(keys, values) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = keys;
      final value = values;
      prefs.setString(key, value);
      return true;
    } catch (e) {
      debugPrint("$e");
      return false;
    }
  }

//is_user_loggedin
  //********** Bool value **************
  Future<bool> readBool(keys) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = keys;
      final value = prefs.getBool(key) ?? false;
      return value;
    } catch (e) {
      debugPrint("$e");
      return false;
    }
  }

  saveBool(keys, values) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = keys;
      final value = values;
      prefs.setBool(key, value);
    } catch (e) {
      debugPrint("$e");
    }
  }

  //********** Bool value **************
  Future<dynamic> readDouble(keys) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = keys;
      final value = prefs.getDouble(key) ?? -1;
      return value;
    } catch (e) {
      debugPrint("$e");
      return false;
    }
  }

  saveDouble(keys, values) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = keys;
      final value = values;
      prefs.setDouble(key, value);
    } catch (e) {
      debugPrint("$e");
    }
  }
}
