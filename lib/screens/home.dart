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

class _Home extends State<Home> with SingleTickerProviderStateMixin{
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text('Kidnopathy'),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              backgroundColor: Theme.of(context).primaryColor,
              bottom: TabBar(
                tabs: <Tab>[
                  Tab(text: 'Home', icon: FaIcon(FontAwesomeIcons.home),),
                  Tab(text: 'History', icon: FaIcon(FontAwesomeIcons.history)),
                  Tab(text: 'Profile', icon: FaIcon(FontAwesomeIcons.user)),
                ],
                controller: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            //KidneyDiseaseDetection(),
            UploadImageScreen(),
            HistoryScreen(),
            ProfilePage(),
          ],
        ),
      ),
    );


    /*return SafeArea(
        top: false,
        bottom: false,
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Demo Application'),
              backgroundColor: Theme.of(context).primaryColor,
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Home', icon: FaIcon(FontAwesomeIcons.home),),
                  Tab(text: 'History', icon: FaIcon(FontAwesomeIcons.history)),
                  Tab(text: 'Profile', icon: FaIcon(FontAwesomeIcons.user)),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                UploadImageScreen(),
                HistoryScreen(),
                ProfilePage(),
              ],
            ),
          ),
    )
    );*/
  }
}