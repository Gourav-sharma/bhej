
import 'dart:convert';

class UserContact {
  String name="", phone="";
  UserContact({
    required this.name,
    required this.phone,
  });

  factory UserContact.fromJson(Map<String, dynamic> jsonData) {
    return UserContact(
      name: jsonData['name'],
      phone: jsonData['phone'],

    );
  }

  static Map<String, dynamic> toMap(UserContact music) => {
    'name': music.name,
    'phone': music.phone,

  };

  static String encode(List<UserContact> musics) => json.encode(
    musics
        .map<Map<String, dynamic>>((music) => UserContact.toMap(music))
        .toList(),
  );

  static List<UserContact> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<UserContact>((item) => UserContact.fromJson(item))
          .toList();
}