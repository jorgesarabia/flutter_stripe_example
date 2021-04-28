import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_stripe_example/stripe_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;

class StripeService {
  StripeService._constructor();
  static final StripeService instance = StripeService._constructor();

  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApi = '$apiBase/payment_intents';
  static Map<String, String> headers = {
    'Authorization': 'Bearer $secret',
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  // Keys:
  static String customerKey = 'customerKey';

  final CreditCard _testCard = CreditCard(
    number: '4111111111111111',
    expMonth: 08,
    expYear: 30,
  );

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

    final paymentIntent = await _getPaymentIntent(
      amount: amount,
      currency: currency,
      moreParams: {
        'payment_method_types[]': 'card',
      },
    );

    final confirmPayment = await StripePayment.confirmPaymentIntent(
      PaymentIntent(
        clientSecret: paymentIntent['client_secret'],
        paymentMethodId: paymentMethod.id,
      ),
    );

    print(confirmPayment);
  }

  Future<void> payWithToken({
    @required int amount,
    @required String currency,
  }) async {
    Token token = await _getCreditCardToken(_testCard);

    final paymentMethod = await _createPaymentMethodWithToken(token);

    final paymentIntent = await _getPaymentIntent(
      amount: amount,
      currency: currency,
      moreParams: {
        'payment_method_types[]': 'card',
      },
    );

    final confirmPayment = await StripePayment.confirmPaymentIntent(
      PaymentIntent(
        clientSecret: paymentIntent['client_secret'],
        paymentMethodId: paymentMethod.id,
      ),
    );

    print(confirmPayment);
  }

  Future<Token> _getCreditCardToken(CreditCard card) async {
    final token = await StripePayment.createTokenWithCard(card);

    return token;
  }

  Future<PaymentMethod> _createPaymentMethodWithToken(Token token) async {
    return await StripePayment.createPaymentMethod(
      PaymentMethodRequest(
        card: CreditCard(token: token.tokenId),
      ),
    );
  }

  Future<void> saveInfo({
    @required int amount,
    @required String currency,
  }) async {
    Map<String, dynamic> customer = await _getSavedCustomer();
    if (customer == null) {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(),
      );
      customer = await _createCustomer(paymentMethod.id);
    }

    final paymentIntent = await _getPaymentIntent(
      amount: amount,
      currency: currency,
      moreParams: {
        'customer': customer['id'],
        'setup_future_usage': 'on_session',
      },
    );

    final confirmPayment = await StripePayment.confirmPaymentIntent(
      PaymentIntent(
        clientSecret: paymentIntent['client_secret'],
        paymentMethodId: customer['payment_method'],
      ),
    );

    print(confirmPayment);
  }

  Future<Map<String, dynamic>> _createCustomer(String paymentMethodId) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBase/customers'),
        body: {
          'email': 'example@example.com',
          'name': 'My Customer Name',
          'address[city]': 'City',
          'address[country]': 'AR',
          'address[line1]': 'Address 001',
          'address[line2]': 'Address line 2',
          'address[postal_code]': '3333',
          'address[state]': 'Province',
          'payment_method': paymentMethodId,
        },
        headers: headers,
      );

      final object = jsonDecode(response.body) as Map<String, dynamic>;
      object['payment_method'] = paymentMethodId;

      final pref = await SharedPreferences.getInstance();
      await pref.setString(customerKey, jsonEncode(object));

      return object;
    } catch (err) {
      print(err);
    }

    return {};
  }

  Future<Map<String, dynamic>> _getSavedCustomer() async {
    final pref = await SharedPreferences.getInstance();
    if (pref.containsKey(customerKey)) {
      return jsonDecode(pref.getString(customerKey));
    }

    return null;
  }

  Future<Map<String, dynamic>> _getPaymentIntent({
    @required int amount,
    @required String currency,
    @required Map<String, String> moreParams,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(paymentApi),
        body: {
          'amount': amount.toString(),
          'currency': currency,
        }..addAll(moreParams),
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
