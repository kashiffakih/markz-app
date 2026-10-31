import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aadab/core/providers/product_pr.dart';
import 'package:aadab/ui/shared/font_sh.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBanners();
  }

  Future<void> _loadBanners() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<ProductModel>(context, listen: false).getBanners();
    } catch (e) {
      if (mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Failed to load contact information: $e')),
        // );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProductModel>(context, listen: false);
    return Scaffold(
      body: Container(
        width: 1.0.sw,
        height: 1.0.sh,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFEF9), Color(0xFFFFFDF7), Colors.white],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFEED056).withOpacity(0.15),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFEED056)),
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Loading...',
                          style: MyGoogleFontStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff232323),
                          )),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        _buildHeader(context),
                        _buildBody(context, productModel),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0.w, vertical: 10.0.w),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8.0.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFEED056).withOpacity(0.15),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 16.0.sp,
                color: const Color(0xffEED056),
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Contact Us',
              textAlign: TextAlign.center,
              style: MyGoogleFontStyle(
                fontFamily: 'Urbanist',
                fontSize: 20.0.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff1e232c),
              ),
            ),
          ),
          SizedBox(width: 48.0.w),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductModel productModel) {
    return Container(
      margin: EdgeInsets.all(10.0.w),
      child: Column(
        children: [
          _buildContactItem(
            context: context,
            title: 'Email',
            subtitle: productModel.banners?['email']?.toString() ??
                'No email available',
            icon: Icons.email,
            onTap: () async {
              final email = productModel.banners?['email']?.toString() ?? '';
              if (email.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email address not available')),
                );
                return;
              }
              final emailUri = Uri(
                scheme: 'mailto',
                path: email,
                query: 'subject=${Uri.encodeComponent("Hello Markz")}',
              );
              try {
                if (!await launchUrl(emailUri)) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not open email app')),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to open email: $e')),
                  );
                }
              }
            },
          ),
          _buildContactItem(
            context: context,
            title: 'WhatsApp',
            subtitle: '+${productModel.banners?['phone']?.toString()}' ??
                'No phone number available',
            icon: Icons.message,
            onTap: () async {
              final phone =
                  '+${productModel.banners?['phone']?.toString()}' ?? '';
              if (phone.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Phone number not available')),
                );
                return;
              }
              final whatsappUri = Uri.parse('whatsapp://send?phone=$phone');
              try {
                if (!await launchUrl(whatsappUri)) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not open WhatsApp')),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to open WhatsApp: $e')),
                  );
                }
              }
            },
          ),
          _buildContactItem(
            context: context,
            title: 'Call Us',
            subtitle: '+${productModel.banners?['phone']?.toString()}' ??
                'No phone number available',
            icon: Icons.phone,
            onTap: () async {
              final phone =
                  '+${productModel.banners?['phone']?.toString()}' ?? '';
              if (phone.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Phone number not available')),
                );
                return;
              }
              final phoneUri = Uri(scheme: 'tel', path: phone);
              try {
                if (!await launchUrl(phoneUri)) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not open phone app')),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to call: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0.w),
        padding: EdgeInsets.all(16.0.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16.0.r)),
          border: Border.all(
            color: const Color(0xffEED056).withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEED056).withOpacity(0.12),
              offset: Offset(0, 6),
              blurRadius: 20,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 16.0.w),
              padding: EdgeInsets.all(12.0.w),
              decoration: BoxDecoration(
                color: const Color(0xFFEED056).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.0.r),
                border: Border.all(
                  color: const Color(0xFFEED056).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                size: 24.0.w,
                color: const Color(0xffEED056),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 16.0.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff232323),
                    ),
                  ),
                  SizedBox(height: 4.0.w),
                  Text(
                    subtitle,
                    style: MyGoogleFontStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff909090),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: const Color(0xffEED056),
            ),
          ],
        ),
      ),
    );
  }
}
