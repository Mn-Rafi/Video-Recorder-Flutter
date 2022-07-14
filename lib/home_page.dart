
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:videorecorder/video_model.dart';

import 'camera_module.dart';
import 'video_view.dart';

List<Videomodel> videoList = [];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          backgroundColor: Colors.white60,
          title: Text(
            "Gallery",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: videoList.length == 0
            ? videoEmptyGalleryView()
            : videoGalleryView(),
        floatingActionButton:
            videoList.length == 0 ? Container() : floatingBtn());
  }

  Widget videoEmptyGalleryView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (builder) => CameraModule()));
            },
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.circle,
              ),
              height: 100,
              width: 100,
              child: const Icon(
                Icons.video_call,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              "No video",
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (builder) => CameraModule()));
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                "Click to record video",
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget videoGalleryView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 8.0,
        children: List.generate(videoList.length, (index) {
          Image img = Image.memory(videoList[index].thumbnail as Uint8List);

          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => VideoView(
                            videomodel: Videomodel(
                                name: videoList[index].name,
                                path: videoList[index].path),
                          )));
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(image: img.image, fit: BoxFit.cover),
                color: Colors.black38,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 33,
                        backgroundColor: Colors.black12,
                        child: Icon(
                          // ? Icons.pause
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          videoList[index].name.toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget floatingBtn() {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.black12,
        shape: BoxShape.circle,
      ),
      height: 100,
      width: 100,
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (builder) => CameraModule()));
        },
        child: const Icon(
          Icons.video_call,
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }
}
