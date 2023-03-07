class UserModel {
  String? email;
  String? age;
  String? role;
  String? uid;
  String? name;
  String? number;
  String? isAssigned;
  String? image;

// receiving data
  UserModel({this.uid, this.email, this.role, this.name, this.number, this.age, this.isAssigned, this.image});
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      role: map['role'],
      name: map['name'],
      number: map['number'],
      age: map['age'],
      isAssigned: map['isAssigned'],
      image: map['image'],
    );
  }
// sending data
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'name': name,
      'number': number,
      'age': age,
      'isAssigned': isAssigned,
      'image': image,
    };
  }
}
