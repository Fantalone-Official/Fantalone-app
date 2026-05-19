class CalcolatoreService {
  // Trasforma il totale punti in gol effettivi
  static int calcolaGol(double punteggio) {
    if (punteggio < 66.0) return 0;

    // Formula: primo gol a 66, poi uno ogni 6 punti
    // (punteggio - 66) / 6 + 1
    int gol = ((punteggio - 66) / 6).floor() + 1;
    return gol;
  }

  // Determina il risultato del match (1, X, 2) e assegna i punti in classifica
  static String determinaRisultato(int golCasa, int golTrasferta) {
    if (golCasa > golTrasferta) return "1"; // Vince casa
    if (golCasa < golTrasferta) return "2"; // Vince trasferta
    return "X"; // Pareggio
  }
}
