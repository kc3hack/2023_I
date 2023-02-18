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

void main() => runApp(const CatalogPage());

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  XFile? _image;
  final picker = ImagePicker();

  Future getImageFromGarally() async {
    var imagePicker;
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
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
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('戻る'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('編集'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void setState(Null Function() param0) {}
}
