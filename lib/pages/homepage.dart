import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_contatos/models/contact_helper.dart';
import 'package:lista_contatos/models/contato.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contact_page.dart';

//serve para enumerar algo em uma ordem
enum OrderOptions { orderaz, orderza }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red.shade500,
          title: Text('Contatos'),
          centerTitle: true,
          actions: <Widget>[
            //serve para criar um tipo de botão com menu que ocupa um espaço pequeno
            PopupMenuButton<OrderOptions>(
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                PopupMenuItem<OrderOptions>(
                    value: OrderOptions.orderaz, child: Text('Ordenar de A-Z')),
                const PopupMenuItem(
                    value: OrderOptions.orderza, child: Text('Ordenar de Z-A')),
                const PopupMenuItem(
                    value: OrderOptions.orderza,
                    child: Text('Ordenar de qualquer jeito')),
              ],
              onSelected: _orderList,
            )
          ],
        ),
        backgroundColor: Colors.white54,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showContactPage();
          },
          backgroundColor: Colors.red,
          child: const Icon(
            Icons.add,
          ),
        ),
        body: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              return Widget_contactCard(context, index);
            }));
  }

  Widget_contactCard(BuildContext context, int index) {
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
                    image: contacts[index].img != null
                        ? FileImage(File(contacts[index].img.toString()))
                        : const AssetImage('assets/images/contato.png')
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].name ?? '',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      contacts[index].email ?? '',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      contacts[index].phone ?? '',
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
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {
                          launchUrl(Uri.parse("tel:${contacts[index].phone}"));
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Ligar',
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: contacts[index]);
                        },
                        child: const Text(
                          'Editar',
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {
                          helper.deleteContact(contacts[index].id!.toInt());
                          setState(() {
                            contacts.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                        child: const Text(
                          'Excluir',
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        setState(() {
          contacts.sort((a, b) {
            return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
          });
        });
        break;

      case OrderOptions.orderza:
        setState(() {
          contacts.sort((a, b) {
            return b.name!.toLowerCase().compareTo(a.name!.toLowerCase());
          });
        });
        break;
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _showContactPage({Contact? contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }
}
