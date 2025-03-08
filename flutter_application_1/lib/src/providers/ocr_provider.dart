import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class OcrProvider extends ChangeNotifier {
  final String _apiKey = 'K89408056888957';

  ///retourne le texte brut détecté ou ya une exception en cas d’erreur
  Future<String> recognizeTextFromImage(File imageFile) async {
    final url = Uri.parse('https://api.ocr.space/parse/image');

    final request = http.MultipartRequest('POST', url)
      ..fields['apikey'] = _apiKey
      ..fields['language'] = 'fre'
      ..fields['OCREngine'] = '2'
      ..files.add(await http.MultipartFile.fromPath(
        'file', 
        imageFile.path,
        contentType: _getMediaType(imageFile),
      ));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResult = json.decode(response.body);
        if (jsonResult['IsErroredOnProcessing'] == true) {
          throw Exception(jsonResult['ErrorMessage'] ?? 'Erreur OCR inconnue');
        }

        //recup le texte retourné par l’API
        final parsedResults = jsonResult['ParsedResults'];
        if (parsedResults == null || parsedResults.isEmpty) {
          throw Exception('Pas de texte détecté');
        }
        final textDetected = parsedResults[0]['ParsedText'] as String? ?? '';
        return textDetected;
      } else {
        throw Exception('Erreur lors de la requête OCR : ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// recup le mediaType
  MediaType? _getMediaType(File file) {
    final mimeType = lookupMimeType(file.path);
    if (mimeType == null) return null;
    final splits = mimeType.split('/');
    return MediaType(splits[0], splits[1]);
  }
}
