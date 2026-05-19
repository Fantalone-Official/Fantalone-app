import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/match_live.dart';

class LiveSerieAService {
  static const String apiKey = "e617733a81cda00742b86936cb5e8147";

  // Endpoint per la Serie A (League 135)
  static const String baseUrl = "https://v3.football.api-sports.io/fixtures";

  static Future<List<MatchLive>> recuperaMatchOggi() async {
    // Otteniamo la data odierna in formato YYYY-MM-DD
    final String oggi = DateTime.now().toIso8601String().split('T')[0];

    try {
      final response = await http.get(
        Uri.parse("$baseUrl?league=135&season=2025&date=$oggi"),
        headers: {
          'x-rapidapi-key': apiKey,
          'x-rapidapi-host': 'v3.football.api-sports.io',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> fixtures = data['response'];

        return fixtures.map((f) {
          // Gestione del minutaggio o stato partita
          String infoPartita = "";
          final status = f['fixture']['status']['short'];

          if (status == "FT" || status == "AET" || status == "PEN") {
            infoPartita = "Finita";
          } else if (status == "1H" || status == "2H" || status == "HT") {
            infoPartita = "${f['fixture']['status']['elapsed']}'";
          } else {
            // Se non è iniziata, mostra l'orario (es. 15:00)
            final date = DateTime.parse(f['fixture']['date']).toLocal();
            infoPartita =
                "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
          }

          return MatchLive(
            casa: f['teams']['home']['name'],
            trasferta: f['teams']['away']['name'],
            punteggio:
                "${f['goals']['home'] ?? 0} - ${f['goals']['away'] ?? 0}",
            info: infoPartita,
            isSerieA: true,
          );
        }).toList();
      } else {
        return []; // Ritorna lista vuota in caso di errore server
      }
    } catch (e) {
      print("Errore LiveService: $e");
      return []; // Ritorna lista vuota in caso di errore connessione
    }
  }

  // Correzione: aggiunto [] per rendere il parametro opzionale e risolvere l'errore nella Dashboard
  static String determinaStatoLega([List<MatchLive>? matches]) {
    // Se la lista è null o vuota, la lega non è ancora live
    if (matches == null || matches.isEmpty) {
      return "NON_INIZIATO";
    }

    // Se almeno una partita di Serie A è in corso, la lega è LIVE
    if (matches.any((m) => m.info.contains("'") || m.info == "HT")) {
      return "LIVE";
    }

    // Se sono tutte finite
    if (matches.every((m) => m.info == "Finita")) {
      return "FINITO";
    }

    // Altrimenti siamo ancora in attesa
    return "NON_INIZIATO";
  }
}
