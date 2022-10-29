import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? phone;
  String? name;
  String? image;
  String? age;

  UserModel ({this.uid, this.email, this.phone, this.name, this.image, this.age});

  /*UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    uid = doc.documentID;
    email = doc.data['email'];
    phone = doc.data['mobileNumber'];
    name = doc.data['fullName'];
    age = doc.data['age'];
    image = doc.data['image'];
  }*/
}