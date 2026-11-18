import 'package:flutter/material.dart';

import '../core/stage.dart';
import '../core/theme.dart';
import '../data/project.dart';

/// RGyi Recap compact cinematic brand mark.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 36});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF9B5CFF), Color(0xFF5145CD), Color(0xFF1D9DBB)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
        boxShadow: [
          BoxShadow(color: DfColors.accent.withValues(alpha: 0.28), blurRadius: 14, spreadRadius: 1),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.movie_creation_outlined, size: size * 0.72, color: Colors.white.withValues(alpha: 0.95)),
          Positioned(
            right: size * 0.08,
            bottom: size * 0.08,
            child: Container(
              width: size * 0.38,
              height: size * 0.38,
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.2),
              ),
              child: Icon(Icons.play_arrow_rounded, size: size * 0.32, color: DfColors.secondary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small drama "poster": the first character of the drama title on a gradient.
class Poster extends StatelessWidget {
  const Poster({super.key, required this.title, this.width = 44, this.height = 58});

  final String title;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final t = title.trim();
    final first = t.isEmpty ? '?' : t.characters.first;
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: DfColors.line),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B2A6E), Color(0xFF0F1D4A), Color(0xFF7A2A5A)],
        ),
      ),
      child: Text(first, style: TextStyle(fontSize: width * 0.42, color: Colors.white)),
    );
  }
}

/// Six segments, one per stage, filled in the stage's own color when done.
class StageBar extends StatelessWidget {
  const StageBar({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final s in Stage.values)
          Expanded(
            child: Container(
              height: 6,
              margin: EdgeInsets.only(right: s == Stage.save ? 0 : 4),
              decoration: BoxDecoration(
                color: project.isDone(s) ? s.color : DfColors.line,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class ErrorBanner extends StatelessWidget {
  const ErrorBanner(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DfColors.danger.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DfColors.danger.withValues(alpha: 0.5)),
      ),
      child: Text(message, style: const TextStyle(color: DfColors.danger)),
    );
  }
}


/// Shared premium surface used by production panels.
class PremiumSurface extends StatelessWidget {
  const PremiumSurface({super.key, required this.child, this.padding = const EdgeInsets.all(14), this.margin});
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) => Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: DfColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: DfColors.line.withValues(alpha: .9)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [DfColors.surface.withValues(alpha: .98), DfColors.surface.withValues(alpha: .78)],
          ),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .16), blurRadius: 18, offset: const Offset(0, 7))],
        ),
        child: child,
      );
}

/// Compact title row with a clear visual hierarchy for studio sections.
class PremiumSectionHeader extends StatelessWidget {
  const PremiumSectionHeader({super.key, required this.title, this.subtitle, this.icon, this.trailing});
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: DfColors.accent.withValues(alpha: .14),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: DfColors.accent.withValues(alpha: .24)),
              ),
              child: Icon(icon, color: DfColors.secondary, size: 20),
            ),
            const SizedBox(width: 11),
          ],
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: DfColors.ink)),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(subtitle!, style: const TextStyle(fontSize: 11.5, color: DfColors.muted)),
              ],
            ]),
          ),
          if (trailing != null) trailing!,
        ],
      );
}

/// Consistent state banner for success, progress and validation feedback.
class PremiumMessage extends StatelessWidget {
  const PremiumMessage(this.message, {super.key, this.error = false, this.icon});
  final String message;
  final bool error;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final color = error ? DfColors.danger : DfColors.ok;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withValues(alpha: .28)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon ?? (error ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded), color: color, size: 18),
        const SizedBox(width: 9),
        Expanded(child: Text(message, style: TextStyle(color: DfColors.ink.withValues(alpha: .92), fontSize: 12.5))),
      ]),
    );
  }
}

/// Empty state that explains the next useful action instead of showing a blank panel.
class PremiumEmptyState extends StatelessWidget {
  const PremiumEmptyState({super.key, required this.title, required this.description, this.icon = Icons.movie_filter_outlined});
  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) => PremiumSurface(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(color: DfColors.accent.withValues(alpha: .14), shape: BoxShape.circle),
            child: Icon(icon, color: DfColors.secondary, size: 26),
          ),
          const SizedBox(height: 12),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          Text(description, textAlign: TextAlign.center, style: const TextStyle(color: DfColors.muted, fontSize: 12)),
        ]),
      );
}
