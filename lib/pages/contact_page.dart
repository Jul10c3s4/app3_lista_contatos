import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/contato.dart';

class ContactPage extends StatefulWidget {

  final Contact? contact;
  
  const ContactPage({Key? key,
  this.contact}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final TextEditingController _nameControler = TextEditingController();
  final TextEditingController _emailControler = TextEditingController();
  final TextEditingController _phoneControler = TextEditingController();


  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  
  bool _userEdited = false;
  
  late Contact _editedContact;

  @override
  void initState(){
    super.initState();
    if(widget.contact == null){
      _editedContact = Contact();
    }else{
      _editedContact = Contact.fromMap(widget.contact!.toMap());
      _nameControler.text = _editedContact.name!;
      _emailControler.text = _editedContact.email!;
      _phoneControler.text = _editedContact.phone!;
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _editedContact.name ?? "novo Contato"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          if(_editedContact.name != null && _editedContact.name!.isNotEmpty){
            Navigator.pop(context, _editedContact);
          }else{
            FocusScope.of(context).requestFocus(_nameFocus);
          }
        },
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.save),),

      // o singlechildScrollView serve para não dar erro de tamanho de tela caso a tela seja pequena ao aparecer o teclado   
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            // sua função é similar ao Inkwell pois trasnforma qualquer widget em um botão dd
            GestureDetector(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _editedContact.img == null ? const AssetImage('assets/images/contato.png') as ImageProvider :  
                    FileImage(File(_editedContact.img.toString())),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: () {
                ImagePicker()
                .pickImage(source: ImageSource.camera) 
                .then((file){
                  if(file == null) return;
                    setState((){
                      _editedContact.img = file.path;
                    });
                  }
                );
              },
            ),
            TextField(
              controller: _nameControler,
              focusNode: _nameFocus,
              decoration: const InputDecoration(
                labelText: 'Nome' 
              ),
              onChanged: (text){
                _userEdited = true;
                setState(() {
                  _editedContact.name = text;
                });
              },
            ),
            TextField(
              controller: _emailControler,
              focusNode: _emailFocus,
              decoration: const InputDecoration(
                labelText: 'Email' 
              ),
              onChanged: (text){
                _userEdited = true;
                setState(() {
                  _editedContact.email = text;
                });
              },
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: _phoneControler,
              focusNode: _phoneFocus,
              decoration: const InputDecoration(
                labelText: 'Telefone' 
              ),
              onChanged: (text){
                _userEdited = true;
                setState(() {
                  _editedContact.phone = text;
                });
              },
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    ),
       onWillPop: _requestPop);
  }

  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: const Text("Descartar todas as alterações?"),
          content: const Text('Se sair as alterações serão perdidas!'),
          actions: [
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text('Cancelar')),

            ElevatedButton(onPressed: (){
              Navigator.pop(context);
              Navigator.pop(context);
            }, child: const Text('Sim')),
          ],
        );
      });
      return Future.value(false);
    }else{
      return Future.value(true);
    }
    }
  }
