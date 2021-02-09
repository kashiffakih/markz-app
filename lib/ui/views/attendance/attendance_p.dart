import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/attendance_pr.dart';
import 'package:sales_app/core/providers/device_info_pr.dart';
import 'package:sales_app/core/providers/location_pr.dart';
import 'package:sales_app/ui/shared/images_sh.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  TextEditingController _remarksController = TextEditingController();

  Map<String, dynamic> _attendanceData = {
    'id': '',
    'date': '',
    'login_time': '',
    'logout_time': '',
    'login_lat': '',
    'login_lng': '',
    'logout_lat': '',
    'logout_lng': '',
    'battery': '',
    'session_type': 'PRESENT',
    'remarks': '',
    'login_address': '',
    'logout_address': '',
  };

  bool _sessionInStatus = false;
  bool _sessionOutStatus = false;

  DateFormat timeFormat = DateFormat('hh:mm:ss');
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  punchAttendance(
      {@required AttendanceModel attendanceModel, @required String event}) {
    _attendanceData['date'] = dateFormat.format(DateTime.now());
    _attendanceData['remarks'] = _remarksController.text;
    if (event == 'LOGIN')
      attendanceModel.saveAttendance(
        attendanceData: _attendanceData,
      );
    if (event == 'LOGOUT')
      attendanceModel.updateAttendance(
        attendanceData: _attendanceData,
      );
  }

  void initalizeLocation({@required LocationModel locationModel}) {
    if (locationModel.address == null && locationModel.currentLocation != null)
      locationModel.getLocationAddress(
        latitude: locationModel.currentLocation.lat,
        longitude: locationModel.currentLocation.lng,
      );
  }

  void initalizeData({@required AttendanceModel attendanceModel}) {
    if (attendanceModel.todayAttendance != null &&
        _attendanceData['date'] == '') {
      _attendanceData['id'] = attendanceModel.todayAttendance.id;
      _attendanceData['date'] = attendanceModel.todayAttendance.date;
      _attendanceData['login_time'] =
          attendanceModel.todayAttendance.loginTime ?? '';
      _attendanceData['logout_time'] =
          attendanceModel.todayAttendance.logoutTime ?? '';
      _attendanceData['login_lat'] = attendanceModel.todayAttendance.loginLat;
      _attendanceData['login_lng'] = attendanceModel.todayAttendance.loginLng;
      _attendanceData['logout_lat'] = attendanceModel.todayAttendance.logoutLat;
      _attendanceData['logout_lng'] = attendanceModel.todayAttendance.logoutLng;
      _attendanceData['battery'] = attendanceModel.todayAttendance.battery;
      _attendanceData['session_type'] =
          attendanceModel.todayAttendance.sessionType;
      _attendanceData['remarks'] = attendanceModel.todayAttendance.remarks;
      _attendanceData['login_address'] =
          attendanceModel.todayAttendance.loginAddress;
      _attendanceData['logout_address'] =
          attendanceModel.todayAttendance.logoutAddress;

      if (attendanceModel.todayAttendance.loginTime != null) {
        _sessionInStatus = true;
      }
      if (attendanceModel.todayAttendance.logoutTime != null) {
        _sessionOutStatus = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _attendanceModel = Provider.of<AttendanceModel>(context);
    final _locationModel = Provider.of<LocationModel>(context);
    final _deviceInfoModel = Provider.of<DeviceInfoModel>(context);

    this.initalizeLocation(
      locationModel: _locationModel,
    );

    this.initalizeData(
      attendanceModel: _attendanceModel,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, '/attendanceCalendar');
                },
                child: Container(
                  height: 235,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(
                    Images.attendance,
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField(
                      decoration:
                          InputDecoration(labelText: 'Select session type'),
                      value: _attendanceData['session_type'],
                      items: _attendanceModel.sessionTypes
                          .map(
                            (_type) => DropdownMenuItem(
                              child: Text(_type),
                              value: _type,
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _attendanceData['session_type'] = value;
                        });
                      }),
                ),
              ),
              if (_locationModel.address != null)
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Current Location: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(_locationModel.address),
                        ),
                      ],
                    ),
                  ),
                ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _locationModel.address == null
                      ? Row(
                          children: [
                            Expanded(
                              child: Text('Locating Current Location...'),
                            ),
                            SizedBox(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                              height: 20,
                              width: 20,
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Session In (Time: ${_attendanceData['login_time']})',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Switch(
                                    value: _sessionInStatus,
                                    onChanged: (value) {
                                      setState(() {
                                        _sessionInStatus = true;
                                        if (_attendanceData['login_time'] ==
                                            '') {
                                          _attendanceData['login_time'] =
                                              timeFormat.format(DateTime.now());
                                          _attendanceData['login_lat'] =
                                              _locationModel
                                                  .currentLocation.lat;
                                          _attendanceData['login_lng'] =
                                              _locationModel
                                                  .currentLocation.lng;
                                          _attendanceData['login_address'] =
                                              _locationModel.address;
                                          _attendanceData['battery'] =
                                              _deviceInfoModel.batteryLevel;
                                          this.punchAttendance(
                                            attendanceModel: _attendanceModel,
                                            event: 'LOGIN',
                                          );
                                        }
                                      });
                                    }),
                              ],
                            ),
                            if (_attendanceData['login_time'] != '')
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Session Out (Time: ${_attendanceData['logout_time']})',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Switch(
                                      value: _sessionOutStatus,
                                      onChanged: (value) {
                                        setState(() {
                                          _sessionOutStatus = value;
                                          if (value) {
                                            _attendanceData['logout_time'] =
                                                timeFormat
                                                    .format(DateTime.now());
                                            _attendanceData['logout_lat'] =
                                                _locationModel
                                                    .currentLocation.lat;
                                            _attendanceData['logout_lng'] =
                                                _locationModel
                                                    .currentLocation.lng;
                                            _attendanceData['logout_address'] =
                                                _locationModel.address;
                                          } else {
                                            _attendanceData['logout_time'] = '';
                                            _attendanceData['logout_lat'] = '';
                                            _attendanceData['logout_lng'] = '';
                                            _attendanceData['logout_address'] =
                                                '';
                                            _attendanceData['battery'] =
                                                _deviceInfoModel.batteryLevel;
                                          }
                                          this.punchAttendance(
                                            attendanceModel: _attendanceModel,
                                            event: 'LOGOUT',
                                          );
                                        });
                                      }),
                                ],
                              ),
                          ],
                        ),
                ),
              ),
              Card(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Remarks',
                  ),
                  controller: _remarksController,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
