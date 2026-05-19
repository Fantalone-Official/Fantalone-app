class Partecipante {
  final String id;
  final String nomeSquadra;
  final bool isBot;
  final bool isAdmin; // <--- Nuovo campo

  Partecipante({
    required this.id,
    required this.nomeSquadra,
    this.isBot = false,
    this.isAdmin = false,
  });
}
