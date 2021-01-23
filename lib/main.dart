import 'package:flutter/material.dart';
import './containers/singer_detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Select_Singer(),
    );
  }
}

class Select_Singer extends StatelessWidget {
  List<String> singer_list = List();

  Widget show_Singers() {
    singer_list.add("임영웅");
    singer_list.add("영탁");
    singer_list.add("김호중");
    singer_list.add("d");

    return GridView.builder(
      itemCount: singer_list.length,
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Card(
            child: new InkWell(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: Text(
                  singer_list[index],
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // 파라미터 todo로 tap된 index의 아이템을 전달
                builder: (context) => Singer_Detail(singer: singer_list[index]),
              ),
            );
          },
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select your singer"),
      ),
      body: show_Singers(),
    );
  }
}
