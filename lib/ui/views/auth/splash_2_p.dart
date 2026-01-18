import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aadab/ui/shared/font_sh.dart';

class Splash2Page extends StatefulWidget {
  const Splash2Page({Key? key}) : super(key: key);

  @override
  State<Splash2Page> createState() => _Splash2PageState();
}

class _Splash2PageState extends State<Splash2Page> {
  // Define colors as constants for better maintainability
  static const Color primaryColor = Color(0xFF1A237E); // Deep Indigo
  static const Color wholesalerColor = Color(0xFF00695C); // Deep Teal
  static const Color customerColor = Color(0xFF7B1FA2); // Purple
  static const Color guestColor = Color(0xFF455A64); // Blue Grey
  static const Color whiteColor = Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.0.sh,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F5F5),
              Color(0xFFE8EAF6),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Logo
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.6),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Image.asset(
                        'assets/images/aadab-logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Welcome Text
                  Text(
                    'Welcome to Aadab',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose how you want to continue',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Role Selection Cards
                  // Wholesaler Card
                  _buildRoleCard(
                    context,
                    icon: Icons.business,
                    label: 'Wholesaler',
                    subtitle: 'For bulk orders & business',
                    color: wholesalerColor,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/loginPage',
                        arguments: {'role': 'Distributor'},
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Customer Card
                  _buildRoleCard(
                    context,
                    icon: Icons.shopping_bag,
                    label: 'Customer',
                    subtitle: 'Shop our latest collection',
                    color: customerColor,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/loginPage',
                        arguments: {'role': 'User'},
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Guest Card
                  _buildRoleCard(
                    context,
                    icon: Icons.visibility,
                    label: 'Guest',
                    subtitle: 'Browse without account',
                    color: guestColor,
                    onPressed: () {
                      Navigator.pushNamed(context, '/homePage');
                    },
                  ),
                  const SizedBox(height: 40),
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
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Text(
                        '  •  ',
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
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for creating role selection cards
  Widget _buildRoleCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow Icon
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: whiteColor,
                    size: 16,
                  ),
                ),
              ],
            ),
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
        height: 0.75.sh,
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
        height: 0.75.sh,
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
• Images' colors which shown in application may be differ from actual
• Reward point calculated based on 25% on purchase amount or available whichever more. and it is our sole proprietary can change percentage level any time

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
• We will deliver our product within 7-10 days, depending on the local area

5. RETURNS AND REFUNDS
• Items may be returned within 7 days of delivery in original condition
• Return shipping costs may apply unless the item was defective or incorrectly shipped
• Refund will be PROCESS AND CREDITED INTO ACCOUNT 7-10 DAYS after we receive the returned item

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
• Email: adaab.treder@gmail.com
• Phone: +91 86001 75751
• Address: RAZA TRADING CO - House number 607 Khadan Road, Laxmi Sizing,
Land Mark Prime Hospital, Kalyan road
Bhiwandi Dist Thane Maharashtra 421302

By using our services, you consent to the collection and use of your information as outlined in this Privacy Policy.

Last updated: ${DateTime.now().year}''';
  }
}
