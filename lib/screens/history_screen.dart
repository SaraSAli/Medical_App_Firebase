import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../services/auth.dart';

class HistoryWidget extends StatelessWidget {
  final AuthService _auth = new AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
              future: _auth.listFiles(),
              builder: (BuildContext context, AsyncSnapshot<firebase_storage.ListResult> snapshot){
                if(snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData){
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.items.length,
                      itemBuilder: (BuildContext context, int index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: (){},
                            child: Text(snapshot.data!.items[index].name),
                          ),
                        );
                      }),
                  );
                }
                if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData){
                  return CircularProgressIndicator();
                }
                return CircularProgressIndicator();

              })
        ],
      ),
    );
  }
}
