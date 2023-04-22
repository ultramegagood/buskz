/// Синглтон үшін әдістерді белгілеуге арналған дерексіз класс
import 'dart:convert';
import 'dart:developer';

import 'package:buskz/ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mobx/mobx.dart';
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
    await getUserDocumentTickets();
  }

  ///
  ///Тізімге билет қосу, сонымен қатар json түрлендіру арқылы «cars» қалтасында деректерді сақтау
  ///
  Future<void> _saveTickets() async {
    createUserDocumentTickets();
  }

  Future<void> createUserDocumentTickets() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    if (user != null) {
      // Create a document for the user using their UID
      final DocumentReference userDocRef = usersCollection.doc(user.uid);
      // Set the user data in the document

      // Save bus tickets in the 'busTickets' subcollection

      final CollectionReference busTicketsCollection =
          userDocRef.collection('busTickets');

      for (final BusTicket busTicket in tickets) {
        final Map<String, dynamic> busTicketData =
            busTicket.toJson(); // Convert BusTicket object to Map
        await busTicketsCollection.add(
            busTicketData); // Save bus ticket data in a new document in the subcollection
      }
    } else {
      // Handle error
    }
  }

  Future<List<BusTicket>> getUserDocumentTickets() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    if (user != null) {
      // Create a document for the user using their UID
      final DocumentReference userDocRef = usersCollection.doc(user.uid);

      // Get bus tickets from the 'busTickets' subcollection
      final CollectionReference busTicketsCollection =
          userDocRef.collection('busTickets');
      final QuerySnapshot querySnapshot = await busTicketsCollection.get();

      // Store bus tickets in a List<BusTicket>
      final List<BusTicket> busTickets = [];
      querySnapshot.docs.forEach((doc) {
        log("data is " + doc.data().toString());
        final BusTicket busTicket =
            BusTicket.fromJson(doc.data() as Map<String, dynamic>);
        tickets.add(busTicket);
      });

      return busTickets;
    } else {
      // Handle error
      throw Exception('User is not signed in');
    }
  }
}
