import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/db/database.dart';
import 'dart:async';
import 'dart:io';
import 'package:project/main.dart';
//import 'package:project/screens/catalog.dart';

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
      //home: EditPage(title: 'image_picker'),
    );
  }
}

class EditPage extends StatefulWidget {
  final int id;
  EditPage({required this.id});
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final dbHelper = DatabaseHelper.instance; //databaseインスタンスを作成
  final picker = ImagePicker(); //画像をギャラリーから取得するために使用
  File? _image; //画像を取得
  late String category; //カテゴリーを取得
  late String name; //商品名を取得
  late String purchaseDate; //購入日を取得
  late String consumeDate; //消費期限を取得
  late String memo; //メモ内容を取得
  int? id;
  void _update() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: id, //更新するデータのID
      DatabaseHelper.columnCategory: category,
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnPurchase: purchaseDate,
      DatabaseHelper.columnLimit: consumeDate,
      DatabaseHelper.columnPhotoPath: _image,
      DatabaseHelper.columnMemo: memo,
    };
    final rowsAffected = await dbHelper.update(row);
    print(rowsAffected);
  }

  void _delete() async {
    final rowsDeleted = await dbHelper.delete(id!); //削除するデータのID
  }

  ///ギャラリーから画像を取得
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
    id = widget.id;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(centerTitle: true, title: Text('編集画面')),
      body: SingleChildScrollView(
        child: Container(
          //画面の上下左右に余白を設定
          margin: EdgeInsets.all(20),
          //ウィジェットを縦並びで配置
          child: Column(
            children: <Widget>[
              //カテゴリテキストの設定
              Container(
                width: double.infinity,
                child: Text(
                  'カテゴリ(必須)',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              //テキストフィールドの設定
              SizedBox(
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                      //contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      hintText: ' 例) 肉'),
                  //入力したカテゴリーを格納
                  onChanged: (text) {
                    category = text;
                  },
                ),
              ),
              //商品名テキストの設定
              Container(
                margin: EdgeInsets.only(top: 10),
                width: double.infinity,
                child: Text(
                  '商品名(必須)',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              //テキストフィールドの設定
              SizedBox(
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    //contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    hintText: ' 例) 豚肉',
                  ),
                  //入力した商品名を格納
                  onChanged: (text) {
                    name = text;
                  },
                ),
              ),
              //購入日テキストの設定
              Container(
                margin: EdgeInsets.only(top: 10),
                width: double.infinity,
                child: Text(
                  '購入日(必須)',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              //テキストフィールドの設定
              SizedBox(
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    //contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    hintText: ' 例) 2023/3/5',
                  ),
                  //入力した購入日を格納
                  onChanged: (text) {
                    purchaseDate = text;
                  },
                ),
              ),
              //消費期限テキストの設定
              Container(
                margin: EdgeInsets.only(top: 10),
                width: double.infinity,
                child: Text(
                  '期限(必須)',
                  //textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              //テキストフィールドの設定
              SizedBox(
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    //contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    hintText: ' 例) 2023/5/20',
                  ),
                  //入力した期限を格納
                  onChanged: (text) {
                    consumeDate = text;
                  },
                ),
              ),
              //メモテキストの設定
              Container(
                width: double.infinity,
                child: Text(
                  'メモ(任意)',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              //テキストフィールドの設定
              SizedBox(
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                      //contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      hintText: ' メモしたいことがあれば入力して下さい'),
                  //入力したメモを格納
                  onChanged: (text) {
                    memo = text;
                  },
                ),
              ),
              //画像添付テキストの設定
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
                    //イメージアイコンの設定
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: ElevatedButton(
                        child: Icon(Icons.image),
                        onPressed: _getImage, //ボタンが押されたとき
                      ),
                    ),
                  ],
                ),
              ),
              //画像をデバイスから取得する
              _image == null ? Text('画像が選択されていません') : Image.file(_image!),
              //ボタンの設定
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //戻るボタンの設定
                    ElevatedButton(
                      child: Text('戻る'),
                      onPressed: () {
                        //一覧画面に戻る
                        Navigator.pop(context);
                      },
                    ),
                    //登録ボタンの設定
                    ElevatedButton(
                      child: Text('更新'),
                      onPressed: () {
                        //データベースに情報を登録し、一覧画面に戻る
                        _update();
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      child: Text('削除'),
                      onPressed: () {
                        //データベースからデータを消す
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
