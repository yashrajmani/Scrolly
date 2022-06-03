import 'package:flutter/material.dart';
import 'package:scrolly/components/remoteservice.dart';
import 'dart:async';
import 'package:scrolly/routes/home.dart';

class MemeLoader extends StatelessWidget {
  MemeLoader({
    Key? key,
    required this.color,
  }) : super(key: key);
  final Color color;
  late Future<Meme> futureMeme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 1,
          ),
          FutureBuilder<Meme>(
            future: futureMeme = RemoteService().fetchMeme(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: Image.network(
                        snapshot.data!.url,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        "*${snapshot.data!.title.toString().toUpperCase()}*",
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const Center(
                  child: Image(image: AssetImage("assets/loading01.gif")));
            },
          ),
        ],
      ),
    );
  }
}
