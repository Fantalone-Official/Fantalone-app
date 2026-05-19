import '../models/lega_match.dart';

class CalendarioService {
  static List<List<LegaMatch>> generaCalendario(
    List<dynamic> partecipanti,
    int turni,
  ) {
    List<List<LegaMatch>> calendarioCompleto = [];

    // Se i partecipanti sono dispari, aggiungiamo un "Riposo"
    List<dynamic> squadre = List.from(partecipanti);
    if (squadre.length % 2 != 0) {
      squadre.add("Riposo");
    }

    int numeroSquadre = squadre.length;
    int giornatePerAndata = numeroSquadre - 1;

    // Algoritmo di Berger (Girone all'italiana)
    for (int t = 0; t < turni; t++) {
      for (int g = 0; g < giornatePerAndata; g++) {
        List<LegaMatch> giornataSingola = [];

        for (int i = 0; i < numeroSquadre / 2; i++) {
          int casa = (g + i) % (numeroSquadre - 1);
          int trasferta = (numeroSquadre - 1 - i + g) % (numeroSquadre - 1);

          if (i == 0) {
            trasferta = numeroSquadre - 1;
          }

          // CORREZIONE: Aggiunto il parametro 'giornata' richiesto dal modello
          giornataSingola.add(
            LegaMatch(
              idCasa: squadre[casa] is String
                  ? squadre[casa]
                  : squadre[casa].id,
              idTrasferta: squadre[trasferta] is String
                  ? squadre[trasferta]
                  : squadre[trasferta].id,
              giornata:
                  (t * giornatePerAndata) +
                  g +
                  1, // <--- QUESTA È LA RIGA MANCANTE
            ),
          );
        }
        calendarioCompleto.add(giornataSingola);
      }
    }

    return calendarioCompleto;
  }
}
