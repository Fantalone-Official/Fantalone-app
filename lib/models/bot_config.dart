import 'dart:math';

enum FocusMercato { topPlayer, equilibrato, risparmio }

class BotConfig {
  final String idPartecipante;

  // Parametri di comportamento (da 0.0 a 1.0)
  final double coraggioRilancio;
  final double focusTopPlayer;
  final double frequenzaScambi;

  // Stato interno del bot
  FocusMercato focusAttuale = FocusMercato.equilibrato;

  BotConfig({
    required this.idPartecipante,
    required this.coraggioRilancio,
    required this.focusTopPlayer,
    required this.frequenzaScambi,
  });

  // Generazione Automatica Bilanciata
  factory BotConfig.autoGenera(String id) {
    final random = Random();

    return BotConfig(
      idPartecipante: id,
      coraggioRilancio: 0.4 + (random.nextDouble() * 0.5),
      focusTopPlayer: 0.2 + (random.nextDouble() * 0.6),
      frequenzaScambi: 0.1 + (random.nextDouble() * 0.9),
    );
  }

  // Funzione per aggiornare la strategia durante l'asta
  void aggiornaStrategia(double creditiRimanenti, int slotLiberi) {
    // Evita divisioni per zero se gli slot sono finiti
    if (slotLiberi <= 0) return;

    double mediaCreditiPerSlot = creditiRimanenti / slotLiberi;

    if (mediaCreditiPerSlot > 40) {
      focusAttuale = FocusMercato.topPlayer;
    } else if (mediaCreditiPerSlot < 15) {
      focusAttuale = FocusMercato.risparmio;
    } else {
      focusAttuale = FocusMercato.equilibrato;
    }
  }
}
