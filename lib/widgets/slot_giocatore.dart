import 'package:flutter/material.dart';
import '../models/giocatore.dart';

class SlotGiocatore extends StatelessWidget {
  final Giocatore? giocatore;
  final String ruoloDesc; // es. "POR", "DIF"
  final VoidCallback onTap;

  const SlotGiocatore({super.key, 
    this.giocatore,
    required this.ruoloDesc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: giocatore == null
                  ? Colors.white.withOpacity(0.5)
                  : _getColoreRuolo(ruoloDesc),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black26),
            ),
            child: giocatore == null
                ? Icon(Icons.add, color: Colors.black38)
                : Center(
                    child: Text(
                      giocatore!.ruolo,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
          SizedBox(height: 4),
          Text(
            giocatore?.nome ?? ruoloDesc,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _getColoreRuolo(String ruolo) {
    switch (ruolo) {
      case "POR":
        return Colors.yellow.shade700;
      case "DIF":
        return Colors.blue.shade700;
      case "CEN":
        return Colors.green.shade700;
      case "ATT":
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }
}
