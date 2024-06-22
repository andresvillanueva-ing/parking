

// To parse this JSON data, do
//
//     final users = usersFromMap(jsonString);

import 'dart:convert';

Users usersFromMap(String str) => Users.fromMap(json.decode(str));

String usersToMap(Users data) => json.encode(data.toMap());

class Users {
    static int _NextId = 1;
    int userId;
    String? fullName;
    String? parking;
    String userName;
    String password;

    Users({
        int? userId,
        required this.fullName,
        required this.parking,
        required this.userName,
        required this.password,
    }): userId = userId ?? _NextId++, // use the next available ID if not provided
        assert(userId == null || userId > 0);

    factory Users.fromMap(Map<String, dynamic> json) => Users(
        userId: json["userId"] ?? _NextId++,
        fullName: json["fullName"],
        parking: json["parking"],
        userName: json["userName"],
        password: json["password"],
    );

    Map<String, dynamic> toMap() => {
        "userId": userId,
        "fullName": fullName,
        "parking": parking,
        "userName": userName,
        "password": password,
    };
}

