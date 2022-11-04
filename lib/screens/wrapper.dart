import 'package:firebase/screens/category.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../models/FirebaseUser.dart';
import 'authenticate/handler.dart';
import 'home.dart';

class Wrapper extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    final user =  Provider.of<FirebaseUser?>(context);

    if(user == null)
    {
      //return Handler();
      return Category();
    }else
    {
      return Home();
    }

  }
}