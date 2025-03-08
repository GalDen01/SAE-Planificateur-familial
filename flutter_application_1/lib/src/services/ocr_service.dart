import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OCRService {
  // Remplacez par votre clé API OCR.space
  final String apiKey = "YOUR_API_KEY";

  /// Envoie l'image à l'API OCR.space et tente d'extraire un prix
  Future<String> extractPriceFromImage(File imageFile) async {
    final uri = Uri.parse("https://api.ocr.space/parse/image");
    final request = http.MultipartRequest("POST", uri);

    request.fields['apikey'] = apiKey;
    request.fields['language'] = 'eng';
    request.fields['isOverlayRequired'] = 'false';

    final multipartFile = await http.MultipartFile.fromPath("file", imageFile.path);
    request.files.add(multipartFile);

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = json.decode(responseData);
      if (data["ParsedResults"] != null && data["ParsedResults"].isNotEmpty) {
        String parsedText = data["ParsedResults"][0]["ParsedText"];
        // Recherche d'un nombre au format prix (ex: 12.34 ou 12,34)
        final priceRegex = RegExp(r"(\d+[\.,]\d{2})");
        final match = priceRegex.firstMatch(parsedText);
        if (match != null) {
          // Normalise le format en remplaçant la virgule par un point
          String priceStr = match.group(0)!.replaceAll(',', '.');
          return priceStr;
        } else {
          return "Aucun prix trouvé";
        }
      } else {
        return "Erreur d'analyse OCR";
      }
    } else {
      return "Erreur lors de l'appel OCR: ${response.statusCode}";
    }
  }
}
