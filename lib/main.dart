import 'dart:io';
import 'package:flutter/material.dart';
import 'package:unsplash_client/unsplash_client.dart';
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
  var appCredentials;

  @override
  void initState() {
    super.initState();

    appCredentials = loadAppCredentials();
  }

  void getSearchImage() async {
    if (appCredentials == null) {
      throw 'Please provide a credentials file as the first and only argument.';
    }

    // Create a client.
    final client = UnsplashClient(
      settings: ClientSettings(credentials: appCredentials),
    );

    listImages.clear();

    final photos = await client.search.photos(imageSearch).goAndGet();
    for (var photo in Iterable.castFrom(photos.results)) {
      listImages.add(photo.urls.regular);
    }

    setState(() {
      listImages = listImages;
      hasSearched = true;
    });
  }

  void getRandomImage() async {
    if (appCredentials == null) {
      throw 'Please provide a credentials file as the first and only argument.';
    }

    // Create a client.
    final client = UnsplashClient(
      settings: ClientSettings(credentials: appCredentials),
    );

    // Fetch 5 random photos by calling `goAndGet` to execute the [Request]
    // returned from `random` and throw an exception if the [Response] is not ok.
    final photos = await client.photos.random(count: 10).goAndGet();

    listImages.clear();

    for (var element in photos) {
      listImages.add(element.urls.regular);
    }

    setState(() {
      listImages = listImages;
      hasSearched = true;
    });
  }

  AppCredentials? loadAppCredentials() {
    return const AppCredentials(
      accessKey: kUnsplashAccessKey,
      secretKey: kUnsplashSecretKey,
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
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () async {
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
                                      await getApplicationDocumentsDirectory();
                                  File file = File(path.join(docDir.path,
                                      path.basename(path.basename(url))));
                                  await file.writeAsBytes(response.bodyBytes);
                                  // ignore: use_build_context_synchronously
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
