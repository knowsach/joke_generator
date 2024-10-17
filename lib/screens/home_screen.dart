import 'package:flutter/material.dart';
import '../components/app_bar.dart';
import 'common/infinite_joke_scroller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppBar(),
      body: InfiniteJokeScroller(),
    );
  }
}
