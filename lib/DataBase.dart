

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Constvalue.screen.dart';
import 'CreateAccount.dart';
import 'Login.dart';
class Dbhelper{
  late Database database;
  List<Map> list=[];

  Future<void> sqldb() async {

    print("Start");

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    print("Path Set");
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {

          await db.execute('CREATE TABLE UserDetails(SNO INTEGER PRIMARY KEY AUTOINCREMENT,Name TEXT,Password TEXT)');
          print("Path Tab");
    });
    print("Path Tab Create");
    List<Map> list = await database.rawQuery('SELECT * FROM UserDetails');
    print(list.length);
    print(list);


  }

  Future<void> UserDetailsinsert(name,password,context)async {
    database.transaction((txn) async {
      await txn.rawInsert('INSERT INTO UserDetails(Name,Password) VALUES (${name},${password})');
    });

    List<Map> list = await database.rawQuery('SELECT * FROM UserDetails');
    print("UserDetails${list.length}");
    if(int.parse(list.length.toString())>0){
      Toastmsg('Record Insert Successfully');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    }else{
      Toastmsg('Record Not Insert Kindly Check You Data');
    }
  }

  Future<void>getUserDetails(name,password,context)async {

   try{
     list = await database.rawQuery('Select * from UserDetails WHERE Name=${name} and Password=${password}');

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

  }
}

