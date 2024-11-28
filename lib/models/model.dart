class LoginModel {
  String? message;
  UserData? userData;

  LoginModel({this.message, this.userData});

  LoginModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    userData = json['user_data'] != null
        ? new UserData.fromJson(json['user_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (userData != null) {
      data['user_data'] = this.userData!.toJson();
    }
    return data;
  }
}
class UserData {
  String? accessToken;
  String? email;
  int? id;
  int? userType;

  UserData({this.accessToken, this.email, this.id, this.userType});

  UserData.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    email = json['email'];
    id = json['id'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['email'] = this.email;
    data['id'] = this.id;
    data['user_type'] = this.userType;
    return data;
  }
}




class RegistrationModel {
  String? message;

  RegistrationModel({this.message});

  RegistrationModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}


