// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:project/db/database.dart';
import 'package:logger/logger.dart';
import 'package:project/main.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final logger = Logger();
//Controllerの定義
final controller = TextEditingController();

void main() => runApp(const EditPage());

class EditPage extends StatelessWidget {
  const EditPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
    );
  }
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
      appBar: AppBar(
        title: Text('修正画面'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'カテゴリを入力してください(必須)',
                    labelText: 'カテゴリー',
                    //fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '分類',
                  border: OutlineInputBorder(),
                  labelText: '分類',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]')), //英小文字のみ許可
                ],
                decoration: InputDecoration(
                    hintText: '購入日',
                    labelText: '購入日',
                    border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]')), //英小文字のみ許可
                ],
                decoration: InputDecoration(
                    hintText: '消費期限',
                    border: OutlineInputBorder(),
                    labelText: '消費期限'),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'その他メモ',
                  labelText: 'その他',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 5,
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
                    child: Text('編集'),
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
