class MovimentoRosa {
  final String nomeGiocatore;
  final String tipo; // "Asta", "Scambio", "Riparazione"
  final int crediti;
  final DateTime data;
  final bool isIngresso; // true se comprato, false se ceduto

  MovimentoRosa({
    required this.nomeGiocatore,
    required this.tipo,
    required this.crediti,
    required this.data,
    required this.isIngresso,
  });
}
