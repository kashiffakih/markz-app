import 'package:flutter/material.dart';
import 'package:sales_app/ui/shared/font_sh.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
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
                                'Notifications',
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
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 25,
                        top: 0,
                        child: SingleChildScrollView(
                          child: Container(
                            width: MediaQuery.of(context).size.width - 50,
                            height: MediaQuery.of(context).size.height - 100,
                            child: ListView.builder(
                              itemCount: 10,
                              itemBuilder: (BuildContext context, index) =>
                                  Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 18, 0),
                                        child: Image.asset(
                                          'assets/images/mask-group-HvE.png',
                                          width: 100,
                                          height: 100,
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                180,
                                        child: Column(
                                          children: [
                                            Text(
                                              'Your order #123456789 has been shipped successfully',
                                              style: MyGoogleFontStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xff232323),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ',
                                                    style: MyGoogleFontStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(0xff909090),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'New',
                                                  textAlign: TextAlign.right,
                                                  style: MyGoogleFontStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff27ae60),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    child: Divider(
                                      thickness: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
