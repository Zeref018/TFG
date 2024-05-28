import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tfg/models/participant_details.dart';
import 'package:tfg/models/match_details.dart';

Future<void> exportToExcel(BuildContext context, String username, String hashtag, List<MatchDetails> matchDetails) async {
  var excel = Excel.createExcel();
  Sheet sheetObject = excel['Match History'];

  // Encabezados de la tabla con estilos
  List<String> headers = [
    'Champion',
    'Allied Support',
    'Enemy ADC',
    'Enemy Support',
    'KDA',
    'KDA Ratio',
    'DMG to Champs',
    'DMG/MIN',
    'Minions Killed/Min',
    'Duration',
    'Result'
  ];

  // Colores para las columnas
  List<String> columnColors = [
    '#FFEB3B', // Amarillo
    '#FF5722', // Naranja
    '#9C27B0', // Púrpura
    '#03A9F4', // Azul claro
    '#E91E63', // Rosa
    '#4CAF50', // Verde
    '#FF9800', // Naranja oscuro
    '#673AB7', // Índigo
    '#00BCD4', // Cian
    '#8BC34A', // Verde claro
    '#FFD700', // Oro
    '#FF5252', // Rojo
  ];

  // Colores para los encabezados (ligeramente más oscuros que los colores de las columnas)
  List<String> headerColors = [
    '#FBC02D', // Amarillo oscuro
    '#E64A19', // Naranja oscuro
    '#7B1FA2', // Púrpura oscuro
    '#0288D1', // Azul oscuro
    '#C2185B', // Rosa oscuro
    '#388E3C', // Verde oscuro
    '#F57C00', // Naranja oscuro
    '#512DA8', // Índigo oscuro
    '#0097A7', // Cian oscuro
    '#689F38', // Verde oscuro
    '#C6A700', // Oro oscuro
    '#D32F2F', // Rojo oscuro
  ];

  // Aplicar estilos a los encabezados
  for (int i = 0; i < headers.length; i++) {
    CellStyle headerStyle = CellStyle(
        backgroundColorHex: headerColors[i],
        bold: true,
        fontColorHex: '#FFFFFF'
    );
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value = headers[i];
    sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).cellStyle = headerStyle;
  }

  int rowIndex = 1; // Para empezar en la segunda fila, después de los encabezados

  for (var match in matchDetails) {
    final currentUserParticipant = match.participants.firstWhere(
          (p) => p.riotIdGameName == username && p.riotIdTagline == hashtag,
      orElse: () => ParticipantDetails.empty(),
    );

    final alliedSupport = match.participants.firstWhere(
          (p) => p.teamPosition == 'UTILITY' && p.teamId == currentUserParticipant.teamId && p.riotIdGameName != username,
      orElse: () => ParticipantDetails.empty(),
    );

    final enemyADC = match.participants.firstWhere(
          (p) => p.teamPosition == 'BOTTOM' && p.teamId != currentUserParticipant.teamId,
      orElse: () => ParticipantDetails.empty(),
    );

    final enemySupport = match.participants.firstWhere(
          (p) => p.teamPosition == 'UTILITY' && p.teamId != currentUserParticipant.teamId,
      orElse: () => ParticipantDetails.empty(),
    );

    double kdaRatio = (currentUserParticipant.kills + currentUserParticipant.assists) / (currentUserParticipant.deaths == 0 ? 1 : currentUserParticipant.deaths);
    String kdaText = '${currentUserParticipant.kills}/${currentUserParticipant.deaths}/${currentUserParticipant.assists}';
    String duration = '${(match.gameDuration / 60).floor()}m ${(match.gameDuration % 60).floor()}s';
    String damagePerMinute = currentUserParticipant.damagePerMinute.toStringAsFixed(2);
    double minionsKilledPerMinute = currentUserParticipant.totalMinionsKilled / (match.gameDuration / 60);

    List<dynamic> row = [
      currentUserParticipant.championName,
      alliedSupport.championName.isNotEmpty ? alliedSupport.championName : 'N/A',
      enemyADC.championName.isNotEmpty ? enemyADC.championName : 'N/A',
      enemySupport.championName.isNotEmpty ? enemySupport.championName : 'N/A',
      kdaText,
      kdaRatio.toStringAsFixed(2),
      currentUserParticipant.totalDamageDealtToChampions,
      damagePerMinute,
      minionsKilledPerMinute.toStringAsFixed(2),
      duration,
      currentUserParticipant.win ? 'Win' : 'Lose',
    ];

    sheetObject.appendRow(row);

    // Estilo para cada celda de la fila
    for (int i = 0; i < row.length; i++) {
      CellStyle cellStyle = CellStyle(
          backgroundColorHex: columnColors[i]
      );
      sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: rowIndex)).cellStyle = cellStyle;

      // Aplicar color especial a la columna KDA Ratio
      if (i == 5) { // Columna KDA Ratio
        if (kdaRatio > 3) {
          cellStyle = CellStyle(backgroundColorHex: '#00FF00'); // Verde
        } else if (kdaRatio >= 2) {
          cellStyle = CellStyle(backgroundColorHex: '#808080'); // Gris
        } else {
          cellStyle = CellStyle(backgroundColorHex: '#FF0000'); // Rojo
        }
        sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: rowIndex)).cellStyle = cellStyle;
      }

      // Aplicar color especial a la columna Win
      if (i == 10) { // Columna Win
        if (currentUserParticipant.win) {
          cellStyle = CellStyle(backgroundColorHex: '#00FF00'); // Verde
        } else {
          cellStyle = CellStyle(backgroundColorHex: '#FF0000'); // Rojo
        }
        sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: rowIndex)).cellStyle = cellStyle;
      }
    }

    rowIndex++;
  }

  var fileBytes = excel.encode();
  if (fileBytes != null) {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/match_history.xlsx';
    final file = File(path);
    await file.writeAsBytes(fileBytes, flush: true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exported to $path')),
    );
  }
}
