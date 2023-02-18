import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project/db/database.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

final logger = Logger();

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CatalogPage(),
    );
  }
}

class CatalogPage extends StatefulWidget {
  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  // DatabaseHelper クラスのインスタンス取得
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dbHelper.select('category, name, limit_date'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final catalog = snapshot.data!; // category, name, limit_dateの全データ
          Map<String, List<List<String>>> itemsByCategory = {};

          for (var map in catalog) {
            List<String> itemlimit = [];
            String category = map['category'];
            String name = map['name'];
            String date = map['limit_date'];
            itemlimit.add(name);
            itemlimit.add(date);
            itemsByCategory[category] ??= [];
            itemsByCategory[category]!.add(itemlimit);
          }

          List<Widget> expansionTiles =
              itemsByCategory.keys.toList().map((categoryName) {
            return ExpansionTile(
              title: Text(
                categoryName,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              children: itemsByCategory[categoryName]!.map((itemName) {
                return GestureDetector(
                  onTap: () {
                    // 修正画面に遷移 （未実装）
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => hoge),
                    // );
                  },
                  child: ListTile(
                    title: Text(itemName[0]),
                    subtitle: Text(() {
                      String limitDate = itemName[1];
                      try {
                        return DateFormat('yyyy/MM/dd')
                            .format(DateTime.parse(limitDate));
                      } catch (e) {
                        return limitDate;
                      }
                    }()),
                  ),
                );
              }).toList(),
            );
          }).toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text('一覧'),
            ),
            body: ListView(children: expansionTiles),
            // 右下の＋ボタンで登録画面に遷移
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // CatalogPageの状態をリセットし、新しいデータを取得
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CatalogPage()),
            );
          },
        ),
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
    logger.d(allRows);
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
