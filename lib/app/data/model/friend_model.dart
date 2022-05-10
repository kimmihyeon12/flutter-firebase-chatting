import 'dart:convert';

FriendUsersModel FriendUsersModelFromJson(String str) =>
    FriendUsersModel.fromJson(json.decode(str));

String FriendUsersModelToJson(FriendUsersModel data) =>
    json.encode(data.toJson());

class FriendUsersModel {
  FriendUsersModel({
    this.email,
    this.name,
    this.photoUrl,
    this.prvPhotoUrl,
    this.img,
    this.prvImg,
    this.msg,
    this.time,
    this.datetime,
    this.read_index,
    this.backgroundImgUrl,
  });

  String? email;
  String? name;
  String? photoUrl;
  String? prvPhotoUrl;
  String? img;
  String? prvImg;
  String? msg;
  String? time;
  DateTime? datetime;
  int? read_index;
  String? backgroundImgUrl;

  factory FriendUsersModel.fromJson(Map<String, dynamic> json) =>
      FriendUsersModel(
        email: json["email"],
        name: json["name"],
        photoUrl: json["photoUrl"],
        prvPhotoUrl: json["prvPhotoUrl"],
        img: json["img"],
        prvImg: json["prvImg"],
        msg: json["msg"],
        time: json["time"],
        datetime: json["datetime"],
        read_index: json["read_index"],
        backgroundImgUrl: json["backgroundImgUrl"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "photoUrl": photoUrl,
        "prvPhotoUrl": prvPhotoUrl,
        "img": img,
        "prvImg": prvImg,
        "msg": msg,
        "time": time,
        "datetime": datetime,
        "read_index": read_index,
        "backgroundImgUrl": backgroundImgUrl,
      };
}
