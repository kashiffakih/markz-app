import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/auth_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';

class PhotoPickerWidget extends StatefulWidget {
  @override
  State<PhotoPickerWidget> createState() => _PhotoPickerWidgetState();
}

class _PhotoPickerWidgetState extends State<PhotoPickerWidget> {
  final ImagePicker _picker = ImagePicker();
  ConfigModel _configModel = locator<ConfigModel>();
  File? _profileImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load the profile image from ConfigModel when the widget is first created
    _loadProfileImage();
  }

  void _loadProfileImage() {
    // Check if there's a locally stored profile image in ConfigModel
    if (File(_configModel.selectedImage).existsSync()) {
      setState(() {
        _profileImage = File(_configModel.selectedImage);
      });
    }
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    setState(() {
      _isLoading = true; // Show the loader when picking an image
    });

    try {
      // Pick the image from the specified source (gallery or camera)
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        final authModel = Provider.of<AuthModel>(context, listen: false);
        final String userId = _configModel.user!.id.toString();

        // Upload the image to the API
        await authModel.uploadImage(
          imageFile: imageFile,
          userId: userId,
        );

        // Update the profile image path in ConfigModel and locally
        _configModel.updateProfileImage(imageFile.path);

        setState(() {
          _profileImage = imageFile; // Update the profile image
        });
      }
    } catch (error) {
      debugPrint('Error uploading image: $error');
    } finally {
      setState(() {
        _isLoading = false; // Hide the loader after the process
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 90,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: CircleAvatar(
              radius: 45, // Adjust the radius for the desired size
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!) // Show locally picked image
                  : (_configModel.user!.imagepath == null
                      ? AssetImage("assets/images/user.png") as ImageProvider
                      : NetworkImage(
                          "${_configModel.apiConfig['mediaURL']}${_configModel.user?.imagepath}",
                        )),
              backgroundColor: Colors
                  .transparent, // Optional, makes the background transparent
            ),
            // Container(
            //   width: 100,
            //   height: 100,
            //   decoration: ShapeDecoration(
            //     image: DecorationImage(
            //       image: _profileImage != null
            //           ? FileImage(_profileImage!) // Show locally picked image
            //           : (_configModel.user.imagePath == null
            //           ? AssetImage(AppMedia.sampleUserPhoto) as ImageProvider
            //           : NetworkImage(
            //         "${_configModel.apiConfig['mediaURL']}${_configModel.user.imagePath}",
            //       )),
            //       fit: BoxFit.fill,
            //     ),
            //     shape: OvalBorder(),
            //   ),
            // ),
          ),
          Positioned(
            left: 64,
            top: 64,
            child: GestureDetector(
              onTap: () async => await _pickImage(context, ImageSource.camera),
              // onTap: ()  => _showImageSourceSelector(context),
              child: Container(
                width: 30,
                height: 30,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    "assets/images/user.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  void _showImageSourceSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Selfie'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(context, ImageSource.camera);
                },
              ),
              // ListTile(
              //   leading: Icon(Icons.photo_library),
              //   title: Text('Select from Gallery'),
              //   onTap: () {
              //     Navigator.of(context).pop();
              //     _pickImage(context,ImageSource.gallery);
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }
}
