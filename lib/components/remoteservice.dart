import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scrolly/routes/home.dart';

class RemoteService {
  Future<Meme> fetchMeme() async {
    final response =
    await http.get(Uri.parse('https://meme-api.herokuapp.com/gimme'));
    if (response.statusCode == 200) {
      return Meme.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load meme');
    }
  }
}