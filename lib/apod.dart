import 'dart:convert';
import 'package:apod/config/config.dart';
import 'package:http/http.dart' as http;

List<Map<String, dynamic>> apodImages = [];

Future<List<Map<String, dynamic>>> apod() async {
  String apiUrl =
      'https://api.nasa.gov/planetary/apod?api_key=${Config.getApodApiToken()}&count=3';

  await http.get(Uri.parse(apiUrl)).then((response) {
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      for (var item in data) {
        Map<String, dynamic> map = {
          'title': item['title'],
          'date': item['date'],
          'description': item['explanation'],
          'type': item['media_type'],
          "url": item['url'],
        };
        apodImages.add(map);
      }
    } else {
      print('Erro na requisição: ${response.statusCode}');
    }
  }).catchError((error) {
    print('Erro na requisição: $error');
  });

  return apodImages;
}
