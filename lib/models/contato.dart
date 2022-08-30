const String contactTable = 'contactTable';
const String idColumn = 'idColumn';
const String nameColumn = 'nameColumn';
const String phoneColumn = 'phoneColumn';
const String imgColumn = 'imgColumn';
const String emailColumn = 'emailColumn';

class Contact {
  int? id;
  String? name;
  String? phone;
  String? img;
  String? email;
  Contact();

  Contact.fromMap(Map<String, dynamic> map)
  :id = map[idColumn],
  name = map[nameColumn],
  email = map[emailColumn],
  phone = map[phoneColumn];

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    if(id!=null){
      map[idColumn] = id;
    }
    return map;
  }
}