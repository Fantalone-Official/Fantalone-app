import 'package:fantalone_app/models/bot_config.dart';
import 'package:fantalone_app/models/partecipante.dart';
import 'package:fantalone_app/services/stato_lega.dart';

void popolaLegaConBot(int numeroBot) {
  for (int i = 1; i <= numeroBot; i++) {
    String idBot = "bot_$i";

    // 1. Crea l'identità pubblica (quella che vedi in classifica)
    Partecipante p = Partecipante(
      id: idBot,
      nomeSquadra: "Team AI $i",
      isBot: true,
    );

    // 2. Crea il DNA segreto (l'Opzione A che abbiamo appena scritto)
    BotConfig config = BotConfig.autoGenera(idBot);

    // 3. Salva tutto nello stato della lega
    StatoLega.addPartecipante(p);
    StatoLega.addBotConfig(idBot, config);
  }
}
