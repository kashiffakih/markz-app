import 'package:flutter/material.dart';
import 'package:sales_app/core/providers/course_pr.dart';
import 'package:provider/provider.dart';

class TrainingVideosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CourseModel _courseModel = Provider.of<CourseModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Training Videos'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Card(
              child: Column(
                children: [
                  Container(
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'Sr.',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              'Title',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              'Description',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              'Instructor',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              'Hrs',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: Text((_courseModel
                                                            .courses!
                                                            .indexOf(_course) +
                                                        1)
                                                    .toString()),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Center(
                                                child: Text(
                                                    _course.courseName ?? ''),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Center(
                                                child: Text(
                                                    _course.description ?? ''),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Center(
                                                child: Text(
                                                  _course.instructor ?? '',
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Center(
                                                child:
                                                    Text(_course.noOfHrs ?? ''),
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
    );
  }
}
