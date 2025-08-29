import 'package:flutter/material.dart';
import 'package:aadab/ui/shared/font_sh.dart';

class Splash2Page extends StatefulWidget {
  const Splash2Page({Key? key}) : super(key: key);

  @override
  State<Splash2Page> createState() => _Splash2PageState();
}

class _Splash2PageState extends State<Splash2Page> {
  // Define colors as constants for better maintainability
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
                // _buildButton(
                //   context,
                //   label: 'Wholesaler',
                //   backgroundColor: primaryColor,
                //   textColor: whiteColor,
                //   onPressed: () {
                //     Navigator.pushNamed(
                //       context,
                //       '/loginPage',
                //       arguments: {'role': 'Distributor'},
                //     );
                //   },
                // ),
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
                const SizedBox(height: 30),
                // Terms & Conditions and Privacy Policy links
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _showTermsAndConditions(context),
                      child: Text(
                        'Terms & Conditions',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Text(
                      '  |  ',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showPrivacyPolicy(context),
                      child: Text(
                        'Privacy Policy',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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

  // Method to show Terms & Conditions modal
  void _showTermsAndConditions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Terms & Conditions',
                style: MyGoogleFontStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            const Divider(thickness: 1),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Text(
                  _getTermsAndConditionsContent(),
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to show Privacy Policy modal
  void _showPrivacyPolicy(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Privacy Policy',
                style: MyGoogleFontStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            const Divider(thickness: 1),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Text(
                  _getPrivacyPolicyContent(),
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Terms & Conditions content
  String _getTermsAndConditionsContent() {
    return '''Welcome to Aadab (RAZA TRADING CO)! These Terms & Conditions govern your use of our clothing online store and the purchase of our products. By using our services, you agree to these terms.

1. ACCEPTANCE OF TERMS
By accessing and using this website, you accept and agree to be bound by the terms and provision of this agreement.

2. PRODUCTS AND SERVICES
• We offer high-quality clothing and fashion accessories through our online platform
• Product descriptions, images, and prices are subject to change without notice
• We reserve the right to limit quantities and refuse service to anyone

3. ORDERING AND PAYMENT
• All orders are subject to acceptance and product availability
• We accept various payment methods including credit/debit cards and digital wallets
• Payment processing is handled through secure, encrypted payment gateways
• Prices are displayed in local currency and include applicable taxes

4. SHIPPING AND DELIVERY
• We ship to addresses within our service areas
• Delivery times are estimates and may vary based on location and product availability
• Shipping charges will be calculated at checkout
• Risk of loss transfers to you upon delivery

5. RETURNS AND EXCHANGES
• Items may be returned within 7 days of delivery in original condition
• Return shipping costs may apply unless the item was defective or incorrectly shipped
• Refunds will be processed to the original payment method within 7-10 business days

6. USER ACCOUNTS
• You are responsible for maintaining the confidentiality of your account information
• You must provide accurate and complete information when creating an account
• You are responsible for all activities that occur under your account

7. INTELLECTUAL PROPERTY
• All content, trademarks, and intellectual property on this site are owned by Aadab (RAZA TRADING CO)
• You may not reproduce, distribute, or create derivative works without permission

8. LIABILITY LIMITATION
• Our liability is limited to the maximum extent permitted by law
• We are not responsible for indirect, incidental, or consequential damages

9. PRIVACY
• Your privacy is important to us. Please review our Privacy Policy for information about how we collect and use your data

10. MODIFICATIONS
• We reserve the right to modify these terms at any time
• Continued use of our services constitutes acceptance of any changes

For questions about these Terms & Conditions, please contact our customer service team.

Last updated: ${DateTime.now().year}''';
  }

  // Privacy Policy content
  String _getPrivacyPolicyContent() {
    return '''At Aadab (RAZA TRADING CO), we respect your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and safeguard your data when you use our online clothing store.

1. INFORMATION WE COLLECT
We collect information you provide directly to us, such as:
• Personal details (name, email, phone number, address)
• Payment information (processed securely through our payment gateways)
• Order history and preferences
• Account credentials and profile information
• Communication records with our customer service

We also automatically collect certain information:
• Device information and IP address
• Browser type and operating system
• Pages visited and time spent on our site
• Cookies and similar tracking technologies

2. HOW WE USE YOUR INFORMATION
We use your information to:
• Process and fulfill your orders
• Provide customer support and respond to inquiries
• Send order confirmations, shipping updates, and delivery notifications
• Improve our products, services, and website functionality
• Send promotional emails and marketing communications (with your consent)
• Detect and prevent fraud and unauthorized access
• Comply with legal obligations

3. INFORMATION SHARING
We do not sell, trade, or rent your personal information to third parties. We may share your information with:
• Payment processors to handle transactions securely
• Shipping partners to deliver your orders
• Service providers who assist with our operations
• Legal authorities when required by law or to protect our rights

4. PAYMENT SECURITY
• We use industry-standard encryption to protect your payment information
• Payment processing is handled through secure, PCI-compliant payment gateways
• We do not store complete credit card numbers on our servers
• All financial transactions are processed through encrypted connections

5. DATA SECURITY
We implement appropriate security measures to protect your information:
• SSL encryption for data transmission
• Secure servers and databases
• Regular security audits and updates
• Access controls and authentication procedures
• Employee training on data protection

6. COOKIES AND TRACKING
We use cookies and similar technologies to:
• Remember your preferences and settings
• Analyze website traffic and user behavior
• Provide personalized content and recommendations
• Enable certain website features and functionality

You can control cookie settings through your browser preferences.

7. YOUR RIGHTS
You have the right to:
• Access and review your personal information
• Update or correct your account details
• Delete your account and associated data
• Opt-out of marketing communications
• Request a copy of your data
• Withdraw consent for data processing

8. DATA RETENTION
We retain your information for as long as necessary to:
• Provide our services and support
• Comply with legal obligations
• Resolve disputes and enforce agreements
• Maintain business records as required

9. THIRD-PARTY LINKS
Our website may contain links to third-party sites. We are not responsible for the privacy practices of these external sites.

10. CHILDREN'S PRIVACY
Our services are not intended for children under 13. We do not knowingly collect personal information from children.

11. INTERNATIONAL TRANSFERS
Your information may be transferred and processed in countries other than your own, subject to appropriate safeguards.

12. POLICY UPDATES
We may update this Privacy Policy periodically. We will notify you of significant changes through email or website notices.

13. CONTACT INFORMATION
For questions about this Privacy Policy or your personal information, please contact:
• Email: privacy@aadab.com
• Phone: [Customer Service Number]
• Address: RAZA TRADING CO - [Business Address]

By using our services, you consent to the collection and use of your information as outlined in this Privacy Policy.

Last updated: ${DateTime.now().year}''';
  }
}
