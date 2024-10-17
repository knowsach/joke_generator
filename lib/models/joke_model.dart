import 'dart:convert';

class Joke {
  final String id;
  final String joke;

  Joke({required this.id, required this.joke});

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      id: json['id'],
      joke: json['joke'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'joke': joke,
      };

  static List<Joke> parseJokes(String responseBody) {
    final parsed = json.decode(responseBody)['results'] as List;
    return parsed.map<Joke>((json) => Joke.fromJson(json)).toList();
  }
}
