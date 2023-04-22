/// бірінші бет
import 'package:buskz/screens/login.dart';
import 'package:buskz/screens/tickets.dart';
import 'package:buskz/stores/ticket_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../service_locator.dart';
import '../ticket.dart';
import '../widgets/drawer.dart';

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final ticketStore = serviceLocator<TicketStore>();

  String _from = 'КазНУ';
  String _to = 'АТАКЕНТ';
  String _selectedCategory = 'кәдімгі';

  List<String> _categories = ['кәдімгі', 'студент', 'пенсионер', 'военный'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ticketStore.getTickets();
    ticketStore.selectedBusTicket.from = _from;
    ticketStore.selectedBusTicket.to = _to;
    ticketStore.selectedBusTicket.discountType = _selectedCategory;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ticketStore.tickets.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawer(
          name: FirebaseAuth.instance.currentUser?.displayName ?? "",
          email: FirebaseAuth.instance.currentUser?.email ??"",
          onAvatarChanged: (val){

          },
        ),
        appBar: AppBar(
          title: const Text('Маршрутты таңдаңыз'),
        ),
        body: SingleChildScrollView(
          child: Observer(builder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Қайдан:',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 8.0),
                  DropdownButtonFormField(
                    value: _from,
                    items: const [
                      DropdownMenuItem(
                        value: 'КазНУ',
                        child: Text('КазНУ'),
                      ),
                      DropdownMenuItem(
                        value: 'Достык',
                        child: Text('Достык'),
                      ),
                      DropdownMenuItem(
                        value: 'Алатау',
                        child: Text('Алатау'),
                      ),
                      DropdownMenuItem(
                        value: 'Манаса',
                        child: Text('Манаса'),
                      ),
                      // Добавьте другие опции по необходимости
                    ],
                    onChanged: (value) {
                      setState(() {
                        _from = value!;
                        ticketStore.selectedBusTicket.from = _from;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Қайда:',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 8.0),
                  DropdownButtonFormField(
                    value: _to,
                    items: const [
                      DropdownMenuItem(
                        value: 'АТАКЕНТ',
                        child: Text('АТАКЕНТ'),
                      ),
                      DropdownMenuItem(
                        value: 'Райымбека',
                        child: Text('Райымбека'),
                      ),
                      DropdownMenuItem(
                        value: 'Абая',
                        child: Text('Абая'),
                      ),
                      // Добавьте другие опции по необходимости
                    ],
                    onChanged: (value) {
                      setState(() {
                        _to = value!;
                        ticketStore.selectedBusTicket.to = _to;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Артықшылықтар:',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 8.0),
                  Column(
                    children: _categories
                        .map((category) => RadioListTile(
                              title: Text(category),
                              value: category,
                              groupValue: _selectedCategory,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value!;
                                  ticketStore.selectedBusTicket.discountType =
                                      _selectedCategory;
                                  if (_selectedCategory == "обычный") {
                                    ticketStore.selectedBusTicket.discount =
                                        0.0;
                                  } else if (_selectedCategory == "студент") {
                                    ticketStore.selectedBusTicket.discount =
                                        0.5;
                                  } else if (_selectedCategory == "пенсионер") {
                                    ticketStore.selectedBusTicket.discount =
                                        0.3;
                                  } else if (_selectedCategory == "военный") {
                                    ticketStore.selectedBusTicket.discount = 1;
                                  }
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Обработчик нажатия кнопки
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RoutesPage()));
                    },
                    child: const Text('Маршрутты таңдаңыз'),
                  ),
                  ...ticketStore.tickets.reversed.map((element) => ListTile(
                        title: Text('Льгота: ${element.discountType}'),
                        subtitle: Text(
                            'Қайдан: ${element.from}\nҚайда: ${element.to}'),
                        trailing: Text('${element.price}тг.'),
                      ))
                ],
              ),
            );
          }),
        ));
  }
}
