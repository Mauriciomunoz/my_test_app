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
        title: 'Namer App',
        theme: ThemeData(
          primarySwatch: Colors.green,
          //useMaterial3: true,
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  // ↓ Add the code below.
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    var selectedIndex = 0;

    // ↓ Add this.
    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("My app")),
      drawer: Drawer(
        width: 250,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                padding: EdgeInsets.all(20.0),
                child: Text("Menu"),
              ),
            ),
            ListTile(
              selected: selectedIndex == 0,
              title: const Text("Main"),
              trailing: Icon(Icons.home),
              onTap: () {
                selectedIndex = 0;
                Navigator.pop(context);
              },
            ),
            Ink(
              color:
                  selectedIndex == 1 ? Color(0xffE3EAFF) : Colors.transparent,
              child: ListTile(
                selected: selectedIndex == 1,
                title: const Text("Favorites"),
                trailing: Icon(Icons.favorite),
                onTap: () {
                  selectedIndex = 1;
                  print('Like pressed!');
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: GeneratorPage(pair: pair, appState: appState, icon: icon),
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({
    super.key,
    required this.pair,
    required this.appState,
    required this.icon,
  });

  final WordPair pair;
  final MyAppState appState;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Creating words:'),
        SizedBox(
          height: 10,
        ),
        BigCard(pair: pair),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                print('Like pressed!');
                appState.toggleFavorite();
              },
              icon: Icon(icon),
              label: Text('Like'),
            ),
            SizedBox(
              width: 20,
            ),
            ElevatedButton(
              onPressed: () {
                print('button pressed!');
                appState.getNext();
              },
              child: Text('Next'),
            ),
          ],
        ),
      ],
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
    var styleCard =
        //theme.textTheme.displayMedium!.copyWith(color: Color(0xFFFFFFFF));
        theme.textTheme.displayMedium!
            .copyWith(color: theme.colorScheme.onPrimary);

    return Card(
      color: Color.fromARGB(255, 61, 198, 229),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: styleCard,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
