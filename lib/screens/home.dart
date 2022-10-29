import 'package:firebase/screens/upload_screen.dart';
import 'package:firebase/screens/history_screen.dart';
import 'package:firebase/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home>{
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Demo Application'),
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Home', icon: FaIcon(FontAwesomeIcons.home),),
                  Tab(text: 'History', icon: FaIcon(FontAwesomeIcons.history)),
                  Tab(text: 'Profile', icon: FaIcon(FontAwesomeIcons.user)),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                UploadImage(),
                HistoryWidget(),
                ProfilePage(),
              ],
            ),
          ),
    )
    );
  }
}