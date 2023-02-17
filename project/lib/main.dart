import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:project/db/database.dart';
import 'package:logger/logger.dart';

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

class CatalogPage extends StatelessWidget {
  // DatabaseHelper クラスのインスタンス取得
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dbHelper.select('category, name, limit_date'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // 全てのカテゴリを取得
          final catalog = snapshot.data!;
          List<List<String>> splitedList = [];
          Map<String, List<String>> itemsByCategory = {};

          int i = 0;
          for (var maps in catalog) {
            splitedList.add(maps['category'].split("."));
            splitedList[i].add(maps['name']);
            itemsByCategory[splitedList[i][0]] ??= []; // Listの初期化
            itemsByCategory[splitedList[i][0]]!.add(splitedList[i][1]);
            i++;
          }

          List<Widget> expansionTiles = [];

          print(splitedList);

          List<List<dynamic>> transposedList;
          if (splitedList.any((list) => list is List)) {
            transposedList = List.generate(
              splitedList.fold(
                  0, (maxValue, list) => max(maxValue, list.length)),
              (i) => List.generate(splitedList.length,
                  (j) => splitedList[j].length > i ? splitedList[j][i] : null),
            );
          } else {
            transposedList = [splitedList];
          }

          print(transposedList);

          // nullを消去
          List<List<dynamic>> transposedFilteredList = transposedList
              .map((list) => list.where((item) => item != null).toList())
              .toList();

          print(transposedFilteredList);

          for (int i = 0; i < transposedList.length - 1; i++) {
            expansionTiles = transposedList[i].toSet().map((categoryName) {
              return ExpansionTile(
                title: Text(categoryName == null ? "" : categoryName),
                children: transposedList[i + 1].toSet().map((path) {
                  return ListTile(
                    title: Text(path == null ? "" : path),
                  );
                }).toList(),
              );
            }).toList();
          }

          // for (int i = 0; i < splitedList.length; i++) {
          //   for (int j = 0; j < splitedList[i].length - 1; j++) {
          //     expansionTiles = transposedList[i].toSet().map((categoryName) {
          //       return ExpansionTile(
          //         title: Text(categoryName),
          //         children: transposedList[i + 1].toSet().map((path) {
          //           if (j < splitedList[i].length - 2) {
          //             return ExpansionTile(
          //               title: Text(path),
          //               children: [
          //                 ListTile(
          //                   title: Text(splitedList[i][j + 2]),
          //                 ),
          //               ],
          //             );
          //           } else {
          //             return ListTile(
          //               title: Text(path),
          //             );
          //           }
          //         }).toList(),
          //       );
          //     }).toList();
          //   }
          // }

          return Scaffold(
            appBar: AppBar(
              title: const Text('一覧'),
            ),
            body: ListView(children: expansionTiles),
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

  // Widget createTile(List<List<String>> transposedList, int i) {
  //   if (transposedList == null) return const SizedBox.shrink();

  //   int n = transposedList.length;
  //   int m = n > 0 ? transposedList[i].length : 0;
  //   List<Widget> expansionTiles = [];

  //   if (n <= 0 || m <= 0) return const SizedBox.shrink();

  //   if (m >= 3 && transposedList.any((row) => row[m-2] == null && row[m-1] == null)) {
  //     expansionTiles = transposedList[i].toSet().map((categoryName) {
  //       return ExpansionTile(
  //         title: Text(categoryName),
  //         children: [
  //           ListView.builder(
  //             itemCount: m,
  //             itemBuilder: (BuildContext context, int index) {
  //               return ListTile(
  //                 title:  Text (transposedList[i][index]),
  //               );
  //             },
  //             ),
  //         ],
  //         );
  //     } else {
  //       expansionTiles = transposedList[i].toSet().map(categoryName) {
  //         return ExpansionTile(
  //           title: Text(categoryName),
  //           children: List.generate(n, (m) {
  //             return createTile(transposedList, i+1);
  //           }),
  //         );
  //       }
  //     }
  //     )

  //   }
  // }

  // List<Widget> createTile(List<List<dynamic>> transposedList, int i) {
  //   List<Widget> expansionTiles = [];
  //   if (transposedList == null) {
  //     return expansionTiles;
  //   }

  //   int n = transposedList.length;
  //   int m = n > 0 ? transposedList[i].length - i : 0;

  //   if (n <= 0 || m <= 0) {
  //     return expansionTiles;
  //   }

  //   if (m >= 3 &&
  //       transposedList.any((row) => row[m - 2] == null && row[m - 1] == null)) {
  //     expansionTiles = transposedList[i].toSet().map((categoryName) {
  //       return ExpansionTile(
  //         title: Text(categoryName),
  //         children: [
  //           ListView.builder(
  //             itemCount: m,
  //             itemBuilder: (BuildContext context, int index) {
  //               return ListTile(
  //                 title: Text(transposedList[i][index]),
  //               );
  //             },
  //           ),
  //         ],
  //       );
  //     }).toList();
  //   } else {
  //     expansionTiles = transposedList[i].toSet().map((categoryName) {
  //       return ExpansionTile(
  //         title: Text(categoryName),
  //         children: List.generate(n, (j) {
  //           return createTile(transposedList, i + 1);
  //         }),
  //       );
  //     }).toList();
  //   }

  //   return Column(
  //     children: expansionTiles,
  //   );
  // }
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
            Navigator.pop(context);
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
