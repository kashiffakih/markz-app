import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/models/user.dart';
import 'package:sales_app/core/providers/auth_pr.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class SettingUpdatePage extends StatefulWidget {
  final arguments;
  const SettingUpdatePage({Key? key, required this.arguments})
      : super(key: key);

  @override
  State<SettingUpdatePage> createState() => _SettingUpdatePageState();
}

class _SettingUpdatePageState extends State<SettingUpdatePage> {
  File? galleryFile;
  final picker = ImagePicker();
  User _user = User();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _user = widget.arguments['user'];
  }

  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    AuthModel _userModel = Provider.of<AuthModel>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                // Title
                Container(
                  margin: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Container(
                              child: Image.asset(
                                'assets/images/vector-GJ4.png',
                                height: 15,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Update Personal Information',
                                textAlign: TextAlign.center,
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1e232c),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Body
                Container(
                  padding: EdgeInsets.all(15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Full Name
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xffe3e3e3)),
                            color: Color(0xfffbfbfb),
                          ),
                          child: TextFormField(
                            initialValue: _user.firstName,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(9, 6, 1, 5),
                              hintText: 'Full name',
                              hintStyle: TextStyle(color: Color(0x3f000000)),
                            ),
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Full name Cannot be empty.";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _user.firstName = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // Address
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xffe3e3e3)),
                            color: Color(0xfffbfbfb),
                          ),
                          child: TextFormField(
                            initialValue: _user.phone.toString(),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(9, 6, 1, 5),
                              hintText: 'Phone',
                              hintStyle: TextStyle(color: Color(0x3f000000)),
                            ),
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                              color: Color(0xff000000),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Phone Cannot be empty.";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _user.phone = int.parse(value.toString());
                            },
                          ),
                        ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // Center(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       ElevatedButton(
                        //         style: ButtonStyle(
                        //             backgroundColor: MaterialStateProperty.all(
                        //                 Colors.green)),
                        //         child: const Text(
                        //             'Select Image from Gallery and Camera'),
                        //         onPressed: () {
                        //           _showPicker(context: context);
                        //         },
                        //       ),
                        //       const SizedBox(
                        //         height: 20,
                        //       ),
                        //       SizedBox(
                        //         height: 200.0,
                        //         width: 300.0,
                        //         child: galleryFile == null
                        //             ? const Center(
                        //                 child: Text('Sorry nothing selected!!'))
                        //             : Center(child: Image.file(galleryFile!)),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                        // Save address
                        Container(
                          // primaryXwC (318:2628)
                          margin: EdgeInsets.fromLTRB(5, 0, 6.34, 0),
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                setState(() {
                                  _loading = true;
                                });
                                // print(galleryFile.toString());
                                // _user.imagepath =
                                //     galleryFile.toString() != 'null'
                                //         ? galleryFile.toString().split('/').last
                                //         : '';
                                bool response = await _userModel.register(
                                    registerData: _user.toJson());
                                if (response == true) {
                                  Navigator.pushNamed(context, '/settingsPage');
                                }
                                setState(() {
                                  _loading = false;
                                });
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 53,
                              decoration: BoxDecoration(
                                color: Color(0xff1e1e1e),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: _loading
                                    ? SizedBox(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                        ),
                                        height: 20,
                                        width: 20,
                                      )
                                    : Text(
                                        'Update Personal information',
                                        textAlign: TextAlign.center,
                                        style: MyGoogleFontStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 15.1428556442,
                                          fontWeight: FontWeight.w700,
                                          height: 1.4999999685,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
}
