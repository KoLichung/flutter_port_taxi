import 'package:intl/intl.dart';

class DateTimeConverter{

  static date(String date){
    DateTime dateTimeDate = DateTime.parse(date);
    String stringDate = DateFormat('yyyy/MM/dd').format(dateTimeDate);
    return stringDate;
  }

  static dateTime(String dateTime){
    DateTime dateTimeDateTime = DateTime.parse(dateTime).add(const Duration(hours: 8));
    if(dateTimeDateTime.hour >= 12 && dateTimeDateTime.hour < 24){
      String stringDateTime = DateFormat('yyyy/MM/dd 下午 h:mm ').format(dateTimeDateTime);
      return stringDateTime;
    } else {
      String stringDateTime = DateFormat('yyyy/MM/dd 上午 h:mm ').format(dateTimeDateTime);
      return stringDateTime;
    }
  }

}