import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/format.dart';
import '../core/providers.dart';
import '../core/stage.dart';
import '../core/theme.dart';
import '../data/project.dart';
import '../state/project_store.dart';
import 'dialogs.dart';
import 'fair_use_screen.dart';
import 'subtitle_studio_screen.dart';
import 'backup_screen.dart';
import 'quick_screen.dart';
import 'news_screen.dart';
import 'video_recap_screen.dart';
import 'srt_split_screen.dart';
import 'publish_screen.dart';
import 'transformative_editor_screen.dart';
import 'translation_studio_screen.dart';
import 'widgets.dart';

enum _Action { none, workflow, library, studio, fairUse, transformative, publish, backup, quick, srtSplit, videoRecap, news, translation }

class _Module {
  const _Module(this.code, this.title, this.sub, this.color, this.phase, [this.action = _Action.none, this.capabilityId]);
  final String code;
  final String title;
  final String sub;
  final Color color;
  final int phase;
  final _Action action;
  final String? capabilityId;
}

IconData _moduleIcon(String code) {
  return switch (code) {
    'VI' => Icons.video_library_outlined,
    'GM' => Icons.auto_awesome,
    'ST' => Icons.closed_caption_outlined,
    'TT' => Icons.record_voice_over_outlined,
    'ED' => Icons.movie_outlined,
    'RN' => Icons.high_quality_outlined,
    'DL' => Icons.video_collection_outlined,
    'FU' => Icons.verified_user_outlined,
    'TE' => Icons.tune_rounded,
    'QK' => Icons.flash_on_outlined,
    'SS' => Icons.subtitles_outlined,
    'VR' => Icons.smart_display_outlined,
    'NW' => Icons.newspaper_outlined,
    'BK' => Icons.backup_outlined,
    'UP' => Icons.publish_outlined,
    'TR' => Icons.translate_rounded,
    'WH' => Icons.hearing_rounded,
    'BM' => Icons.blur_on_rounded,
    _ => Icons.extension_outlined,
  };
}

const _modules = <_Module>[
  _Module('VI', 'Video Index', 'အပိုင်းခွဲ', Color(0xFFFF9F43), 2, _Action.workflow),
  _Module('GM', 'Recap Studio', 'Gemini handoff', Color(0xFF3DDC84), 3, _Action.workflow),
  _Module('ST', 'Subtitle Studio', 'SRT ပြင်၊ စစ်', Color(0xFF5B8CFF), 4, _Action.studio),
  _Module('TT', 'TTS / MP3', 'အသံ ထုတ်/ဖမ်း', Color(0xFF5B8CFF), 5, _Action.workflow, 'speech_synthesis'),
  _Module('ED', 'Video Editor', 'Timeline', Color(0xFFA46BFF), 6, _Action.workflow),
  _Module('RN', 'Render Center', 'MP4 ထုတ်', Color(0xFFF2C94C), 7, _Action.workflow),
  _Module('DL', 'Drama Library', 'ဇာတ်လမ်း၊ အပိုင်း', Color(0xFFFF9F43), 2, _Action.library),
  _Module('FU', 'Copyright & Fair Use', 'Upload မတင်ခင် စစ်', Color(0xFFF2C94C), 8, _Action.fairUse),
  _Module('TE', 'Transformative Editor', 'Manual · AI · Hybrid', Color(0xFF00C2A8), 9, _Action.transformative),
  _Module('QK', 'အမြန်လမ်း', 'SRT ရှိပြီး → ဗီဒီယိုတန်းထုတ်', Color(0xFF3DDC84), 13, _Action.quick),
  _Module('SS', 'SRT နဲ့ အပိုင်းခွဲ', 'ဗီဒီယို+SRT အတိအကျဖြတ်', Color(0xFF5B8CFF), 13, _Action.srtSplit),
  _Module('VR', 'Video Recap', 'Gemini က ဗီဒီယိုကြည့်ပြီး script', Color(0xFFB36BFF), 13, _Action.videoRecap),
  _Module('NW', 'သတင်း (RSS)', 'သတင်းဖတ်၊ script ရေး', Color(0xFF2FA8FF), 14, _Action.news),
  _Module('BK', 'Backup / Restore', 'Project သိမ်း/ပြန်ယူ', Color(0xFF8E9AAF), 12, _Action.backup),
  _Module('UP', 'Upload & Thumbnail', 'ခေါင်းစဉ်၊ hashtag၊ ပုံ', Color(0xFFFF6B9D), 11, _Action.publish),
  _Module('TR', 'Translation Studio', 'Recap / Full Translation', Color(0xFF35B6A5), 4, _Action.translation, 'translation'),
  _Module('WH', 'Whisper Subtitles', 'အသံမှ SRT အလိုအလျောက်ထုတ်', Color(0xFF62A0EA), 5, _Action.none, 'whisper_transcription'),
  _Module('BM', 'Smart Blur Masks', 'နေရာသတ်မှတ်ပြီး Blur ဖုံး', Color(0xFFB17CE8), 6, _Action.none, 'smart_blur_masks'),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onOpenWorkflow, required this.onOpenLibrary});
  final VoidCallback onOpenWorkflow;
  final VoidCallback onOpenLibrary;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ProjectStore>();
    final resume = store.resumeCandidate;
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= 900;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        titleSpacing: 20,
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          const BrandMark(size: 38),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('RGyi RECAP', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, letterSpacing: 1.1)),
            Text('AI PRODUCTION WORKSPACE', style: TextStyle(fontSize: 9, letterSpacing: 1.6, color: DfColors.secondary.withValues(alpha: .9))),
          ]),
        ]),
        actions: [
          if (wide) const Center(child: _LivePill()),
          IconButton(tooltip: 'Project Library', onPressed: onOpenLibrary, icon: const Icon(Icons.video_library_outlined)),
          const SizedBox(width: 10),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showNewProjectSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Project'),
      ),
      body: store.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.fromLTRB(wide ? 28 : 16, 8, wide ? 28 : 16, 110),
              children: [
                if (store.error != null) ErrorBanner(store.error!),
                _StudioHero(onCreate: () => showNewProjectSheet(context), onWorkflow: onOpenWorkflow),
                const SizedBox(height: 18),
                if (resume != null) ...[
                  _SectionHeading(title: 'CONTINUE PRODUCTION', subtitle: 'နောက်ဆုံးလုပ်နေတဲ့ Project ကို ဆက်လုပ်ပါ'),
                  _ResumeCard(project: resume, onResume: () { store.open(resume); onOpenWorkflow(); }),
                  const SizedBox(height: 22),
                ] else if (store.items.isEmpty) ...[
                  const _EmptyHint(),
                  const SizedBox(height: 18),
                ],
                _SectionHeading(title: 'PRODUCTION TOOLS', subtitle: 'လုပ်ငန်းစဉ်အလိုက် ရွေးချယ်အသုံးပြုနိုင်ပါတယ်'),
                LayoutBuilder(builder: (context, c) {
                  final cols = c.maxWidth >= 1100 ? 4 : c.maxWidth >= 720 ? 3 : 2;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _modules.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols, crossAxisSpacing: 12, mainAxisSpacing: 12,
                      mainAxisExtent: 142,
                    ),
                    itemBuilder: (_, i) => _ModuleTile(
                      module: _modules[i], onOpenWorkflow: onOpenWorkflow, onOpenLibrary: onOpenLibrary,
                    ),
                  );
                }),
                if (store.items.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _SectionHeading(title: 'YOUR PROJECTS', subtitle: '${store.items.length} projects in your workspace'),
                  for (final p in store.items) _ProjectTile(project: p, onOpenWorkflow: onOpenWorkflow),
                ],
                const SizedBox(height: 20),
                const _FooterSignature(),
              ],
            ),
    );
  }
}

class _LivePill extends StatelessWidget {
  const _LivePill();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(color: DfColors.ok.withValues(alpha: .10), borderRadius: BorderRadius.circular(30), border: Border.all(color: DfColors.ok.withValues(alpha: .3))),
    child: const Row(children: [Icon(Icons.circle, size: 7, color: DfColors.ok), SizedBox(width: 7), Text('STUDIO READY', style: TextStyle(fontSize: 10, letterSpacing: 1, color: DfColors.ok, fontWeight: FontWeight.w800))]),
  );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 12, letterSpacing: 1.5, fontWeight: FontWeight.w900, color: DfColors.secondary)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: DfColors.muted)),
      ])),
      Container(width: 34, height: 2, decoration: BoxDecoration(color: DfColors.accent, borderRadius: BorderRadius.circular(2))),
    ]),
  );
}

class _StudioHero extends StatelessWidget {
  const _StudioHero({required this.onCreate, required this.onWorkflow});
  final VoidCallback onCreate;
  final VoidCallback onWorkflow;
  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 210),
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(26),
      gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF28204F), Color(0xFF142C45), Color(0xFF101A2B)]),
      border: Border.all(color: const Color(0xFF8B75FF).withValues(alpha: .42)),
      boxShadow: [BoxShadow(color: const Color(0xFF6753D8).withValues(alpha: .16), blurRadius: 34, offset: const Offset(0, 14))],
    ),
    child: Stack(children: [
      Positioned(right: -12, top: -24, child: Icon(Icons.movie_filter_rounded, size: 180, color: Colors.white.withValues(alpha: .045))),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: DfColors.secondary.withValues(alpha: .12), borderRadius: BorderRadius.circular(30)), child: const Text('✦  AI-POWERED VIDEO STUDIO', style: TextStyle(color: DfColors.secondary, fontSize: 9, letterSpacing: 1.2, fontWeight: FontWeight.w900))),
          const Spacer(),
          const Icon(Icons.auto_awesome, color: Color(0xFFFFD78A), size: 20),
        ]),
        const SizedBox(height: 18),
        const Text('Your Story.\nYour Cinematic Recap.', style: TextStyle(fontSize: 27, height: 1.12, fontWeight: FontWeight.w900, letterSpacing: -.7)),
        const SizedBox(height: 8),
        const Text('ဗီဒီယို၊ စာတန်းထိုး၊ အသံနဲ့ Editing ကို Workspace တစ်ခုထဲမှာ စီမံဖန်တီးပါ။', style: TextStyle(fontSize: 12, height: 1.5, color: Color(0xFFB9C6DD))),
        const SizedBox(height: 18),
        Wrap(spacing: 10, runSpacing: 8, children: [
          FilledButton.icon(onPressed: onCreate, icon: const Icon(Icons.add_rounded, size: 18), label: const Text('Create Project'), style: FilledButton.styleFrom(backgroundColor: const Color(0xFF9B7BFF), foregroundColor: Colors.white)),
          OutlinedButton.icon(onPressed: onWorkflow, icon: const Icon(Icons.account_tree_outlined, size: 17), label: const Text('Open Workspace'), style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: BorderSide(color: Colors.white.withValues(alpha: .25)))),
        ]),
      ]),
    ]),
  );
}

class _FooterSignature extends StatelessWidget {
  const _FooterSignature();
  @override
  Widget build(BuildContext context) => const Center(child: Text('RGYI RECAP  •  CREATE WITHOUT LIMITS', style: TextStyle(color: DfColors.muted, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.w700)));
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DfColors.line),
      ),
      child: const Text(
        'Project မရှိသေးပါဘူး။ အောက်ခြေက “Project အသစ်” ကို နှိပ်ပြီး စပါ။',
        textAlign: TextAlign.center,
        style: TextStyle(color: DfColors.muted),
      ),
    );
  }
}

class _ResumeCard extends StatelessWidget {
  const _ResumeCard({required this.project, required this.onResume});

  final Project project;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    final stage = project.currentStage;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: DfColors.accent.withValues(alpha: 0.5)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [DfColors.accent.withValues(alpha: 0.22), DfColors.surface],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Poster(title: project.dramaTitle, width: 56, height: 76),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ဆက်လုပ်ရန်', style: TextStyle(color: DfColors.muted, fontSize: 13)),
                    Text(
                      project.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${project.dramaTitle} · အပိုင်း ${project.episode} · ${formatWhen(project.updatedAt)}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: DfColors.muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          StageBar(project: project),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: stage.color,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: stage.color, blurRadius: 8)],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'အဆင့် ${stage.index + 1} · ${stage.title}',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              FilledButton(onPressed: onResume, child: const Text('ဆက်လုပ်မယ်')),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({
    required this.module,
    required this.onOpenWorkflow,
    required this.onOpenLibrary,
  });

  final _Module module;
  final VoidCallback onOpenWorkflow;
  final VoidCallback onOpenLibrary;

  void _tap(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    if (module.action == _Action.library) {
      onOpenLibrary();
      return;
    }
    if (module.action == _Action.backup) {
      // Works without a project, so a fresh install can restore.
      _push(context, const BackupScreen());
      return;
    }
    if (module.action == _Action.news) {
      _push(context, const NewsScreen());
      return;
    }
    if (module.action == _Action.none) {
      final capability = capabilityById(module.capabilityId ?? '');
      messenger.showSnackBar(SnackBar(
        content: Text(capability == null
            ? '${module.title} ကို Phase ${module.phase} မှာ ရေးမယ်။ အခု မရသေးပါဘူး။'
            : '${module.title} — ${capability.note}'),
      ));
      return;
    }
    final store = context.read<ProjectStore>();
    final target = store.current ?? store.resumeCandidate ?? (store.items.isNotEmpty ? store.items.first : null);
    if (target == null || target.id == null) {
      messenger.showSnackBar(const SnackBar(content: Text('Project တစ်ခု အရင်ဖန်တီးပါ။')));
      return;
    }
    switch (module.action) {
      case _Action.workflow:
        store.open(target);
        onOpenWorkflow();
      case _Action.studio:
        _push(context, SubtitleStudioScreen(project: target));
      case _Action.translation:
        _push(context, TranslationStudioScreen(project: target));
      case _Action.fairUse:
        _push(context, FairUseScreen(project: target));
      case _Action.transformative:
        _push(context, TransformativeEditorScreen(project: target));
      case _Action.srtSplit:
        _push(context, SrtSplitScreen(project: target));
      case _Action.videoRecap:
        _push(context, VideoRecapScreen(project: target));
      case _Action.quick:
        _push(context, QuickScreen(projectId: target.id!));
      case _Action.publish:
        _push(context, PublishScreen(project: target));
      case _Action.library:
      case _Action.news:
      case _Action.backup:
      case _Action.none:
        break;
    }
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final c = module.color;
    final capability = capabilityById(module.capabilityId ?? '');
    final available = capability?.state == CapabilityState.available || (capability == null && module.action != _Action.none);
    final status = capability == null
        ? (module.action == _Action.none ? 'COMING SOON' : 'READY')
        : switch (capability.state) {
            CapabilityState.available => 'READY',
            CapabilityState.partial => 'BETA',
            CapabilityState.planned => 'PLANNED',
            CapabilityState.unavailable => 'OFFLINE',
          };
    return Material(
      color: DfColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: c.withValues(alpha: .25))),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _tap(context),
        child: Stack(children: [
          Positioned(right: -15, bottom: -22, child: Icon(_moduleIcon(module.code), size: 104, color: c.withValues(alpha: .055))),
          Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 42, height: 42, decoration: BoxDecoration(color: c.withValues(alpha: .14), borderRadius: BorderRadius.circular(13), border: Border.all(color: c.withValues(alpha: .42))), child: Icon(_moduleIcon(module.code), color: c, size: 23)),
              const Spacer(),
              Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4), decoration: BoxDecoration(color: (available ? DfColors.ok : DfColors.warn).withValues(alpha: .10), borderRadius: BorderRadius.circular(20)), child: Text(status, style: TextStyle(fontSize: 8, letterSpacing: .7, fontWeight: FontWeight.w900, color: available ? DfColors.ok : DfColors.warn))),
            ]),
            const Spacer(),
            Text(module.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
            const SizedBox(height: 3),
            Text(module.sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: DfColors.muted, fontSize: 10)),
            const SizedBox(height: 8),
            Row(children: [Text('OPEN MODULE', style: TextStyle(color: c, fontSize: 8, letterSpacing: 1.1, fontWeight: FontWeight.w900)), const Spacer(), Icon(Icons.arrow_outward_rounded, size: 14, color: c)]),
          ])),
        ]),
      ),
    );
  }
}

class _ProjectTile extends StatelessWidget {
  const _ProjectTile({required this.project, required this.onOpenWorkflow});

  final Project project;
  final VoidCallback onOpenWorkflow;

  Future<void> _menu(BuildContext context, String action) async {
    final store = context.read<ProjectStore>();
    if (action == 'rename') {
      final name = await askText(context, 'နာမည်ပြောင်းမယ်', project.name);
      if (name != null) await store.rename(project, name);
    } else if (action == 'duplicate') {
      await store.duplicate(project);
    } else if (action == 'delete') {
      final ok = await confirmDelete(context, project.name);
      if (ok) await store.delete(project);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stage = project.currentStage;
    final label = project.finished ? 'ပြီး' : stage.title;
    final color = project.finished ? DfColors.ok : stage.color;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: DfColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: DfColors.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          context.read<ProjectStore>().open(project);
          onOpenWorkflow();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
          child: Row(
            children: [
              Poster(title: project.dramaTitle, width: 42, height: 56),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(
                      '${project.dramaTitle} · EP ${project.episode} · ${formatWhen(project.updatedAt)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: DfColors.muted, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    StageBar(project: project),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: color.withValues(alpha: 0.55)),
                ),
                child: Text(label, style: TextStyle(color: color, fontSize: 12)),
              ),
              PopupMenuButton<String>(
                onSelected: (a) => _menu(context, a),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'rename', child: Text('နာမည်ပြောင်း')),
                  PopupMenuItem(value: 'duplicate', child: Text('ကူးယူ')),
                  PopupMenuItem(value: 'delete', child: Text('ဖျက်')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
