import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/user.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/core/providers/profile_pr.dart';
import 'package:sales_app/core/services/profile_s.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';
import 'package:sales_app/ui/shared/images_sh.dart';
import 'package:sales_app/ui/widgets/take_image_w.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ConfigModel _configModel = locator<ConfigModel>();
  final ProfileService _profileService = ProfileService();

  DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

  GlobalKey<FormState> _userKey = GlobalKey<FormState>();
  TextEditingController _otpController = TextEditingController();

  bool _loading = false;

  alert() {
    if (_configModel.user.imagePath == null)
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Please upload photo'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Ok'),
            ),
          ],
        ),
      );
    if (_configModel.user.phone == 0)
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Please enter your phone no'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Ok'),
            ),
          ],
        ),
      );
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () => alert());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = _configModel.user;

    Random random = new Random();
    int otp = random.nextInt(99999) + 100000;

    final ProfileModel _profileModel = Provider.of<ProfileModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Column(
                  children: [
                    if (_configModel.user.imagePath != null)
                      InkWell(
                        onTap: () {},
                        child: Hero(
                          tag: '123',
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(
                              _configModel.apiConfig['mediaURL'] +
                                  _configModel.user.imagePath,
                            ),
                          ),
                        ),
                      ),
                    if (_configModel.user.imagePath == null)
                      InkWell(
                        onTap: () {},
                        child: Hero(
                          tag: '123',
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: AssetImage(Images.avatar),
                          ),
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: TakeImageWidget(imagePath: ''),
                        ),
                        Expanded(
                          flex: 2,
                          child: FlatButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              if (_configModel.file == null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: Text('Please upload image'),
                                    actions: [
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Ok'),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                _profileModel.addProfileImage();
                                // _profileService.addProfileImage();
                              }
                            },
                            child: Text(
                              'Upload photo',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: Font.primaryFont),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Form(
                      key: _userKey,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Enter name',
                              ),
                              enabled: false,
                              initialValue: user.name,
                              validator: (value) {
                                if (value!.isEmpty) return 'Please enter name';
                                return null;
                              },
                              onSaved: (value) {
                                user.name = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Enter email',
                              ),
                              enabled: false,
                              initialValue: user.email,
                              validator: (value) {
                                if (value!.isEmpty) return 'Please enter email';
                                return null;
                              },
                              onSaved: (value) {
                                user.email = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Enter phone',
                              ),
                              enabled: false,
                              keyboardType: TextInputType.number,
                              initialValue: user.phone.toString(),
                              validator: (value) {
                                if (value!.isEmpty) return 'Please enter phone';
                                return null;
                              },
                              onSaved: (value) {
                                user.phone = int.parse(value.toString());
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // RaisedButton(
                            //   color: Theme.of(context).primaryColor,
                            //   onPressed: () {
                            //     if (_userKey.currentState.validate()) {
                            //       _userKey.currentState.save();
                            //       _profileService.sendOTP(
                            //         otp: otp,
                            //       );
                            //       showDialog(
                            //         context: context,
                            //         builder: (BuildContext context) =>
                            //             AlertDialog(
                            //           title: Column(
                            //             children: [
                            //               Text('Please enter otp'),
                            //               TextFormField(
                            //                 decoration: InputDecoration(
                            //                   labelText: 'Enter otp',
                            //                 ),
                            //                 controller: _otpController,
                            //               ),
                            //             ],
                            //           ),
                            //           actions: [
                            //             FlatButton(
                            //               onPressed: () async {
                            //                 if (_otpController.text ==
                            //                     otp.toString()) {
                            //                   setState(() {
                            //                     _loading = true;
                            //                   });
                            //                   await _profileService
                            //                       .updateProfile(
                            //                     userData: user,
                            //                   );
                            //                   setState(() {
                            //                     _loading = false;
                            //                   });
                            //                   Navigator.pop(context);
                            //                   Navigator.pushReplacementNamed(
                            //                     context,
                            //                     '/home',
                            //                   );
                            //                 } else {
                            //                   showDialog(
                            //                     context: context,
                            //                     builder:
                            //                         (BuildContext context) =>
                            //                             AlertDialog(
                            //                       title: Text('Incorrect OTP'),
                            //                       actions: [
                            //                         FlatButton(
                            //                           onPressed: () {
                            //                             Navigator.pop(context);
                            //                           },
                            //                           child: Text('Ok'),
                            //                         )
                            //                       ],
                            //                     ),
                            //                   );
                            //                 }
                            //               },
                            //               child: _loading
                            //                   ? CircularProgressIndicator()
                            //                   : Text('Save'),
                            //             ),
                            //             FlatButton(
                            //               onPressed: () {
                            //                 Navigator.pop(context);
                            //               },
                            //               child: Text('Cancel'),
                            //             ),
                            //           ],
                            //         ),
                            //       );
                            //     }
                            //   },
                            //   child: Text(
                            //     'Update',
                            //     style: TextStyle(
                            //         color: Colors.white,
                            //         fontFamily: Font.primaryFont),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.orange,
                              ),
                              child: Text(
                                'Employee Code',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.cyan,
                              ),
                              child: Text(
                                user.employeeCode ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.orange,
                              ),
                              child: Text(
                                'Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.cyan,
                              ),
                              child: Text(
                                user.name.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.orange,
                              ),
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.cyan,
                              ),
                              child: Text(
                                user.email.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.orange,
                              ),
                              child: Text(
                                'Phone',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.cyan,
                              ),
                              child: Text(
                                user.phone.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.orange,
                              ),
                              child: Text(
                                'Address',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  color: Colors.cyan,
                                ),
                                child: Text(
                                  user.address ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.orange,
                              ),
                              child: Text(
                                'DOJ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.cyan,
                              ),
                              child: Text(
                                user.doj != null
                                    ? _dateFormat.format(
                                        DateTime.parse(user.doj.toString()))
                                    : '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.orange,
                              ),
                              child: Text(
                                'DOB',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.cyan,
                              ),
                              child: Text(
                                user.dob != null
                                    ? _dateFormat.format(
                                        DateTime.parse(user.dob.toString()))
                                    : '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.orange,
                              ),
                              child: Text(
                                'Designation',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  color: Colors.cyan,
                                ),
                                child: Text(
                                  user.dob != null ? 'SSM' : '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.orange,
                              ),
                              child: Text(
                                'PF No',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  color: Colors.cyan,
                                ),
                                child: Text(
                                  user.pfNo ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.orange,
                              ),
                              child: Text(
                                'UAN No',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  color: Colors.cyan,
                                ),
                                child: Text(
                                  user.uanNo ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.orange,
                              ),
                              child: Text(
                                'ESI No',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  color: Colors.cyan,
                                ),
                                child: Text(
                                  user.esiNo ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.orange,
                              ),
                              child: Text(
                                'UID No',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  color: Colors.cyan,
                                ),
                                child: Text(
                                  user.uidNo ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
