class FormazioneInviata {
  final String idUtente;
  final int giornata;
  final List<String> idTitolari; // Salviamo gli ID per leggerezza
  final List<String> idPanchinari;
  final String modulo; // es. "4-3-3"
  final DateTime dataInvio;

  FormazioneInviata({
    required this.idUtente,
    required this.giornata,
    required this.idTitolari,
    required this.idPanchinari,
    required this.modulo,
    required this.dataInvio,
  });
}
