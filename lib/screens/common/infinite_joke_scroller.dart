import 'package:flutter/material.dart';
import 'package:joke_app/utils/text_constant.dart';
import 'package:provider/provider.dart';
import '../../../providers/joke_provider.dart';
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
    _searchController.text = context.read<JokeProvider>().searchQuery;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
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
    context.read<JokeProvider>().setSearchQuery(query);
    context.read<JokeProvider>().searchJokes();
  }

  void _onSearchChanged() {
    context.read<JokeProvider>().setSearchQuery(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<JokeProvider>(
            builder: (context, provider, _) {
              return TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search jokes...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      provider.setSearchQuery('');
                      provider.searchJokes();
                    },
                  ),
                ),
                onSubmitted: _onSearch,
              );
            },
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
                  child: Text(TextConstants.noJokesFound),
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
