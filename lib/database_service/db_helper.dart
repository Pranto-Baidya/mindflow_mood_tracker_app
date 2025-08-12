
import 'dart:io';

import 'package:mindflow_mood_tracker_app_with_firebase/model/quote_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  static Database? db;

  Future<Database> getDB()async{
    if(db!=null){
      return db!;
    }
    else{
      db = await initDB();
      return db!;
    }
  }

  Future<Database> initDB()async{
    Directory appDir = await getApplicationDocumentsDirectory();
    String path = join(appDir.path,'quoteDB.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable
    );
  }

  Future<void> _createTable(Database db, int version)async{
     await db.execute(
       '''
       CREATE TABLE quote(
        uid TEXT,
        content TEXT,
        author TEXT,
        length INTEGER
       )
       '''
     );
  }

  Future<List<QuoteModel>> getAllQuotes(String uid)async{
    final db = await getDB();
    List<Map<String,dynamic>> query = await db.query('quote',where: 'uid=?',whereArgs: [uid]);
    return query.map((i)=>QuoteModel.fromMap(i)).toList();
  }
  
  Future<void> insertQuote(QuoteModel quote)async{
    final db = await getDB();
    await db.insert('quote', quote.toMap());
  }
  
  Future<void> deleteQuote(QuoteModel quote)async{
    final db = await getDB();
    await db.delete('quote',where: 'content=? AND uid=?',whereArgs: [quote.content,quote.uid]);
  }

  Future<bool> hasQuote(String uid)async{
    final db = await getDB();
    List<Map<String,dynamic>> value = await db.query('quote',where: 'uid=?', whereArgs: [uid]);
    return value.isNotEmpty;
  }
}