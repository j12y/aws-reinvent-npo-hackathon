import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());
//List<CameraDescription> cameras;
//Future<Null> main() async {
//  cameras = await availableCameras();
//  runApp(MyApp());
//}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Goodwill'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final listChildren = <String>[];

  void addNewRow() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Column(
            mainAxisSize: MainAxisSize.max,
//            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage('images/goodwill.jpg'))
            ]
        ),
        floatingActionButton: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                  child: Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ThirdScreen()));
                  },
                  heroTag: 'nextPage'),
            ]) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  ListTile _buildRow(int index) {
    return ListTile(
      leading: Icon(Icons.map),
      title: Text(listChildren[index]),
    );
  }
}


//Future<Null> main() async {
//
//  runApp(new CameraApp());
//}

class ThirdScreen extends StatefulWidget {
  _CameraState createState() => new _CameraState();
}

const url = 'https://ayps2ndd3l.execute-api.us-east-1.amazonaws.com/dev/image';

class _CameraState extends State<ThirdScreen> {
  File _image;
  var responseText = 'Please upload an image';

  Future getImage() async {
    var image =
    await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 640);

    setState(() {
      _image = image;
      print(image);
      image.length().then((size) {
//        print(size);
      });
      _image.readAsBytes().then((imageBytes) {
//        print(imageBytes);
        String base64Image = base64Encode(imageBytes);
//        print(base64Image);
        final client = http.Client();
        client
          .post(url, body: base64Image)
          .then((http.Response r) {
            final value = json.decode(r.body)['result'] as String;
            final response = http
                .get('https://57l0a1p831.execute-api.us-east-1.amazonaws.com/dev/donate/policy?item=$value')
                .then((response) {
                  if (response.statusCode == 200) {
                    // If server returns an OK response, parse the JSON
                    setState(() {
                      var item = Post.fromJson(json.decode(response.body));
                      var itemsWithSlash = value.replaceAll(',', ' / ');
                      if (item.accepted) {
                        responseText = 'Thank you. We would appreciated the $itemsWithSlash as a donation.\n The value is ${item.value}';
                      } else {
                        responseText = 'Unfortunately, we do not accept $itemsWithSlash as donation.';
                      }
                    });
                  } else {
                    // If that response was not OK, throw an error.
                    throw Exception('Failed to load post');
                  }
                });
          });

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Image Picker'),
        ),
        body: new Center(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _image == null ? new Container() : new Image.file(_image),
                  Text(
                    responseText,
                    style: TextStyle(
                      fontSize: 20.0
                    ),
                  )
                ]
            )
        ),
        floatingActionButton: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                onPressed: getImage,
                tooltip: 'Pick Image',
                child: new Icon(Icons.add_a_photo),
              ),
//              FloatingActionButton(
//                  child: Icon(
//                    Icons.navigate_next,
//                    color: Colors.white,
//                  ),
//                  onPressed: () {
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) =>
//                                SecondScreen(res: responseText)));
//                  },
//                  heroTag: 'upload'),
            ]));
  }

  updateReponseText(String r) {
    setState(() {
      responseText = r;
    });
  }
}
//
//class CameraApp extends StatefulWidget {
//  @override
//  _CameraAppState createState() => new _CameraAppState();
//}
//
//class _CameraAppState extends State<CameraApp> {
//  CameraController controller;
//
//  @override
//  void initState() {
//    super.initState();
//    controller = new CameraController(cameras[0], ResolutionPreset.medium);
//    controller.initialize().then((_) {
//      if (!mounted) {
//        return;
//      }
//      setState(() {});
//    });
//  }
//
//  @override
//  void dispose() {
//    controller?.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    if (!controller.value.isInitialized) {
//      return new Container();
//    }
//    return new AspectRatio(
//        aspectRatio:
//        controller.value.aspectRatio,
//        child: new CameraPreview(controller));
//  }
//}


class SecondScreen extends StatelessWidget {
  Future<Post> post;
  String responseText;

  SecondScreen({Key key, String res}) : super(key: key) {
    this.responseText = res;
    print('this is $responseText');
    this.post = _fetchPost(value: responseText);
  }

  Future<Post> _fetchPost({String value}) async {
    print(
        'https://57l0a1p831.execute-api.us-east-1.amazonaws.com/dev/donate/policy?item=$value');
    final response =
    await http.get(
        'https://57l0a1p831.execute-api.us-east-1.amazonaws.com/dev/donate/policy?item=$value');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return Post.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: FutureBuilder<Post>(
        future: post,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else if (snapshot.hasData) {
            return Text(
                'Item accepted by Goodwill: ${snapshot.data
                .accepted}\n${snapshot.data.value}',
                style: TextStyle(
                    fontSize: 20.0
                ));
          }

          // By default, show a loading spinner
          return CircularProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.input, color: Colors.white),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ThirdScreen()));
          },
          heroTag: 'thirdPage'),
    );
  }
}
//Scaffold.of
class Post {
  final bool accepted;
  final String value;

  Post({this.accepted, this.value});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        accepted: json['accepted'],
        value: json['value']
    );
  }
}