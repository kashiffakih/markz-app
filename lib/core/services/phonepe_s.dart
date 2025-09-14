import 'dart:convert';
import 'package:aadab/core/models/payment_instrument.dart';
import 'package:aadab/core/models/payment_response.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
// import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PhonePeService {
  // final PhonePeModel _phonePeModel = locator<PhonePeModel>();
  final String merchantId = "M231CJCCQCTYF"; //live
  final String appId = "com.crazzycode.aadab";
  final String environmentValue =
      'RELEASE'; //live - PhonePe expects RELEASE for production
  // final String environment = 'UAT_SIM';
  final String packageName = "com.crazzycode.aadab";
  final bool enableLogs = true;
  // final String callback = "https://webhook.site/fc47ee05-89c1-4418-89b1-e554ab833df1";
  final String callback = "https://aadab.online/callback";
  // final String saltKey = "96434309-7796-489d-8924-ab56988a6076"; //test
  final String saltKey = "3455cebd-53ca-41b3-b9f9-24ed90290997"; //production
  final String saltIndex = "1";
  final String apiEndPoint = "/pg/v1/pay";
  Object? result;
  Payment? payment;

  // Public method to initialize the PhonePe SDK
  Future<void> initializePhonePe() async {
    try {
      // According to PhonePe docs: init(environmentValue, merchantId, flowId, enableLogs)
      debugPrint("Initializing PhonePe with:");
      debugPrint("Environment: $environmentValue");
      debugPrint("Merchant ID: $merchantId");
      debugPrint("Package Name: $packageName");

      await PhonePePaymentSdk.init(this.environmentValue, this.merchantId,
          this.merchantId, this.enableLogs);
      debugPrint("PhonePe SDK Initialized successfully");

      // Note: Package signature mismatch warnings can be ignored in development
      // For production, ensure the package signature is registered with PhonePe
    } catch (error) {
      debugPrint("Error Initializing PhonePe SDK: $error");
      // Don't throw error for package signature mismatch in development
      if (!error.toString().contains("PACKAGE_SIGNATURE_MISMATCHED")) {
        throw Exception("Failed to initialize PhonePe SDK: $error");
      } else {
        debugPrint(
            "Package signature mismatch - this can be ignored in development");
      }
    }
  }

  Future<Payment?> startTransaction(Map<String, dynamic> requestData,
      String appSchema, BuildContext context) async {
    try {
      // Create the proper payload structure for PhonePe SDK
      String merchantTransactionId = requestData['orderId'];
      int amount = requestData['amount'];
      String merchantUserId = requestData['merchantUserId'];
      String mobileNumber = requestData['mobileNumber'] ?? '';

      // Create the proper request body structure according to PhonePe API docs
      Map<String, dynamic> body = {
        "merchantId": this.merchantId,
        "orderId": merchantTransactionId, // PhonePe expects 'orderId' field
        "token":
            merchantTransactionId, // PhonePe expects 'token' field (same as orderId)
        "merchantUserId": merchantUserId,
        "amount": amount,
        "redirectUrl": this.callback,
        "redirectMode": "POST",
        "callbackUrl": this.callback,
        "paymentMode": {"type": "PAY_PAGE"}
      };

      debugPrint("PhonePe Request Body: ${jsonEncode(body)}");
      debugPrint("App schema: $appSchema");

      // Start the transaction using the SDK - Convert Map to JSON String
      String jsonBody = jsonEncode(body);
      final response =
          await PhonePePaymentSdk.startTransaction(jsonBody, appSchema).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          debugPrint("PhonePe transaction timed out");
          throw Exception("Transaction timed out");
        },
      );

      debugPrint("Transaction Response: $response");

      if (response != null) {
        String status = response['status']?.toString() ?? "UNKNOWN";
        String error = response['error']?.toString() ?? "No error message";

        debugPrint("Transaction Status: $status");
        debugPrint("Transaction Error: $error");

        // Handle response according to PhonePe documentation
        switch (status) {
          case 'SUCCESS':
            result = "Flow Completed - Status: Success!";
            // Check payment status after successful flow
            payment = await checkStatus(merchantTransactionId, context) ??
                Payment(state: "UNKNOWN");
            break;
          case 'FAILURE':
            payment = Payment(state: "FAILED", message: error);
            result = "Flow Completed - Status: $status and Error: $error";
            break;
          case 'INTERRUPTED':
            payment = Payment(
                state: "CANCELLED",
                message: "Transaction was interrupted by user");
            result = "Flow Interrupted - Status: $status";
            break;
          default:
            payment = Payment(state: status, message: error);
            result = "Flow Completed - Status: $status and Error: $error";
        }
      } else {
        payment = Payment(state: "FAILED", message: "No response from PhonePe");
        result = "Flow Incomplete - No response received";
      }
    } catch (error) {
      debugPrint("Error during transaction: $error");
      payment = Payment(state: "FAILED", message: error.toString());
      result = "Transaction Failed: $error";
    }

    debugPrint("Final Payment State: ${payment?.state ?? 'NULL'}");
    return payment;
  }

  Future<Payment?> checkStatus(
      String merchantTransactionId, BuildContext context) async {
    try {
      String url =
          "https://api.phonepe.com/apis/hermes/pg/v1/status/${this.merchantId}/$merchantTransactionId";

      String concatString =
          "/pg/v1/status/${this.merchantId}/$merchantTransactionId${this.saltKey}";
      var digest = sha256.convert(utf8.encode(concatString));
      String xVerify = "$digest###${this.saltIndex}";

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "X-VERIFY": xVerify,
        "X-MERCHANT-ID": this.merchantId,
        "accept": "application/json"
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        debugPrint("Response: $responseData");

        if (responseData['success'] == true &&
            responseData['code'] == "PAYMENT_SUCCESS" &&
            responseData['data']['state'] == "COMPLETED") {
          // Payment payment = Payment.fromJson(responseData['data']);
          //
          //
          // _phonePeModel.setPayment(payment);
          // debugPrint("Payment Details: ${_phonePeModel.payment?.amount}");
          // Parse the Payment object from response data
          Payment payment = Payment.fromJson(responseData['data']);

// Assign the nested PaymentInstrument if available
          if (responseData['data']['paymentInstrument'] != null) {
            payment.paymentInstrument = PaymentInstrument.fromJson(
                responseData['data']['paymentInstrument']);
          }

// Set the Payment instance in your model
          // _phonePeModel.setPayment(payment);
          // _phonePeModel.transactionId = payment.transactionId!;
// Debug Payment and PaymentInstrument details
          // debugPrint("Payment Details:");
          // debugPrint("Amount: ${_phonePeModel.payment?.amount}");
          // debugPrint("Merchant ID: ${_phonePeModel.payment?.merchantId}");
          // debugPrint("Transaction ID: ${_phonePeModel.payment?.transactionId}");
          // debugPrint("State: ${_phonePeModel.payment?.state}");
          // debugPrint("Response Code: ${_phonePeModel.payment?.responseCode}");

// Debug PaymentInstrument details
          if (payment.paymentInstrument != null) {
            debugPrint("Payment Instrument Details:");
            debugPrint("Type: ${payment.paymentInstrument?.type}");
            debugPrint("Provider: ${payment.paymentInstrument?.accountType}");
          } else {
            debugPrint("No Payment Instrument Found.");
          }

          return payment;
        } else {
          debugPrint("Transaction Failed: Something went wrong");
          return Payment(
              state: "FAILED",
              message: responseData['message'] ?? "Transaction failed");
        }
      } else {
        debugPrint(
            "HTTP Error: ${response.statusCode} - ${response.reasonPhrase}");
        return Payment(
            state: "FAILED", message: "HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Exception: $e");
      return Payment(state: "FAILED", message: e.toString());
    }
  }
}
