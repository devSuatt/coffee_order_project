class Users {

  final String name;
  final String uid;
  final String email;
  final String role;
  final String password;

  Users({this.name, this.uid, this.email, this.role, this.password});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'email': email,
      'role': role,
      'password': password,
    };
  }

}