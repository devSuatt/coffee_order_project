
class Brew {
  String brewId;
  final String sugars;
  final String name;
  final String customerName;
  final String role;
  final int strength;
  final bool ready;
  final String date;
  final String userId;


  Brew({this.brewId, this.sugars, this.name, this.customerName, this.strength, this.role, this.ready, this.date, this.userId});

  Map<String, dynamic> toMap() {
    return {
      'brewId': brewId,
      'sugars': sugars,
      'name': name,
      'customerName': customerName,
      'strength': strength,
      'role': role,
      'ready': ready,
      'date': date,
      'userId': userId,
    };
  }

}

class UserData {

  final String uid;
  final String brewId;
  final String name;
  final String customerName;
  final String sugars;
  final String role;
  final int strength;
  final bool ready;
  final String date;

  UserData({this.uid, this.brewId, this.name, this.customerName, this.sugars, this.strength, this.role, this.ready, this.date});

}
