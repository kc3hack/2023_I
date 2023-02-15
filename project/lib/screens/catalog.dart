import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/db/database.dart';
import 'package:logger/logger.dart';
import 'package:project/main.dart';

final logger = Logger();

void main() => runApp(const CatalogPage());

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});
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
    final category = dbHelper.getCategory();

    return Scaffold(
      appBar: AppBar(
        title: const Text('一覧画面'),
      ),
      body: FutureBuilder(
        future: dbHelper.getCategory(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Text('$error');
          } else if (snapshot.hasData) {
            List<String> result = snapshot.data!;
            return Container(
              child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(snapshot.data[index]);
                  }),
            );
          } else {
            return const Text("else");
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/register'),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
