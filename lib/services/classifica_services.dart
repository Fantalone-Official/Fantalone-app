import '../models/classifica_entry.dart';
import '../models/lega_match.dart';

class ClassificaService {
  // Aggiorna la classifica basandosi sui match finiti
  static List<ClassificaEntry> aggiornaClassifica(
    List<ClassificaEntry> classificaAttuale,
    List<LegaMatch> matchFiniti,
  ) {
    for (var match in matchFiniti) {
      var casa = classificaAttuale.firstWhere(
        (e) => e.idPartecipante == match.idCasa,
      );
      var trasf = classificaAttuale.firstWhere(
        (e) => e.idPartecipante == match.idTrasferta,
      );

      casa.partiteGiocate++;
      trasf.partiteGiocate++;
      casa.golFatti += match.golCasa ?? 0;
      casa.golSubiti += match.golTrasferta ?? 0;
      trasf.golFatti += match.golTrasferta ?? 0;
      trasf.golSubiti += match.golCasa ?? 0;

      if (match.golCasa! > match.golTrasferta!) {
        casa.punti += 3;
        casa.vittorie++;
        trasf.sconfitte++;
      } else if (match.golCasa! < match.golTrasferta!) {
        trasf.punti += 3;
        trasf.vittorie++;
        casa.sconfitte++;
      } else {
        casa.punti += 1;
        trasf.punti += 1;
        casa.pareggi++;
        trasf.pareggi++;
      }
    }

    // Ordina per punti, poi per differenza reti (gol fatti - subiti)
    classificaAttuale.sort((a, b) {
      int cmp = b.punti.compareTo(a.punti);
      if (cmp != 0) return cmp;
      return (b.golFatti - b.golSubiti).compareTo(a.golFatti - a.golSubiti);
    });

    return classificaAttuale;
  }
}
