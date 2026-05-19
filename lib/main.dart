import 'package:flutter/material.dart';
import 'package:fantalone_app/screens/homepage_lega.dart';
import 'package:fantalone_app/services/database_service.dart';
import 'screens/dashboard_lega.dart';
import 'screens/schermata_asta.dart';
import 'screens/impostazioni_lega_screen.dart';
import 'screens/schermata_classifica.dart';

void main() async {
  // Assicura che i servizi Flutter siano pronti
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Carica le impostazioni della lega dal database locale (se esiste)
  var datiLega = await DatabaseService.caricaLega();

  // 2. Avvia l'App
  runApp(MyApp(datiIniziali: datiLega));
}

class MyApp extends StatelessWidget {
  final Map<String, dynamic>? datiIniziali;
  const MyApp({super.key, this.datiIniziali});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FantAlone',
      theme: ThemeData(primarySwatch: Colors.teal),
      // Se la lega esiste vai in Dashboard, altrimenti Crea Lega
      initialRoute: datiIniziali == null ? '/creazione_lega' : '/',
      routes: AppRoutes.getRoutes(),
    );
  }
}

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => const DashboardLega(),
      '/creazione_lega': (context) => const HomepageLega(),
      '/asta': (context) => const SchermataAsta(),
      '/impostazioni': (context) => const ImpostazioniLegaScreen(),
      '/classifica': (context) => const SchermataClassifica(),
      // Aggiungi qui le altre che hai già trascritto (Rosa, Mercato, ecc.)
    };
  }
}