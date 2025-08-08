import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorpay;
  final BuildContext context;

  RazorpayService({required this.context}) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout({
    required String amount,
    required String name,
    required String contact,
    required String email,
    String? orderId,
  }) {
    final options = {
      'key': 'razorpay key yaha paste karo',
      'amount': (double.parse(amount) * 100).toInt(),
      'description': 'Order Payment',
      'prefill': {
        'contact': contact,
        'email': email,
      },
      'order_id': orderId, // Optional
      'theme': {'color': '#F37254'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening Razorpay: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Payment Success: ${response.paymentId}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Successful!')),
    );

    Navigator.pushReplacementNamed(context, '/payment-success', arguments: {
      'payment_id': response.paymentId,
      'order_id': response.orderId,
      'signature': response.signature,
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Payment Error: ${response.code} | ${response.message}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Failed: ${response.message}')),
    );

    Navigator.pushReplacementNamed(context, '/payment-failure', arguments: {
      'code': response.code,
      'message': response.message,
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet selected: ${response.walletName}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Wallet: ${response.walletName} selected')),
    );
  }

  void dispose() {
    _razorpay.clear();
  }
}
