import 'package:flutter/material.dart';
import 'package:joke_app/providers/joke_provider.dart';
import 'package:joke_app/utils/text_constant.dart';
import '../components/app_bar.dart';
import 'common/infinite_joke_scroller.dart';
import 'common/welcome_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeJokes();
  }

  void _initializeJokes() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JokeProvider>().searchJokes();
    });
  }

  static const List<Widget> _widgetOptions = [
    WelcomeScreen(),
    InfiniteJokeScroller(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: TextConstants.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_quote),
            label: TextConstants.jokes,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
