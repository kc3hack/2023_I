import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/db/database.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CatalogCreate(title: 'image_picker'),
    );
  }
}

class CatalogCreate extends StatefulWidget {
  const CatalogCreate({super.key, required this.title});
  final String title;

  @override
  State<CatalogCreate> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CatalogCreate> {
  final picker = ImagePicker();
  File _image = File('');

  Future _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('登録画面')),
      body: Container(
        //画面の上下左右に余白を設定
        margin: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            //カテゴリの設定
            Container(
              width: double.infinity,
              child: Text(
                'カテゴリ',
                //textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                  //contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  hintText: 'カテゴリを入力してください(必須)'),
            ),
            //商品名の設定
            Container(
              margin: EdgeInsets.only(top: 10),
              width: double.infinity,
              child: Text(
                '商品名',
                //textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                //ontentPadding: EdgeInsets.all(20),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  ),
                ),
                hintText: '商品名を入力して下さい(必須)',
              ),
            ),
            //消費期限の設定
            Container(
              margin: EdgeInsets.only(top: 10),
              width: double.infinity,
              child: Text(
                '消費期限',
                //textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                //contentPadding: EdgeInsets.all(20),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  ),
                ),
                hintText: '消費期限を入力して下さい(必須)',
              ),
            ),
            //量の設定
            Container(
              margin: EdgeInsets.only(top: 10),
              width: double.infinity,
              child: Text(
                '量',
                //textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                //contentPadding: EdgeInsets.all(20),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  ),
                ),
                hintText: '量を入力して下さい(必須)',
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: double.infinity,
              child: Row(
                children: [
                  Text(
                    '画像を添付して下さい(任意)',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                      child: Icon(Icons.image),
                      onPressed: _getImage,
                    ),
                  ),
                ],
              ),
            ),
            _image != '' ? Text('No image selected.') : Image.file(_image),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text('戻る'),
                    onPressed: () {
                      //一覧画面に戻る
                    },
                  ),
                  ElevatedButton(
                    child: Text('登録'),
                    onPressed: () {
                      //データベースに情報を登録
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
