import 'package:flutter/material.dart';
import 'package:sales_app/core/models/course.dart';
import 'package:sales_app/ui/shared/images_sh.dart';
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
        title: Text(
          'Course Videos',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.backgroundImg),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _courseDetail.description ?? '-',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          YoutubePlayer(
                            controller: _controller,
                            showVideoProgressIndicator: true,
                            onReady: () {
                              print(
                                'Player is ready.',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
        // child: ,
      ),
    );
  }
}
