import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/profile.dart';
import 'package:sales_app/core/providers/location_pr.dart';
import 'package:sales_app/core/providers/profiles_pr.dart';
import 'package:sales_app/ui/shared/images_sh.dart';
import 'package:sales_app/ui/widgets/take_image_w.dart';

class ProfileCreatePage extends StatefulWidget {
  final arguments; // profile

  ProfileCreatePage({@required this.arguments});

  @override
  State<ProfileCreatePage> createState() => _ProfileCreatePageState();
}

class _ProfileCreatePageState extends State<ProfileCreatePage> {
  bool _isLoading = false;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  List<String> _visitCalls = [
    'VISIT',
    'CALL',
  ];

  List<String> _industries = [
    'BPO / KPO',
    'IT Services',
    'BFSI',
    'Education / E-Learning'
  ];

  List<String> _products = [
    'Contractual staffing',
    'Permanent Staffing',
    'App based Services',
  ];

  Profile _profile = Profile();

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  DateTime? date;
  DateTime? dealDate;
  DateTime? agreementDate;
  DateTime? nextMeetingDate;

  bool isDataUpdatedIfEditing = false;

  @override
  void initState() {
    super.initState();
  }

  bool? _locationServiceEnabled;
  LocationPermission? _locationPermission;
  bool isLocatingLocation = false;

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
  }

  @override
  Widget build(BuildContext context) {
    final _profileModel = Provider.of<ProfilesModel>(context);
    final _locationModel = Provider.of<LocationModel>(context);
    _profile.date = dateFormat.format(DateTime.now());

    if (widget.arguments != null) {
      if (widget.arguments['profile'] != null) {
        setState(() {
          if (!isDataUpdatedIfEditing) {
            _profile = widget.arguments['profile'];
            print(_profile.toJson());
            if (_profile.date != null)
              date = DateTime.parse(_profile.date.toString());
            if (_profile.dealDate != null)
              dealDate = DateTime.parse(_profile.dealDate.toString());
            if (_profile.agreementDate != null)
              agreementDate = DateTime.parse(_profile.agreementDate.toString());
            if (_profile.nextMeetingDate != null)
              nextMeetingDate =
                  DateTime.parse(_profile.nextMeetingDate.toString());
            isDataUpdatedIfEditing = true;
          }
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: _profile.id != null
            ? Text('Update Profile: ' + _profile.id.toString())
            : Text('Add new Profile'),
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
                child: Form(
                  key: _key,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Date: ' +
                                    (date != null
                                        ? dateFormat.format(
                                            DateTime.parse(date.toString()))
                                        : ''),
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _selectDate(context, setState),
                              child: Text('Select Date'),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: 'Select visit/call',
                          ),
                          value: _profile.visitCall,
                          items: _visitCalls
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
                                _profile.visitCall = value.toString();
                            });
                          },
                          onSaved: (value) {
                            if (value != null)
                              _profile.visitCall = value.toString();
                          },
                        ),
                        // Mark In & Mark Out
                        if (_profile.visitCall == 'VISIT')
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
                                          _profile.markInLat = _locationModel
                                              .currentLocation.lat;
                                          _profile.markInLng = _locationModel
                                              .currentLocation.lng;
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
                                          _profile.markOutLat = _locationModel
                                              .currentLocation.lat;
                                          _profile.markOutLng = _locationModel
                                              .currentLocation.lng;
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
                        // Mobile 1
                        TextFormField(
                          initialValue: _profile.mobile1 != null
                              ? _profile.mobile1.toString()
                              : '',
                          decoration: InputDecoration(labelText: 'Mobile 1'),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(11),
                          ],
                          validator: (value) {
                            if (value == null) return 'Please enter mobile 1';
                            return null;
                          },
                          onChanged: (value) {
                            _profile.mobile1 = int.parse(value.toString());
                          },
                          onSaved: (value) {
                            _profile.mobile1 = int.parse(value.toString());
                          },
                        ),
                        // Email 1
                        TextFormField(
                          initialValue: _profile.email1 != null
                              ? _profile.email1.toString()
                              : '',
                          decoration: InputDecoration(labelText: 'Email 1'),
                          validator: (value) {
                            if (value == null) return 'Please enter email 1';
                            return null;
                          },
                          onChanged: (value) {
                            _profile.email1 = value;
                          },
                          onSaved: (value) {
                            _profile.email1 = value;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text('Photo'),
                            ),
                            TakeImageWidget(imagePath: ''),
                          ],
                        ),
                        // Company Name
                        TextFormField(
                          initialValue: _profile.companyName,
                          decoration:
                              InputDecoration(labelText: 'Company Name'),
                          onSaved: (value) {
                            _profile.companyName = value;
                          },
                        ),
                        // Industry Name
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: 'Select industry',
                          ),
                          value: _profile.industry,
                          items: _industries
                              .map(
                                (_industry) => DropdownMenuItem(
                                  value: _industry,
                                  child: Text(_industry),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null)
                              _profile.industry = value.toString();
                          },
                          onSaved: (value) {
                            if (value != null)
                              _profile.industry = value.toString();
                          },
                        ),
                        // Employee Size
                        TextFormField(
                          initialValue: _profile.employeeSize != null
                              ? _profile.employeeSize.toString()
                              : null,
                          decoration:
                              InputDecoration(labelText: 'Employee Size'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            if (value != null && value != '')
                              _profile.employeeSize =
                                  int.parse(value.toString());
                          },
                        ),
                        // Turnover
                        TextFormField(
                          initialValue: _profile.turnover,
                          decoration:
                              InputDecoration(labelText: 'Turnover (In Cr.)'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            _profile.turnover = value;
                          },
                        ),
                        // Head office
                        TextFormField(
                          initialValue: _profile.headOffice,
                          decoration: InputDecoration(labelText: 'Head Office'),
                          onSaved: (value) {
                            _profile.headOffice = value;
                          },
                        ),
                        // Address
                        TextFormField(
                          initialValue: _profile.address,
                          decoration: InputDecoration(labelText: 'Address'),
                          onSaved: (value) {
                            _profile.address = value;
                          },
                        ),
                        // Website
                        TextFormField(
                          initialValue: _profile.website,
                          decoration: InputDecoration(labelText: 'Website'),
                          onSaved: (value) {
                            _profile.website = value;
                          },
                        ),
                        // Contact 1 Name
                        TextFormField(
                          initialValue: _profile.contact1Name,
                          decoration:
                              InputDecoration(labelText: 'Contact 1 Name'),
                          onSaved: (value) {
                            _profile.contact1Name = value;
                          },
                        ),
                        // Contact 1 Mobile
                        TextFormField(
                          initialValue: _profile.contact1Mobile != null
                              ? _profile.contact1Mobile.toString()
                              : '',
                          decoration:
                              InputDecoration(labelText: 'Contact 1 Mobile'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            if (value != null && value != '')
                              _profile.contact1Mobile =
                                  int.parse(value.toString());
                          },
                        ),
                        // Contact 1 Email
                        TextFormField(
                          initialValue: _profile.contact1Email,
                          decoration:
                              InputDecoration(labelText: 'Contact 1 Email'),
                          onSaved: (value) {
                            _profile.contact1Email = value;
                          },
                        ),
                        // // Contact 1 Visiting Card
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Text('Contact 1 Visiting Card'),
                        //     ),
                        //     TakeImageWidget(imagePath: ''),
                        //   ],
                        // ),
                        // Contact 2 Name
                        TextFormField(
                          initialValue: _profile.contact2Name,
                          decoration:
                              InputDecoration(labelText: 'Contact 2 Name'),
                          onSaved: (value) {
                            _profile.contact2Name = value;
                          },
                        ),
                        // Contact 2 Mobile
                        TextFormField(
                          initialValue: _profile.contact2Mobile != null
                              ? _profile.contact2Mobile.toString()
                              : '',
                          decoration:
                              InputDecoration(labelText: 'Contact 2 Mobile'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            if (value != null && value != '')
                              _profile.contact2Mobile =
                                  int.parse(value.toString());
                          },
                        ),
                        // Contact 2 Email
                        TextFormField(
                          initialValue: _profile.contact2Email,
                          decoration:
                              InputDecoration(labelText: 'Contact 2 Email'),
                          onSaved: (value) {
                            _profile.contact2Email = value;
                          },
                        ),
                        // // Contact 2 Visiting Card
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Text('Contact 2 Visiting Card'),
                        //     ),
                        //     TakeImageWidget(imagePath: ''),
                        //   ],
                        // ),
                        // Contact 3 Name
                        TextFormField(
                          initialValue: _profile.contact3Name,
                          decoration:
                              InputDecoration(labelText: 'Contact 3 Name'),
                          onSaved: (value) {
                            _profile.contact3Name = value;
                          },
                        ),
                        // Contact 3 Mobile
                        TextFormField(
                          initialValue: _profile.contact3Mobile != null
                              ? _profile.contact2Mobile.toString()
                              : '',
                          decoration:
                              InputDecoration(labelText: 'Contact 3 Mobile'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            if (value != null && value != '')
                              _profile.contact3Mobile = value.toString();
                          },
                        ),
                        // Contact 3 Email
                        TextFormField(
                          initialValue: _profile.contact3Email,
                          decoration:
                              InputDecoration(labelText: 'Contact 3 Email'),
                          onSaved: (value) {
                            _profile.contact3Email = value;
                          },
                        ),
                        // // Contact 3 Visiting Card
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Text('Contact 3 Visiting Card'),
                        //     ),
                        //     TakeImageWidget(imagePath: ''),
                        //   ],
                        // ),
                        // Contact 4 Name
                        TextFormField(
                          initialValue: _profile.contact4Name,
                          decoration:
                              InputDecoration(labelText: 'Contact 4 Name'),
                          onSaved: (value) {
                            _profile.contact4Name = value;
                          },
                        ),
                        // Contact 4 Mobile
                        TextFormField(
                          initialValue: _profile.contact4Mobile != null
                              ? _profile.contact2Mobile.toString()
                              : '',
                          decoration:
                              InputDecoration(labelText: 'Contact 4 Mobile'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            if (value != null && value != '')
                              _profile.contact4Mobile = value.toString();
                          },
                        ),
                        // Contact 4 Email
                        TextFormField(
                          initialValue: _profile.contact4Email,
                          decoration:
                              InputDecoration(labelText: 'Contact 4 Email'),
                          onSaved: (value) {
                            _profile.contact4Email = value;
                          },
                        ),
                        // // Contact 4 Visiting Card
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Text('Contact 4 Visiting Card'),
                        //     ),
                        //     TakeImageWidget(imagePath: ''),
                        //   ],
                        // ),
                        // Contact 5 Name
                        TextFormField(
                          initialValue: _profile.contact5Name,
                          decoration:
                              InputDecoration(labelText: 'Contact 5 Name'),
                          onSaved: (value) {
                            _profile.contact5Name = value;
                          },
                        ),
                        // Contact 5 Mobile
                        TextFormField(
                          initialValue: _profile.contact5Mobile != null
                              ? _profile.contact2Mobile.toString()
                              : '',
                          decoration:
                              InputDecoration(labelText: 'Contact 5 Mobile'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) {
                            if (value != null && value != '')
                              _profile.contact5Mobile = value.toString();
                          },
                        ),
                        // Contact 5 Email
                        TextFormField(
                          initialValue: _profile.contact5Email,
                          decoration:
                              InputDecoration(labelText: 'Contact 5 Email'),
                          onSaved: (value) {
                            _profile.contact5Email = value;
                          },
                        ),
                        // // Contact 5 Visiting Card
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Text('Contact 5 Visiting Card'),
                        //     ),
                        //     TakeImageWidget(imagePath: ''),
                        //   ],
                        // ),
                        // Product Offered
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: 'Product Offered',
                          ),
                          value: _profile.productOffered,
                          items: _products
                              .map(
                                (_product) => DropdownMenuItem(
                                  value: _product,
                                  child: Text(_product),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              if (value != null)
                                _profile.productOffered = value.toString();
                            });
                          },
                          onSaved: (value) {
                            if (value != null)
                              _profile.productOffered = value.toString();
                          },
                        ),
                        // Contractual staffing Points
                        if (_profile.productOffered == 'Contractual staffing')
                          Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text('Service Fees'),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: _profile.serviceFees,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Amount (in ₹)'),
                                      onSaved: (value) {
                                        _profile.serviceFees = value;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text('Recruitment Fees'),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: _profile.recruitmentFees,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Amount (in ₹)'),
                                      onSaved: (value) {
                                        _profile.recruitmentFees = value;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text('On-boarding charges'),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: _profile.onboardingFees,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Amount (in ₹)'),
                                      onSaved: (value) {
                                        _profile.onboardingFees = value;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child:
                                        Text('Service fees on Reimbursement'),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue:
                                          _profile.serviceFeeOnReimbursements,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Amount (in ₹)'),
                                      onSaved: (value) {
                                        _profile.serviceFeeOnReimbursements =
                                            value;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text('Service fees on Incentive'),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue:
                                          _profile.serviceFeeOnIncentive,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Amount (in ₹)'),
                                      onSaved: (value) {
                                        _profile.serviceFeeOnIncentive = value;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child:
                                        Text('Service fees on Ad-hoc payments'),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: _profile.serviceFeeOnAdHoc,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Amount (in ₹)'),
                                      onSaved: (value) {
                                        _profile.serviceFeeOnAdHoc = value;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text('Absorption fees'),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: _profile.absorptionFee,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Amount (in ₹)'),
                                      onSaved: (value) {
                                        _profile.absorptionFee = value;
                                      },
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        // Permanent Staffing
                        if (_profile.productOffered == 'Permanent Staffing')
                          Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text('Agency Fees for Junior level'),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue:
                                          _profile.agencyFeeForJuniorLevel,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Amount (in ₹)'),
                                      onSaved: (value) {
                                        _profile.agencyFeeForJuniorLevel =
                                            value;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text('Agency Fees for Middle level'),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue:
                                          _profile.agencyFeeForMiddleLevel,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Amount (in ₹)'),
                                      onSaved: (value) {
                                        _profile.agencyFeeForMiddleLevel =
                                            value;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text('Agency Fees for Senior level'),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue:
                                          _profile.agencyFeeForSeniorLevel,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Amount (in ₹)'),
                                      onSaved: (value) {
                                        _profile.agencyFeeForSeniorLevel =
                                            value;
                                      },
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        // App based Services:
                        if (_profile.productOffered == 'App based Services')
                          Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text('Hajiri/User/Month'),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue:
                                          _profile.hajiriPerUserPerMonth,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Amount (in ₹)'),
                                      onSaved: (value) {
                                        _profile.hajiriPerUserPerMonth = value;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text('Dastavej/User/Month'),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue:
                                          _profile.dastavejPerUserPerMonth,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Amount (in ₹)'),
                                      onSaved: (value) {
                                        _profile.dastavejPerUserPerMonth =
                                            value;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text('SalesApp/User/Month'),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue:
                                          _profile.salesPerUserPerMonth,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Amount (in ₹)'),
                                      onSaved: (value) {
                                        _profile.salesPerUserPerMonth = value;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text('MerchandisingApp/User/Month'),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      initialValue:
                                          _profile.merchandisingPerUserPerMonth,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          labelText: 'Amount (in ₹)'),
                                      onSaved: (value) {
                                        _profile.merchandisingPerUserPerMonth =
                                            value;
                                      },
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        // Terms
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Terms'),
                          onSaved: (value) {
                            _profile.terms = value;
                          },
                        ),
                        // Remarks
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Remarks'),
                          onSaved: (value) {
                            _profile.remarks = value;
                          },
                        ),
                        // Deal Date
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Deal Date: ' +
                                    (dealDate != null
                                        ? dateFormat.format(
                                            DateTime.parse(dealDate.toString()))
                                        : ''),
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  _selectDealDate(context, setState),
                              child: Text('Select Date'),
                            )
                          ],
                        ),
                        // Agreement Date
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Agreement Date: ' +
                                    (agreementDate != null
                                        ? dateFormat.format(DateTime.parse(
                                            agreementDate.toString()))
                                        : ''),
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  _selectAgreementDate(context, setState),
                              child: Text('Select Date'),
                            )
                          ],
                        ),

                        // Next Meeting Date
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Next Meeting Date: ' +
                                    (nextMeetingDate != null
                                        ? dateFormat.format(DateTime.parse(
                                            nextMeetingDate.toString()))
                                        : ''),
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  _selectNextMeetingDate(context, setState),
                              child: Text('Select Date'),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _isLoading
                            ? Text('Saving Data...')
                            : ElevatedButton(
                                onPressed: () async {
                                  if (_key.currentState!.validate()) {
                                    _key.currentState!.save();
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    if (dealDate != null)
                                      _profile.dealDate =
                                          dateFormat.format(dealDate!);
                                    if (agreementDate != null)
                                      _profile.agreementDate =
                                          dateFormat.format(agreementDate!);
                                    if (nextMeetingDate != null)
                                      _profile.nextMeetingDate =
                                          dateFormat.format(nextMeetingDate!);
                                    await _profileModel.profileCreate(
                                        profile: _profile);

                                    _profileModel.getProfiles();

                                    Navigator.pop(context);

                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                },
                                child: Text(_profile.id != null
                                    ? 'Update Profile'
                                    : 'Add Profile'),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: (date != null ? date! : DateTime.now()),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  Future<void> _selectDealDate(
      BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: (dealDate != null ? dealDate! : DateTime.now()),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != dealDate) {
      setState(() {
        dealDate = picked;
      });
    }
  }

  Future<void> _selectAgreementDate(
      BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: (agreementDate != null ? agreementDate! : DateTime.now()),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != agreementDate) {
      setState(() {
        agreementDate = picked;
      });
    }
  }

  Future<void> _selectNextMeetingDate(
      BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate:
            (nextMeetingDate != null ? nextMeetingDate! : DateTime.now()),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != nextMeetingDate) {
      setState(() {
        nextMeetingDate = picked;
      });
    }
  }
}
