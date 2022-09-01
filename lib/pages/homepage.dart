import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lista_contatos/models/contato.dart';

import 'contact_page.dart';

//serve para enumerar algo em uma ordem
enum OrderOptions {orderaz, orderza}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> contatos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade500,
        title: Text(
          'Contatos'
        ),
        centerTitle: true,
        actions: <Widget>[
          //serve para criar um tipo de menu que ocupa um espaço pequeno
          PopupMenuButton<OrderOptions>(
          itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
            PopupMenuItem<OrderOptions>(
                value: OrderOptions.orderaz,
                child: Text(
                  'Ordenar de A-Z')),

            const PopupMenuItem(
                value:OrderOptions.orderza ,
                child: Text(
                  'Ordenar de Z-A'
                ))
          ]
          )
        ],
      ),
      backgroundColor: Colors.white54,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showContactPage();
        },
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.add,
        ),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: contatos.length,
          itemBuilder: (context, index){
            return Widget_contactCard(context, index);
          })
    );
  }
  Widget_contactCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contatos[index].img != null ?
                        FileImage(File(contatos[index].img.toString())):
                        const AssetImage('assets/images/contato.png') as ImageProvider,
                        fit: BoxFit.cover,
                  ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(contatos[index].name ?? '',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(contatos[index].email ?? '',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(contatos[index].phone ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: (){
        _showOptions(context, index);
      },
    );
  }
  void _showOptions(BuildContext, int index){

  }

  void _showContactPage({Contact? contact}){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ContactPage(contact: contact))) ;
  }
}
