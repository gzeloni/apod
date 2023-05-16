import 'dart:convert';
import 'package:epic/config/config.dart';
import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

void apod() {
  // String date = '2020-12-11'; // Defina a data desejada

  String apiUrl =
      'https://api.nasa.gov/planetary/apod?api_key=${Config.getApodApiToken()}&count=5';

  http.get(Uri.parse(apiUrl)).then((response) {
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      for (var item in data) {
        String imageName = item['title'];
        final imageUrl = item['url'];
        // DateTime? img = DateTime.tryParse(imageDate);
        // final imageYear = DateFormat('yyyy').format(img!);
        // final imageMonth = DateFormat('MM').format(img);
        // final imageDay = DateFormat('dd').format(img);
        // String imageUrl =
        //     'https://epic.gsfc.nasa.gov/archive/natural/$imageYear/$imageMonth/$imageDay/png/$imageName.png';

        print('Image Name: $imageName');
        // print('Date: $imageDate');
        print('Image URL: $imageUrl');
        print('------------------------------------');
      }
    } else {
      print('Erro na requisição: ${response.statusCode}');
    }
  }).catchError((error) {
    print('Erro na requisição: $error');
  });
}
