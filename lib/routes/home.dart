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
    final controller = new PageController(initialPage: 999);

    List<Widget> pages = [
      MemeLoader(color: Colors.red),
      MemeLoader(color: Colors.blue),
      MemeLoader(color: Colors.green),
      MemeLoader(color: Colors.purple),

    ];

    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: BottomAppBar(
              color: Colors.amberAccent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {
                        print("SEND CLICKED!");
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.blue,
                      )),
                  SizedBox(
                    height: 40,
                    child: VerticalDivider(
                      color: Colors.black,
                      thickness: 2,
                      indent: 5,
                      endIndent: 2,
                      width: 5,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        print("CLOSE CLICKED!");
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                      )),
                ],
              )),
          body: PageView.builder(
            controller: controller,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return new Center(
                child: pages.elementAt(index % 4),
              );
            },
          )),
    );
  }
}




//SETUP///////////////////////////////////////////////////////////
class MemeLoader extends StatelessWidget {
  MemeLoader({
    Key? key,
    required this.color,
  }) : super(key: key);

  late Future<Meme> futureMeme;
  final Color color;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: color,
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
            future: futureMeme=fetchMeme(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Image.network(
                      snapshot.data!.url,
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.7,
                    ),
                    Text(
                      snapshot.data!.title,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
