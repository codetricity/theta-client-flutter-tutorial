import 'package:flutter/material.dart';
import 'package:theta_client_flutter/theta_client_flutter.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: FlutterTutorial(),
      appBar: AppBar(
        title: Text('theta Flutter demo'),
      ),
    ),
  ));
}

class FlutterTutorial extends StatefulWidget {
  const FlutterTutorial({super.key});

  @override
  State<FlutterTutorial> createState() => _FlutterTutorialState();
}

class _FlutterTutorialState extends State<FlutterTutorial> {
  final _thetaClientFlutter = ThetaClientFlutter();
  PhotoCapture? photoCapture;
  PhotoCaptureBuilder? builder;

  Widget responseWindow = const Text('response area');

  @override
  void initState() {
    super.initState();
    initThetaApp();
    initializePhotoCapture();
  }

  Future<void> initThetaApp() async {
    debugPrint('debug: ${await _thetaClientFlutter.getPlatformVersion()}');
    await _thetaClientFlutter.initialize();
    debugPrint(
        'debug: intialized=${await _thetaClientFlutter.isInitialized()}');
  }

  void initializePhotoCapture() async {
    builder = _thetaClientFlutter.getPhotoCaptureBuilder();
    builder!.build().then(
      (value) {
        photoCapture = value;
        debugPrint('Ready to capture photos');
      },
    ).onError((error, stackTrace) {
      debugPrint('debug: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  size: 64,
                ),
                onPressed: () {
                  debugPrint('debug: take picture');
                  photoCapture!.takePicture((fileUrl) {
                    setState(() {
                      responseWindow = Image.network('$fileUrl?type=thumb');
                    });
                  }, (exception) {
                    debugPrint(exception.toString());
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () async {
                      var thetaInfo = await _thetaClientFlutter.getThetaInfo();
                      setState(() {
                        responseWindow =
                            Text('firmware: ${thetaInfo.firmwareVersion}\n');
                      });
                    },
                    child: Text(
                      'info',
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Expanded(
        //   child: responseWindow,
        //   flex: 1,
        // ),
      ],
    );
  }
}
