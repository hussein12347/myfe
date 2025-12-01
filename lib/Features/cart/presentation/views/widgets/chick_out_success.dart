import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/nav_bar.dart';
import 'package:multi_vendor_e_commerce_app/generated/assets.dart';
import 'package:multi_vendor_e_commerce_app/generated/l10n.dart';

class ChickOutSuccess extends StatelessWidget {
  final String number;
  final String date;

  const ChickOutSuccess({super.key, required this.number, required this.date});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Success Lottie animation
                    Lottie.asset(
                      Assets.jsonSuccess,
                      width: 250,
                      height: 250,
                      fit: BoxFit.contain,
                      repeat: false,
                    ),
                    const SizedBox(height: 32),

                    // Success title
                    Text(
                      s.orderSuccessTitle,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Success message
                    Text(
                      s.orderSuccessMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Order details card
                    Card(
                      color: Theme.of(context).cardColor,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              s.orderNumber(number),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              s.orderDateNumber(date.substring(0, 10)),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const NavBar()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
              child: Text(
                s.backToHome,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
