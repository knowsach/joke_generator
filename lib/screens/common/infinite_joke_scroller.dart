import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/joke_provider.dart';
import '../../components/joke_card.dart';

class InfiniteJokeScroller extends StatefulWidget {
  const InfiniteJokeScroller({super.key});

  @override
  _InfiniteJokeScrollerState createState() => _InfiniteJokeScrollerState();
}

class _InfiniteJokeScrollerState extends State<InfiniteJokeScroller> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreJokes();
    }
  }

  Future<void> _loadMoreJokes() async {
    await context.read<JokeProvider>().fetchMoreJokes();
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      context.read<JokeProvider>().searchJokes('');
    } else {
      context.read<JokeProvider>().searchJokes(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search jokes...',
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _onSearch('');
                },
              ),
            ),
            onSubmitted: _onSearch,
          ),
        ),
        Expanded(
          child: Consumer<JokeProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (provider.jokeList.isEmpty) {
                return const Center(
                  child: Text('No jokes found'),
                );
              }

              if (provider.error.isNotEmpty) {
                return Center(
                  child: Text(provider.error),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount:
                    provider.jokeList.length + (provider.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < provider.jokeList.length) {
                    return JokeCard(joke: provider.jokeList[index]);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
