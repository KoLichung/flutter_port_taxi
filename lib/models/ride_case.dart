class RideCase {
  int? id;
  String? userName;
  String? userEmail;
  String? caseState;
  bool? isEnglish;
  String? onLat;
  String? onLng;
  String? onAddress;
  String? onAddressEn;
  String? offLat;
  String? offLng;
  String? offAddress;
  String? offAddressEn;
  String? driverName;
  String? carModel;
  String? carIdNumber;
  int? expectMinutes;
  int? caseMoney;
  String? createTime;
  String? confirmTime;
  String? arrivedTime;
  String? catchedTime;
  String? offTime;
  int? user;

  RideCase(
      {this.id,
        this.userName,
        this.userEmail,
        this.caseState,
        this.isEnglish,
        this.onLat,
        this.onLng,
        this.onAddress,
        this.onAddressEn,
        this.offLat,
        this.offLng,
        this.offAddress,
        this.offAddressEn,
        this.driverName,
        this.carModel,
        this.carIdNumber,
        this.expectMinutes,
        this.caseMoney,
        this.createTime,
        this.confirmTime,
        this.arrivedTime,
        this.catchedTime,
        this.offTime,
        this.user});

  RideCase.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    caseState = json['case_state'];
    isEnglish = json['is_english'];
    onLat = json['on_lat'];
    onLng = json['on_lng'];
    onAddress = json['on_address'];
    onAddressEn = json['on_address_en'];
    offLat = json['off_lat'];
    offLng = json['off_lng'];
    offAddress = json['off_address'];
    offAddressEn = json['off_address_en'];
    driverName = json['driver_name'];
    carModel = json['car_model'];
    carIdNumber = json['car_id_number'];
    expectMinutes = json['expect_minutes'];
    caseMoney = json['case_money'];
    createTime = json['create_time'];
    confirmTime = json['confirm_time'];
    arrivedTime = json['arrived_time'];
    catchedTime = json['catched_time'];
    offTime = json['off_time'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['user_email'] = this.userEmail;
    data['case_state'] = this.caseState;
    data['is_english'] = this.isEnglish;
    data['on_lat'] = this.onLat;
    data['on_lng'] = this.onLng;
    data['on_address'] = this.onAddress;
    data['on_address_en'] = this.onAddressEn;
    data['off_lat'] = this.offLat;
    data['off_lng'] = this.offLng;
    data['off_address'] = this.offAddress;
    data['off_address_en'] = this.offAddressEn;
    data['driver_name'] = this.driverName;
    data['car_model'] = this.carModel;
    data['car_id_number'] = this.carIdNumber;
    data['expect_minutes'] = this.expectMinutes;
    data['case_money'] = this.caseMoney;
    data['create_time'] = this.createTime;
    data['confirm_time'] = this.confirmTime;
    data['arrived_time'] = this.arrivedTime;
    data['catched_time'] = this.catchedTime;
    data['off_time'] = this.offTime;
    data['user'] = this.user;
    return data;
  }
}