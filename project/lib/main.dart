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
  var limitDateIndex; // limitDateのインデックス

  DateTime now = DateTime.now();
  late String limitColor;

  get danger => null; // 期限の警告表示色

  @override
  Widget build(BuildContext context) {
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    String date = outputFormat.format(now); // 今日の日付
    int r, g, b;
    double opacity;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dbHelper.select('category, name, limit_date'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final catalog = snapshot.data!; // category, name, limit_dateの全データ
          List<String> limitDate = [];
          Map<String, List<String>> itemsByCategory = {}; // key: メインカテゴリ, value: 商品名

          for (var map in catalog) {
            limitDate.add(map['limit_date']);
            itemsByCategory[map['category']] ??= []; // Listの初期化
            itemsByCategory[map['category']]!.add(map['name']);
          }

          List<Widget> expansionTiles =
              itemsByCategory.keys.toList().map((categoryName) {
            return ExpansionTile(
              collapsedBackgroundColor: Color.fromRGBO(220, 220, 220, 100),
              title: Text(
                categoryName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: itemsByCategory[categoryName]!.map((itemName) {
                // リストのインデックスを割り当てる
                if (limitDateIndex == null) {
                  limitDateIndex = 0;
                } else {
                  limitDateIndex++;
                }

                // 期限のフォーマット: xxxxxxxx -> yyyy/MM/dd
                String limit = outputFormat
                    .format(DateTime.parse(limitDate[limitDateIndex]));
                var limitDt = DateTime.parse(limit);
                var dateDt = DateTime.parse(date); // 今日の日付

                // 期限間近の判定
                if (dateDt.isAfter(limitDt)) {
                  // 期限切れの場合
                  r = 255;
                  g = 0;
                  b = 0;
                  opacity = 100;
                } else if (dateDt.difference(limitDt).inDays <= 4) {
                  // 期限まであと4日
                  r = 245;
                  g = 194;
                  b = 59;
                  opacity = 100;
                } else {
                  r = 0;
                  g = 0;
                  b = 0;
                  opacity = 100;
                }

                return GestureDetector(
                  onTap: () {
                    // 詳細画面に遷移？ （未実装）

                    // testcode
                    // showDialog(
                    //   context: context,
                    //   builder: (context) => AlertDialog(
                    //     content: Text('test'),
                    //   ),
                    // );
                  },
                  child: ListTile(
                    isThreeLine: true,
                    title: Text(
                      '\t$itemName',
                      style: TextStyle(color: Color.fromRGBO(r, g, b, opacity)),
                    ),
                    subtitle: Text('\t期限：$limit'),
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
