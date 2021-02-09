import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/analytics_pr.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AttendanceCalendarPage extends StatefulWidget {
  @override
  _AttendanceCalendarPageState createState() => _AttendanceCalendarPageState();
}

class _AttendanceCalendarPageState extends State<AttendanceCalendarPage> {
  List<Map<String, dynamic>> _parameters = [
    {'name': 'Total Worked hrs / Day', 'value': ':    '},
    {'name': 'Avg. Working hrs', 'value': ':    '},
    {'name': 'Present', 'value': ':    '},
    {'name': 'Absent', 'value': ':    '},
    {'name': '<5 hrs', 'value': ':    '},
    {'name': '>=5 hrs', 'value': ':    '},
  ];

  @override
  Widget build(BuildContext context) {
    final _analyticsModel = Provider.of<AnalyticsModel>(context);
    if (_analyticsModel.attendanceCalendar != null)
      setState(() {
        _parameters = [
          {
            'name': 'Total Worked hrs / Day',
            'value':
                ':    ${_analyticsModel.attendanceCalendar.totalWorkedHrsDay}',
          },
          {
            'name': 'Avg. Working hrs',
            'value': ':    ${_analyticsModel.attendanceCalendar.avgWorkingHrs}'
          },
          {
            'name': 'Present',
            'value': ':    ${_analyticsModel.attendanceCalendar.present}'
          },
          {
            'name': 'Absent',
            'value': ':    ${_analyticsModel.attendanceCalendar.absent}'
          },
          {
            'name': '<5 hrs',
            'value': ':    ${_analyticsModel.attendanceCalendar.lessThan5Hrs}'
          },
          {
            'name': '>=5 hrs',
            'value':
                ':    ${_analyticsModel.attendanceCalendar.greaterThan5Hrs}'
          },
        ];
      });

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Calendar'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _analyticsModel.attendanceCalendar == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Container(
                      height: 800,
                      child: SfCalendar(
                        view: CalendarView.month,
                        dataSource: MeetingDataSource(_getDataSource(
                          analyticsModel: _analyticsModel,
                        )),
                        monthViewSettings: MonthViewSettings(
                          appointmentDisplayMode:
                              MonthAppointmentDisplayMode.appointment,
                        ),
                      ),
                    ),
                    Divider(),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ..._parameters
                                .map(
                                  (_parameter) => Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _parameter['name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            _parameter['value'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                            Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text('>=5 hrs'),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text('<5 hrs'),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text('Absent'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}

List<Meeting> _getDataSource({@required AnalyticsModel analyticsModel}) {
  List<Meeting> meetings = <Meeting>[];
  analyticsModel.attendanceCalendar.attendances.forEach((_attendance) {
    DateTime date = DateTime.parse(_attendance.date);
    final DateTime startTime =
        DateTime(date.year, date.month, date.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting(
      _attendance.status,
      startTime,
      endTime,
      HexColor(_attendance.color),
      true,
    ));
  });

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
