import 'package:flutter/material.dart';
import 'package:sales_app/core/providers/course_pr.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/ui/shared/images_sh.dart';

class TrainingVideosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CourseModel _courseModel = Provider.of<CourseModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Training Videos',
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
            child: Container(
              child: Card(
                child: Column(
                  children: [
                    Container(
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Sr.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Title',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Action',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _courseModel.courses == null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: _courseModel.courses!
                                  .map(
                                    (_course) => InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/trainingVideoList',
                                            arguments: {
                                              'course': _course,
                                            });
                                      },
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    (_courseModel.courses!
                                                                .indexOf(
                                                                    _course) +
                                                            1)
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Center(
                                                  child: Text(
                                                    _course.courseName ?? '',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Icon(
                                                  Icons
                                                      .arrow_right_alt_outlined,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Divider(),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
