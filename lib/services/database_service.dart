import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/giocatore.dart';

class DatabaseService {
  static List<Giocatore> listaCompleta = [];

  // Recupera la cartella sicura dell'app sullo smartphone
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/lega_data.json');
  }

  // Salva tutto lo stato della lega in un colpo solo
  static Future<File> salvaLega(Map<String, dynamic> data) async {
    final file = await _localFile;
    return file.writeAsString(jsonEncode(data));
  }

  // Carica la lega all'avvio dell'app
  static Future<Map<String, dynamic>?> caricaLega() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) return null;
      String contents = await file.readAsString();
      return jsonDecode(contents);
    } catch (e) {
      return null;
    }
  }
}
