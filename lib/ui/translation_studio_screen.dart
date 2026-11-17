import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/project.dart';
import 'gemini_panel.dart';

/// Translation workspace built on the existing, resumable Gemini handoff.
/// Source SRT is retained; translated output is merged using source timings.
class TranslationStudioScreen extends StatelessWidget {
  const TranslationStudioScreen({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translation Studio'),
        subtitle: Text(project.name),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: DfColors.accent.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: DfColors.accent.withValues(alpha: 0.28)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ဘာသာပြန်လုပ်ငန်း', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  SizedBox(height: 6),
                  Text(
                    'Source SRT ကို မပြောင်းဘဲ အပိုင်းငယ်ခွဲပြီး Gemini app မှာ ဘာသာပြန်နိုင်ပါတယ်။ '
                    'ပြန်ရလာတဲ့ SRT ကို စစ်ဆေးပြီး နံပါတ်နဲ့ အချိန်တွေကို မူရင်းအတိုင်း ပြန်ပေါင်းပေးမယ်။',
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'လက်ရှိနည်းလမ်း — Gemini app သို့ ကိုယ်တိုင်ပို့/ပြန်ထည့်ခြင်း။ '
                    'API အလိုအလျောက်ဘာသာပြန်ကို မချိတ်ရသေးပါ။',
                    style: TextStyle(color: DfColors.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GeminiPanel(
              project: project,
              onlyKeys: const ['zh_my', 'ts_translate'],
              initialKey: 'zh_my',
            ),
          ],
        ),
      ),
    );
  }
}
