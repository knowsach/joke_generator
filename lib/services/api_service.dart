import 'package:http/http.dart' as http;
import '../constants/api_constant.dart';
import '../models/joke_model.dart';

class ApiService {
  Future<List<Joke>> fetchRandomJoke() async {
    final response = await http.get(Uri.parse(ApiConstants.searchJokes),
        headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      return Joke.parseJokes(response.body);
    } else {
      throw Exception('Failed to load random joke');
    }
  }

  Future<List<Joke>> searchJokes(String query, {int page = 1}) async {
    final response = await http.get(
        Uri.parse('${ApiConstants.searchJokes}?term=$query&page=$page'),
        headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      return Joke.parseJokes(response.body);
    } else {
      throw Exception('Failed to load jokes');
    }
  }
}
