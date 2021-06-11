import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


class FormValidationFunction {
  String? matchValidator({required String value1, required String value2, required String errorMessage}){
    return value1 == value2 ? null : errorMessage;
  }

  String? blankValidator({required String value, required String errorMessage}){
    return value != "" ? null : errorMessage;
  }

  String? regularExpressionValidator({String? type, required String value, required String errorMessage}){
    switch (type) {
      case "email":
        {
          RegExp emailRegExp = RegExp(
              r'^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$');
          return emailRegExp.hasMatch(value) ? null : errorMessage;
        }
      case "password":
        {
          RegExp passwordRegExp = RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9]).{8,20}$');
          return passwordRegExp.hasMatch(value) ? null : errorMessage;
        }


      case "birthday":
        {
          RegExp birthdayRegExp = RegExp(r'^(19|20)\d{2}[.](0[1-9]|1[012])[.](0[1-9]|[12][0-9]|3[0-1])$');
          return birthdayRegExp.hasMatch(value) ? null : errorMessage;
        }

      case "phone":
        {
          RegExp phoneRegExp = RegExp(r'^[0-9]{3}[-][0-9]{4}[-][0-9]{4}$');
          return phoneRegExp.hasMatch(value) ? null : errorMessage;
        }

      default :
        return null;
    }
  }

  String? validationFunction({required List<String?> validators}){
    String _errorMessage = "";

    for(String? validator in validators){
      if(validator != null){
        _errorMessage = validator;
      }
    }

    return _errorMessage == "" ? null : _errorMessage;
  }

  String? formValidationFunction({String? type, required String value, TextEditingController? value2}){
    switch(type) {
      case "name":
        return validationFunction(
            validators: [
              blankValidator(value: value, errorMessage: 'nameBlankValidationError'.tr()),
            ]
        );
      case "email":
        return validationFunction(
            validators: [
              regularExpressionValidator(type: "email", value: value, errorMessage: 'emailRegularExpressionValidationError'.tr()),
              blankValidator(value: value, errorMessage: 'emailBlankValidationError'.tr()),
            ]
        );
      case "password":
        return validationFunction(
            validators: [
              regularExpressionValidator(type: "password", value: value, errorMessage: 'passwordRegularExpressionValidationError'.tr()),
              blankValidator(value: value, errorMessage: 'passwordBlankValidationError'.tr()),
            ]
        );

      case "confirmPassword":
        return validationFunction(
            validators: [
              matchValidator(value1: value, value2: value2!.text, errorMessage: 'confirmPasswordMatchValidationError'.tr()),
              blankValidator(value: value, errorMessage: 'passwordBlankValidationError'.tr()),
            ]
        );

      case "birthday":
        return validationFunction(
            validators: [
              regularExpressionValidator(type: "birthday", value: value, errorMessage: 'birthdayRegularExpressionValidationError'.tr()),
            ]
        );

      case "phone":
        return validationFunction(
            validators: [
              regularExpressionValidator(type: "phone", value: value, errorMessage: 'phoneRegularExpressionValidationError'.tr()),
            ]
        );

      default :
        return null;
    }
  }
}