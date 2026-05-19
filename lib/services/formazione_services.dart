import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/giocatore.dart';

class FormazioneService {
  // Chiave univoca basata su Utente e Giornata
  static String _generaChiave(String idUtente, int giornata) =>
      "form_v1_${idUtente}_$giornata";

  static Future<void> salvaFormazione(Map<String, dynamic> f) async {
    final prefs = await SharedPreferences.getInstance();

    // Creiamo una mappa con i dati essenziali
    final Map<String, dynamic> mappaFormazione = {
      'modulo': f['modulo'],
      'titolari': f['idTitolari'],
      'panchina': f['idPanchinari'],
      'timestamp': f['dataInvio'],
    };

    await prefs.setString(
      _generaChiave(f['idUtente'], f['giornata']),
      jsonEncode(mappaFormazione),
    );
  }

  static Future<Map<String, dynamic>?> recuperaFormazione(
    String idUtente,
    int giornata,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? datiRaw = prefs.getString(_generaChiave(idUtente, giornata));

    if (datiRaw == null) return null;
    return jsonDecode(datiRaw);
  }

  // Esegue le sostituzioni basandosi sul voto (se null o 0)
  static void processaSostituzioni(List<Giocatore> titolari, List<Giocatore> panchina, int limiteCambi) {
    int cambiEffettuati = 0;

    for (int i = 0; i < titolari.length; i++) {
      if (cambiEffettuati >= limiteCambi) break;

      // Se il titolare non ha voto (voto == null o 0)
      if (titolari[i].voto == null || titolari[i].voto == 0) {
        // Cerca in panchina il primo dello stesso ruolo con un voto valido
        var sostituto = panchina.firstWhere(
          (p) => p.ruolo == titolari[i].ruolo && (p.voto != null && p.voto! > 0),
          orElse: () => titolari[i], // Se non trova nessuno, resta lui
        );

        if (sostituto != titolari[i]) {
          titolari[i] = sostituto;
          cambiEffettuati++;
        }
      }
    }
  }
}
