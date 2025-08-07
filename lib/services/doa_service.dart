import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xii_rpl_3/models/doa_model.dart';

class DoaService {
  static const String albumUrl =
      'https://doa-doa-api-ahmadramadhan.fly.dev/api';

  static Future<List<DoaModel>> listAlbum() async {
    final response = await http.get(Uri.parse(albumUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => DoaModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal Load Data Album');
    }
  }
}
