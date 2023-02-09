import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/profile.dart';
import 'package:sales_app/core/providers/location_pr.dart';
import 'package:sales_app/core/providers/profiles_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/images_sh.dart';
import 'package:sales_app/core/providers/config_pr.dart';

class ProfileIdPage extends StatefulWidget {
  final arguments; // profile

  ProfileIdPage({@required this.arguments});

  @override
  State<ProfileIdPage> createState() => _ProfileIdPageState();
}

class _ProfileIdPageState extends State<ProfileIdPage> {
  bool _isFollowUpLoading = false;

  late Profile _profile;

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  List<Map<String, dynamic>> _profileData = [];

  late ProfileFollowUps _profileFollowUp;
  DateTime nextMeetingDate = DateTime.now();

  List<String> _visitCall = [
    'VISIT',
    'CALL',
  ];

  List<String> _visitStatus = [
    'General Meeting',
    'Deal followup',
  ];

  bool isLocatingLocation = false;

  @override
  void initState() {
    setState(() {
      _profileFollowUp = ProfileFollowUps(
        profileId: widget.arguments['profile'].id,
        remarks: '',
        nextMeetingDate: '',
        visitCall: 'VISIT',
        status: 'General Meeting',
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _profileModel = Provider.of<ProfilesModel>(context);
    final _configModel = locator<ConfigModel>();

    _profileModel.profiles.forEach((p) {
      if (p.id == widget.arguments['profile'].id) {
        _profile = p;
        _profileData = [];
        _profileData.add({'name': 'Date', 'value': _profile.date});
        _profileData.add({'name': 'Type', 'value': _profile.visitCall});
        _profileData
            .add({'name': 'Mobile 1', 'value': _profile.mobile1.toString()});
        _profileData
            .add({'name': 'Email 1', 'value': _profile.email1.toString()});
        _profileData
            .add({'name': 'Company', 'value': _profile.companyName ?? ''});
        _profileData
            .add({'name': 'Industry', 'value': _profile.industry ?? ''});
        _profileData.add({
          'name': 'Employee Size',
          'value': (_profile.employeeSize != null
              ? _profile.employeeSize.toString()
              : '')
        });
        _profileData
            .add({'name': 'Turnover', 'value': _profile.turnover ?? ''});
        _profileData
            .add({'name': 'Head office', 'value': _profile.headOffice ?? ''});
        _profileData.add({'name': 'Address', 'value': _profile.address ?? ''});
        _profileData.add({'name': 'Website', 'value': _profile.website ?? ''});
        _profileData.add(
            {'name': 'Contact 1 Name', 'value': _profile.contact1Name ?? ''});
        _profileData.add({
          'name': 'Contact 1 Mobile',
          'value': (_profile.contact1Mobile != null
              ? _profile.contact1Mobile.toString()
              : '')
        });
        _profileData.add(
            {'name': 'Contact 1 Email', 'value': _profile.contact1Email ?? ''});
        _profileData.add(
            {'name': 'Contact 2 Name', 'value': _profile.contact2Name ?? ''});
        _profileData.add({
          'name': 'Contact 2 Mobile',
          'value': (_profile.contact2Mobile != null
              ? _profile.contact2Mobile.toString()
              : '')
        });
        _profileData.add(
            {'name': 'Contact 2 Email', 'value': _profile.contact2Email ?? ''});
        _profileData.add(
            {'name': 'Contact 3 Name', 'value': _profile.contact3Name ?? ''});
        _profileData.add({
          'name': 'Contact 3 Mobile',
          'value': (_profile.contact3Mobile != null
              ? _profile.contact3Mobile.toString()
              : '')
        });
        _profileData.add(
            {'name': 'Contact 3 Email', 'value': _profile.contact3Email ?? ''});
        _profileData.add(
            {'name': 'Contact 4 Name', 'value': _profile.contact4Name ?? ''});
        _profileData.add({
          'name': 'Contact 4 Mobile',
          'value': (_profile.contact4Mobile != null
              ? _profile.contact4Mobile.toString()
              : '')
        });
        _profileData.add(
            {'name': 'Contact 4 Email', 'value': _profile.contact4Email ?? ''});
        _profileData.add(
            {'name': 'Contact 5 Name', 'value': _profile.contact5Name ?? ''});
        _profileData.add({
          'name': 'Contact 5 Mobile',
          'value': (_profile.contact5Mobile != null
              ? _profile.contact5Mobile.toString()
              : '')
        });
        _profileData.add(
            {'name': 'Contact 5 Email', 'value': _profile.contact5Email ?? ''});
        _profileData.add({
          'name': 'Product Offered',
          'value': _profile.productOffered ?? ''
        });
        _profileData.add({'name': 'Terms', 'value': _profile.terms ?? ''});
        _profileData.add({'name': 'Remarks', 'value': _profile.remarks ?? ''});
        _profileData
            .add({'name': 'Deal Date', 'value': _profile.dealDate ?? ''});
        _profileData.add(
            {'name': 'Agreement Date', 'value': _profile.agreementDate ?? ''});
        _profileData.add({
          'name': 'Next Meeting Date',
          'value': _profile.nextMeetingDate ?? ''
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile ID - ' + _profile.id.toString()),
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
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Card(
                color: Color.fromRGBO(255, 255, 255, 0.6),
                elevation: 7,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Followups',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          FloatingActionButton.small(
                            elevation: 5.0,
                            child: new Icon(Icons.add),
                            backgroundColor: new Color(0xFFE57373),
                            onPressed: () =>
                                addNextMeeting(context, _profileModel),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Card(
                          elevation: 8,
                          child: Column(children: [
                            Container(
                              color: Theme.of(context).primaryColor,
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Sr.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Description',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Next Meeting',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ..._profile.profileFollowUps!
                                .map(
                                  (_profileFollowUp) => Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                (_profile.profileFollowUps!
                                                            .indexOf(
                                                                _profileFollowUp) +
                                                        1)
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _profileFollowUp.remarks!,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                dateFormat.format(
                                                    DateTime.parse(
                                                        _profileFollowUp
                                                            .nextMeetingDate!
                                                            .toString())),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList()
                          ]),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/profileCreate',
                                arguments: {
                                  'profile': _profile,
                                });
                          },
                          child: Text('Edit')),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Photo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (_profile.photo1Path != null)
                            Container(
                              height: 50,
                              width: 50,
                              child: Image.network(
                                _configModel.apiConfig['mediaURL'] +
                                    _profile.photo1Path,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ..._profileData
                          .map(
                            (pD) => Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        pD['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      pD['value'],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectNextMeetingDate(
      BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: nextMeetingDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != nextMeetingDate) {
      setState(() {
        nextMeetingDate = picked;
      });
    }
  }

  addNextMeeting(BuildContext context, ProfilesModel _profileModel) {
    final _locationModel = Provider.of<LocationModel>(context, listen: false);
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Followup:'),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              label: Text('Enter description'),
                            ),
                            maxLines: 2,
                            onChanged: (value) {
                              _profileFollowUp.remarks = value;
                            },
                            onSaved: (value) {
                              _profileFollowUp.remarks = value;
                            },
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: 'Select visit/call',
                            ),
                            value: _profileFollowUp.visitCall,
                            items: _visitCall
                                .map(
                                  (_visitCall) => DropdownMenuItem(
                                    value: _visitCall,
                                    child: Text(_visitCall),
                                  ),
                                )
                                .toList(),
                            validator: (value) {
                              if (value == null)
                                return 'Please select visit/call';
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                if (value != null)
                                  _profileFollowUp.visitCall = value.toString();
                              });
                            },
                            onSaved: (value) {
                              if (value != null)
                                _profileFollowUp.visitCall = value.toString();
                            },
                          ),
                          // Mark In & Mark Out
                          if (_profileFollowUp.visitCall == 'VISIT')
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              isLocatingLocation = true;
                                            });
                                            await Provider.of<LocationModel>(
                                                    context,
                                                    listen: false)
                                                .getCurrentLocation();
                                            _locationModel.getLocationAddress(
                                              latitude: _locationModel
                                                  .currentLocation.lat,
                                              longitude: _locationModel
                                                  .currentLocation.lng,
                                            );
                                            setState(() {
                                              isLocatingLocation = false;
                                            });
                                          },
                                          child: Text('Mark In'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              isLocatingLocation = true;
                                            });
                                            await Provider.of<LocationModel>(
                                                    context,
                                                    listen: false)
                                                .getCurrentLocation();
                                            _locationModel.getLocationAddress(
                                              latitude: _locationModel
                                                  .currentLocation.lat,
                                              longitude: _locationModel
                                                  .currentLocation.lng,
                                            );
                                            setState(() {
                                              isLocatingLocation = false;
                                            });
                                          },
                                          child: Text('Mark Out'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (isLocatingLocation)
                                  Text('Locating Location...'),
                                if (_locationModel.address != '')
                                  Text(_locationModel.address),
                              ],
                            ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: 'Select status',
                            ),
                            value: _profileFollowUp.status,
                            items: _visitStatus
                                .map(
                                  (_vS) => DropdownMenuItem(
                                    value: _vS,
                                    child: Text(_vS),
                                  ),
                                )
                                .toList(),
                            validator: (value) {
                              if (value == null) return 'Please select status';
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                if (value != null)
                                  _profileFollowUp.status = value.toString();
                              });
                            },
                            onSaved: (value) {
                              if (value != null)
                                _profileFollowUp.status = value.toString();
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Next Meeting Date',
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Date: ' +
                                      dateFormat.format(
                                        DateTime.parse(
                                            nextMeetingDate.toString()),
                                      ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    _selectNextMeetingDate(context, setState),
                                child: Text('Date'),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                );
              }),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                _isFollowUpLoading
                    ? Text('Saving Data...')
                    : FlatButton(
                        onPressed: () async {
                          _profileFollowUp.nextMeetingDate =
                              nextMeetingDate.toString();
                          print(_profileFollowUp.nextMeetingDate);
                          if (_profileFollowUp.remarks == '' ||
                              _profileFollowUp.nextMeetingDate == '') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text('Please enter all the details'),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Ok'))
                                ],
                              ),
                            );
                            return;
                          }
                          setState(() {
                            _isFollowUpLoading = true;
                          });

                          // if (_configModel.file == null) {
                          //   showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) =>
                          //         AlertDialog(
                          //       title: Text('Please upload image'),
                          //       actions: [
                          //         FlatButton(
                          //           onPressed: () {
                          //             Navigator.pop(context);
                          //           },
                          //           child: Text('Ok'),
                          //         ),
                          //       ],
                          //     ),
                          //   );
                          // } else
                          await _profileModel.profileFollowupCreate(
                              profile: _profile,
                              profileFollowup: _profileFollowUp);

                          _profileModel.getProfiles();

                          Navigator.pop(context);

                          setState(() {
                            _isFollowUpLoading = false;
                          });
                        },
                        child: Text(
                          'Add Profile followup',
                        ),
                      ),
              ],
            ));
  }
}
