import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "DataBase.db"; // DB名
  static const _databaseVersion = 1; // スキーマのバージョン指定

  static const table = 'data_table'; // テーブル名

  static const columnId = '_id'; // カラム名：ID
  static const columnCategory = 'category'; // カラム名:Category
  static const columnName = 'name'; // カラム名：Name
  static const columnPurchase = 'purchase_date'; // カラム名：Purchase
  static const columnLimit = 'limit_date'; // カラム名：Limit
  static const columnMemo = 'memo'; // カラム名：Memo
  static const columnPhotoPath = 'photo_path'; // カラム名：PhotoPath

  // DatabaseHelper クラスを定義
  DatabaseHelper._privateConstructor();
  // DatabaseHelper._privateConstructor() コンストラクタを使用して生成されたインスタンスを返すように定義
  // DatabaseHelper クラスのインスタンスは、常に同じものであるという保証
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Databaseクラス型のstatic変数_databaseを宣言
  // クラスはインスタンス化しない
  static Database? _database;

  // databaseメソッド定義
  // 非同期処理
  Future<Database?> get database async {
    // _databaseがNULLか判定
    // NULLの場合、_initDatabaseを呼び出しデータベースの初期化し、_databaseに返す
    // NULLでない場合、そのまま_database変数を返す
    // これにより、データベースを初期化する処理は、最初にデータベースを参照するときにのみ実行されるようになります。
    // このような実装を「遅延初期化 (lazy initialization)」と呼びます。
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // データベース接続
  _initDatabase() async {
    if (kIsWeb) {
      String path = _databaseName;
      //Directory(path).create();
      var factory = databaseFactoryFfiWeb;
      final options = OpenDatabaseOptions(
        version: _databaseVersion,
        onCreate: (db, version) => _onCreate(db, version),
      );
      return await factory.openDatabase(path, options: options);
    } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      String path = join(Directory.current.path, "resource");
      Directory(path).create();
      var factory = databaseFactoryFfi;
      final options = OpenDatabaseOptions(
        version: _databaseVersion,
        onCreate: (db, version) => _onCreate(db, version),
      );
      return await factory.openDatabase(path + _databaseName, options: options);
    } else {
      // アプリケーションのドキュメントディレクトリのパスを取得
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      // 取得パスを基に、データベースのパスを生成
      String path = join(documentsDirectory.path, _databaseName);
      // データベース接続
      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: (db, version) => _onCreate(db, version),
      );
    }
  }

  /// テーブル作成
  ///
  /// [db] データベース
  ///
  /// [version] スキーマーのversion （スキーマーのバージョンはテーブル変更時にバージョンを上げる（テーブル・カラム追加・変更・削除など））
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnCategory TEXT NOT NULL,
            $columnName TEXT NOT NULL,
            $columnPurchase TEXT NOT NULL,
            $columnLimit TEXT NOT NULL,
            $columnMemo TEXT NOT NULL,
            $columnPhotoPath TEXT NOT NULL
          )
          ''');
  }

  ///テーブルにデータを追加する
  ///
  ///[row]追加するデータ
  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  ///テーブルのデータをすべて取得
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  ///データの取得
  ///
  ///[id] 取得するデータのID
  Future<List<Map<String, dynamic>>> get(int id) async {
    Database? db = await instance.database;
    return await db!.rawQuery('SELECT * FROM $table WHERE $columnId = $id');
  }

  ///テーブルに対してSELECTの実行
  ///
  ///[column] 列の名前
  Future<List<Map<String, dynamic>>> select(String column) async {
    Database? db = await instance.database;
    return await db!.rawQuery('SELECT $column FROM $table');
  }

  ///テーブルに対してWHEREの実行
  ///
  ///[condition] 検索条件
  Future<List<Map<String, dynamic>>> where(String condition) async {
    Database? db = await instance.database;
    return await db!.rawQuery('SELECT * FROM $table WHERE $condition');
  }

  ///DBへのクエリの発行
  ///
  ///[sql] 発光するSQLクエリ
  Future<List<Map<String, dynamic>>> query(String sql) async {
    Database? db = await instance.database;
    return await db!.rawQuery(sql);
  }

  // レコード数を確認
  Future<int?> queryRowCount() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  /// データの更新処理
  ///
  /// [row] 更新するデータ
  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!
        .update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  /// データの削除
  ///
  /// [id] 削除するデータのID
  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  ///現在登録されているカテゴリの取得
  Future<List<String>> getCategory() async {
    final Database? db = await instance.database;
    final data = await db!.rawQuery('SELECT $columnCategory FROM $table');
    List<String> list = [];
    for (var element in data) {
      if (!list.contains(element[columnCategory].toString())) {
        list.add(element[columnCategory].toString());
      }
    }
    return list;
  }
}
