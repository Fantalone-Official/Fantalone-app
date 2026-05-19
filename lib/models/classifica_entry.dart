class ClassificaEntry {
  final String idPartecipante;
  int punti;
  int partiteGiocate;
  int vittorie;
  int pareggi;
  int sconfitte;
  int golFatti;
  int golSubiti;

  ClassificaEntry({
    required this.idPartecipante,
    this.punti = 0,
    this.partiteGiocate = 0,
    this.vittorie = 0,
    this.pareggi = 0,
    this.sconfitte = 0,
    this.golFatti = 0,
    this.golSubiti = 0,
  });
}
