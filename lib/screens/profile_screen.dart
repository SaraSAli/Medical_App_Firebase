import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';

class ProfilePage extends StatelessWidget {
  final currentUser = FirebaseAuth.instance;
  final AuthService _auth = AuthService();

  String? email = '';
  String? name = '';
  String? age = '';
  String? phone = '';

  @override
  Widget build(BuildContext context) {
    final SignOut = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme
          .of(context)
          .primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          await _auth.signOut();
        },
        child: Text(
          "Logout",
          style: TextStyle(color: Theme
              .of(context)
              .primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );


    return Scaffold(
      body: Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where("uid", isEqualTo: currentUser.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                //Error Handling conditions
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        var data = snapshot.data!.docs[i];
                        email = data['email'];
                        name = data['fullName'];
                        age = data['age'];
                        phone = data['mobileNumber'];
//                        return Text("Full Name and Email: ${data['fullName']} ${data['email']}");
                        return Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                name!,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, bottom: 4.0),
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "User Information",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Card(
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                ...ListTile.divideTiles(
                                                  color: Colors.grey,
                                                  tiles: [
                                                    ListTile(
                                                      leading:
                                                      Icon(Icons.email),
                                                      title: Text("Email"),
                                                      subtitle: Text(
                                                          email!),
                                                    ),
                                                    ListTile(
                                                      leading:
                                                      Icon(Icons.phone),
                                                      title: Text("Phone"),
                                                      subtitle:
                                                      Text(phone!),
                                                    ),
                                                    ListTile(
                                                      leading:
                                                      Icon(Icons.person),
                                                      title: Text("Age"),
                                                      subtitle:
                                                      Text(age!),
                                                    ),
                                                    ListTile(
                                                      leading:
                                                      Icon(Icons.person),
                                                      title: Text("About Me"),
                                                      subtitle: Text(
                                                          "This is a about me link and you can khow about me in this section."),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                }

                return CircularProgressIndicator();
              }),
          SizedBox(
            height: 20,
          ),
          Center(child: SignOut),
        ],
      ),
    );
  }
}
