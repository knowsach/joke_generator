import 'package:flutter/material.dart';
import '../models/joke_model.dart';

class JokeCard extends StatelessWidget {
  final Joke joke;

  JokeCard({required this.joke});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(joke.joke, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
