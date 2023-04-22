///билет таңдау беті
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:uuid/uuid.dart';

import '../service_locator.dart';
import '../stores/ticket_store.dart';

class RoutesPage extends StatelessWidget {
  final List<Map<String, dynamic>> routes = [
    {'name': 'Маршрут 124', 'distance': '10 км'},
    {'name': 'Маршрут 32', 'distance': '12 км'},
    {'name': 'Маршрут 30', 'distance': '8 км'},
    {'name': 'Маршрут 45', 'distance': '15 км'},
    {'name': 'Маршрут 70', 'distance': '20 км'},
    {'name': 'Маршрут 7', 'distance': '5 км'},
    {'name': 'Маршрут 9', 'distance': '7 км'},
    {'name': 'Маршрут 11', 'distance': '9 км'},
  ];
  final ticketStore = serviceLocator<TicketStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Маршрутты таңдаңыз'),
      ),
      body: Observer(builder: (context) {
        return ListView.builder(
          itemCount: routes.length,
          itemBuilder: (BuildContext context, int index) {
            routes.sort((a, b) => getTimeLeft(a['distance'])
                .compareTo(getTimeLeft(b['distance'])));
            final route = routes[index];
            final distance = route['distance'];
            final price = calculatePrice(distance);
            final duration = getTimeLeft(distance);
            return ListTile(
              title: Text(route['name']),
              subtitle: Text(
                  'Қашықтық: $distance\n${duration.inMinutes} минут қалды\nБағасы: $price тг.'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Маршрут бойынша төлем'),
                      content: Text('Оплатить $price тг.?'),
                      actions: <Widget>[
                        ElevatedButton(
                          child: Text('Болдырмау'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          child: Text('Растау'),
                          onPressed: () {
                            // Обработка оплаты
                            var uuid = Uuid();

                            ticketStore.selectedBusTicket.busId = route['name'];
                            ticketStore.selectedBusTicket.price = price.toInt();
                            ticketStore.selectedBusTicket.distance = distance;
                            ticketStore.selectedBusTicket.paymentDate = DateTime.now();
                            ticketStore.selectedBusTicket.id = uuid.v4();
                            ticketStore.addTicket();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      }),
    );
  }

  num calculatePrice(String distance) {
    final km = int.parse(distance.split(' ')[0]);
    if (ticketStore.selectedBusTicket.discountType == "кәдімгі") {
      return (10 * km) - (km * 0.0);
    } else if (ticketStore.selectedBusTicket.discountType == "студент") {
      return (10 * km) - (km * 0.5);
    } else if (ticketStore.selectedBusTicket.discountType == "пенсионер") {
      return (10 * km) - (km * 0.3);
    } else {
      return 0;
    }
  }

  Duration getTimeLeft(String distance) {
    final kmPerMinute = 0.5; // средняя скорость автобуса в км/мин
    final distanceInKm = double.parse(distance.split(' ')[0]);
    final timeInMinutes = (distanceInKm / kmPerMinute).floor();
    return Duration(minutes: timeInMinutes);
  }
}
