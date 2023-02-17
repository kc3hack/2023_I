// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:project/db/database.dart';
import 'package:logger/logger.dart';
import 'package:project/main.dart';

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
            TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: 'カテゴリー'),
            ),
            TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: '分類'),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]')), //英小文字のみ許可
                ],
                decoration: InputDecoration(hintText: '購入日'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[0-9]')), //英小文字のみ許可
                ],
                decoration: InputDecoration(hintText: '消費期限'),
              ),
            ),
            TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: '写真'),
            ),
            TextField(
              autofocus: true,
              decoration: InputDecoration(hintText: 'その他メモ'),
            ),
          ],
        ),
      ),
    );
  }
}
