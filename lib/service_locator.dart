/// Синглотон обьект для всего проекта

import 'package:buskz/stores/ticket_store.dart';
import 'package:get_it/get_it.dart';

///
/// Синглотон обьект для всего проекта
///
GetIt serviceLocator = GetIt.instance;

///
/// Метод для регистраций синглтонов для проекта
///
Future<void> serviceLocatorSetup() async {
  serviceLocator
    .registerSingleton<TicketStore>(TicketStore());
}
