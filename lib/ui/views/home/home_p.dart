import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     double baseWidth = 360;
//     double fem = MediaQuery.of(context).size.width / baseWidth;
//     double ffem = fem * 0.97;
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           width: double.infinity,
//           child: Container(
//             // homedashboardLCW (318:1931)
//             padding: EdgeInsets.fromLTRB(0 * fem, 10 * fem, 0 * fem, 38 * fem),
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Color(0xffffffff),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   // autogroupeveykGE (Gb5gBLB7LhU8d64Pr5eVEY)
//                   width: double.infinity,
//                   height: 247 * fem,
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         // unsplashhcpwe1prcgfg (318:1932)
//                         left: 0 * fem,
//                         top: 67 * fem,
//                         child: Align(
//                           child: SizedBox(
//                             width: 360 * fem,
//                             height: 180 * fem,
//                             child: Image.asset(
//                               'assets/images/unsplash__HCpwe1-Prc.png',
//                               // 'assets/images/unsplash-hcpwe1-prc.png',
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         // group9021nyc (318:1933)
//                         left: 106.1574707031 * fem,
//                         top: 138.9032592773 * fem,
//                         child: Container(
//                           width: 149 * fem,
//                           height: 82.21 * fem,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Center(
//                                 // theresagiftforeveryoneiMU (318:1934)
//                                 child: Container(
//                                   margin: EdgeInsets.fromLTRB(
//                                       0 * fem, 0 * fem, 0 * fem, 12.21 * fem),
//                                   constraints: BoxConstraints(
//                                     maxWidth: 149 * fem,
//                                   ),
//                                   child: Text(
//                                     'There’s a Gift\nfor everyone',
//                                     textAlign: TextAlign.center,
//                                     style: MyGoogleFontStyle(
//                                       fontFamily: 'Philosopher',
//                                       fontSize: 25 * ffem,
//                                       fontWeight: FontWeight.w700,
//                                       height: 1 * ffem / fem,
//                                       color: Color(0xff002140),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Center(
//                                 // shopnowyoC (318:1935)
//                                 child: Container(
//                                   margin: EdgeInsets.fromLTRB(
//                                       0 * fem, 0 * fem, 0.54 * fem, 0 * fem),
//                                   child: Text(
//                                     'Shop now',
//                                     textAlign: TextAlign.center,
//                                     style: MyGoogleFontStyle(
//                                       fontFamily: 'Poppins',
//                                       fontSize: 13 * ffem,
//                                       fontWeight: FontWeight.w500,
//                                       height: 1.5 * ffem / fem,
//                                       color: Color(0xff303030),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 210,
//                       ),
//                       Positioned(
//                         // group8977gSi (318:1974)
//                         left: 0 * fem,
//                         top: 0 * fem,
//                         child: Container(
//                           padding: EdgeInsets.fromLTRB(
//                               5.36 * fem, 9.6 * fem, 8.64 * fem, 7.95 * fem),
//                           width: 360 * fem,
//                           height: 71.04 * fem,
//                           child: ClipRect(
//                             child: BackdropFilter(
//                               filter: ImageFilter.blur(
//                                 sigmaX: 23.0399990082 * fem,
//                                 sigmaY: 23.0399990082 * fem,
//                               ),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                     // group89748pW (318:1976)
//                                     margin: EdgeInsets.fromLTRB(
//                                         0 * fem, 0 * fem, 0 * fem, 0 * fem),
//                                     height: double.infinity,
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.end,
//                                       children: [
//                                         Container(
//                                           // pinewrapslogo1GQv (318:1978)
//                                           margin: EdgeInsets.fromLTRB(0 * fem,
//                                               0 * fem, 0 * fem, 4.7 * fem),
//                                           width: 28.22 * fem,
//                                           height: 42.79 * fem,
//                                           child: Image.asset(
//                                             'assets/images/pinewrapslogo-1-9g4.png',
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                         Container(
//                                           // autogroup99k6Y7Y (Gb5gQpndK38ijyCFQE99K6)
//                                           width: 102 * fem,
//                                           height: 39.83 * fem,
//                                           child: Stack(
//                                             children: [
//                                               Positioned(
//                                                 // welcometoewG (318:1977)
//                                                 left: 0 * fem,
//                                                 top: 0 * fem,
//                                                 child: Align(
//                                                   child: SizedBox(
//                                                     width: 68 * fem,
//                                                     height: 17 * fem,
//                                                     child: Text(
//                                                       'Welcome to',
//                                                       style: MyGoogleFontStyle(
//                                                         fontFamily: 'Poppins',
//                                                         fontSize:
//                                                             10.9245996475 *
//                                                                 ffem,
//                                                         fontWeight:
//                                                             FontWeight.w700,
//                                                         height: 1.5000000436 *
//                                                             ffem /
//                                                             fem,
//                                                         color:
//                                                             Color(0xff303030),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 // pinewrapsXEN (318:1979)
//                                                 left: 0 * fem,
//                                                 top: 11.8349609375 * fem,
//                                                 child: Align(
//                                                   child: SizedBox(
//                                                     width: 102 * fem,
//                                                     height: 28 * fem,
//                                                     child: Text(
//                                                       'PINEWRAPS',
//                                                       style: MyGoogleFontStyle(
//                                                         fontFamily: 'Righteous',
//                                                         fontSize:
//                                                             18.2076663971 *
//                                                                 ffem,
//                                                         fontWeight:
//                                                             FontWeight.w400,
//                                                         height: 1.5000000524 *
//                                                             ffem /
//                                                             fem,
//                                                         color:
//                                                             Color(0xff303030),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     // group8975zNr (318:1980)
//                                     margin: EdgeInsets.fromLTRB(0 * fem,
//                                         14.4 * fem, 0 * fem, 16.79 * fem),
//                                     height: double.infinity,
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         Container(
//                                           // searchKAE (318:1984)
//                                           margin: EdgeInsets.fromLTRB(0 * fem,
//                                               0 * fem, 0 * fem, 0 * fem),
//                                           child: TextButton(
//                                             onPressed: () {},
//                                             style: TextButton.styleFrom(
//                                               padding: EdgeInsets.zero,
//                                             ),
//                                             child: Container(
//                                               width: 18.58 * fem,
//                                               height: 18.58 * fem,
//                                               child: Image.asset(
//                                                 'assets/images/search.png',
//                                                 width: 18.58 * fem,
//                                                 height: 18.58 * fem,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Container(
//                                           // vectorc9L (318:1985)
//                                           margin: EdgeInsets.fromLTRB(0 * fem,
//                                               0 * fem, 5.09 * fem, 0.93 * fem),
//                                           child: TextButton(
//                                             onPressed: () {},
//                                             style: TextButton.styleFrom(
//                                               padding: EdgeInsets.zero,
//                                             ),
//                                             child: Container(
//                                               width: 18.58 * fem,
//                                               height: 19.51 * fem,
//                                               child: Image.asset(
//                                                 'assets/images/vector-afp.png',
//                                                 width: 18.58 * fem,
//                                                 height: 19.51 * fem,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         TextButton(
//                                           // group8990e62 (318:1981)
//                                           onPressed: () {},
//                                           style: TextButton.styleFrom(
//                                             padding: EdgeInsets.zero,
//                                           ),
//                                           child: Container(
//                                             width: 22.3 * fem,
//                                             height: 22.3 * fem,
//                                             child: Image.asset(
//                                               'assets/images/group-8990.png',
//                                               width: 22.3 * fem,
//                                               height: 22.3 * fem,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   // autogroupaciuWtv (Gb5gcpSeB7j2BRKELaaciU)
//                   padding:
//                       EdgeInsets.fromLTRB(7 * fem, 40 * fem, 0 * fem, 40 * fem),
//                   width: double.infinity,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         // loginwithDHY (318:1986)
//                         margin: EdgeInsets.fromLTRB(
//                             1 * fem, 0 * fem, 0 * fem, 24 * fem),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               // line1X3L (318:1989)
//                               margin: EdgeInsets.fromLTRB(
//                                   0 * fem, 7 * fem, 9 * fem, 0 * fem),
//                               width: 105 * fem,
//                               height: 0.94 * fem,
//                             ),
//                             Container(
//                               // newarrivals1z6 (318:1988)
//                               margin: EdgeInsets.fromLTRB(
//                                   0 * fem, 0 * fem, 11 * fem, 0 * fem),
//                               child: Text(
//                                 'New Arrivals',
//                                 style: MyGoogleFontStyle(
//                                   fontFamily: 'Urbanist',
//                                   fontSize: 20 * ffem,
//                                   fontWeight: FontWeight.w700,
//                                   height: 1.5 * ffem / fem,
//                                   color: Color(0xff1e1e1e),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               // line27GS (318:1990)
//                               margin: EdgeInsets.fromLTRB(
//                                   0 * fem, 7 * fem, 0 * fem, 0 * fem),
//                               width: 105 * fem,
//                               height: 0.94 * fem,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         // group9022e1U (318:1996)
//                         margin: EdgeInsets.fromLTRB(
//                             0 * fem, 0 * fem, 0 * fem, 40 * fem),
//                         width: double.infinity,
//                         height: 265 * fem,
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               // group8949Yce (318:1997)
//                               width: 145 * fem,
//                               height: double.infinity,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15 * fem),
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                     // frame9Si2 (318:1998)
//                                     margin: EdgeInsets.fromLTRB(
//                                         0 * fem, 0 * fem, 0 * fem, 15 * fem),
//                                     padding: EdgeInsets.fromLTRB(106 * fem,
//                                         13 * fem, 14 * fem, 13 * fem),
//                                     width: double.infinity,
//                                     height: 193 * fem,
//                                     decoration: BoxDecoration(
//                                       borderRadius:
//                                           BorderRadius.circular(15 * fem),
//                                       color: Color(0x0c000000),
//                                       image: DecorationImage(
//                                         fit: BoxFit.cover,
//                                         image: AssetImage(
//                                           'assets/images/shades-chocolate-cake-3-1-2-1-bg.png',
//                                         ),
//                                       ),
//                                       gradient: LinearGradient(
//                                         begin: Alignment(0.917, -0.907),
//                                         end: Alignment(0.262, 1.223),
//                                         colors: <Color>[
//                                           Color(0x3f000000),
//                                           Color(0x3f000000),
//                                           Color(0x3e050505),
//                                           Color(0x00fbfbfb)
//                                         ],
//                                         stops: <double>[0, 0, 0.021, 0.938],
//                                       ),
//                                     ),
//                                     child: Align(
//                                       // vectorRZx (318:2001)
//                                       alignment: Alignment.topRight,
//                                       child: SizedBox(
//                                         width: 25 * fem,
//                                         height: 22.4 * fem,
//                                         child: Image.asset(
//                                           'assets/images/vector-ZZQ.png',
//                                           width: 25 * fem,
//                                           height: 22.4 * fem,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     // shadechocolatecake3pc6 (318:2002)
//                                     margin: EdgeInsets.fromLTRB(
//                                         0 * fem, 0 * fem, 0 * fem, 4 * fem),
//                                     constraints: BoxConstraints(
//                                       maxWidth: 123 * fem,
//                                     ),
//                                     child: Text(
//                                       '3 SHADE CHOCOLATE\nCAKE 3′',
//                                       textAlign: TextAlign.center,
//                                       style: MyGoogleFontStyle(
//                                         fontFamily: 'Urbanist',
//                                         fontSize: 15 * ffem,
//                                         fontWeight: FontWeight.w700,
//                                         height: 1.2 * ffem / fem,
//                                         letterSpacing: -0.3 * fem,
//                                         color: Color(0xff000000),
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     // 5H8 (318:2003)
//                                     margin: EdgeInsets.fromLTRB(
//                                         0 * fem, 0 * fem, 1 * fem, 0 * fem),
//                                     child: Text(
//                                       'د.إ65.00',
//                                       style: MyGoogleFontStyle(
//                                         fontFamily: 'Poppins',
//                                         fontSize: 10.9543466568 * ffem,
//                                         fontWeight: FontWeight.w500,
//                                         height: 1.5 * ffem / fem,
//                                         letterSpacing: -0.2190869331 * fem,
//                                         color: Color(0x99000000),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               // autogroupaeoaB5G (Gb5hD3xboiab36ppmDAeoa)
//                               padding: EdgeInsets.fromLTRB(
//                                   17.42 * fem, 0 * fem, 0 * fem, 0 * fem),
//                               height: double.infinity,
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     // group89506i2 (318:2004)
//                                     margin: EdgeInsets.fromLTRB(
//                                         0 * fem, 0 * fem, 17.58 * fem, 0 * fem),
//                                     width: 145 * fem,
//                                     decoration: BoxDecoration(
//                                       borderRadius:
//                                           BorderRadius.circular(10 * fem),
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         Container(
//                                           // frame9D1x (318:2005)
//                                           margin: EdgeInsets.fromLTRB(0 * fem,
//                                               0 * fem, 0 * fem, 15 * fem),
//                                           width: double.infinity,
//                                           height: 193 * fem,
//                                           decoration: BoxDecoration(
//                                             color: Color(0x0c000000),
//                                             borderRadius:
//                                                 BorderRadius.circular(10 * fem),
//                                           ),
//                                           child: Stack(
//                                             children: [
//                                               Positioned(
//                                                 // image22iUW (318:2006)
//                                                 left: 0.4233398438 * fem,
//                                                 top: 0 * fem,
//                                                 child: Align(
//                                                   child: SizedBox(
//                                                     width: 145 * fem,
//                                                     height: 193 * fem,
//                                                     child: ClipRRect(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               15 * fem),
//                                                       child: Image.asset(
//                                                         'assets/images/image-22-dav.png',
//                                                         fit: BoxFit.cover,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 // rectangle2425p1k (318:2007)
//                                                 left: 0 * fem,
//                                                 top: 0 * fem,
//                                                 child: Align(
//                                                   child: SizedBox(
//                                                     width: 145 * fem,
//                                                     height: 193 * fem,
//                                                     child: Container(
//                                                       decoration: BoxDecoration(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(
//                                                                     15 * fem),
//                                                         gradient:
//                                                             LinearGradient(
//                                                           begin: Alignment(
//                                                               0.917, -0.907),
//                                                           end: Alignment(
//                                                               0.262, 1.223),
//                                                           colors: <Color>[
//                                                             Color(0x3f000000),
//                                                             Color(0x00fbfbfb)
//                                                           ],
//                                                           stops: <double>[
//                                                             0,
//                                                             0.938
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 // vectorUc6 (318:2008)
//                                                 left: 106 * fem,
//                                                 top: 13 * fem,
//                                                 child: Align(
//                                                   child: SizedBox(
//                                                     width: 25 * fem,
//                                                     height: 22.4 * fem,
//                                                     child: Image.asset(
//                                                       'assets/images/vector-5tS.png',
//                                                       width: 25 * fem,
//                                                       height: 22.4 * fem,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Container(
//                                           // icecreambRp (318:2009)
//                                           margin: EdgeInsets.fromLTRB(
//                                               0.15 * fem,
//                                               0 * fem,
//                                               0 * fem,
//                                               4 * fem),
//                                           child: Text(
//                                             'ICE CREAM',
//                                             textAlign: TextAlign.center,
//                                             style: MyGoogleFontStyle(
//                                               fontFamily: 'Urbanist',
//                                               fontSize: 15 * ffem,
//                                               fontWeight: FontWeight.w700,
//                                               height: 1.2 * ffem / fem,
//                                               letterSpacing: -0.3 * fem,
//                                               color: Color(0xff000000),
//                                             ),
//                                           ),
//                                         ),
//                                         Container(
//                                           // J5L (318:2010)
//                                           margin: EdgeInsets.fromLTRB(0 * fem,
//                                               0 * fem, 1.85 * fem, 0 * fem),
//                                           child: Text(
//                                             'د.إ65.00',
//                                             style: MyGoogleFontStyle(
//                                               fontFamily: 'Poppins',
//                                               fontSize: 10.9543466568 * ffem,
//                                               fontWeight: FontWeight.w500,
//                                               height: 1.5 * ffem / fem,
//                                               letterSpacing:
//                                                   -0.2190869331 * fem,
//                                               color: Color(0x99000000),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     // group8984CRc (318:2011)
//                                     width: 145 * fem,
//                                     decoration: BoxDecoration(
//                                       borderRadius:
//                                           BorderRadius.circular(15 * fem),
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         Container(
//                                           // frame9uqp (318:2012)
//                                           margin: EdgeInsets.fromLTRB(0 * fem,
//                                               0 * fem, 0 * fem, 49.29 * fem),
//                                           width: double.infinity,
//                                           decoration: BoxDecoration(
//                                             color: Color(0x0c000000),
//                                             borderRadius:
//                                                 BorderRadius.circular(15 * fem),
//                                           ),
//                                           child: Align(
//                                             // shadeschocolatecake3121RJN (318:2013)
//                                             alignment: Alignment.centerRight,
//                                             child: SizedBox(
//                                               width: 150 * fem,
//                                               height: 193 * fem,
//                                               child: ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                         10 * fem),
//                                                 child: Image.asset(
//                                                   'assets/images/shades-chocolate-cake-3-1-2-1-sVY.png',
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Container(
//                                           // oJv (318:2014)
//                                           margin: EdgeInsets.fromLTRB(
//                                               2.68 * fem,
//                                               0 * fem,
//                                               0 * fem,
//                                               0 * fem),
//                                           child: Text(
//                                             'د.إ65.00',
//                                             style: MyGoogleFontStyle(
//                                               fontFamily: 'Poppins',
//                                               fontSize: 10.9543466568 * ffem,
//                                               fontWeight: FontWeight.w500,
//                                               height: 1.5 * ffem / fem,
//                                               letterSpacing:
//                                                   -0.2190869331 * fem,
//                                               color: Color(0x99000000),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         // loginwithGTQ (318:1991)
//                         margin: EdgeInsets.fromLTRB(
//                             1 * fem, 0 * fem, 0 * fem, 24 * fem),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               // line1PY2 (318:1994)
//                               margin: EdgeInsets.fromLTRB(
//                                   0 * fem, 7 * fem, 6 * fem, 0 * fem),
//                               width: 85 * fem,
//                               height: 0.94 * fem,
//                             ),
//                             Container(
//                               // shopbycategoryKwU (318:1993)
//                               margin: EdgeInsets.fromLTRB(
//                                   0 * fem, 0 * fem, 5 * fem, 0 * fem),
//                               child: Text(
//                                 'Shop by Category',
//                                 style: MyGoogleFontStyle(
//                                   fontFamily: 'Urbanist',
//                                   fontSize: 20 * ffem,
//                                   fontWeight: FontWeight.w700,
//                                   height: 1.5 * ffem / fem,
//                                   color: Color(0xff1e1e1e),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               // line2qup (318:1995)
//                               margin: EdgeInsets.fromLTRB(
//                                   0 * fem, 7 * fem, 0 * fem, 0 * fem),
//                               width: 85 * fem,
//                               height: 0.94 * fem,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         // group9023Nuk (318:1955)
//                         width: 345 * fem,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Container(
//                               // group89937cS (318:1962)
//                               width: 344 * fem,
//                               height: 107 * fem,
//                               child: Stack(
//                                 children: [
//                                   Positioned(
//                                     // image24Suc (318:1963)
//                                     left: 0 * fem,
//                                     top: 0 * fem,
//                                     child: Align(
//                                       child: SizedBox(
//                                         width: 344 * fem,
//                                         height: 106.69 * fem,
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(10 * fem),
//                                           child: Image.asset(
//                                             'assets/images/image-24.png',
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     // rectangle2422kfQ (318:1964)
//                                     left: 0 * fem,
//                                     top: 0 * fem,
//                                     child: Align(
//                                       child: SizedBox(
//                                         width: 344 * fem,
//                                         height: 107 * fem,
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(
//                                                 10.1176462173 * fem),
//                                             gradient: LinearGradient(
//                                               begin: Alignment(-1, 0.138),
//                                               end: Alignment(1, 0.128),
//                                               colors: <Color>[
//                                                 Color(0x99000000),
//                                                 Color(0x00d9d9d9)
//                                               ],
//                                               stops: <double>[0, 1],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     // group8983dDQ (318:1965)
//                                     left: 22 * fem,
//                                     top: 39.5 * fem,
//                                     child: Container(
//                                       width: 59 * fem,
//                                       height: 38.31 * fem,
//                                       child: Stack(
//                                         children: [
//                                           Positioned(
//                                             // cakeswjt (318:1966)
//                                             left: 0 * fem,
//                                             top: 0 * fem,
//                                             child: Align(
//                                               child: SizedBox(
//                                                 width: 59 * fem,
//                                                 height: 28 * fem,
//                                                 child: Text(
//                                                   'Cakes',
//                                                   style: MyGoogleFontStyle(
//                                                     fontFamily: 'Poppins',
//                                                     fontSize:
//                                                         18.3132514954 * ffem,
//                                                     fontWeight: FontWeight.w600,
//                                                     height: 1.5 * ffem / fem,
//                                                     color: Color(0xffffffff),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Positioned(
//                                             // itemsdci (318:1967)
//                                             left: 2.7470703125 * fem,
//                                             top: 24.3071899414 * fem,
//                                             child: Align(
//                                               child: SizedBox(
//                                                 width: 38 * fem,
//                                                 height: 14 * fem,
//                                                 child: Text(
//                                                   '15 items',
//                                                   style: MyGoogleFontStyle(
//                                                     fontFamily: 'Poppins',
//                                                     fontSize:
//                                                         9.1566257477 * ffem,
//                                                     fontWeight: FontWeight.w600,
//                                                     height: 1.5 * ffem / fem,
//                                                     color: Color(0xffffffff),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: 16 * fem,
//                             ),
//                             Container(
//                               // group8992hca (318:1968)
//                               width: double.infinity,
//                               height: 107 * fem,
//                               child: Stack(
//                                 children: [
//                                   Positioned(
//                                     // image23jZG (318:1969)
//                                     left: 0 * fem,
//                                     top: 0 * fem,
//                                     child: Align(
//                                       child: SizedBox(
//                                         width: 344 * fem,
//                                         height: 107 * fem,
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(10 * fem),
//                                           child: Image.asset(
//                                             'assets/images/image-23.png',
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     // rectangle2422duY (318:1970)
//                                     left: 1 * fem,
//                                     top: 0 * fem,
//                                     child: Align(
//                                       child: SizedBox(
//                                         width: 344 * fem,
//                                         height: 107 * fem,
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(
//                                                 10.1176462173 * fem),
//                                             gradient: LinearGradient(
//                                               begin: Alignment(-1, 0.138),
//                                               end: Alignment(1, 0.128),
//                                               colors: <Color>[
//                                                 Color(0x99000000),
//                                                 Color(0x00d9d9d9)
//                                               ],
//                                               stops: <double>[0, 1],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Positioned(
//                                     // group8983taa (318:1971)
//                                     left: 250 * fem,
//                                     top: 33.5 * fem,
//                                     child: Container(
//                                       width: 71 * fem,
//                                       height: 38.31 * fem,
//                                       child: Stack(
//                                         children: [
//                                           Positioned(
//                                             // flowerspUE (318:1972)
//                                             left: 0 * fem,
//                                             top: 0 * fem,
//                                             child: Align(
//                                               child: SizedBox(
//                                                 width: 71 * fem,
//                                                 height: 28 * fem,
//                                                 child: Text(
//                                                   'Flowers',
//                                                   style: MyGoogleFontStyle(
//                                                     fontFamily: 'Poppins',
//                                                     fontSize:
//                                                         18.3132514954 * ffem,
//                                                     fontWeight: FontWeight.w600,
//                                                     height: 1.5 * ffem / fem,
//                                                     color: Color(0xffffffff),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Positioned(
//                                             // itemsuEn (318:1973)
//                                             left: 2.7470703125 * fem,
//                                             top: 24.3071899414 * fem,
//                                             child: Align(
//                                               child: SizedBox(
//                                                 width: 38 * fem,
//                                                 height: 14 * fem,
//                                                 child: Text(
//                                                   '15 items',
//                                                   style: MyGoogleFontStyle(
//                                                     fontFamily: 'Poppins',
//                                                     fontSize:
//                                                         9.1566257477 * ffem,
//                                                     fontWeight: FontWeight.w600,
//                                                     height: 1.5 * ffem / fem,
//                                                     color: Color(0xffffffff),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: 16 * fem,
//                             ),
//                             Container(
//                               // group8991vva (318:1956)
//                               padding: EdgeInsets.fromLTRB(
//                                   22 * fem, 39.5 * fem, 22 * fem, 29.19 * fem),
//                               width: 344 * fem,
//                               height: 107 * fem,
//                               decoration: BoxDecoration(
//                                 borderRadius:
//                                     BorderRadius.circular(10.1176462173 * fem),
//                                 image: DecorationImage(
//                                   fit: BoxFit.cover,
//                                   image: AssetImage(
//                                     'assets/images/image-20-bg.png',
//                                   ),
//                                 ),
//                                 gradient: LinearGradient(
//                                   begin: Alignment(-1, 0.138),
//                                   end: Alignment(1, 0.128),
//                                   colors: <Color>[
//                                     Color(0x99000000),
//                                     Color(0x00d9d9d9)
//                                   ],
//                                   stops: <double>[0, 1],
//                                 ),
//                               ),
//                               child: Container(
//                                 // group8983ynN (318:1959)
//                                 width: 80 * fem,
//                                 height: double.infinity,
//                                 child: Stack(
//                                   children: [
//                                     Positioned(
//                                       // combosizr (318:1960)
//                                       left: 0 * fem,
//                                       top: 0 * fem,
//                                       child: Align(
//                                         child: SizedBox(
//                                           width: 80 * fem,
//                                           height: 28 * fem,
//                                           child: Text(
//                                             'Combos',
//                                             style: MyGoogleFontStyle(
//                                               fontFamily: 'Poppins',
//                                               fontSize: 18.3132514954 * ffem,
//                                               fontWeight: FontWeight.w600,
//                                               height: 1.5 * ffem / fem,
//                                               color: Color(0xffffffff),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       // itemsReN (318:1961)
//                                       left: 2.7470703125 * fem,
//                                       top: 24.3071899414 * fem,
//                                       child: Align(
//                                         child: SizedBox(
//                                           width: 38 * fem,
//                                           height: 14 * fem,
//                                           child: Text(
//                                             '15 items',
//                                             style: MyGoogleFontStyle(
//                                               fontFamily: 'Poppins',
//                                               fontSize: 9.1566257477 * ffem,
//                                               fontWeight: FontWeight.w600,
//                                               height: 1.5 * ffem / fem,
//                                               color: Color(0xffffffff),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   // group81Wvi (318:1936)
//                   width: double.infinity,
//                   height: 150 * fem,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5 * fem),
//                   ),
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         // rectangle45ELv (318:1937)
//                         left: 0 * fem,
//                         top: 0 * fem,
//                         child: Align(
//                           child: SizedBox(
//                             width: 360 * fem,
//                             height: 150 * fem,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(5 * fem),
//                                 color: Color(0x33eecf56),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         // group46Ler (318:1938)
//                         left: 268.130859375 * fem,
//                         top: 84.827545166 * fem,
//                         child: Align(
//                           child: SizedBox(
//                             width: 81.72 * fem,
//                             height: 65.17 * fem,
//                             child: Image.asset(
//                               'assets/images/group-46.png',
//                               width: 81.72 * fem,
//                               height: 65.17 * fem,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         // ellipse25pa2 (318:1944)
//                         left: 324.5180664062 * fem,
//                         top: 15.5172424316 * fem,
//                         child: Align(
//                           child: SizedBox(
//                             width: 5.34 * fem,
//                             height: 5.17 * fem,
//                             child: Image.asset(
//                               'assets/images/ellipse-25.png',
//                               width: 5.34 * fem,
//                               height: 5.17 * fem,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         // ellipse32Kmg (318:1945)
//                         left: 2.1362304688 * fem,
//                         top: 37.2411804199 * fem,
//                         child: Align(
//                           child: SizedBox(
//                             width: 8.82 * fem,
//                             height: 8.54 * fem,
//                             child: Image.asset(
//                               'assets/images/ellipse-32.png',
//                               width: 8.82 * fem,
//                               height: 8.54 * fem,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         // ellipse27Edk (318:1946)
//                         left: 334.1323242188 * fem,
//                         top: 26.8965454102 * fem,
//                         child: Align(
//                           child: SizedBox(
//                             width: 11.75 * fem,
//                             height: 11.38 * fem,
//                             child: Image.asset(
//                               'assets/images/ellipse-27.png',
//                               width: 11.75 * fem,
//                               height: 11.38 * fem,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         // ellipse33MyG (318:1947)
//                         left: 16.0239257812 * fem,
//                         top: 2.0690307617 * fem,
//                         child: Align(
//                           child: SizedBox(
//                             width: 16.38 * fem,
//                             height: 15.86 * fem,
//                             child: Image.asset(
//                               'assets/images/ellipse-33.png',
//                               width: 16.38 * fem,
//                               height: 15.86 * fem,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         // ellipse26UY6 (318:1948)
//                         left: 311.69921875 * fem,
//                         top: 41.3793029785 * fem,
//                         child: Align(
//                           child: SizedBox(
//                             width: 18.16 * fem,
//                             height: 17.59 * fem,
//                             child: Image.asset(
//                               'assets/images/ellipse-26.png',
//                               width: 18.16 * fem,
//                               height: 17.59 * fem,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         // ellipse34PQA (318:1949)
//                         left: 329.859375 * fem,
//                         top: 66.2068786621 * fem,
//                         child: Align(
//                           child: SizedBox(
//                             width: 14.96 * fem,
//                             height: 14.48 * fem,
//                             child: Image.asset(
//                               'assets/images/ellipse-34.png',
//                               width: 14.96 * fem,
//                               height: 14.48 * fem,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         // ellipse35WUn (318:1950)
//                         left: 290.333984375 * fem,
//                         top: 66.2068786621 * fem,
//                         child: Align(
//                           child: SizedBox(
//                             width: 11.75 * fem,
//                             height: 11.38 * fem,
//                             child: Image.asset(
//                               'assets/images/ellipse-35-GPY.png',
//                               width: 11.75 * fem,
//                               height: 11.38 * fem,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         // inviteafriendandearnplantifyre (318:1951)
//                         left: 24.5698242188 * fem,
//                         top: 18.6206817627 * fem,
//                         child: Align(
//                           child: SizedBox(
//                             width: 252 * fem,
//                             height: 60 * fem,
//                             child: Text(
//                               'Invite a Friend and earn Plantify rewards',
//                               style: MyGoogleFontStyle(
//                                 fontFamily: 'Philosopher',
//                                 fontSize: 24 * ffem,
//                                 fontWeight: FontWeight.w700,
//                                 height: 1.2400000095 * ffem / fem,
//                                 color: Color(0xff000000),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         // redeemthemtogetinstantdiscount (318:1952)
//                         left: 28.8427734375 * fem,
//                         top: 95.1724243164 * fem,
//                         child: Align(
//                           child: SizedBox(
//                             width: 135 * fem,
//                             height: 30 * fem,
//                             child: Text(
//                               'Redeem them to get instant discounts',
//                               style: MyGoogleFontStyle(
//                                 fontFamily: 'Poppins',
//                                 fontSize: 13 * ffem,
//                                 fontWeight: FontWeight.w600,
//                                 height: 1.1538461538 * ffem / fem,
//                                 color: Color(0xff888888),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         // rectangle59cAS (318:1953)
//                         left: 190.1484375 * fem,
//                         top: 95.1724243164 * fem,
//                         child: Align(
//                           child: SizedBox(
//                             width: 64.09 * fem,
//                             height: 31.03 * fem,
//                             child: TextButton(
//                               onPressed: () {},
//                               style: TextButton.styleFrom(
//                                 padding: EdgeInsets.zero,
//                               ),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5 * fem),
//                                   color: Color(0xffeecf56),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         // invite6rJ (318:1954)
//                         left: 202.9672851562 * fem,
//                         top: 99.655166626 * fem,
//                         child: Align(
//                           child: SizedBox(
//                             width: 37 * fem,
//                             height: 20 * fem,
//                             child: Text(
//                               'Invite',
//                               style: MyGoogleFontStyle(
//                                 fontFamily: 'Poppins',
//                                 fontSize: 13 * ffem,
//                                 fontWeight: FontWeight.w600,
//                                 height: 1.5 * ffem / fem,
//                                 color: Color(0xffffffff),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
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

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

class _HomePageState extends State<HomePage> {
  ConfigModel _configModel = locator<ConfigModel>();

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(6, 16, 6, 80),
          // height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Image.asset(
                            'assets/images/vector-GJ4.png',
                            height: 15,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Home Page',
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
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Text(
                  'Hello! Welcome Back',
                  textAlign: TextAlign.center,
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1e232c),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: Text('Are you sure you want to logout?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('NO'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await _configModel.removeLoginData();
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: Text('YES'),
                          ),
                        ],
                      ),
                    );
                  },
                  title: Text('Logout'),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
