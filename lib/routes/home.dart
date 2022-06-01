import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Meme> fetchMeme() async {
  final response =
      await http.get(Uri.parse('https://meme-api.herokuapp.com/gimme'));
  if (response.statusCode == 200) {
    return Meme.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load meme');
  }
}

class Meme {
  String title;
  String url;

  Meme({
    required this.title,
    required this.url,
  });

  factory Meme.fromJson(Map<String, dynamic> json) {
    return Meme(
      title: json['title'],
      url: json['url'],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Meme> futureMeme;

  @override
  void initState() {
    super.initState();
    futureMeme = fetchMeme();
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: 0);
    List<Widget> pages = [
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "BELOW IS MEME",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder<Meme>(
              future: futureMeme,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                      width: 300,
                      height: 300,
                      child: Column(
                        children: [
                          Text(
                            "CAPTION : "+snapshot.data!.title,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Image.network(snapshot.data!.url),
                        ],
                      ));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
            ElevatedButton(
                onPressed: () {
                  print("RELOAD CLICKED!");
                  setState((){
                    futureMeme=fetchMeme(); // Set state like this
                  });

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Reload"),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(Icons.refresh),
                  ],
                ))
          ],
        ),
      ),
      Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.yellow),
      Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.green),
      Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.blue)
    ];

    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: controller,
          scrollDirection: Axis.vertical,
          children: pages,
        ),
      ),
    );
  }
}
