/// Бүкіл жобаға арналған жалғыз нысан

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
