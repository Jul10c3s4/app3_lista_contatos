import 'dart:async';
import 'dart:js';
import 'package:lista_contatos/models/contato.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ContactHelper{

  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database? _db;

  //Verificando se o banco é nulo  
  Future<Database?> get db async {
    if(_db != null){
      return _db;
    }else{
      _db = await initDb();
      return _db;
    }
  }
   
  //Inicia o banco de dados  
  Future<Database> initDb() async{
    //busca o caminho do banco
    final databasesPath = await getDatabasesPath();
    //adiciona no caminho o contacts.db
    final path = join(databasesPath, 'contacts.db');

    //abre o banco
    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async{
      
      //cria tabela 
      await db.execute(
        'CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)'
      );
    });
    }

//salvar contato
Future<Contact> saveContact(Contact contact) async{
  Database? dbContact = await db;
  //contact.id = await dbContact!.query(contactTable, columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
  //where: "$idColumn = ?",
  contact.id = await dbContact?.insert(contactTable, contact.toMap());

  return contact;

}

//buscar 1 contato
Future<Contact?> getContact(int id) async{
  Database? dbContact = await db;
  /*await dbContact!.query(contactTable, columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
  where: "$idColumn = ?",
  whereArgs: [id]);*/
  List<Map> maps = await dbContact!.query(contactTable, columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
  where: "$idColumn = ?",
  whereArgs: [id]); 

  if(maps.isNotEmpty){
    return Contact.fromMap(maps.first as Map<String, dynamic>);
  }else{
    return null;
  }
}

//apagar 1 contato
Future<int> deleteContact(int id) async{
  Database? dbContact = await db;
  return await dbContact!.delete(contactTable, where: "$idColumn = ?", whereArgs: [id]); 
  
}

//editar contato
Future<int> updateContact(Contact contact) async{
  Database? dbContact = await db;
  return await dbContact!.update(contactTable, contact.toMap(),
   where: "$idColumn = ?",
    whereArgs: [contact.id]);
}
  
//buscar todos os cotatos
Future<List<Contact>> getAllContacts() async{
  Database? dbContact = await db;
  List listMap = await dbContact!.rawQuery("SELECT * FROM $contactTable");
  List<Contact> lista = [];

  for(Map m in listMap){
    lista.add(Contact.fromMap(m as Map<String, dynamic>));
  }

  return lista;
}

//buscar todos os contatos salvos
/*Future<Contact>*/ getNumber(){}

//fechar banco
/*Future<Contact>*/ close(){}

}