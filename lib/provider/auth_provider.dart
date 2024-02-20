import 'dart:convert';
import 'dart:io';
import 'package:alphawash/provider/profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:alphawash/data/model/response/base/api_response.dart';
import 'package:alphawash/data/model/response/base/error_response.dart';
import 'package:alphawash/data/model/response/response_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:alphawash/data/model/response/signup_model.dart';
import 'package:alphawash/data/repository/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:alphawash/utill/app_constants.dart';
import 'package:provider/provider.dart';

class CustomerAuthProvider extends ChangeNotifier {
  final AuthRepo? authRepo;
  CustomerAuthProvider({@required this.authRepo});

  ///new change
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _checkEmailLoading = false;
  bool get checkEmailLoading => _checkEmailLoading;

  String _loginErrorMessage = '';
  String get loginErrorMessage => _loginErrorMessage;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String _registrationErrorMessage = '';
  String get registrationErrorMessage => _registrationErrorMessage;

  String _checkEmailMessage = '';
  String get checkEmailMessage => _checkEmailMessage;

  //GOOGLE LOGIN
  String? _accessToken;
  String? get accessToken => _accessToken;

  String? _idToken;
  String? get idToken => _idToken;

  String? _googleFullName;
  String? get googleFullName => _googleFullName;

  String? _googleEmail;
  String? get googleEmail => _googleEmail;

  String? _googleProviderId;
  String? get googleProviderId => _googleProviderId;

  String _verificationMsg = '';
  String get verificationMessage => _verificationMsg;

  bool _isEnableVerificationCode = false;
  bool get isEnableVerificationCode => _isEnableVerificationCode;

  String _verificationCode = '';
  String get verificationCode => _verificationCode;

  bool _verifyTokenLoading = false;
  bool get verifyTokenLoading => _verifyTokenLoading;

  bool _isverificationButtonLoading = false;
  bool get isverificationButtonLoading => _isverificationButtonLoading;

  bool _termsAccepted = false;
  bool get termsAccepted => _termsAccepted;

  SignUpModel? _signUpModel;
  SignUpModel? get signUpModel => _signUpModel;

  bool _isForgotPasswordLoading = false;
  bool get isForgotPasswordLoading => _isForgotPasswordLoading;

  File? _profileImageFile;
  File? get profileImageFile => _profileImageFile;

  File? _driverLicenseImageFile;
  File? get driverLicenseImageFile => _driverLicenseImageFile;

  File? _driverInsuranceImageFile;
  File? get driverInsuranceImageFile => _driverInsuranceImageFile;

  String _email = '';
  String get email => _email;

  void setTermValue(bool value) {
    _termsAccepted = value;
    notifyListeners();
  }

  void setProfileImage(File image) {
    _profileImageFile = image;
    notifyListeners();
  }

  void setLicenseImage(File image) {
    _driverLicenseImageFile = image;
    notifyListeners();
  }

  void setInsuranceImage(File image) {
    _driverInsuranceImageFile = image;
    notifyListeners();
  }

  void setSignUpModel(SignUpModel model) {
    _signUpModel = model;
    notifyListeners();
  }

  String getUserNumber() {
    return authRepo!.getUserNumber() ?? "";
  }

  String getUserPassword() {
    return authRepo!.getUserPassword() ?? "";
  }

  var box = Hive.box('myBox');

  Future<bool> checkLoggedIn() async {
    var _token = box.get(AppConstants.TOKEN);
    _isLoggedIn = _token != null ? true : false;
    print('token --  ${_token}');
    return _token != null ? true : false;
  }

  void clearVerificationMessage() {
    _verificationMsg = '';
  }

  Future<ResponseModel> login(
      BuildContext context, String email, String password) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();
    signInWithEmailAndPass(context , email.toString(), password.toString())
        .then((value) => login(context , email, password));

    ApiResponse apiResponse =
        await authRepo!.login(email: email, password: password);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String token = map["token"];
      authRepo!.saveUserToken(token).then((value) {
        checkLoggedIn();
      });
      await authRepo!.updateToken();
      responseModel = ResponseModel(true, 'successful');
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      print(errorMessage);
      _loginErrorMessage = errorMessage;
      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  ///sign in with firebase
  Future<UserCredential> signInWithEmailAndPass(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      final profile = Provider.of<ProfileProvider>(context, listen: false);
      _fireStore.collection('usersAlphaWash').doc(userCredential.user!.uid).set(
          {'uid': profile.userInfoModel!.id, 'email': email},
          SetOptions(merge: true));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Future<ResponseModel> login(String email, String password) async {
  //   _isLoading = true;
  //   _loginErrorMessage = '';
  //   notifyListeners();
  //   ResponseModel responseModel;
  //   try {
  //     ApiResponse apiResponse = await authRepo!.login(email: email, password: password);
  //
  //     if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
  //       Map map = apiResponse.response!.data;
  //       String token = map["token"];
  //       authRepo!.saveUserToken(token).then((value) {
  //         checkLoggedIn();
  //       });
  //       await authRepo!.updateToken();
  //       responseModel = ResponseModel(true, 'successful');
  //     } else {
  //       String errorMessage;
  //       if (apiResponse.error is String) {
  //         errorMessage = apiResponse.error.toString();
  //       } else {
  //         errorMessage = apiResponse.error.errors[0].message;
  //       }
  //       print(errorMessage);
  //       _loginErrorMessage = errorMessage;
  //       responseModel = ResponseModel(false, errorMessage);
  //     }
  //   }catch(e){
  //     responseModel = ResponseModel(false, 'Error');
  //   }
  //
  //   _isLoading = false;
  //   notifyListeners();
  //   return responseModel;
  // }

  Future<bool> clearSharedData() async {
    _isLoading = true;
    notifyListeners();
    bool _isSuccess = await authRepo!.clearSharedData();
    _isLoading = false;
    notifyListeners();
    return _isSuccess;
  }

  updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  Future<ResponseModel> checkEmail(
      String email, String fromUpdatePassword) async {
    _checkEmailLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await authRepo!.checkEmail(email, fromUpdatePassword);

    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _checkEmailLoading = false;
      responseModel = ResponseModel(true, 'success!');
    } else {
      _checkEmailLoading = false;
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message!;
      }
      responseModel = ResponseModel(false, errorMessage);
      _checkEmailMessage = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  void resetMessages() {
    _checkEmailMessage = '';
    _registrationErrorMessage = '';
    notifyListeners();
  }

  Future<ResponseModel> registration(BuildContext context , SignUpModel signUpModel) async {
    print('signup model ${jsonEncode(signUpModel)}');
    _isLoading = true;
    _registrationErrorMessage = '';
    notifyListeners();

    signUpWithEmailAndPass(context , email.toString(), signUpModel.password.toString())
        .then((value) => registration(context , signUpModel));
    ApiResponse apiResponse = await authRepo!.registration(signUpModel);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String token = map["token"];
      authRepo!.saveUserToken(token).then((value) {
        checkLoggedIn();
      });
      await authRepo!.updateToken();
      responseModel = ResponseModel(true, 'successful');
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        errorMessage = errorResponse.errors![0].message!;
      }
      print(errorMessage);
      _registrationErrorMessage = errorMessage;
      responseModel = ResponseModel(false, errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  ///sign up with firebase
  Future<UserCredential> signUpWithEmailAndPass(BuildContext context ,
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      final profile = Provider.of<ProfileProvider>(context, listen: false);

      _fireStore
          .collection('usersAlphaWash')
          .doc(userCredential.user!.uid)
          .set({'uid': profile.userInfoModel!.id, 'email': email});
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Future<ResponseModel> registration(SignUpModel signUpModel) async {
  //   print('signup model ${jsonEncode(signUpModel)}');
  //   _isLoading = true;
  //   _registrationErrorMessage = '';
  //   notifyListeners();
  //   ApiResponse apiResponse = await authRepo!.registration(signUpModel);
  //   ResponseModel responseModel;
  //   if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
  //
  //     Map map = apiResponse.response!.data;
  //     String token = map["token"];
  //     authRepo!.saveUserToken(token).then((value) {
  //       checkLoggedIn();
  //     });
  //     await authRepo!.updateToken();
  //     responseModel = ResponseModel(true, 'successful');
  //   } else {
  //     String errorMessage;
  //     if (apiResponse.error is String) {
  //       errorMessage = apiResponse.error.toString();
  //     } else {
  //       ErrorResponse errorResponse = apiResponse.error;
  //       errorMessage = errorResponse.errors![0].message!;
  //     }
  //     print(errorMessage);
  //     _registrationErrorMessage = errorMessage;
  //     responseModel = ResponseModel(false, errorMessage);
  //
  //   }
  //   _isLoading = false;
  //   notifyListeners();
  //   return responseModel;
  // }

  updateVerificationCode(String query) {
    if (query.length == 4) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    notifyListeners();
  }

  Future<ResponseModel> verifyEmail(String email) async {
    _isverificationButtonLoading = true;
    _verificationMsg = '';
    notifyListeners();
    ApiResponse apiResponse =
        await authRepo!.verifyEmail(email, _verificationCode);
    _isverificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message!;
      }
      responseModel = ResponseModel(false, errorMessage);
      _verificationMsg = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> verifyPasswordToken(String email) async {
    _verifyTokenLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await authRepo!.verifyPasswordToken(email, _verificationCode);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _verifyTokenLoading = false;
      notifyListeners();
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      _verifyTokenLoading = false;
      notifyListeners();
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message!;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    return responseModel;
  }

  Future<ResponseModel> verifyToken(String email) async {
    _verifyTokenLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await authRepo!.verifyToken(email, _verificationCode);
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _verifyTokenLoading = false;
      notifyListeners();
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      _verifyTokenLoading = false;
      notifyListeners();
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message!;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    return responseModel;
  }

  Future<ResponseModel> forgetPassword(String email) async {
    _isForgotPasswordLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authRepo!.forgetPassword(email);
    _isForgotPasswordLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _isForgotPasswordLoading = false;
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      _isForgotPasswordLoading = false;
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message!;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    return responseModel;
  }

  Future<ResponseModel> resetPassword(
      String email, String password, String confirmPassword) async {
    _isForgotPasswordLoading = true;
    print('email : ${email}');
    notifyListeners();
    ApiResponse apiResponse =
        await authRepo!.resetPassword(email, password, confirmPassword);
    _isForgotPasswordLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      responseModel =
          ResponseModel(true, apiResponse.response!.data["message"]);
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors![0].message);
        errorMessage = errorResponse.errors![0].message!;
      }
      responseModel = ResponseModel(false, errorMessage);
    }
    return responseModel;
  }

  void resetSignUpModel() {
    _signUpModel = null;
    notifyListeners();
  }

  String getUserToken() {
    return authRepo!.getUserToken();
  }
}
