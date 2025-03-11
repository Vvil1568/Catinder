import 'dart:convert';
import 'package:catinder/data/model/cat_image.dart';
import 'package:http/http.dart' as http;

import '../../util/constants.dart';

Future<List<CatImage>> getCatInfo({required int pageSize}) async {
  final response = await http.get(
    Uri.parse(
        '${Constants.apiUrl}${Constants.imagesEndpoint}?has_breeds=1&api_key=${Constants.apiKey}&limit=$pageSize'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    final List<CatImage> catImages =
        jsonList.map((json) => CatImage.fromJson(json)).toList();

    return catImages;
  } else {
    throw Exception('Failed to load giveaways');
  }
}
