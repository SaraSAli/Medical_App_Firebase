import 'dart:io';

import 'authenticate/handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../models/FirebaseUser.dart';
import '../services/auth.dart';
import 'authenticate/handler.dart';
import 'home.dart';

class Category extends StatelessWidget {
  const Category({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Future<bool> _onWillPop() async {
      return (await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: new Text(
                "Exit Application",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: new Text("Are You Sure?"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                TextButton(
                  child: new Text(
                    "No",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: new Text(
                    "Yes",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    exit(0);
                  },
                ),
              ],
            ),
          )) ??
          false;
    }

    return StreamProvider<FirebaseUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            body: SafeArea(
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: height * 0.065,
                    ),
                    Column(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.2),
                          radius: height * 0.075,
                          child: Image(
                            image: AssetImage("assets/doctor.png"),
                            height: height * 0.2,
                          ),
                        ),
                        ElevatedButton(onPressed: (){
                          Navigator.pushNamed(context, '/Login');
                        }, child: Text('Doctor'),
                        ),
                        SizedBox(
                          height: height * 0.1,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.2),
                          radius: height * 0.075,
                          child: Image(
                            image: AssetImage("assets/patient.png"),
                            height: height * 0.2,
                          ),
                        ),
                        ElevatedButton(onPressed: (){
                          Navigator.pushNamed(context, '/Login');
                        }, child: Text('Patient'),),
                        SizedBox(
                          height: height * 0.13,
                        ),
                        SizedBox(height: 5,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }

  Widget patDocBtn(String categoryText, context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      width: MediaQuery.of(context).size.width * 0.5,
      child: ElevatedButton(
        onPressed: () {
          if (categoryText == 'Doctor') {
            Navigator.pushNamed(context, '/Login');
          } else {
            Navigator.pushNamed(context, '/Login');
          }
        },
        child: Text("I am $categoryText"),
      ),
    );
  }
}
