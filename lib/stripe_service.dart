import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_stripe_example/stripe_info.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

class StripeService {
  StripeService._constructor();
  static final StripeService instance = StripeService._constructor();

  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApi = '$apiBase/payment_intents';

  void init() {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: publish,
        merchantId: 'Test',
        androidPayMode: 'test',
      ),
    );
  }

  Future<void> payWithNewCard({
    @required int amount,
    @required String currency,
  }) async {
    final paymentMethod = await StripePayment.paymentRequestWithCardForm(
      CardFormPaymentRequest(),
    );

    final paymentIntent = await getPaymentIntent(
      amount: amount,
      currency: currency,
    );

    final confirmPayment = await StripePayment.confirmPaymentIntent(
      PaymentIntent(
        clientSecret: paymentIntent['client_secret'],
        paymentMethodId: paymentMethod.id,
      ),
    );

    print(confirmPayment);
  }

  Future<Map<String, dynamic>> getPaymentIntent({
    @required int amount,
    @required String currency,
  }) async {
    try {
      final headers = {
        'Authorization': 'Bearer $secret',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final response = await http.post(
        Uri.parse(paymentApi),
        body: {
          'amount': amount.toString(),
          'currency': currency,
          'payment_method_types[]': 'card',
        },
        headers: headers,
      );

      print(response.body);
      return jsonDecode(response.body);
    } catch (err) {
      print(err);
    }

    return {};
  }
}
