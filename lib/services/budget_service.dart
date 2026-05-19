class BudgetService {
  static int budgetIniziale = 500; // Puoi cambiarlo a piacimento
  static int budgetRimanente = 500;

  // Sottrae i crediti quando compri qualcuno
  static void sottrai(int importo) {
    budgetRimanente -= importo;
  }

  // Aggiunge i crediti (utile per gli scambi ricevuti)
  static void aggiungi(int importo) {
    budgetRimanente += importo;
  }

  // Verifica se l'utente ha abbastanza soldi prima di un'offerta
  static bool haDisponibilita(int importo) {
    return budgetRimanente >= importo;
  }
}
