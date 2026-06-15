import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:unsplash/constants.dart';
import 'package:unsplash/config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Images',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: kAppColor),
          scaffoldBackgroundColor: const Color.fromARGB(255, 236, 214, 194),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            backgroundColor: kAppBarColor,
          )),
      home: const MyHomePage(title: 'Images'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List listImages = [];
  bool hasSearched = false;
  String imageSearch = '';
  final TextEditingController _searchController = TextEditingController();

  // Unsplash API requests authenticate via the access key as a Client-ID.
  Map<String, String> get _authHeaders =>
      {'Authorization': 'Client-ID $kUnsplashAccessKey'};

  void getSearchImage() async {
    final uri = Uri.https('api.unsplash.com', '/search/photos', {
      'query': imageSearch,
      'per_page': '10',
    });
    final response = await http.get(uri, headers: _authHeaders);
    if (response.statusCode != 200) {
      _showError('Search failed (${response.statusCode})');
      return;
    }

    final results = (jsonDecode(response.body)['results'] as List);

    setState(() {
      listImages = [for (final photo in results) photo['urls']['regular']];
      hasSearched = true;
    });
  }

  void getRandomImage() async {
    final uri = Uri.https('api.unsplash.com', '/photos/random', {
      'count': '10',
    });
    final response = await http.get(uri, headers: _authHeaders);
    if (response.statusCode != 200) {
      _showError('Could not load random images (${response.statusCode})');
      return;
    }

    final results = (jsonDecode(response.body) as List);

    setState(() {
      listImages = [for (final photo in results) photo['urls']['regular']];
      hasSearched = true;
    });
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _searchController,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () async {
                      if (_searchController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Enter search text')),
                        );
                        return;
                      }
                      setState(() {
                        // isLoading = true;
                      });
                      getSearchImage();
                    },
                    icon: const Icon(Icons.search),
                    iconSize: 35.0,
                    color: Colors.black,
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 230, 191, 154),
                  hintText: 'Search Images',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  imageSearch = value;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_searchController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Enter search text')),
                        );
                        return;
                      }
                      getSearchImage();
                    },
                    child: const Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  ElevatedButton(
                    onPressed: () {
                      _searchController.clear();
                      getRandomImage();
                    },
                    child: const Text(
                      'Random',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext ctx, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Card(
                        shape: Border.all(
                          width: 5,
                        ),
                        elevation: 20,
                        // color: Colors.black,
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                                child:
                                    Image.network(listImages[index].toString()),
                                onTap: () async {
                                  String url = listImages[index].toString();
                                  var response = await http.get(Uri.parse(url));
                                  Directory docDir =
                                      (await getDownloadsDirectory()) ??
                                      await getApplicationDocumentsDirectory();
                                  String fileName = path.basename(Uri.parse(url).path);
                                  File file = File(path.join(docDir.path, '$fileName.jpg'));
                                  await file.writeAsBytes(response.bodyBytes);
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Image saved in the Downloads folder')),
                                  );
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text('Image Saved'),
                                            content: Image.file(file),
                                          ));
                                }),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: listImages.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
