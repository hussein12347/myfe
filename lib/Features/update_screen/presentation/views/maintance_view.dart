import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import 'package:lottie/lottie.dart';
import '../../../../generated/assets.dart';

class MaintenanceView extends StatelessWidget {
  const MaintenanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                Assets.jsonMaintenance, // أو أي ملف لوتي لصيانة
                height: 300,
                repeat: true,
              ),
              const SizedBox(height: 24),
              Text(
                lang.maintenance, // مثلاً "التطبيق في حالة صيانة"
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                lang.pleaseWait, // مثلاً "الرجاء الانتظار لحين انتهاء الصيانة"
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
