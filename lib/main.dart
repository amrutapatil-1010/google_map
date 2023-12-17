import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RazorPayment(),
    );
  }
}

class RazorPayment extends StatefulWidget {
  const RazorPayment({super.key});

  @override
  State<RazorPayment> createState() => _RazorPaymentState();
}

class _RazorPaymentState extends State<RazorPayment> {
  final Razorpay _razorPay = Razorpay();

  void openRazorPay(Map<String, dynamic> options) async {
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handleSuccessPayment);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentFailure);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExtWalletSelected);
    _razorPay.open(options);
  }

  void handleSuccessPayment(PaymentSuccessResponse paymentSuccess) {
    AlertDialog(
      title: const Text("Payment is success...."),
      actions: [
        ElevatedButton(
          child: const Text("Continue"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
    log("the API details =============>  ${paymentSuccess.orderId},\n ${paymentSuccess.paymentId}, \n ${paymentSuccess.signature}");
  }

  void handlePaymentFailure(PaymentFailureResponse paymentFail) {
    AlertDialog(
      title: const Text("Payment failure"),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("continue"))
      ],
    );
    log("the API details =============>  ${paymentFail.error} \n ${paymentFail.message}, ");
  }

  void handleExtWalletSelected(ExternalWalletResponse walletResponse) {
    AlertDialog(
      title: const Text("Wallet"),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Continue"),
        )
      ],
    );
    log("the API details =============>  ${walletResponse.walletName} ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "RazorPay",
          style: Theme.of(context).primaryTextTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            child: Text(
              "Razor Pay",
              style: Theme.of(context).primaryTextTheme.labelLarge?.copyWith(
                  color: Colors.blueGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              height: 50,
              width: double.infinity,
              color: Colors.amber,
            ),
          ),
          InkWell(
              onTap: () {
                log("ddb");
                // setState(() {
                Map<String, dynamic> options = {
                  'key': 'rzp_test_iNdS94G3o1lLMQ',
                  'amount': 100,
                  'name': 'Acme Corp.',
                  'description': 'Fine T-Shirt',
                  'retry': {'enabled': true, 'max_count': 1},
                  'send_sms_hash': true,
                  'prefill': {
                    'contact': '9632327874',
                    'email': 'test@razorpay.com'
                  },
                  'external': {
                    'wallets': ['paytm']
                  }
                };
                // });

                openRazorPay(options);
              },
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(
                    Icons.payment,
                  )))
        ],
      ),
    );
  }
}
