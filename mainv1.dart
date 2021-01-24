import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;
  List _outputs;
  File _image;
  bool _loading = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();

    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nude_detection_by_Sinai'),
          backgroundColor: Colors.deepPurple,
          elevation: 0.0,
          leading: Icon(Icons.menu),
        ),
        body: _loading
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _image == null ? Container() : Image.file(_image),
                    SizedBox(
                      height: 20,
                    ),
                    _outputs != null
                        ? Text(
                            "${_outputs[0]["label"]}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              background: Paint()..color = Colors.deepPurple,
                              fontFamily: 'Roboto',
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionBubble(
            // Menu items
            items: <Bubble>[
              Bubble(
                title: "Gallery",
                iconColor: Colors.white,
                bubbleColor: Colors.green,
                icon: Icons.photo_album,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  _animationController.reverse();
                  pickImage();
                },
              ),
              Bubble(
                title: "Camera",
                iconColor: Colors.white,
                bubbleColor: Colors.green,
                icon: Icons.camera_alt,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  _animationController.reverse();
                  _imgFromCamera();
                },
              ),
            ],
            animation: _animation,

            // On pressed change animation state
            onPress: () => _animationController.isCompleted
                ? _animationController.reverse()
                : _animationController.forward(),
            iconColor: Colors.green,
            icon: AnimatedIcons.menu_close));
  }

  pickImage() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(image);
  }

  _imgFromCamera() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(image);
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    print(output);
    setState(() {
      _loading = false;
      _outputs = output;
      if (_outputs[0]['index'] == 0) {
        Fluttertoast.showToast(
            msg: "nudes cannot be uploaded",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 14.0);
        _loading = true;
      } else {
        _loading = false;
        Container();
      }
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/classifier.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
