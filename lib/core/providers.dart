import 'dart:typed_data';

import 'srt.dart';

/// Provider-neutral contracts for Phase 2 integrations.
///
/// These interfaces deliberately contain no network implementation. A
/// provider is only advertised as available after a real adapter is wired and
/// exercised on the target platform.

enum TranslationMode { recap, fullSubtitles }

class TranslationRequest {
  const TranslationRequest({
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.mode,
    this.glossary = const {},
    this.instructions = '',
  });

  final String sourceLanguage;
  final String targetLanguage;
  final TranslationMode mode;
  final Map<String, String> glossary;
  final String instructions;
}

class TranslationBatch {
  const TranslationBatch({required this.textByCueIndex});

  /// Only translated text is returned. Cue IDs and timestamps remain owned by
  /// the source document and cannot be overwritten by a provider response.
  final Map<int, String> textByCueIndex;
}

abstract interface class TranslationProvider {
  String get id;
  String get displayName;

  Future<TranslationBatch> translateCues({
    required List<SrtEntry> cues,
    required TranslationRequest request,
  });
}

class TranslationApplyResult {
  const TranslationApplyResult(this.entries, this.missingCueIndices);

  final List<SrtEntry> entries;
  final List<int> missingCueIndices;
}

/// Applies translated text while preserving source cue order, indices and
/// timestamps. Missing/blank translations keep the original source text.
TranslationApplyResult applyTranslationBatch(
  List<SrtEntry> source,
  TranslationBatch batch,
) {
  final output = <SrtEntry>[];
  final missing = <int>[];
  for (final cue in source) {
    final translated = batch.textByCueIndex[cue.index]?.trim();
    if (translated == null || translated.isEmpty) {
      output.add(cue);
      missing.add(cue.index);
    } else {
      output.add(cue.withText(translated));
    }
  }
  return TranslationApplyResult(output, missing);
}

class TranscriptionRequest {
  const TranscriptionRequest({
    required this.audio,
    required this.language,
    this.detectLanguage = false,
  });

  final Uint8List audio;
  final String language;
  final bool detectLanguage;
}

abstract interface class TranscriptionProvider {
  String get id;
  String get displayName;

  /// Must return timestamped cues that pass the app's SRT validation.
  Future<List<SrtEntry>> transcribe(TranscriptionRequest request);
}

class SpeechSynthesisRequest {
  const SpeechSynthesisRequest({
    required this.text,
    required this.language,
    required this.voiceId,
    this.rate = 1,
    this.pitch = 1,
  });

  final String text;
  final String language;
  final String voiceId;
  final double rate;
  final double pitch;
}

class SpeechSynthesisResult {
  const SpeechSynthesisResult({
    required this.audio,
    required this.mimeType,
    this.sampleRate,
  });

  final Uint8List audio;
  final String mimeType;
  final int? sampleRate;
}

abstract interface class SpeechSynthesisProvider {
  String get id;
  String get displayName;
  bool get isOffline;

  Future<SpeechSynthesisResult> synthesize(SpeechSynthesisRequest request);
}

/// Honest capability states for the UI. "planned" is not the same as
/// "available"; no unimplemented feature should look ready to use.
enum CapabilityState { available, partial, planned, unavailable }

class FeatureCapability {
  const FeatureCapability({
    required this.id,
    required this.state,
    required this.note,
  });

  final String id;
  final CapabilityState state;
  final String note;
}

const rgCapabilities = <FeatureCapability>[
  FeatureCapability(
    id: 'subtitle_srt',
    state: CapabilityState.available,
    note: 'SRT ဖတ်၊ ပြင်၊ စစ်ဆေးနိုင်သည်',
  ),
  FeatureCapability(
    id: 'speech_synthesis',
    state: CapabilityState.partial,
    note: 'Device TTS၊ အသံဖမ်း၊ import နှင့် Gemini TTS ရှိသည်',
  ),
  FeatureCapability(
    id: 'translation',
    state: CapabilityState.planned,
    note: 'Provider ချိတ်ဆက်မှု မပြီးသေးပါ',
  ),
  FeatureCapability(
    id: 'whisper_transcription',
    state: CapabilityState.planned,
    note: 'Whisper model နှင့် audio pipeline မချိတ်ရသေးပါ',
  ),
  FeatureCapability(
    id: 'smart_blur_masks',
    state: CapabilityState.planned,
    note: 'Background blur ရှိသော်လည်း အချိန်သတ်မှတ် Blur Mask မရှိသေးပါ',
  ),
];

FeatureCapability? capabilityById(String id) {
  for (final capability in rgCapabilities) {
    if (capability.id == id) return capability;
  }
  return null;
}
