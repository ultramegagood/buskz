// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TicketStore on _TicketStore, Store {
  late final _$selectedBusTicketAtom =
      Atom(name: '_TicketStore.selectedBusTicket', context: context);

  @override
  BusTicket get selectedBusTicket {
    _$selectedBusTicketAtom.reportRead();
    return super.selectedBusTicket;
  }

  @override
  set selectedBusTicket(BusTicket value) {
    _$selectedBusTicketAtom.reportWrite(value, super.selectedBusTicket, () {
      super.selectedBusTicket = value;
    });
  }

  late final _$ticketsAtom =
      Atom(name: '_TicketStore.tickets', context: context);

  @override
  ObservableList<BusTicket> get tickets {
    _$ticketsAtom.reportRead();
    return super.tickets;
  }

  @override
  set tickets(ObservableList<BusTicket> value) {
    _$ticketsAtom.reportWrite(value, super.tickets, () {
      super.tickets = value;
    });
  }

  late final _$addTicketAsyncAction =
      AsyncAction('_TicketStore.addTicket', context: context);

  @override
  Future<void> addTicket() {
    return _$addTicketAsyncAction.run(() => super.addTicket());
  }

  @override
  String toString() {
    return '''
selectedBusTicket: ${selectedBusTicket},
tickets: ${tickets}
    ''';
  }
}
