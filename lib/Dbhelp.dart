import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

import 'Constvalue.screen.dart';
import 'CreateAccount.dart';
import 'Login.dart';
import 'MapScreen.dart';

class SQLHelper {

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE UserDetails(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        Name TEXT,
        Password TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
    await database.execute("""CREATE TABLE Location(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        Lat TEXT ,
        Lang TEXT,
        LatLang TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'chandran.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);

      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(String title, String? descrption,context) async {
    final db = await SQLHelper.db();

    final data = {'Name': title, 'Password': descrption};
    final id = await db.insert('UserDetails', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    print('id${id}');
    if(int.parse(id.toString())>0){
      Toastmsg('Record Insert Successfully');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }else{
      Toastmsg('Record Not Insert Kindly Check You Data');
    }
    return id;

  }
  static Future<int> locationitem(String lat, String? long,String latlong,) async {
    final db = await SQLHelper.db();

    final data = {'Lat': lat, 'Lang': long,'LatLang':latlong};
    print('data${data}');
    final id = await db.insert('Location', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    print('id${id}');
    print('id${id}');
    if(int.parse(id.toString())>0){
      Toastmsg('Record Insert Successfully');
    }else{
      Toastmsg('Record Not Insert Kindly Check You Data');
    }
    return id;

  }




 static Future<void>getDetails(name,password,context)async {
    final db = await SQLHelper.db();

    List<Map> result = await db.rawQuery(
        'SELECT * FROM UserDetails WHERE Name=? and Name=?',
        ['${name}', '${password}']
    );
    print('result${result}');
    if(result.toString()=='[]'){

      print('notsuccess');
      print('${db}');
      Toastmsg('NoRecord..!');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CreateAccount()));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MapScreen()));
    }
   /* List<Map> list=[];
    try{
      print('1notsuccess');
      list = await db.rawQuery('Select * from UserDetails WHERE Name=${name} and Password=${password}');

      print('list${list}');

      if(list.toString()=='[]'){
        print('notsuccess');
        Toastmsg('NoRecord..!');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CreateAccount()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CreateAccount()));
      }
    }catch (e)
    {
      print('Failed to insert: ' + e.toString());
      Toastmsg('Kindly Check User & Password..!');
    }
*/
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('UserDetails', orderBy: "id");
  }

}