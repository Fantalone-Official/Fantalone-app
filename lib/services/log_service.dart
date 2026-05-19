import '../models/movimento_rosa.dart';

class LogService {
  static List<MovimentoRosa> cronologia = [];

  static void aggiungiEvento(
    String nome,
    String tipo,
    int crediti,
    bool ingresso,
  ) {
    cronologia.insert(
      0,
      MovimentoRosa(
        // Inseriamo in testa per vedere i più recenti per primi
        nomeGiocatore: nome,
        tipo: tipo,
        crediti: crediti,
        data: DateTime.now(),
        isIngresso: ingresso,
      ),
    );
  }
}
