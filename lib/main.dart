import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Mix Blaster',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favourites = <WordPair>{};
  var selectedIndex = 0;

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavourite() {
    toggle(current);
  }

  void toggle(WordPair wp) {
    if (favourites.contains(wp)) {
      favourites.remove(wp);
    } else {
      favourites.add(wp);
    }
    notifyListeners();
  }

  bool isFavourite() {
    return favourites.contains(current);
  }

  void changeView(int value) {
    selectedIndex = value;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0: 
        page = GeneratorPage();
        break;
      case 1:
        page = FavouritesPage();
        break;
      case 2:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError("This page has not been implemented");
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 450) {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favorites'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text('Settings'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: page,
                  ),
                ),
              ],
            );
          } else {
            return Column(children: [
              Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: page,
                  ),
                ),
              SafeArea(
                child: BottomNavigationBar(
                    items: [                    
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: "Home",
                      ),                
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: "Favorites",
                      ),           
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: "Settings",
                      ),                      
                    ],
                    currentIndex: selectedIndex,
                    onTap: (int value) => {
                      setState(() {
                        selectedIndex = value;
                      }),
                    },
                  )
              ),
            ],);
          }
        }
      )
    );
  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.isFavourite()) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_outline;
    }

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(pair: pair),
            SizedBox(height: 10.0,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavourite();
                  }, 
                  icon: Icon(icon),
                  label: Text("Like")
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  }, 
                  child: Text("Next")
                ),
              ],
            ),
          ],
        ),
      );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary
    );

    return Card(
      color: theme.colorScheme.primary,
      elevation: 5.0,
      child: Padding(        
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asUpperCase, 
          style: style,
          semanticsLabel: pair.asPascalCase,
          ),
      ),
    );
  }
}

class FavouritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    var theme = Theme.of(context);
    var style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimaryContainer
    );

    if (appState.favourites.isEmpty) {
      return Center(
        child: Text("No favorites yet!")
      );
    }

    return Center(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("My Favourites", style: style,),
          ),
        
          for (var fav in appState.favourites) 
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  appState.toggle(fav);
                },),              
              title: Text(fav.asUpperCase),
            )
    
        ],
      ),
    );
  }

}