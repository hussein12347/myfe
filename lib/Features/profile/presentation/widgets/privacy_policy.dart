import 'package:flutter/material.dart';
import '../../../../core/utils/functions/is_arabic.dart';
import 'localization_data.dart'; // تأكد من استيراد الملف

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  // متغير لتحديد اللغة الحالية
  final String _currentLanguage = (LanguageHelper.isArabic()) ? 'ar' : 'en';

  @override
  Widget build(BuildContext context) {
    // تحميل بيانات الترجمة بناءً على اللغة المختارة
    final localization = LocalizationData.getLocalization(_currentLanguage);
    final isArabic = _currentLanguage == 'ar';

    // تحديد اتجاه النص (RTL للعربية، LTR للإنجليزية)
    final textDirection = isArabic ? TextDirection.rtl : TextDirection.ltr;
    final textAlign = isArabic ? TextAlign.right : TextAlign.left;

    // دالة مساعدة لبناء عنوان القسم (Section Title)
    Widget _buildSectionTitle(String key) {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
        child: Text(
          localization[key]!,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
          textDirection: textDirection,
          textAlign: textAlign,
        ),
      );
    }

    // دالة مساعدة لبناء عنصر تعداد (Bullet Point Item)
    Widget _buildBulletItem(String key) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: textDirection,
          children: <Widget>[
            Text(
              isArabic ? '•  ' : '• ',
              style: const TextStyle(fontSize: 16),
            ),
            Expanded(
              child: Text(
                localization[key]!,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textDirection: textDirection,
                textAlign: textAlign,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization['title']!,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Directionality(
        textDirection: textDirection,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // --- المقدمة ---
              _buildBulletItem('intro_p1'),
              _buildBulletItem('intro_p2'),
              _buildBulletItem('intro_p3'),

              const Divider(height: 30, thickness: 1.5),

              // --- جمع المعلومات واستخدامها ---
              _buildSectionTitle('section_info_collect'),
              _buildBulletItem('info_collect_p1'),
              _buildBulletItem('info_collect_p2'),
              _buildBulletItem('info_collect_p3'),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                child: Text(
                  localization['info_collect_link']!,
                  textDirection: textDirection,
                  textAlign: textAlign,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              _buildBulletItem('service_google_play'),

              const Divider(height: 30, thickness: 1.5),

              // --- البيانات المسجلة ---
              _buildSectionTitle('section_log_data'),
              _buildBulletItem('log_data_p1'),
              _buildBulletItem('log_data_p2'),

              const Divider(height: 30, thickness: 1.5),

              // --- ملفات تعريف الارتباط ---
              _buildSectionTitle('section_cookies'),
              _buildBulletItem('cookies_p1'),
              _buildBulletItem('cookies_p2_explicit'),
              _buildBulletItem('cookies_p3_option'),

              const Divider(height: 30, thickness: 1.5),

              // --- مقدمو الخدمة ---
              _buildSectionTitle('section_service_providers'),
              _buildBulletItem('sp_p1_reasons'),
              _buildBulletItem('sp_reason_facilitate'),
              _buildBulletItem('sp_reason_provide'),
              _buildBulletItem('sp_reason_perform'),
              _buildBulletItem('sp_reason_assist'),
              _buildBulletItem('sp_p2_access'),

              const Divider(height: 30, thickness: 1.5),

              // --- الأمان ---
              _buildSectionTitle('section_security'),
              _buildBulletItem('security_p1'),
              _buildBulletItem('security_p2_disclaimer'),

              const Divider(height: 30, thickness: 1.5),

              // --- روابط لمواقع أخرى ---
              _buildSectionTitle('section_links'),
              _buildBulletItem('links_p1'),
              _buildBulletItem('links_p2_disclaimer'),

              const Divider(height: 30, thickness: 1.5),

              // --- خصوصية الأطفال ---
              _buildSectionTitle('section_children'),
              _buildBulletItem('children_p1_age'),
              _buildBulletItem('children_p2_collect'),
              _buildBulletItem('children_p3_delete'),
              _buildBulletItem('children_p4_contact'),

              const Divider(height: 30, thickness: 1.5),

              // --- التغييرات في سياسة الخصوصية ---
              _buildSectionTitle('section_changes'),
              _buildBulletItem('changes_p1'),
              _buildBulletItem('changes_p2_notify'),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

