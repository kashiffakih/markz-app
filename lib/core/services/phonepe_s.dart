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
  // final String merchantId = "PGTESTPAYUAT86"; //test
  final String merchantId = "M231CJCCQCTYF"; //live
  final String appId = "com.crazzycode.aadab";
  // final String environmentValue = 'SANDBOX'; //test
  final String environmentValue = 'PRODUCTION'; //live
  // final String environment = 'UAT_SIM';
  final String packageName = "com.crazzycode.aadab";
  final bool enableLogs = true;
  // final String callback = "https://webhook.site/fc47ee05-89c1-4418-89b1-e554ab833df1";
  final String callback = "https://webhook.site/callback-url";
  // final String saltKey = "96434309-7796-489d-8924-ab56988a6076"; //test
  final String saltKey = "3455cebd-53ca-41b3-b9f9-24ed90290997"; //production
  final String saltIndex = "1";
  final String apiEndPoint = "/pg/v1/pay";
  final String transactionId = DateTime.now().millisecondsSinceEpoch.toString();
  Object? result;
  Payment? payment;

  // Public method to initialize the PhonePe SDK
  Future<void> initializePhonePe() async {
    await PhonePePaymentSdk.init(
        environmentValue, appId, merchantId, enableLogs);
    //print("PhonePe SDK Initialized");
  }

  Future<Payment?> startTransaction(String body, String callback,
      String checksum, BuildContext context) async {
    try {
      final response = await PhonePePaymentSdk.startTransaction(body, checksum);

      debugPrint("Transaction Response: $response");

      if (response != null) {
        String status = response['status']?.toString() ?? "UNKNOWN";
        String error = response['error']?.toString() ?? "No error message";

        if (status == 'SUCCESS') {
          result = "Flow Completed - Status: Success!";
          payment = await checkStatus(context) ?? Payment(state: "UNKNOWN");
        } else {
          payment ??= Payment(state: "UNKNOWN");
          payment!.state = status;
          result = "Flow Completed - Status: $status and Error: $error";
        }
      } else {
        result = "Flow Incomplete";
      }
    } catch (error) {
      debugPrint("Error during transaction: $error");
      throw Exception("Transaction Failed: $error");
    }

    debugPrint("Payment State: ${payment?.state ?? 'NULL'}");
    return payment;
  }

  Future<Payment?> checkStatus(BuildContext context) async {
    try {
      String url =
          "https://api.phonepe.com/apis/hermes/pg/v1/status/$merchantId/$transactionId";

      String concatString = "/pg/v1/status/$merchantId/$transactionId$saltKey";
      var digest = sha256.convert(utf8.encode(concatString));
      String xVerify = "$digest###$saltIndex";

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "X-VERIFY": xVerify,
        "X-MERCHANT-ID": merchantId,
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
        }
      } else {
        debugPrint(
            "HTTP Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      debugPrint("Exception: $e");
    }

    return null; // Return null if the status check fails
  }
}
