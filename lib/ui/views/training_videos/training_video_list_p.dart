import 'package:flutter/material.dart';
import 'package:sales_app/core/models/course.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrainingVideoListPage extends StatefulWidget {
  final Course course;

  TrainingVideoListPage({required this.course});
  @override
  _TrainingVideoListPageState createState() => _TrainingVideoListPageState();
}

class _TrainingVideoListPageState extends State<TrainingVideoListPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Videos'),
      ),
      body: SafeArea(
        child: Column(
          children: widget.course.courseDetails!.map(
            (_courseDetail) {
              _controller = YoutubePlayerController(
                initialVideoId: _courseDetail.videolink ?? 'feQhHStBVLE',
                flags: YoutubePlayerFlags(
                  mute: false,
                  autoPlay: true,
                ),
              );
              return Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                  elevation: 7.0,
                  child: Column(
                    children: [
                      Text(_courseDetail.description ?? '-'),
                      SizedBox(height: 10),
                      YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        onReady: () {
                          print('Player is ready.');
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ).toList(),
        ),
        // child: ,
      ),
    );
  }
}
