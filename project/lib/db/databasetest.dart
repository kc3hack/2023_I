import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/db/database.dart';
import 'package:logger/logger.dart';

final logger = Logger();

void main() => runApp(const DataBaseTestPage());

class DataBaseTestPage extends StatelessWidget {
  const DataBaseTestPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  // DatabaseHelper クラスのインスタンス取得
  final dbHelper = DatabaseHelper.instance;

  MyHomePage({super.key});

  // homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLiteデモ'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: _insert,
              child: const Text(
                '登録',
                style: TextStyle(fontSize: 28),
              ),
            ),
            ElevatedButton(
              onPressed: _query,
              child: const Text(
                '照会',
                style: TextStyle(fontSize: 28),
              ),
            ),
            ElevatedButton(
              onPressed: _update,
              child: const Text(
                '更新',
                style: TextStyle(fontSize: 28),
              ),
            ),
            ElevatedButton(
              onPressed: _delete,
              child: const Text(
                '削除',
                style: TextStyle(fontSize: 28),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/'),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  // 登録ボタンクリック
  void _insert() async {
    // row to insert
    const List<String> cat = ['肉.豚', '肉.牛', '魚', '野菜', '果物'];
    Map<String, dynamic> row = {
      DatabaseHelper.columnCategory: cat[Random().nextInt(5)],
      DatabaseHelper.columnName: '豚バラ',
      DatabaseHelper.columnPurchase: '20230214',
      DatabaseHelper.columnLimit: '20230218',
      DatabaseHelper.columnPhotoPath: 'Path/To/Photo.jpg',
      DatabaseHelper.columnMemo: '残り半分',
    };
    final id = await dbHelper.insert(row);
    logger.d('登録しました。id: $id');
  }

  // 照会ボタンクリック
  void _query() async {
    final allRows = await dbHelper.getCategory(); //登録されているカテゴリ一覧を取得
    //final allRows = await dbHelper.where('categoly LIKE \'肉.豚\'');//カテゴリが肉.豚の物を取得
    //final allRows = await dbHelper.where('categoly LIKE \'肉.%\'');//カテゴリが肉の物を取得
    //final allRows = await dbHelper.where('_id = 3');//ID=3を取得
    logger.d('全てのデータを照会しました。');
    allRows.forEach(logger.d);
  }

  // 更新ボタンクリック
  void _update() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1, //更新するデータのID
      DatabaseHelper.columnCategory: '肉.豚',
      DatabaseHelper.columnName: '豚こま切れ',
      DatabaseHelper.columnPurchase: '20230214',
      DatabaseHelper.columnLimit: '20230218',
      DatabaseHelper.columnPhotoPath: 'Path/To/Photo.jpg',
      DatabaseHelper.columnMemo: '残り半分',
    };
    final rowsAffected = await dbHelper.update(row);
    logger.d('更新しました。 ID：$rowsAffected ');
  }

  // 削除ボタンクリック
  void _delete() async {
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id!); //削除するデータのID
    logger.d('削除しました。 $rowsDeleted ID: $id');
  }
}
