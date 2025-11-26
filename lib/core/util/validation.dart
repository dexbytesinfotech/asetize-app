import 'package:flutter/material.dart';

abstract class Validation {
  /*===============check valid mobile or not=================*/
  static bool validMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(value)) {
      return true;
    }
    return false;
  }

  /*===============validate name field=================*/
  static bool restrictNumbersOnly(String value) {
    if (value.isNotEmpty) {
      String pattern = r'^[^0-9.,(){}+-@!#$&*%]+$';
      RegExp regExp = RegExp(pattern);
      if (regExp.hasMatch(value)) {
        return true;
      }
    }
    return false;
  }

  /* =======================validate phone number field===========*/
  static bool validatePhoneNumber(String pass) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,10}$)';
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(pass)) {
      return true;
    }
    return false;
  }

  /*==============check phone not blank=================*/
  static bool isNotEmpty(String value) {
    try {
      value = value.trim();
      if (value.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("$e");
      return false;
    }
  }

  /*==============check lenght of phone =================*/
  static bool phoneLength(String value) {
    if (value.length >= 7 && value.length <= 12) {
      return true;
    }
    return false;
  }

  /*==============check lenght of phone =================*/
  static bool postCodeLength(String value) {
    if (value.length >= 6 || value.length <= 2) {
      return true;
    }
    return false;
  }

  /*==============check lenght of password =================*/
  static bool isPasswordValidation(String value) {
    if (value.length >= 8 && value.length <= 16) {
      return true;
    }
    return false;
    return false;
  }

  /*===============validate name field=================*/
  static bool validateNameField(String value) {
    if (value.isNotEmpty) {
      String pattern = r'(^[a-zA-Z ]*$)';
      RegExp regExp = RegExp(pattern);
      if (regExp.hasMatch(value)) {
        return true;
      }
    }
    return false;
  }

  /*===============validate full name field=================*/
  static bool validateFullNameField(String value) {
    if (value.length > 2) {
      String pattern = r'(^[a-zA-Z ]*$)';
      RegExp regExp = RegExp(pattern);
      if (regExp.hasMatch(value)) {
        return true;
      }
    }
    return false;
  }

  /*===============validate name field=================*/
  static bool passwordLength(String value) {
    if (value.length < 8) {
      return false;
    }
    return true;
  }

  static bool validateVerificationCodeLength(String value) {
    if (value.length < 6) {
      return false;
    }
    return true;
  }

  /*========================validate email field=============*/

  static bool validateEmail(String email) {
    //String pattern = r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(email)) {
      return true;
    }
    return false;
  }

  /*========================validate email field=============*/
  static bool validatePassword(String pass) {
    // String pattern = r"^(?=.*[a-zA-Z])(?=.*?[0-9])";
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (regExp.hasMatch(pass)) {
      return true;
    }
    return false;
  }

  /*========================validate username field=============*/
  static bool validateUserName(String pass) {
    // String pattern = r"^[a-zA-Z0-9]";
    String pattern = r"^[._a-zA-Z0-9]+$";
    RegExp regExp = RegExp(pattern);
    //RegExp regExp1 = new RegExp(r"^[0-9]");
    RegExp regExp2 = RegExp(r"^[.]");
    if (regExp.hasMatch(pass)) {
      if (pass.startsWith(regExp2)) {
        return false;
      }
      return true;
    }
    return false;
  }

  /*================validate card Number only =============*/

  static bool cardNumberOnly(String value) {
    if (value.length < 3) {
      return false;
    }
    return true;
  }

  /*========================validate full name with dot field=============*/
  static bool validateFullNameWithDotAndSpace(String pass) {
    // String pattern = r"^[a-zA-Z0-9]";
    String pattern = r"^[._a-zA-Z ]+$";
    RegExp regExp = RegExp(pattern);
    //RegExp regExp1 = new RegExp(r"^[0-9]");
    RegExp regExp2 = RegExp(r"^[.]");
    if (regExp.hasMatch(pass)) {
      if (pass.startsWith(regExp2)) {
        return false;
      }
      return true;
    }
    return false;
  }

  static bool onlyNumberAndCharacter(String pass) {
    // String pattern = r"^[a-zA-Z0-9]";
    String pattern = r"^(?=.*\d)(?=.*[A-Za-z])[A-Za-z0-9]{1,12}$";
    RegExp regExp = RegExp(pattern);
    //RegExp regExp1 = new RegExp(r"^[0-9]");
    if (regExp.hasMatch(pass)) {
      return true;
    }
    return false;
  }
}
