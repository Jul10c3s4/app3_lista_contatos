import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ContactHelper{

  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database? _db;

  //GET
  Future<Database?> get db async {
    if(_db != null){
      return _db;
    }else{
      _db = await initDb();
      return _db;
    }
  }
   
  Future<Database> initDb() async{
    final databasesPath = await getDatabasesPath();
      
    }
 }

