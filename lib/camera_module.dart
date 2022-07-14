import 'dart:math';
import 'package:video_thumbnail/video_thumbnail.dart' as thumbnail;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:videorecorder/home_page.dart';
import 'package:videorecorder/video_model.dart';

List<CameraDescription> cameras = [];

class CameraModule extends StatefulWidget {
  const CameraModule({Key? key}) : super(key: key);

  @override
  _CameraModuleState createState() => _CameraModuleState();
}

class _CameraModuleState extends State<CameraModule> {
  bool isRecording = false;
  bool flash = false;
  bool iscamerafront = true;
  double transform = 0;
  late CameraController _cameraController;
  late Future<void> cameraValue;
  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
              future: cameraValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: CameraPreview(_cameraController));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          bottomCameraModuleBar(),
        ],
      ),
    );
  }

  Widget bottomCameraModuleBar() {
    return Positioned(
      bottom: 0.0,
      child: Container(
        color: Colors.black,
        padding: EdgeInsets.only(top: 5, bottom: 5),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    icon: Icon(
                      flash ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      setState(() {
                        flash = !flash;
                      });
                      flash
                          ? _cameraController.setFlashMode(FlashMode.torch)
                          : _cameraController.setFlashMode(FlashMode.off);
                    }),
                GestureDetector(
                  onTap: () async {
                    await _cameraController.startVideoRecording();
                    setState(() {
                      isRecording = true;
                    });
                  },
                  onTapUp: (vs) async {
                    XFile videopath =
                        await _cameraController.stopVideoRecording();
                    final uint8list =
                        await thumbnail.VideoThumbnail.thumbnailData(
                      video: videopath.path,
                      imageFormat: thumbnail.ImageFormat.JPEG,
                      maxWidth:
                          500, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                      quality: 25,
                    );
                    //MemoryImage(uint8list!);
                    setState(() {
                      isRecording = false;
                    });
                    videoList.add(Videomodel(
                        name: videopath.name,
                        path: videopath.path,
                        thumbnail: uint8list));
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => HomePage()));
                  },
                  child: isRecording
                      ? Icon(
                          Icons.stop_circle_outlined,
                          color: Colors.red,
                          size: 80,
                        )
                      : Icon(
                          Icons.panorama_fish_eye,
                          color: Colors.white,
                          size: 70,
                        ),
                ),
                IconButton(
                    icon: Transform.rotate(
                      angle: transform,
                      child: Icon(
                        Icons.flip_camera_ios,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        iscamerafront = !iscamerafront;
                        transform = transform + pi;
                      });
                      int cameraPos = iscamerafront ? 0 : 1;
                      _cameraController = CameraController(
                          cameras[cameraPos], ResolutionPreset.high);
                      cameraValue = _cameraController.initialize();
                    }),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              "Tap for Video",
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
