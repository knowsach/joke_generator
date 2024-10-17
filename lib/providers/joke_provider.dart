import 'package:flutter/material.dart';
import '../models/joke_model.dart';
import '../services/api_service.dart';

class JokeProvider with ChangeNotifier {
  List<Joke> jokeList = [];
  bool isLoading = false;
  bool _isLoadingMore = false;
  String error = '';
  int currentPage = 1;
  String currentQuery = '';
  String _searchQuery = '';

  bool get isLoadingMore => _isLoadingMore;

  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Fetch a random joke
  Future<void> fetchRandomJoke() async {
    isLoading = true;
    notifyListeners();
    try {
      jokeList = await ApiService().fetchRandomJoke();
    } catch (e) {
      error = 'Failed to load joke';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch more jokes (for infinite scroll)
  Future<void> fetchMoreJokes() async {
    if (_isLoadingMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      currentPage++;
      List<Joke> newJokes =
          await ApiService().searchJokes(currentQuery, page: currentPage);
      jokeList.addAll(newJokes);
    } catch (e) {
      error = 'Failed to load more jokes';
      currentPage--;
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Update searchJokes method
  Future<void> searchJokes() async {
    isLoading = true;
    currentQuery = _searchQuery;
    currentPage = 1;
    notifyListeners();

    try {
      jokeList =
          await ApiService().searchJokes(currentQuery, page: currentPage);
    } catch (e) {
      error = 'Failed to load jokes';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
