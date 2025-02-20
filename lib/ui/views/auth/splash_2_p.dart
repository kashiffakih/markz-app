// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:aadab/core/providers/auth_pr.dart';
// import 'package:aadab/ui/shared/font_sh.dart';

// class Splash2Page extends StatefulWidget {
//   const Splash2Page({Key? key}) : super(key: key);

//   @override
//   State<Splash2Page> createState() => _Splash2PageState();
// }

// class _Splash2PageState extends State<Splash2Page> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.all(20),
//           height: MediaQuery.of(context).size.height,
//           decoration: BoxDecoration(
//             color: Color(0xffffffff),
//           ),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 30.0),
//                   child: SizedBox(
//                     width: 200,
//                     height: 300,
//                     child: Image.asset(
//                       'assets/images/aadab-logo.png',
//                     ),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Navigator.pushNamed(context, '/loginPage',
//                         arguments: {'role': 'Distributor'});
//                   },
//                   child: Container(
//                     width: double.infinity,
//                     height: 55,
//                     decoration: BoxDecoration(
//                       color: Color(0xff0f0f0f),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Center(
//                       child: Text(
//                         'Wholesaler',
//                         textAlign: TextAlign.center,
//                         style: MyGoogleFontStyle(
//                           fontFamily: 'Urbanist',
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                           color: Color(0xffffffff),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   width: double.infinity,
//                   height: 55,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Color(0xff000000)),
//                     color: Color(0xffffffff),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Consumer<AuthModel>(
//                     builder: (context, authModel, child) => MaterialButton(
//                       height: 55,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: new BorderRadius.circular(10)),
//                       minWidth: MediaQuery.of(context).size.width * .8,
//                       color: Colors.white,
//                       onPressed: () async {
//                         Navigator.pushNamed(context, '/loginPage',
//                             arguments: {'role': 'User'});
//                         // Navigator.pushNamed(context, '/homePage');
//                       },
//                       child: Text(
//                         'Customer',
//                         style: MyGoogleFontStyle(
//                           fontFamily: 'Urbanist',
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   width: double.infinity,
//                   height: 55,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Color(0xff000000)),
//                     color: Color(0xffffffff),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Consumer<AuthModel>(
//                     builder: (context, authModel, child) => MaterialButton(
//                       height: 55,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: new BorderRadius.circular(10)),
//                       minWidth: MediaQuery.of(context).size.width * .8,
//                       color: Colors.grey,
//                       onPressed: () async {
//                         Navigator.pushNamed(context, '/homePage');
//                       },
//                       child: Text(
//                         'Guest',
//                         style: MyGoogleFontStyle(
//                           fontFamily: 'Urbanist',
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// TEst v1
import 'package:flutter/material.dart';
import 'package:aadab/ui/shared/font_sh.dart';

class Splash2Page extends StatefulWidget {
  const Splash2Page({Key? key}) : super(key: key);

  @override
  State<Splash2Page> createState() => _Splash2PageState();
}

class _Splash2PageState extends State<Splash2Page> {
  // Define colors as constants for better maintainability
  static const Color primaryColor = Color(0xff0f0f0f);
  static const Color borderColor = Color(0xff000000);
  static const Color whiteColor = Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: screenHeight,
          color: whiteColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                SizedBox(
                  width: 200,
                  height: 300,
                  child: Image.asset(
                    'assets/images/aadab-logo.png',
                  ),
                ),
                const SizedBox(height: 30),
                // Wholesaler Button
                _buildButton(
                  context,
                  label: 'Wholesaler',
                  backgroundColor: primaryColor,
                  textColor: whiteColor,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/loginPage',
                      arguments: {'role': 'Distributor'},
                    );
                  },
                ),
                const SizedBox(height: 10),
                // Customer Button
                _buildOutlinedButton(
                  context,
                  label: 'Customer',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/loginPage',
                      arguments: {'role': 'User'},
                    );
                  },
                ),
                const SizedBox(height: 10),
                // Guest Button
                _buildOutlinedButton(
                  context,
                  label: 'Guest',
                  backgroundColor: Colors.grey,
                  onPressed: () {
                    Navigator.pushNamed(context, '/homePage');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for creating filled buttons
  Widget _buildButton(BuildContext context,
      {required String label,
      required Color backgroundColor,
      required Color textColor,
      required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: MyGoogleFontStyle(
              fontFamily: 'Urbanist',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for creating outlined buttons
  Widget _buildOutlinedButton(BuildContext context,
      {required String label,
      Color backgroundColor = whiteColor,
      required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: MaterialButton(
        height: 55,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: MyGoogleFontStyle(
            fontFamily: 'Urbanist',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: backgroundColor == whiteColor ? borderColor : Colors.black,
          ),
        ),
      ),
    );
  }
}
