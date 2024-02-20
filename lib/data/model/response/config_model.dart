class ConfigModel {
  String? _appName;
  String? _appLogo;
  String? _appAddress;
  String? _appPhone;
  String? _appEmail;
  BaseUrls? _baseUrls;
  String? _currencySymbol;
  String? _digitalPayment;
  String? _termsAndConditions;
  String? _privacyPolicy;
  String? _aboutUs;

  ConfigModel({
    String? appName,
    String? appLogo,
    String? appAddress,
    String? appPhone,
    String? appEmail,
    BaseUrls? baseUrls,
    String? currencySymbol,
    String? digitalPayment,
    String? termsAndConditions,
    String? privacyPolicy,
    String? aboutUs,
  }) {
    this._appName = appName;
    this._appLogo = appLogo;
    this._appAddress = appAddress;
    this._appPhone = appPhone;
    this._appEmail = appEmail;
    this._baseUrls = baseUrls;
    this._currencySymbol = currencySymbol;
    this._digitalPayment = digitalPayment;
    this._termsAndConditions = termsAndConditions;
    this._aboutUs = aboutUs;
    this._privacyPolicy = privacyPolicy;
  }

  String? get appName => _appName;
  String? get appLogo => _appLogo;
  String? get appAddress => _appAddress;
  String? get appPhone => _appPhone;
  String? get appEmail => _appEmail;
  BaseUrls? get baseUrls => _baseUrls;
  String? get currencySymbol => _currencySymbol;
  String? get digitalPayment => _digitalPayment;
  String? get termsAndConditions => _termsAndConditions;
  String? get aboutUs => _aboutUs;
  String? get privacyPolicy => _privacyPolicy;

  ConfigModel.fromJson(Map<String, dynamic> json) {
    _appName = json['app_name'];
    _appLogo = json['app_logo'];
    _appAddress = json['app_address'];
    _appPhone = json['app_phone'];
    _appEmail = json['app_email'];
    _baseUrls = json['base_urls'] != null
        ? new BaseUrls.fromJson(json['base_urls'])
        : null;
    _currencySymbol = json['currency_symbol'];
    _digitalPayment = json['digital_payment'];
    _termsAndConditions = json['terms_and_conditions'];
    _privacyPolicy = json['privacy_policy'];
    _aboutUs = json['about_us'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_name'] = this._appName;
    data['app_logo'] = this._appLogo;
    data['app_address'] = this._appAddress;
    data['app_phone'] = this._appPhone;
    data['app_email'] = this._appEmail;
    if (this._baseUrls != null) {
      data['base_urls'] = this._baseUrls!.toJson();
    }
    data['currency_symbol'] = this._currencySymbol;
    data['digital_payment'] = this._digitalPayment;
    data['terms_and_conditions'] = this._termsAndConditions;
    data['privacy_policy'] = this.privacyPolicy;
    data['about_us'] = this.aboutUs;

    return data;
  }
}

class BaseUrls {
  String? _notificationImageUrl;
  String? _userImageUrl;
  String? _chatImageUrl;
  String? _placeImageUrl;
  String? _driverImageUrl;
  String? _categoryImageUrl;
  String? _paymentUrl;
  String? _taskImageUrl;
  BaseUrls({
    String? taskImageUrl,
    String? notificationImageUrl,
    String? userImageUrl,
    String? chatImageUrl,
    String? placeImageUrl,
    String? driverImageUrl,
    String? categoryImageUrl,
    String? paymentUrl,
  }) {
    this._notificationImageUrl = notificationImageUrl;
    this._userImageUrl = userImageUrl;
    this._chatImageUrl = chatImageUrl;
    this._taskImageUrl = taskImageUrl;
    this._chatImageUrl = chatImageUrl;
    this._placeImageUrl = placeImageUrl;
    this._driverImageUrl = driverImageUrl;
    this._categoryImageUrl = categoryImageUrl;
    this._paymentUrl = paymentUrl;
  }

  String? get notificationImageUrl => _notificationImageUrl;
  String? get userImageUrl => _userImageUrl;
  String? get chatImageUrl => _chatImageUrl;
  String? get placeImageUrl => _placeImageUrl;
  String? get driverImageUrl => _driverImageUrl;
  String? get categoryImageUrl => _categoryImageUrl;
  String? get paymentUrl => _paymentUrl;
  String? get taskImageUrl => _taskImageUrl;

  BaseUrls.fromJson(Map<String, dynamic> json) {
    _notificationImageUrl = json['notification_image_url'];
    _userImageUrl = json['user_image_url'];
    _chatImageUrl = json['chat_image_url'];
    _placeImageUrl = json['place_image_url'];
    _driverImageUrl = json['driver_image_url'];
    _categoryImageUrl = json['category_image_url'];
    _paymentUrl = json['payment_url'];
    _taskImageUrl = json['task_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_image_url'] = this._notificationImageUrl;
    data['user_image_url'] = this._userImageUrl;
    data['chat_image_url'] = this._chatImageUrl;

    return data;
  }
}
