import 'dart:convert';

import 'package:buskz/ticket.dart';
import 'package:mobx/mobx.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'ticket_store.g.dart';

class TicketStore = _TicketStore with _$TicketStore;

abstract class _TicketStore with Store {
  _TicketStore();
  @observable
  BusTicket selectedBusTicket = BusTicket();

  @observable
  ObservableList<BusTicket> tickets = ObservableList<BusTicket>();

  @action
  Future<void> addTicket() async {
    tickets.add(selectedBusTicket);
    await _saveTickets();
  }

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

  Future<void> _saveTickets() async {
    final _prefs = await SharedPreferences.getInstance();
    final carsJson = jsonEncode(tickets.map((e) => e.toJson()).toList());
    await _prefs.setString('cars', carsJson);
  }
}
