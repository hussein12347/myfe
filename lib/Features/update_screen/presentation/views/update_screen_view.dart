import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/styles/app_styles.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../data/models/update_model.dart';

class UpdateScreenView extends StatelessWidget {
  final UpdateModel updateModel;
  const UpdateScreenView({super.key, required this.updateModel});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  Assets.jsonUpdate,
                  height: 400,
                  repeat: true,
                ),
                const SizedBox(height: 24),
                Text(
                  lang.updateAvailable, // أو اكتب "تحديث جديد متاح!"
                  style: AppStyles.bold32(context),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  '${lang.newVersion} ${updateModel.version}', // الإصدار الجديد
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  lang.updateDescription, // مثلاً "تم إصلاح بعض الأخطاء وتحسين الأداء"
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: theme.colorScheme.primary,
                    elevation: 4,
                  ),
                  onPressed: () => _launchUrl(updateModel.downloadUrl),
                  icon: const Icon(Icons.download_rounded, size: 22),
                  label: Text(
                    lang.downloadUpdate, // أو "تحميل التحديث"
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
