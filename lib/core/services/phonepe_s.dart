import 'dart:convert';
import 'package:aadab/core/models/payment_instrument.dart';
import 'package:aadab/core/models/payment_response.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PhonePeService {
  // Configuration - Using Sandbox for testing
  final String merchantId = "M231CJCCQCTYF"; // Test merchant ID
  final String flowId = "com.crazzycode.aadab";
  final String environmentValue = 'PRODUCTION'; // Use sandbox for testing
  final bool enableLogs = true;

  // V2 API credentials for testing
  final String clientId = "SU2509112100302056472244"; // Test client ID
  final String clientSecret =
      "3455cebd-53ca-41b3-b9f9-24ed90290997"; // Test client secret
  final String clientVersion = "1";

  // V2 API endpoints - Sandbox URLs
  final String _baseUrl = "https://api.phonepe.com/apis";
  final String _authEndpoint = "/identity-manager/v1/oauth/token";
  final String _orderEndpoint = "/pg/checkout/v2/sdk/order";
  final String _statusEndpoint = "/pg/checkout/v2/order";

  String? _authToken;
  DateTime? _tokenExpiry;

  /// Initialize PhonePe SDK as per V2 documentation
  Future<void> initializePhonePe() async {
    try {
      await PhonePePaymentSdk.init(
        environmentValue,
        merchantId,
        flowId,
        enableLogs,
      );
      debugPrint("PhonePe SDK initialized successfully");
    } catch (e) {
      debugPrint("PhonePe SDK initialization failed: $e");
      throw Exception("SDK initialization failed: $e");
    }
  }

  /// Step 1: Get authentication token as per V2 documentation
  Future<String> _getAuthToken() async {
    if (_authToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      return _authToken!;
    }

    try {
      // Prepare form data as per PhonePe V2 documentation
      final formData = {
        'client_id': 'SU2509112100302056472244',
        'client_version': '1',
        'client_secret': '3455cebd-53ca-41b3-b9f9-24ed90290997',
        'grant_type': 'client_credentials',
      };

      final response = await http.post(
        Uri.parse('$_baseUrl$_authEndpoint'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: formData,
      );

      debugPrint("Auth request URL: $_baseUrl$_authEndpoint");
      debugPrint("Auth request body: $formData");
      debugPrint("Auth response status: ${response.statusCode}");
      debugPrint("Auth response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _authToken = data['access_token'];
        _tokenExpiry =
            DateTime.fromMillisecondsSinceEpoch(data['expires_at'] * 1000);
        debugPrint("Auth token obtained successfully");
        return _authToken!;
      } else {
        throw Exception(
            'Auth failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("Auth token error: $e");
      throw Exception('Authentication failed: $e');
    }
  }

  /// Step 2: Create order as per V2 documentation
  Future<String> createOrder({
    required String merchantOrderId,
    required int amount, // Amount in paisa
  }) async {
    try {
      final authToken = await _getAuthToken();

      final orderPayload = {
        'merchantOrderId': merchantOrderId,
        'amount': amount,
        "paymentFlow": {"type": "PG_CHECKOUT"}
      };

      final response = await http.post(
        Uri.parse('$_baseUrl$_orderEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'O-Bearer $authToken',
        },
        body: json.encode(orderPayload),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("Order creation response: $responseData");
        final orderToken = responseData['token'];
        final orderId = responseData['orderId'];
        debugPrint("Order created successfully. Token: $orderToken");
        return '$orderToken - $orderId';
      } else {
        throw Exception(
            'Order creation failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("Order creation error: $e");
      throw Exception('Order creation failed: $e');
    }
  }

  /// Step 3: Start transaction using SDK as per V2 documentation
  Future<Payment?> startTransaction({
    required String merchantOrderId,
    required int amount,
  }) async {
    try {
      debugPrint("Attempting V2 order creation flow...");

      // Try V2 order creation first
      try {
        final orderToken = await createOrder(
          merchantOrderId: merchantOrderId,
          amount: amount,
        );

        // For V2, wrap the order token in the required JSON structure
        final token = orderToken.split(' - ').first;
        final orderId = orderToken.split(' - ').last;

        // Create the V2 request structure the SDK expects
        final v2Request = {
          "token": token,
          "orderId": orderId,
          "paymentMode": {"type": "PAY_PAGE"}
        };

        final requestBody = json.encode(v2Request);
        debugPrint("V2 request with token wrapper: $requestBody");

        // Try with JSON first
        var response = await PhonePePaymentSdk.startTransaction(
          requestBody, // V2 token wrapped in JSON
          "", // App schema for callbacks
        );

        // If JSON fails with conversion error, try base64 encoding
        if (response != null &&
            response['status'] == 'FAILURE' &&
            response['error']
                    ?.toString()
                    .contains('cannot be converted to JSONObject') ==
                true) {
          debugPrint("JSON format failed, trying base64 encoding for V2 token");

          final base64Request = base64.encode(utf8.encode(requestBody));
          debugPrint(
              "Base64 encoded V2 request: ${base64Request.substring(0, 50)}...");

          response = await PhonePePaymentSdk.startTransaction(
            base64Request, // Base64 encoded V2 request
            "",
          );
        }

        debugPrint("V2 SDK Response: $response");

        if (response != null) {
          final status = response['status']?.toString() ?? 'UNKNOWN';

          if (status == 'SUCCESS') {
            return await checkOrderStatus(merchantOrderId);
          } else {
            return Payment(
              state: status,
              merchantId: merchantId,
              transactionId: merchantOrderId,
            );
          }
        } else {
          throw Exception("No response from SDK");
        }
      } catch (orderError) {
        debugPrint("V2 transaction failed: $orderError");
        throw Exception("V2 transaction failed: $orderError");
      }
    } catch (e) {
      debugPrint("Transaction error: $e");
      throw Exception('Transaction failed: $e');
    }
  }

  /// Step 4: Check order status as per V2 documentation
  Future<Payment?> checkOrderStatus(String merchantOrderId) async {
    try {
      final authToken = await _getAuthToken();

      final response = await http.get(
        Uri.parse('$_baseUrl$_statusEndpoint/$merchantOrderId/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'O-Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        debugPrint("Status check response: $responseData");

        final state = responseData['state'];

        if (state == 'COMPLETED') {
          final payment = Payment(
            merchantId: merchantId,
            transactionId: responseData['orderId'],
            amount: responseData['amount'],
            state: 'COMPLETED',
            responseCode: 'SUCCESS',
          );

          // Parse payment instrument if available
          if (responseData['paymentDetails'] != null &&
              responseData['paymentDetails'].isNotEmpty) {
            final paymentDetail = responseData['paymentDetails'][0];
            if (paymentDetail['paymentInstrument'] != null) {
              payment.paymentInstrument = PaymentInstrument.fromJson(
                  paymentDetail['paymentInstrument']);
            }
          }

          return payment;
        } else {
          return Payment(
            merchantId: merchantId,
            transactionId: responseData['orderId'],
            amount: responseData['amount'],
            state: state,
            responseCode: state == 'FAILED' ? 'FAILURE' : state,
          );
        }
      } else {
        throw Exception('Status check failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Status check error: $e");
      throw Exception('Status check failed: $e');
    }
  }
}
