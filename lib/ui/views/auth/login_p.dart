import 'dart:io';
import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/auth_pr.dart';
import 'package:aadab/core/providers/config_pr.dart';
import 'package:aadab/locator.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:firebase_auth/firebase_auth.dart';
class LoginPage extends StatefulWidget {
  final argument;

  const LoginPage({Key? key, this.argument}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    // initPlatformState();
    fetchLoginData();
  }

  bool _obscurePassword = true;

  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

  ConfigModel _configModel = locator<ConfigModel>();

  Map<String, dynamic> _loginData = {
    'email': '',
    'password': '',
    'rememberme': 1,
    'role': ''
  };

  final ImagePicker _picker = ImagePicker();

  // Bottom sheet wholesaler form state
  bool _bsHasGst = false;
  File? _bsVisitingCardImage;
  File? _bsShopImage;
  final Map<String, dynamic> _bsWholesalerData = {
    'first_name': '',
    'email': '',
    'password': '',
    'confirm_password': '',
    'phone': '',
    'gst_number': '',
    'business_name': '',
    'trade_name': '',
    'address': '',
    'pincode_business': '',
    'state_business': '',
    'registration_date': '',
  };
  bool _isLoading = false;

  // @override
  // void initState() {

  //   super.initState();
  // }
  bool _isValidEmail(String input) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    return RegExp(emailPattern).hasMatch(input);
  }

  fetchLoginData() async {
    await _configModel.fetchLoginData();
  }

  //  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  // Show beautiful login error dialog
  void _showLoginErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Error Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5252),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                // Error Title
                Text(
                  'Login Failed',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff1e1e1e),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Error Message
                Text(
                  message,
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // OK Button
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5252),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'OK',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show dialog for existing user
  void _showExistingUserDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF9800),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                // Warning Title
                Text(
                  'Existing User!',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff1e1e1e),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Warning Message
                Text(
                  'An account with this email already exists. Please login with your existing credentials.',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Action Buttons
                Row(
                  children: [
                    // Go to Login Button
                    Expanded(
                      child: Container(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/loginPage',
                                arguments: {'role': widget.argument['role']});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffc9b758),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Go to Login',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show generic error dialog
  void _showGenericErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF9800),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                // Warning Title
                Text(
                  'Login Issue',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff1e1e1e),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // Warning Message
                Text(
                  message,
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Action Buttons
                Row(
                  children: [
                    // Try Again Button
                    Expanded(
                      child: Container(
                        height: 45,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFF9800)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                          child: Text(
                            'Try Again',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFFF9800),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Go to Register Button
                    Expanded(
                      child: Container(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/registerPage',
                                arguments: {'role': widget.argument['role']});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffc9b758),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Register',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define theme colors
    const Color primaryColor = Color(0xFF1A237E); // Deep Indigo
    const Color accentColor = Color(0xFFc9b758); // Gold accent
    const Color inputBgColor = Color(0xFFF5F7FA);
    const Color inputBorderColor = Color(0xFFE8ECF4);

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _loginKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Back Button & Role Badge Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 16,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      // Role Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: widget.argument?['role'] == 'Distributor'
                              ? const Color(0xFF00695C).withOpacity(0.1)
                              : const Color(0xFF7B1FA2).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: widget.argument?['role'] == 'Distributor'
                                ? const Color(0xFF00695C)
                                : const Color(0xFF7B1FA2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.argument?['role'] == 'Distributor'
                                  ? Icons.business
                                  : Icons.shopping_bag,
                              size: 14,
                              color: widget.argument?['role'] == 'Distributor'
                                  ? const Color(0xFF00695C)
                                  : const Color(0xFF7B1FA2),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.argument?['role'] == 'Distributor'
                                  ? 'Wholesaler'
                                  : 'Customer',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: widget.argument?['role'] == 'Distributor'
                                    ? const Color(0xFF00695C)
                                    : const Color(0xFF7B1FA2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Welcome Header
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Welcome Back!',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sign in to continue',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Login Form Card - Only Email, Password, Login Button
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Email Label
                        Text(
                          'Email',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Email Input
                        Container(
                          decoration: BoxDecoration(
                            color: inputBgColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: inputBorderColor),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              hintText: 'Enter your email',
                              hintStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 13),
                              prefixIcon: Icon(Icons.email_outlined,
                                  color: Colors.grey[500], size: 18),
                              isDense: true,
                            ),
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff1e232c),
                            ),
                            initialValue: _loginData['email'],
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Email cannot be empty';
                              if (!_isValidEmail(value))
                                return 'Please enter a valid email';
                              return null;
                            },
                            onSaved: (value) => _loginData['email'] = value,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Password Label
                        Text(
                          'Password',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Password Input
                        Container(
                          decoration: BoxDecoration(
                            color: inputBgColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: inputBorderColor),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 13),
                              prefixIcon: Icon(Icons.lock_outline,
                                  color: Colors.grey[500], size: 18),
                              isDense: true,
                              suffixIcon: GestureDetector(
                                onTap: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                                child: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey[500],
                                  size: 18,
                                ),
                              ),
                            ),
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff1e232c),
                            ),
                            obscureText: _obscurePassword,
                            initialValue: _loginData['password'],
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Password cannot be empty';
                              return null;
                            },
                            onSaved: (value) => _loginData['password'] = value,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Login Button
                        Consumer<AuthModel>(
                          builder: (context, authModel, child) => Container(
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              onPressed: () async {
                                setState(() => _isLoading = true);
                                if (_loginKey.currentState!.validate()) {
                                  _loginKey.currentState!.save();
                                  _loginData['role'] =
                                      (widget.argument?['role'] ==
                                              'Distributor')
                                          ? 'Distributor'
                                          : 'User';
                                  Map<String, dynamic> loginResult =
                                      await authModel.login(
                                          loginData: _loginData);
                                  if (_configModel.isLoggedIn) {
                                    // Check if logged in as Distributor but user doesn't have the role
                                    if (_loginData['role'] == 'Distributor') {
                                      final user = _configModel.user;
                                      final hasDistributorRole = user?.roles
                                              ?.any((r) =>
                                                  r.name == 'Distributor') ??
                                          false;

                                      if (!hasDistributorRole) {
                                        // Auto-logout and show error
                                        _configModel.clearUserData();
                                        _showGenericErrorDialog(
                                            'Access Denied: This account is not registered as a Wholesaler.');
                                        setState(() => _isLoading = false);
                                        return;
                                      }
                                    }

                                    Navigator.pushReplacementNamed(
                                        context, '/');
                                  } else {
                                    String errorMessage =
                                        loginResult['message'] ??
                                            _configModel.loginFailedMessage;
                                    if (errorMessage
                                            .toLowerCase()
                                            .contains('already exists') ||
                                        errorMessage
                                            .toLowerCase()
                                            .contains('already registered') ||
                                        errorMessage
                                            .toLowerCase()
                                            .contains('user exists') ||
                                        loginResult['error'] ==
                                            'EMAIL_ALREADY_EXISTS') {
                                      _showExistingUserDialog();
                                    } else if (loginResult['error'] ==
                                            'APPROVAL_PENDING' ||
                                        errorMessage
                                            .toLowerCase()
                                            .contains('pending approval')) {
                                      _showWholesalerPendingDialog();
                                    } else if (loginResult['error'] ==
                                            'ACCOUNT_BLOCKED' ||
                                        errorMessage
                                            .toLowerCase()
                                            .contains('blocked')) {
                                      _showWholesalerBlockedDialog(
                                          loginResult['blocked_reason']);
                                    } else if (loginResult['error'] ==
                                            'ACCOUNT_REJECTED' ||
                                        errorMessage
                                            .toLowerCase()
                                            .contains('rejected')) {
                                      _showWholesalerRejectedDialog(
                                          loginResult['rejection_reason']);
                                    } else if (errorMessage
                                            .toLowerCase()
                                            .contains('not found') ||
                                        errorMessage
                                            .toLowerCase()
                                            .contains('invalid') ||
                                        errorMessage
                                            .toLowerCase()
                                            .contains('incorrect')) {
                                      _showLoginErrorDialog(errorMessage);
                                    } else {
                                      _showGenericErrorDialog(errorMessage);
                                    }
                                  }
                                }
                                setState(() => _isLoading = false);
                              },
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2),
                                    )
                                  : Text(
                                      'Login',
                                      style: MyGoogleFontStyle(
                                        fontFamily: 'Urbanist',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Forgot Password - Outside Card
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () =>
                          Navigator.pushNamed(context, '/forgotPasswordPage'),
                      child: Text(
                        'Forgot Password?',
                        style: MyGoogleFontStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Or Divider - Outside Card (hidden for Distributor/Wholesaler)
                  // Or Divider
                  Row(
                    children: [
                      Expanded(
                          child: Container(height: 1, color: inputBorderColor)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Or continue with',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(height: 1, color: inputBorderColor)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Google Sign In Button - Outside Card
                  InkWell(
                    onTap: () async {
                      try {
                        setState(() => _isLoading = true);
                        // Web client ID from google-services.json (client_type: 3)
                        final googleSignIn = GoogleSignIn(
                          scopes: ['email'],
                          serverClientId:
                              '990776187523-31hv31ogtp5c4pdpf5t5f4d687ve4tct.apps.googleusercontent.com',
                        );
                        await googleSignIn.signOut();
                        final googleAccount = await googleSignIn.signIn();
                        if (googleAccount == null) {
                          setState(() => _isLoading = false);
                          return;
                        }
                        final googleAuth = await googleAccount.authentication;
                        final credential = GoogleAuthProvider.credential(
                          accessToken: googleAuth.accessToken,
                          idToken: googleAuth.idToken,
                        );
                        final userCredential = await FirebaseAuth.instance
                            .signInWithCredential(credential);
                        if (userCredential.user != null) {
                          String displayName =
                              userCredential.user!.displayName ??
                                  googleAccount.displayName ??
                                  '';
                          String firstName = '';
                          String lastName = '';
                          if (displayName.trim().isNotEmpty) {
                            List<String> parts =
                                displayName.trim().split(RegExp(r'\s+'));
                            firstName = parts.first;
                            if (parts.length > 1) {
                              lastName = parts.sublist(1).join(' ');
                            }
                          }

                          _loginData['email'] = userCredential.user!.email;
                          _loginData['phone'] =
                              userCredential.user!.phoneNumber ?? '';
                          _loginData['first_name'] = firstName;
                          _loginData['last_name'] = lastName;
                          _loginData['is_social_login'] = true;
                          _loginData['password'] = '123456';
                          _loginData['role'] =
                              (widget.argument?['role'] == 'Distributor')
                                  ? 'Distributor'
                                  : 'User';
                          _loginData['social_login_name'] = "GOOGLE";
                          var authModel =
                              Provider.of<AuthModel>(context, listen: false);
                          Map<String, dynamic> loginResult =
                              await authModel.login(loginData: _loginData);
                          if (_configModel.isLoggedIn) {
                            final user = _configModel.user;
                            final isWholesalerRole =
                                widget.argument?['role'] == 'Distributor';

                            if (isWholesalerRole) {
                              // Check if blocked
                              if (user?.isBlocked == 1) {
                                await FirebaseAuth.instance.signOut();
                                await GoogleSignIn().signOut();
                                await _configModel.removeLoginData();
                                setState(() => _isLoading = false);
                                _showWholesalerBlockedDialog(
                                    user?.blockedReason);
                                return;
                              }

                              // Check if rejected (only when not approved)
                              if (user?.isRejected == 1 &&
                                  user?.isApproved != 1) {
                                await FirebaseAuth.instance.signOut();
                                await GoogleSignIn().signOut();
                                await _configModel.removeLoginData();
                                setState(() => _isLoading = false);
                                _showWholesalerRejectedDialog(
                                    user?.rejectionReason);
                                return;
                              }

                              // Check if submitted business details (business name or address)
                              bool hasSubmittedBusinessDetails =
                                  (user?.businessName != null &&
                                          user!.businessName!
                                              .trim()
                                              .isNotEmpty) ||
                                      (user?.address != null &&
                                          user!.address!.trim().isNotEmpty);

                              if (!hasSubmittedBusinessDetails) {
                                setState(() => _isLoading = false);
                                _showWholesalerRequestBottomSheet(
                                  userId: user?.id?.toString() ?? '',
                                  isFromGoogle: true,
                                  googleName: displayName,
                                  googleEmail: userCredential.user?.email ??
                                      googleAccount.email,
                                );
                                return;
                              } else if (user?.isApproved != 1) {
                                // Completed profile, but pending admin approval
                                await FirebaseAuth.instance.signOut();
                                await GoogleSignIn().signOut();
                                await _configModel.removeLoginData();
                                setState(() => _isLoading = false);
                                _showWholesalerPendingDialog();
                                return;
                              }
                            }

                            Navigator.pushReplacementNamed(context, '/');
                          } else {
                            String errorMessage = loginResult['message'] ??
                                _configModel.loginFailedMessage;
                            String errorCode = loginResult['error'] ?? '';

                            if (errorCode == 'ACCOUNT_BLOCKED' ||
                                errorMessage
                                    .toLowerCase()
                                    .contains('blocked')) {
                              _showWholesalerBlockedDialog(
                                  loginResult['blocked_reason']);
                            } else if (errorCode == 'ACCOUNT_REJECTED' ||
                                errorMessage
                                    .toLowerCase()
                                    .contains('rejected')) {
                              _showWholesalerRejectedDialog(
                                  loginResult['rejection_reason']);
                            } else if (errorCode == 'APPROVAL_PENDING' ||
                                errorMessage
                                    .toLowerCase()
                                    .contains('pending approval')) {
                              final user = _configModel.user;
                              bool hasSubmittedBusinessDetails =
                                  (user?.businessName != null &&
                                          user!.businessName!
                                              .trim()
                                              .isNotEmpty) ||
                                      (user?.address != null &&
                                          user!.address!.trim().isNotEmpty);

                              if (!hasSubmittedBusinessDetails) {
                                setState(() => _isLoading = false);
                                _showWholesalerRequestBottomSheet(
                                  userId: user?.id?.toString() ?? '',
                                  isFromGoogle: true,
                                  googleName: displayName,
                                  googleEmail: userCredential.user?.email ??
                                      googleAccount.email,
                                );
                              } else {
                                _showWholesalerPendingDialog();
                              }
                            } else if (errorMessage
                                    .toLowerCase()
                                    .contains('already exists') ||
                                errorMessage
                                    .toLowerCase()
                                    .contains('already registered') ||
                                errorMessage
                                    .toLowerCase()
                                    .contains('user exists')) {
                              _showExistingUserDialog();
                            } else {
                              _showGenericErrorDialog(errorMessage);
                            }
                          }
                        }
                      } catch (e) {
                        String errorMessage =
                            'An error occurred during Google Sign-In';
                        if (e is FirebaseAuthException) {
                          errorMessage =
                              'Firebase Auth Error: ${e.code} - ${e.message}';
                        } else {
                          errorMessage = 'Error: $e';
                        }
                        print(errorMessage);
                        _showGenericErrorDialog(errorMessage);
                      } finally {
                        setState(() => _isLoading = false);
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: inputBorderColor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/googleic-3Lc.png',
                              width: 20, height: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Continue with Google',
                            style: MyGoogleFontStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff1e232c),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Register Link - Outside Card
                  Center(
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(context, '/registerPage',
                          arguments: {'role': widget.argument['role']}),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account? ",
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                            TextSpan(
                              text: 'Register Now',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Picks an image for the wholesaler bottom sheet form
  Future<void> _bsPickImage(
      {required bool isVisitingCard,
      required StateSetter setModalState}) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 50,
                  );
                  if (pickedFile != null) {
                    setModalState(() {
                      if (isVisitingCard) {
                        _bsVisitingCardImage = File(pickedFile.path);
                      } else {
                        _bsShopImage = File(pickedFile.path);
                      }
                    });
                    setState(() {});
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Select from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 50,
                  );
                  if (pickedFile != null) {
                    setModalState(() {
                      if (isVisitingCard) {
                        _bsVisitingCardImage = File(pickedFile.path);
                      } else {
                        _bsShopImage = File(pickedFile.path);
                      }
                    });
                    setState(() {});
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Show wholesaler request bottom sheet after Google sign-in for new wholesaler
  void _showWholesalerRequestBottomSheet({
    required String userId,
    bool isFromGoogle = true,
    String? googleName,
    String? googleEmail,
  }) {
    final bsFormKey = GlobalKey<FormState>();
    bool bsLoading = false;
    TextEditingController regDateController = TextEditingController(
      text: _bsWholesalerData['registration_date'] ?? '',
    );

    bool bsObscurePassword = true;
    bool bsObscureConfirmPassword = true;

    final user = _configModel.user;
    String resolvedGoogleFullName =
        (googleName != null && googleName.trim().isNotEmpty)
            ? googleName.trim()
            : (user != null
                ? '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim()
                : (_loginData['first_name'] ?? ''));

    String resolvedGoogleEmail =
        (googleEmail != null && googleEmail.trim().isNotEmpty)
            ? googleEmail.trim()
            : (user?.email ?? _loginData['email'] ?? '');

    String initialName = (_bsWholesalerData['first_name'] != null &&
            _bsWholesalerData['first_name'].toString().trim().isNotEmpty)
        ? _bsWholesalerData['first_name'].toString().trim()
        : resolvedGoogleFullName;

    String initialEmail = (_bsWholesalerData['email'] != null &&
            _bsWholesalerData['email'].toString().trim().isNotEmpty)
        ? _bsWholesalerData['email'].toString().trim()
        : resolvedGoogleEmail;

    TextEditingController fullNameController =
        TextEditingController(text: initialName);
    TextEditingController emailController =
        TextEditingController(text: initialEmail);

    if (isFromGoogle) {
      _bsWholesalerData['first_name'] = initialName;
      _bsWholesalerData['email'] = initialEmail;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bsContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xffDDDDDD),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 16.w, 20.w, 0),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9A825).withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.store,
                              color: Color(0xFFF9A825), size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wholesaler Request',
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xff1e232c),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Fill in your business details to complete registration',
                                style: MyGoogleFontStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 12.0.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff8390a1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 24, color: Color(0xffF0F0F0)),
                  // Scrollable form
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.w),
                      child: Form(
                        key: bsFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Full Name (Required)
                            _buildBsTextField(
                              hintText: 'Full Name',
                              controller: fullNameController,
                              readOnly: isFromGoogle,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Full name cannot be empty';
                                }
                                return null;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['first_name'] =
                                      value?.trim() ?? fullNameController.text,
                            ),
                            const SizedBox(height: 10),
                            // Email (Required)
                            _buildBsTextField(
                              hintText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              readOnly: isFromGoogle,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email cannot be empty';
                                }
                                if (!_isValidEmail(value.trim())) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              onSaved: (value) => _bsWholesalerData['email'] =
                                  value?.trim() ?? emailController.text,
                            ),
                            const SizedBox(height: 10),
                            // Phone Number (Required)
                            _buildBsTextField(
                              hintText: 'Phone Number',
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Phone number is required';
                                }
                                if (value.trim().length < 10) {
                                  return 'Please enter a valid 10-digit phone number';
                                }
                                return null;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['phone'] = value?.trim(),
                            ),
                            const SizedBox(height: 10),
                            // Password (Required)
                            _buildBsTextField(
                              hintText: 'Password',
                              obscureText: bsObscurePassword,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    bsObscurePassword = !bsObscurePassword;
                                  });
                                },
                                child: Icon(
                                  bsObscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xff8390a1),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password cannot be empty';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                _bsWholesalerData['password'] = value;
                                return null;
                              },
                              onChanged: (value) {
                                _bsWholesalerData['password'] = value;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['password'] = value,
                            ),
                            const SizedBox(height: 10),
                            // Confirm Password (Required)
                            _buildBsTextField(
                              hintText: 'Confirm Password',
                              obscureText: bsObscureConfirmPassword,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    bsObscureConfirmPassword =
                                        !bsObscureConfirmPassword;
                                  });
                                },
                                child: Icon(
                                  bsObscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xff8390a1),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Confirm password cannot be empty';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                if (value != _bsWholesalerData['password']) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['confirm_password'] = value,
                            ),
                            const SizedBox(height: 10),
                            // Business Name (Required)
                            _buildBsTextField(
                              hintText: 'Business Name',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Business Name is required';
                                }
                                return null;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['business_name'] = value,
                            ),
                            const SizedBox(height: 10),
                            // Trade Name (Optional)
                            _buildBsTextField(
                              hintText: 'Trade Name',
                              onSaved: (value) =>
                                  _bsWholesalerData['trade_name'] = value,
                            ),
                            const SizedBox(height: 10),
                            // Registration Date (Optional)
                            TextFormField(
                              readOnly: true,
                              controller: regDateController,
                              decoration: _bsInputDecoration(
                                hintText: 'Registration Date',
                                suffixIcon: const Icon(Icons.calendar_today,
                                    color: Color(0xff8390a1)),
                              ),
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 14.0.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.25,
                                color: const Color(0xff000000),
                              ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  setModalState(() {
                                    _bsWholesalerData['registration_date'] =
                                        '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
                                    regDateController.text =
                                        _bsWholesalerData['registration_date'];
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            // GST Checkbox
                            Row(
                              children: [
                                Checkbox(
                                  value: _bsHasGst,
                                  onChanged: (value) {
                                    setModalState(() {
                                      _bsHasGst = value!;
                                      if (!_bsHasGst) {
                                        _bsWholesalerData['gst_number'] = '';
                                      }
                                    });
                                  },
                                  activeColor: const Color(0xff1A1A1A),
                                ),
                                Text(
                                  'I have GST Number',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 14.0.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff1A1A1A),
                                  ),
                                ),
                              ],
                            ),
                            if (_bsHasGst) ...[
                              _buildBsTextField(
                                hintText: 'GST Number',
                                textCapitalization:
                                    TextCapitalization.characters,
                                validator: (value) {
                                  if (_bsHasGst &&
                                      (value == null || value.trim().isEmpty)) {
                                    return 'GST Number is required';
                                  }
                                  return null;
                                },
                                onSaved: (value) =>
                                    _bsWholesalerData['gst_number'] = value,
                              ),
                              const SizedBox(height: 10),
                            ],
                            // Address
                            _buildBsTextField(
                              hintText: 'Business Address',
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Address is required';
                                return null;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['address'] = value,
                            ),
                            const SizedBox(height: 10),
                            // Pincode
                            _buildBsTextField(
                              hintText: 'Pincode',
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Pincode required';
                                if (value.length != 6) return 'Invalid pincode';
                                return null;
                              },
                              onSaved: (value) =>
                                  _bsWholesalerData['pincode_business'] = value,
                            ),
                            const SizedBox(height: 10),
                            // State & City picker
                            CSCPickerPlus(
                              layout: Layout.vertical,
                              showStates: true,
                              showCities: true,
                              flagState: CountryFlag.DISABLE,
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.66),
                                color: const Color(0xfff7f8f9),
                                border:
                                    Border.all(color: const Color(0xffe8ecf4)),
                              ),
                              disabledDropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.66),
                                color: const Color(0xfff7f8f9),
                                border:
                                    Border.all(color: const Color(0xffe8ecf4)),
                              ),
                              countrySearchPlaceholder: "Search Country",
                              stateSearchPlaceholder: "Search State",
                              citySearchPlaceholder: "Search City",
                              countryDropdownLabel: "Select Country",
                              stateDropdownLabel: "Select State",
                              cityDropdownLabel: "Select City",
                              defaultCountry: CscCountry.India,
                              disableCountry: false,
                              selectedItemStyle: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 14.0.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                              dropdownHeadingStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                              dropdownItemStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              dropdownDialogRadius: 10.0,
                              searchBarRadius: 10.0,
                              onCountryChanged: (value) {},
                              onStateChanged: (value) {
                                setModalState(() {
                                  _bsWholesalerData['state_business'] =
                                      value?.toString() ?? "";
                                });
                              },
                              onCityChanged: (value) {},
                            ),
                            const SizedBox(height: 16),
                            // Upload Documents header
                            Text(
                              'Upload Documents',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 16.0.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff1e232c),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Visiting Card
                            Text(
                              'Visiting Card',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 13.0.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff8390a1),
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => _bsPickImage(
                                  isVisitingCard: true,
                                  setModalState: setModalState),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xffe8ecf4), width: 2),
                                  color: const Color(0xfff7f8f9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: _bsVisitingCardImage != null
                                    ? Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              _bsVisitingCardImage!,
                                              height: 120,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () {
                                                setModalState(() {
                                                  _bsVisitingCardImage = null;
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(Icons.close,
                                                    color: Colors.white,
                                                    size: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                              Icons.cloud_upload_outlined,
                                              color: Color(0xff8390a1),
                                              size: 28),
                                          const SizedBox(width: 10),
                                          Text(
                                            'Tap to upload visiting card',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 14.0.sp,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff8390a1),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Shop Image
                            Text(
                              'Shop Image',
                              style: MyGoogleFontStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 13.0.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff8390a1),
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => _bsPickImage(
                                  isVisitingCard: false,
                                  setModalState: setModalState),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xffe8ecf4), width: 2),
                                  color: const Color(0xfff7f8f9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: _bsShopImage != null
                                    ? Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              _bsShopImage!,
                                              height: 120,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () {
                                                setModalState(() {
                                                  _bsShopImage = null;
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(Icons.close,
                                                    color: Colors.white,
                                                    size: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                              Icons.cloud_upload_outlined,
                                              color: Color(0xff8390a1),
                                              size: 28),
                                          const SizedBox(width: 10),
                                          Text(
                                            'Tap to upload shop image',
                                            style: MyGoogleFontStyle(
                                              fontFamily: 'Urbanist',
                                              fontSize: 14.0.sp,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff8390a1),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Submit button
                  Container(
                    padding: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: bsLoading
                              ? null
                              : () async {
                                  if (bsFormKey.currentState!.validate()) {
                                    bsFormKey.currentState!.save();
                                    setModalState(() => bsLoading = true);

                                    try {
                                      var authModel = Provider.of<AuthModel>(
                                          context,
                                          listen: false);

                                      // Upload documents
                                      if (userId.isNotEmpty &&
                                          (_bsVisitingCardImage != null ||
                                              _bsShopImage != null)) {
                                        await authModel
                                            .uploadWholesalerDocuments(
                                          userId: userId,
                                          visitingCardImage:
                                              _bsVisitingCardImage,
                                          shopImage: _bsShopImage,
                                        );
                                      }

                                      // Update user with business details
                                      if (userId.isNotEmpty) {
                                        await authModel.updateUser(
                                          updateUserData: _bsWholesalerData,
                                        );
                                      }

                                      // Close bottom sheet
                                      Navigator.of(bsContext).pop();

                                      // Logout user (wholesaler needs approval first)
                                      await FirebaseAuth.instance.signOut();
                                      await GoogleSignIn().signOut();
                                      await _configModel.removeLoginData();

                                      // Show pending approval dialog
                                      _showWholesalerPendingDialog();
                                    } catch (e) {
                                      print('Wholesaler request error: $e');
                                      setModalState(() => bsLoading = false);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Failed to submit. Please try again.'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0f0f0f),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: bsLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Submit Wholesaler Request',
                                  style: MyGoogleFontStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 15.0.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Builds a styled text field for the wholesaler bottom sheet
  Widget _buildBsTextField({
    required String hintText,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
    bool obscureText = false,
    bool readOnly = false,
    Widget? suffixIcon,
    TextEditingController? controller,
    String? initialValue,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      readOnly: readOnly,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: _bsInputDecoration(
          hintText: hintText, suffixIcon: suffixIcon, readOnly: readOnly),
      style: MyGoogleFontStyle(
        fontFamily: 'Urbanist',
        fontSize: 14.0.sp,
        fontWeight: FontWeight.w500,
        height: 1.25,
        color: readOnly ? const Color(0xff8390a1) : const Color(0xff000000),
      ),
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
    );
  }

  /// Standard InputDecoration for the bottom sheet form
  InputDecoration _bsInputDecoration(
      {required String hintText, Widget? suffixIcon, bool readOnly = false}) {
    return InputDecoration(
      filled: true,
      fillColor: readOnly ? const Color(0xffeef0f2) : const Color(0xfff7f8f9),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xffe8ecf4)),
        borderRadius: BorderRadius.circular(7.66),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xffe8ecf4)),
        borderRadius: BorderRadius.circular(7.66),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(7.66),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(7.66),
      ),
      contentPadding: EdgeInsets.fromLTRB(17.94.w, 16.34.w, 17.94.w, 17.66.w),
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xff8390a1)),
      counterText: '',
      suffixIcon: suffixIcon,
    );
  }

  /// Show "Pending Approval" dialog after wholesaler request
  void _showWholesalerPendingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF9A825),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.hourglass_empty,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Request Submitted!',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff1e1e1e),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Your wholesaler request has been submitted successfully. Please wait for admin approval. You will be notified once your account is approved and ready to use.',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/loginPage',
                          arguments: {'role': widget.argument?['role']});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffc9b758),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Back to Login',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Show "Account Blocked / Blacklisted" dialog for Wholesalers
  void _showWholesalerBlockedDialog([String? reason]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD32F2F),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.block,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Account Blocked',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff1e1e1e),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Your wholesaler account has been blocked/blacklisted by admin.\n\n${reason != null && reason.trim().isNotEmpty ? "Reason: $reason\n\n" : ""}Please contact support for assistance.',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Understand',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Show "Account Rejected" dialog for Wholesalers
  void _showWholesalerRejectedDialog([String? reason]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE65100),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Request Rejected',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff1e1e1e),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Your wholesaler account request has been rejected by admin.\n\n${reason != null && reason.trim().isNotEmpty ? "Reason: $reason\n\n" : ""}You can still log in and use your account as a Customer.',
                  style: MyGoogleFontStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff666666),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Login as Customer Button
                Container(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      _loginData['role'] = 'User';
                      setState(() => _isLoading = true);
                      try {
                        var authModel =
                            Provider.of<AuthModel>(context, listen: false);
                        await authModel.login(loginData: _loginData);
                        if (_configModel.isLoggedIn) {
                          Navigator.pushReplacementNamed(context, '/');
                        } else {
                          Navigator.pushReplacementNamed(
                            context,
                            '/loginPage',
                            arguments: {'role': 'User'},
                          );
                        }
                      } catch (e) {
                        Navigator.pushReplacementNamed(
                          context,
                          '/loginPage',
                          arguments: {'role': 'User'},
                        );
                      } finally {
                        setState(() => _isLoading = false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffc9b758),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Login as Customer',
                      style: MyGoogleFontStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Close button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Close',
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff666666),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
