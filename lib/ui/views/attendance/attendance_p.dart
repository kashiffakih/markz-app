import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/attendance_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/device_info_pr.dart';
import 'package:sales_app/core/providers/location_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/images_sh.dart';
import 'package:sales_app/ui/widgets/take_image_w.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  bool? _locationServiceEnabled;
  LocationPermission? _locationPermission;

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
    'selfie_path': '',
    'logout_selfie_path': '',
  };

  bool _sessionInStatus = false;
  bool _sessionOutStatus = false;

  DateFormat timeFormat = DateFormat('hh:mm:ss');
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  bool _isLoginLoading = false;
  bool _isLogoutLoading = false;

  @override
  void initState() {
    initLocationService();

    super.initState();
  }

  void initLocationService() async {
    bool _response = await Geolocator.isLocationServiceEnabled();
    setState(() {
      _locationServiceEnabled = _response;
      if (_locationServiceEnabled != null && _locationServiceEnabled == false)
        return;
    });

    _locationPermission = await Geolocator.checkPermission();

    if (_locationPermission == LocationPermission.denied ||
        _locationPermission == LocationPermission.deniedForever) return;

    Provider.of<LocationModel>(context, listen: false).getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final _attendanceModel = Provider.of<AttendanceModel>(context);
    final _locationModel = Provider.of<LocationModel>(context);
    final _deviceInfoModel = Provider.of<DeviceInfoModel>(context);
    final _configModel = locator<ConfigModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attendance',
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
            child: _locationServiceEnabled == null
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _locationServiceEnabled == false
                    ? buildLocationServicePermission()
                    : (_locationPermission == LocationPermission.denied ||
                            _locationPermission ==
                                LocationPermission.deniedForever)
                        ? buildLocationPermission()
                        : buildAttendance(
                            configModel: _configModel,
                            locationModel: _locationModel,
                            attendanceModel: _attendanceModel,
                            deviceInfoModel: _deviceInfoModel,
                          ),
          ),
        ),
      ),
    );
  }

  Container buildLocationServicePermission() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Location service is disabled'),
            SizedBox(height: 10),
            RaisedButton.icon(
              onPressed: () {
                Geolocator.openLocationSettings();
              },
              icon: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
              label: Text(
                'Open Settings',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }

  Container buildLocationPermission() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Permission Denied'),
            SizedBox(height: 10),
            RaisedButton.icon(
              color: Colors.blue,
              onPressed: () async {
                if (_locationPermission == LocationPermission.deniedForever)
                  Geolocator.openAppSettings();
                if (_locationPermission == LocationPermission.denied) {
                  _locationPermission = await Geolocator.requestPermission();
                  setState(() {});
                }
                initLocationService();
              },
              label: Text(
                'Allow Location Service',
                style: TextStyle(color: Colors.white),
              ),
              icon: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  punchAttendance(
      {required AttendanceModel attendanceModel, required String event}) async {
    _attendanceData['date'] = dateFormat.format(DateTime.now());
    _attendanceData['remarks'] = _remarksController.text;
    late BuildContext dialogContext;
    if (event == 'LOGIN') {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          dialogContext = context;
          return AlertDialog(
            title: Text('Saving attendance...'),
          );
        },
      );
      await attendanceModel.saveAttendance(
        attendanceData: _attendanceData,
      );
      Navigator.pop(dialogContext);
    }

    if (event == 'LOGOUT') {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          dialogContext = context;
          return AlertDialog(
            title: Text('Saving attendance...'),
          );
        },
      );
      await attendanceModel.updateAttendance(
        attendanceData: _attendanceData,
      );
      Navigator.pop(dialogContext);
    }
  }

  void initalizeLocation({required LocationModel locationModel}) {
    if (locationModel.address == '' &&
        locationModel.currentLocation.lat != null)
      locationModel.getLocationAddress(
        latitude: locationModel.currentLocation.lat,
        longitude: locationModel.currentLocation.lng,
      );
  }

  void initalizeData({required AttendanceModel attendanceModel}) {
    if (attendanceModel.todayAttendance != null &&
        attendanceModel.todayAttendance?.id != null &&
        _attendanceData['date'] == '') {
      //   if (attendanceModel.todayAttendance.id != null &&
      // _attendanceData['date'] == '') {
      _attendanceData['id'] = attendanceModel.todayAttendance?.id;
      _attendanceData['date'] = attendanceModel.todayAttendance?.date;
      _attendanceData['login_time'] =
          attendanceModel.todayAttendance?.loginTime ?? '';
      _attendanceData['logout_time'] =
          attendanceModel.todayAttendance?.logoutTime ?? '';
      _attendanceData['login_lat'] = attendanceModel.todayAttendance?.loginLat;
      _attendanceData['login_lng'] = attendanceModel.todayAttendance?.loginLng;
      _attendanceData['logout_lat'] =
          attendanceModel.todayAttendance?.logoutLat;
      _attendanceData['logout_lng'] =
          attendanceModel.todayAttendance?.logoutLng;
      _attendanceData['battery'] = attendanceModel.todayAttendance?.battery;
      _attendanceData['session_type'] =
          attendanceModel.todayAttendance?.sessionType;
      _attendanceData['remarks'] = attendanceModel.todayAttendance?.remarks;
      _attendanceData['login_address'] =
          attendanceModel.todayAttendance?.loginAddress;
      _attendanceData['logout_address'] =
          attendanceModel.todayAttendance?.logoutAddress;
      _attendanceData['selfie_path'] =
          attendanceModel.todayAttendance?.selfiePath;
      _attendanceData['logout_selfie_path'] =
          attendanceModel.todayAttendance?.logoutSelfiePath;

      if (attendanceModel.todayAttendance?.loginTime != null) {
        _sessionInStatus = true;
      }
      if (attendanceModel.todayAttendance?.logoutTime != null) {
        _sessionOutStatus = true;
      }
    }
  }

  buildAttendance(
      {required ConfigModel configModel,
      required LocationModel locationModel,
      required AttendanceModel attendanceModel,
      required DeviceInfoModel deviceInfoModel}) {
    this.initalizeLocation(
      locationModel: locationModel,
    );

    this.initalizeData(
      attendanceModel: attendanceModel,
    );

    print(12345);

    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/attendanceCalendar');
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
          color: Color.fromRGBO(255, 255, 255, 0.6),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  dateFormat.format(DateTime.now()).toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  configModel.user.email! +
                      (configModel.user.baName != null
                          ? ' | ' + configModel.user.baName.toString()
                          : ''),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          color: Color.fromRGBO(255, 255, 255, 0.6),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Select session type'),
                value: _attendanceData['session_type'],
                items: attendanceModel.sessionTypes
                    .map(
                      (_type) => DropdownMenuItem(
                        child: Text(
                          _type,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
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
        if (locationModel.address != '')
          Card(
            color: Color.fromRGBO(255, 255, 255, 0.6),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Current Location: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      locationModel.address,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        Card(
          color: Color.fromRGBO(255, 255, 255, 0.6),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: locationModel.address == '' &&
                    attendanceModel.isTodayAttendanceReceived == false
                ? Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Locating Current Location...',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
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
                      if (_attendanceData['session_type'] != 'WEEKLY OFF' &&
                          _attendanceData['session_type'] != 'HOLIDAY' &&
                          _attendanceData['session_type'] != 'MARKET CLOSED' &&
                          _attendanceData['session_type'] != 'WORK FROM HOME')
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Take Selfie',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TakeImageWidget(imagePath: ''),
                            ),
                          ],
                        ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Session In (Time: ${_attendanceData['login_time']})',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          // if (_attendanceData['selfie_path'] != '')
                          //   if (_attendanceData['selfie_path'] == null)
                          //     Padding(
                          //       padding: EdgeInsets.only(
                          //         top: 8.0,
                          //         right: 8.0,
                          //         bottom: 8.0,
                          //       ),
                          //       child: CircleAvatar(
                          //         radius: 20,
                          //         backgroundImage: AssetImage(Images.product),
                          //       ),
                          //     ),
                          if (_attendanceData['selfie_path'] != null &&
                              _attendanceData['selfie_path'] != '')
                            Padding(
                              padding: EdgeInsets.only(
                                top: 8.0,
                                right: 8.0,
                                bottom: 8.0,
                              ),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  configModel.apiConfig['mediaURL'] +
                                      _attendanceData['selfie_path'],
                                ),
                              ),
                            ),
                          // if (configModel.file.file != null ||
                          //     _attendanceData['session_type'] == 'WEEKLY OFF')
                          Switch(
                              value: _sessionInStatus,
                              onChanged: (value) {
                                print('File');
                                print(configModel.file.file);
                                print('File Name');
                                print(configModel.file.fileName);
                                if (configModel.file.file == null &&
                                    _attendanceData['session_type'] !=
                                        'WEEKLY OFF' &&
                                    _attendanceData['session_type'] !=
                                        'HOLIDAY' &&
                                    _attendanceData['session_type'] !=
                                        'MARKET CLOSED' &&
                                    _attendanceData['session_type'] !=
                                        'WORK FROM HOME') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: Text(
                                        'Please add selfie',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      actions: [
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'OK',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    _sessionInStatus = true;
                                    if (_attendanceData['login_time'] == '') {
                                      _attendanceData['login_time'] =
                                          timeFormat.format(DateTime.now());
                                      _attendanceData['login_lat'] =
                                          locationModel.currentLocation.lat;
                                      _attendanceData['login_lng'] =
                                          locationModel.currentLocation.lng;
                                      _attendanceData['login_address'] =
                                          locationModel.address;
                                      // _attendanceData['battery'] =
                                      //     deviceInfoModel.batteryLevel;

                                      this.punchAttendance(
                                        attendanceModel: attendanceModel,
                                        event: 'LOGIN',
                                      );
                                    }
                                  });
                                }
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
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            // if (_attendanceData['logout_selfie_path'] != null &&
                            //     _attendanceData['logout_selfie_path'] != '')
                            //   if (_attendanceData['logout_selfie_path'] == null)
                            //     Padding(
                            //       padding: EdgeInsets.only(
                            //         top: 8.0,
                            //         right: 8.0,
                            //         bottom: 8.0,
                            //       ),
                            //       child: CircleAvatar(
                            //         radius: 20,
                            //         backgroundImage: AssetImage(Images.product),
                            //       ),
                            //     ),
                            if (_attendanceData['logout_selfie_path'] != null &&
                                _attendanceData['logout_selfie_path'] != '')
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 8.0,
                                  right: 8.0,
                                  bottom: 8.0,
                                ),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                    configModel.apiConfig['mediaURL'] +
                                        _attendanceData['logout_selfie_path'],
                                  ),
                                ),
                              ),
                            Switch(
                                value: _sessionOutStatus,
                                onChanged: (value) {
                                  if (configModel.file.fileName == null &&
                                      _attendanceData['session_type'] !=
                                          'WEEKLY OFF' &&
                                      _attendanceData['session_type'] !=
                                          'HOLIDAY' &&
                                      _attendanceData['session_type'] !=
                                          'MARKET CLOSED' &&
                                      _attendanceData['session_type'] !=
                                          'WORK FROM HOME') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: Text(
                                          'Please add selfie',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        actions: [
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'OK',
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      _sessionOutStatus = value;
                                      if (value) {
                                        _attendanceData['logout_time'] =
                                            timeFormat.format(DateTime.now());
                                        _attendanceData['logout_lat'] =
                                            locationModel.currentLocation.lat;
                                        _attendanceData['logout_lng'] =
                                            locationModel.currentLocation.lng;
                                        _attendanceData['logout_address'] =
                                            locationModel.address;
                                      } else {
                                        _attendanceData['logout_time'] = '';
                                        _attendanceData['logout_lat'] = '';
                                        _attendanceData['logout_lng'] = '';
                                        _attendanceData['logout_address'] = '';
                                        // _attendanceData['battery'] =
                                        //     deviceInfoModel.batteryLevel;
                                      }
                                      this.punchAttendance(
                                        attendanceModel: attendanceModel,
                                        event: 'LOGOUT',
                                      );
                                    });
                                  }
                                }),
                          ],
                        ),
                    ],
                  ),
          ),
        ),
        // Card(
        //   child: TextFormField(
        //     decoration: InputDecoration(
        //       labelText: 'Remarks',
        //     ),
        //     controller: _remarksController,
        //     maxLines: 3,
        //   ),
        // ),
      ],
    );
  }
}
