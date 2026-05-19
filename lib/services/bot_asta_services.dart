import '../models/bot_config.dart';
import '../models/giocatore.dart';

class BotAstaService {
  // Funzione helper per determinare il ruolo prioritario
  static String _determinaRuoloPrioritario(List<Giocatore> rosaAttuale) {
    // Conta i giocatori per ruolo
    Map<String, int> conteggioRuoli = {};
    for (var giocatore in rosaAttuale) {
      conteggioRuoli[giocatore.ruolo] = (conteggioRuoli[giocatore.ruolo] ?? 0) + 1;
    }

    // Limiti ideali (esempio: 3 portieri, 8 difensori, 8 centrocampisti, 6 attaccanti)
    Map<String, int> limiti = {'P': 3, 'D': 8, 'C': 8, 'A': 6};

    // Trova il ruolo con più bisogno (meno giocatori rispetto al limite)
    String ruoloNecessario = 'A'; // Default
    int maxMancanti = 0;
    for (var ruolo in limiti.keys) {
      int mancanti = limiti[ruolo]! - (conteggioRuoli[ruolo] ?? 0);
      if (mancanti > maxMancanti) {
        maxMancanti = mancanti;
        ruoloNecessario = ruolo;
      }
    }

    return ruoloNecessario;
  }

  static String decidiChiChiamare(BotConfig bot, List<Giocatore> svincolati, List<Giocatore> rosaAttuale) {
    // 1. Capisce quale reparto ha più bisogno
    String ruoloNecessario = _determinaRuoloPrioritario(rosaAttuale);

    // 2. Filtra i giocatori disponibili per quel ruolo
    List<Giocatore> candidati = svincolati.where((g) => g.ruolo == ruoloNecessario).toList();

    // 3. Applica la strategia (Top Player vs Risparmio)
    candidati.sort((a, b) => b.quotazione.compareTo(a.quotazione)); // Ordina dal più caro

    if (bot.focusAttuale == FocusMercato.topPlayer && candidati.isNotEmpty) {
      return candidati.first.nome; // Chiama il più forte rimasto
    } else if (candidati.length > 5) {
      return candidati[3].nome; // Chiama un profilo medio (per non svenarsi)
    } else {
      return candidati.last.nome; // Chiama un "tappabuchi" a poco
    }
  }
}