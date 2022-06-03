import 'dart:convert';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:scrolly/components/memeloader.dart';
import 'package:scrolly/components/remoteservice.dart';

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
  bool close = false;

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Do you want to exit the App?'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    futureMeme = RemoteService().fetchMeme() as Future<Meme>;
  }

  Future sendmeme(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/screenshot.png');
    image.writeAsBytesSync(bytes);
    await Share.shareFiles([image.path]);
  }

  @override
  Widget build(BuildContext context) {
    final controller = PageController(initialPage: 999);
    final sscontroller = ScreenshotController();
    List<Widget> pages = [
      MemeLoader(color: Colors.red.shade100),
      MemeLoader(color: Colors.blue.shade100),
      MemeLoader(color: Colors.green.shade100),
      MemeLoader(color: Colors.purple.shade100),
    ];

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Scrolly : The Meme App",
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
            centerTitle: true,
          ),
          bottomNavigationBar: BottomAppBar(
              color: Colors.amber,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () async {
                        print("SEND CLICKED!");
                        final image = await sscontroller.captureFromWidget(PageView());
                        if(image.isNotEmpty)
                          {
                            sendmeme(image);
                          }
                        else
                          {
                            print("NO IMAGE");
                          }
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.blue,
                      )),
                  const SizedBox(
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
                        if (Platform.isAndroid) {
                          SystemNavigator.pop();
                        } else {
                          exit(0);
                        }
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      )),
                ],
              )),
          body: PageView.builder(
              controller: controller,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Center(
                  child: pages.elementAt(index % 4),
                );
              },
            ),
          ),
    );
  }
}
