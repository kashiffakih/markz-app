import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// import 'package:get_ip_address/get_ip_address.dart';
// import 'package:google_sign_in/google_sign_in.dart';
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
                                      widget.argument?['role'] ?? 'Customer';
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
                                            'Access Denied: This account is not registered as a Distributor.');
                                        setState(() => _isLoading = false);
                                        return;
                                      }
                                    } else {
                                      // Check if logged in as User/Customer but user doesn't have the role
                                      final user = _configModel.user;
                                      final hasUserRole = user?.roles
                                              ?.any((r) => r.name == 'User') ??
                                          false;

                                      if (!hasUserRole) {
                                        // Auto-logout and show error
                                        _configModel.clearUserData();
                                        _showGenericErrorDialog(
                                            'Access Denied: This account is not registered as a User.');
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
                                      _showGenericErrorDialog(
                                          'Your wholesaler account is pending approval. Please wait for admin approval before logging in.');
                                    } else if (loginResult['error'] ==
                                            'ACCOUNT_BLOCKED' ||
                                        errorMessage
                                            .toLowerCase()
                                            .contains('blocked')) {
                                      String blockedMessage =
                                          'Your wholesaler account has been blocked. Please contact admin for assistance.';
                                      if (loginResult
                                              .containsKey('blocked_reason') &&
                                          loginResult['blocked_reason'] !=
                                              null) {
                                        blockedMessage =
                                            'Your wholesaler account has been blocked.\nReason: ${loginResult['blocked_reason']}\nPlease contact admin for assistance.';
                                      }
                                      _showGenericErrorDialog(blockedMessage);
                                    } else if (loginResult['error'] ==
                                            'ACCOUNT_REJECTED' ||
                                        errorMessage
                                            .toLowerCase()
                                            .contains('rejected')) {
                                      String rejectedMessage =
                                          'Your wholesaler account has been rejected. Please contact admin for assistance.';
                                      if (loginResult.containsKey(
                                              'rejection_reason') &&
                                          loginResult['rejection_reason'] !=
                                              null) {
                                        rejectedMessage =
                                            'Your wholesaler account has been rejected.\nReason: ${loginResult['rejection_reason']}\nPlease contact admin for assistance.';
                                      }
                                      _showGenericErrorDialog(rejectedMessage);
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
                          _loginData['email'] = userCredential.user!.email;
                          _loginData['phone'] =
                              userCredential.user!.phoneNumber;
                          _loginData['first_name'] =
                              userCredential.user!.displayName;
                          _loginData['is_social_login'] = true;
                          _loginData['password'] = '123456';
                          _loginData['role'] = widget.argument['role'];
                          _loginData['social_login_name'] = "GOOGLE";
                          var authModel =
                              Provider.of<AuthModel>(context, listen: false);
                          await authModel.login(loginData: _loginData);
                          if (_configModel.isLoggedIn) {
                            Navigator.pushReplacementNamed(context, '/');
                          } else {
                            String errorMessage =
                                _configModel.loginFailedMessage;
                            if (errorMessage
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
}
