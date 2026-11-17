import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/project.dart';
import 'gemini_panel.dart';

enum _TranslationMode { recap, fullSrt }

/// Translation workspace with two separate workflows:
/// recap narration and line-preserving full SRT translation.
class TranslationStudioScreen extends StatefulWidget {
  const TranslationStudioScreen({super.key, required this.project});

  final Project project;

  @override
  State<TranslationStudioScreen> createState() => _TranslationStudioScreenState();
}

class _TranslationStudioScreenState extends State<TranslationStudioScreen> {
  _TranslationMode _mode = _TranslationMode.fullSrt;

  static const _recapKeys = <String>[
    'zh_recap',
    'recap_short',
    'recap_medium',
    'recap_long',
    'narration',
    'yt_script',
  ];

  static const _srtKeys = <String>['zh_my', 'ts_translate'];

  @override
  Widget build(BuildContext context) {
    final isRecap = _mode == _TranslationMode.recap;
    final keys = isRecap ? _recapKeys : _srtKeys;

    return Scaffold(
      appBar: AppBar(title: const Text('Translation Studio')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            const Text(
              'ဘာသာပြန်လုပ်ငန်းအမျိုးအစား ရွေးပါ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _ModeCard(
                    selected: isRecap,
                    icon: Icons.auto_stories_rounded,
                    title: 'Recap Translation',
                    subtitle: 'ဇာတ်လမ်းပြန်ပြောစာ',
                    onTap: () => setState(() => _mode = _TranslationMode.recap),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ModeCard(
                    selected: !isRecap,
                    icon: Icons.subtitles_rounded,
                    title: 'Full SRT Translation',
                    subtitle: 'စာတန်းအားလုံး အချိန်မပျက်',
                    onTap: () => setState(() => _mode = _TranslationMode.fullSrt),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: DfColors.accent.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: DfColors.accent.withValues(alpha: 0.28)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isRecap ? 'Recap Translation' : 'Full SRT Translation',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isRecap
                        ? 'တရုတ်စာတန်း သို့မဟုတ် ဇာတ်လမ်းစကားပြောတွေကို မြန်မာလို သဘာဝကျတဲ့ Recap ပြောပြစာအဖြစ် ပြောင်းပါ။ အတို၊ အလတ်၊ အရှည်နဲ့ အသံဖတ် Script ပုံစံတွေ ရွေးနိုင်ပါတယ်။'
                        : 'မူရင်း SRT ရဲ့ နံပါတ်၊ အချိန်နဲ့ စာကြောင်းအစီအစဉ်ကို မပြောင်းဘဲ တစ်ကြောင်းချင်း မြန်မာလို ဘာသာပြန်ပါ။',
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'လက်ရှိနည်းလမ်း — Gemini app သို့ ကိုယ်တိုင်ပို့ပြီး ပြန်ထည့်ခြင်း။ API အလိုအလျောက်ဘာသာပြန်ကို မချိတ်ရသေးပါ။',
                    style: TextStyle(color: DfColors.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            GeminiPanel(
              key: ValueKey('translation-${_mode.name}-${widget.project.id}'),
              project: widget.project,
              onlyKeys: keys,
              initialKey: isRecap ? 'zh_recap' : 'zh_my',
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? DfColors.accent : DfColors.muted;
    return Material(
      color: selected ? DfColors.accent.withValues(alpha: 0.12) : DfColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(minHeight: 112),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? DfColors.accent : DfColors.line,
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 23),
              const SizedBox(height: 9),
              Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: selected ? DfColors.accent : null)),
              const SizedBox(height: 3),
              Text(subtitle, style: const TextStyle(fontSize: 11, color: DfColors.muted)),
            ],
          ),
        ),
      ),
    );
  }
}
