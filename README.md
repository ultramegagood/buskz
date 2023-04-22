# Күй менеджері

Экрандарды жаңарту үшін деректер күйі (өзгертулер/жоюлар/ функционалдық жұмыс) экранды жаңарту үшін біз mobx күй менеджерін қолданамыз оны пайдалану оңай және қарапайым.
мысалы сынып пен әдіс келесідей жарияланады:
```dart
  final ticketStore = serviceLocator<TicketStore>();
  ticketStore.selectedBusTicket.distance = distance;
```

## Singleton

Жобадан деректерді басқару үшін біз singleton бағдарламалау әдісін қолданамыз онда деректер мен өрістер servicelocator көмегімен жергілікті абстрактілі сыныпқа алынады

```dart
import 'package:buskz/stores/ticket_store.dart';
import 'package:get_it/get_it.dart';

///
/// Бүкіл жоба үшін жалғыз сілтеме нысаны
///
GetIt serviceLocator = GetIt.instance;

///
/// Жоба үшін синглтондарды тіркеу әдісі
///
Future<void> serviceLocatorSetup() async {
serviceLocator
.registerSingleton<TicketStore>(TicketStore());
}
```

## Плагиндер мен кітапханалар
```
  cupertino_icons: ^1.0.2
  json_serializable: ^6.6.0
  mobx_codegen: ^2.0.7+3
  mobx: 2.1.1
  flutter_mobx: 2.0.6+4
  flutter_provider:
  mask_text_input_formatter: ^2.4.0
  get_it: ^7.2.0
  build_runner: ^2.3.3
  flutter_svg:
  shared_preferences: ^2.0.17
  logger:
  dartdoc: ^6.2.0
  qr_flutter: ^4.0.0
```

## Жобаның жұмыс әдістері
```

/// Синглтон үшін әдістерді белгілеуге арналған дерексіз класс
import 'dart:convert';

import 'package:buskz/ticket.dart';
import 'package:mobx/mobx.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'ticket_store.g.dart';

class TicketStore = _TicketStore with _$TicketStore;

abstract class _TicketStore with Store {
  _TicketStore();

  ///
  /// Деректерді өзгертуге арналған модель
  ///
  @observable
  BusTicket selectedBusTicket = BusTicket();

  ///
  /// Өзгерістерді тыңдайтын ағыны бар сатып алынған билеттер массиві
  ///
  @observable
  ObservableList<BusTicket> tickets = ObservableList<BusTicket>();

  ///
  ///билеттер тізіміне ticket массивіне қосу
  ///
  @action
  Future<void> addTicket() async {
    tickets.add(selectedBusTicket);
    await _saveTickets();
  }

  ///
  ///Кэштен деректер мен билеттерді алу (құрылғы жады)
  ///
  Future<void> getTickets() async {
    // локальная память
    final _prefs = await SharedPreferences.getInstance();
    final carsJson = _prefs.getString('cars');
    if (carsJson != null) {
      final List<dynamic> decodedJson = jsonDecode(carsJson);
      tickets = ObservableList.of(
          decodedJson.map((e) => BusTicket.fromJson(e)).toList());
    }
  }

  ///
  ///Тізімге билет қосу, сонымен қатар json түрлендіру арқылы «cars» қалтасында деректерді сақтау
  ///
  Future<void> _saveTickets() async {
    final _prefs = await SharedPreferences.getInstance();
    final carsJson = jsonEncode(tickets.map((e) => e.toJson()).toList());
    await _prefs.setString('cars', carsJson);
  }
}
```