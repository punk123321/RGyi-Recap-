import 'package:flutter/material.dart';

import '../core/providers.dart';
import '../core/theme.dart';
import 'backup_screen.dart';
import 'widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Studio Settings'),
        actions: const [Padding(padding: EdgeInsets.only(right: 18), child: Center(child: BrandMark(size: 32)))],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 760;
          return ListView(
            padding: EdgeInsets.fromLTRB(wide ? 28 : 16, 18, wide ? 28 : 16, 36),
            children: [
              PremiumSurface(
                padding: const EdgeInsets.all(22),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const BrandMark(size: 54),
                  const SizedBox(width: 16),
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('RGyi Recap', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                    SizedBox(height: 4),
                    Text('AI Production Studio', style: TextStyle(color: DfColors.secondary, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: .8)),
                    SizedBox(height: 10),
                    Text('Version 1.1.0 · Build 9', style: TextStyle(color: DfColors.muted, fontSize: 12)),
                    SizedBox(height: 5),
                    Text('Project တွေကို စီမံ၊ Backup လုပ်ပြီး လက်ရှိအသုံးပြုနိုင်တဲ့ စွမ်းဆောင်ချက်တွေကို ဒီနေရာမှာ စစ်ဆေးနိုင်ပါတယ်။', style: TextStyle(color: DfColors.muted, fontSize: 12, height: 1.5)),
                  ])),
                ]),
              ),
              const SizedBox(height: 22),
              const PremiumSectionHeader(title: 'Feature Availability', subtitle: 'အသုံးပြုနိုင်မှုအခြေအနေကို ရှင်းလင်းစွာ ဖော်ပြထားသည်', icon: Icons.fact_check_outlined),
              const SizedBox(height: 12),
              for (final capability in rgCapabilities) ...[
                _CapabilityTile(capability: capability),
                const SizedBox(height: 9),
              ],
              const SizedBox(height: 18),
              const PremiumSectionHeader(title: 'Project & Data', subtitle: 'Project အချက်အလက်တွေကို ကိုယ်တိုင်သိမ်းဆည်းထားပါ', icon: Icons.storage_rounded),
              const SizedBox(height: 12),
              PremiumSurface(
                child: Row(children: [
                  Container(width: 42, height: 42, decoration: BoxDecoration(color: DfColors.accent.withValues(alpha: .14), borderRadius: BorderRadius.circular(13)), child: const Icon(Icons.backup_rounded, color: DfColors.secondary)),
                  const SizedBox(width: 12),
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Backup & Restore', style: TextStyle(fontWeight: FontWeight.w800)),
                    SizedBox(height: 3),
                    Text('Project data ကို JSON ဖိုင်အဖြစ် သိမ်း/ပြန်ယူပါ။ Media ဖိုင်တွေ မပါဝင်ပါ။', style: TextStyle(color: DfColors.muted, fontSize: 11.5)),
                  ])),
                  IconButton(tooltip: 'Backup & Restore ဖွင့်ရန်', onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const BackupScreen())), icon: const Icon(Icons.chevron_right_rounded)),
                ]),
              ),
              const SizedBox(height: 16),
              const PremiumMessage('Planned လို့ပြထားတဲ့ Feature တွေကို လက်ရှိ Build မှာ အသုံးပြုလို့မရသေးပါ။ Ready/Beta အခြေအနေတွေကလည်း ဖုန်းပေါ်မှာ စမ်းသပ်အတည်ပြုရန် လိုအပ်နိုင်ပါတယ်။', info: true, icon: Icons.info_outline_rounded),
            ],
          );
        },
      ),
    );
  }
}

class _CapabilityTile extends StatelessWidget {
  const _CapabilityTile({required this.capability});
  final FeatureCapability capability;

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (capability.state) {
      CapabilityState.available => ('READY', DfColors.ok, Icons.check_circle_outline_rounded),
      CapabilityState.partial => ('BETA', DfColors.secondary, Icons.science_outlined),
      CapabilityState.planned => ('PLANNED', DfColors.warn, Icons.schedule_rounded),
      CapabilityState.unavailable => ('OFFLINE', DfColors.danger, Icons.cloud_off_outlined),
    };
    return PremiumSurface(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 11),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(capability.id.replaceAll('_', ' ').toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: .35)),
          const SizedBox(height: 4),
          Text(capability.note, style: const TextStyle(color: DfColors.muted, fontSize: 11.5, height: 1.4)),
        ])),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(color: color.withValues(alpha: .11), borderRadius: BorderRadius.circular(30), border: Border.all(color: color.withValues(alpha: .28))),
          child: Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: .5)),
        ),
      ]),
    );
  }
}
