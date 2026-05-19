import '../models/giocatore.dart';
import '../models/partecipante.dart';
import 'budget_service.dart';

class StatoLega {
  // Rosa dell'utente corrente
  static List<Giocatore> rosaUtente = [];

  // Utente corrente della lega
  static Partecipante? utenteCorrente;

  // Definizione dei limiti ufficiali per reparto
  static const Map<String, int> limitiReparto = {
    "P": 3,
    "D": 8,
    "C": 8,
    "A": 6,
  };

  // Liste dei nomi squadre della lega (per i dropdown)
  static List<String> nomiSquadreLega = [];

  // Funzione rapida per controllare se un reparto è pieno
  static bool isRepartoPieno(String ruolo) {
    int attuali = rosaUtente.where((g) => g.ruolo == ruolo).length;
    int limite = limitiReparto[ruolo] ?? 0;
    return attuali >= limite;
  }

  // Metodo per aggiungere un giocatore
  static void aggiungiGiocatore(Giocatore giocatore, int prezzoAcquisto) {
    if (!isRepartoPieno(giocatore.ruolo)) {
      giocatore.prezzoAcquisto = prezzoAcquisto;
      rosaUtente.add(giocatore);
    }
  }

  // Metodo per svincolare un giocatore
  static void svincolaGiocatore(Giocatore giocatore) {
    rosaUtente.removeWhere((item) => item.nome == giocatore.nome);
    BudgetService.aggiungi(giocatore.prezzoAcquisto ?? 0);
  }

  // Lista dei partecipanti della lega
  static List<Partecipante> partecipantiLega = [];

  static Null get partecipanti => null;

  static Null get botConfigs => null;

  static String getNomeSquadra(String id) {
    // Cerca tra i partecipanti (Umani + Bot) e restituisce il nome
    return partecipantiLega.firstWhere((p) => p.id == id).nomeSquadra;
  }
}
