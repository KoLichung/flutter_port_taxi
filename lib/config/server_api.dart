
class ServerApi{

  static const _host ='207.148.95.172';
  // static const _host='127.0.0.1:8000';
  static const userCreate = '/api/user/create/';
  static const userToken = '/api/user/token/';
  static const userMe = '/api/user/me/';
  static const userUpdatePassword = '/api/user/update_user_password';

  // static const currentAddress = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=27.6669987,85.3071003&key=API_KEY';
  static const currentAddress = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=';
  static const postNewCase = '/api/post_new_case';


  static Uri standard({String? path, Map<String, String>? queryParameters}) {
    print(Uri.http(_host, '$path', queryParameters));
    return Uri.http (_host, '$path', queryParameters);
  }

}
