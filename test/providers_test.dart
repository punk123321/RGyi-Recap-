import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:aistudio/core/providers.dart';
import 'package:aistudio/core/srt.dart';

void main() {
  group('translation provider contract', () {
    test('applies translated text without changing cue IDs or timestamps', () {
      final source = [
        const SrtEntry(7, 1000, 2500, 'Hello'),
        const SrtEntry(9, 3000, 4500, 'World'),
      ];
      final result = applyTranslationBatch(
        source,
        const TranslationBatch(textByCueIndex: {7: 'မင်္ဂလာပါ'}),
      );

      expect(result.entries, [
        const SrtEntry(7, 1000, 2500, 'မင်္ဂလာပါ'),
        const SrtEntry(9, 3000, 4500, 'World'),
      ]);
      expect(result.missingCueIndices, [9]);
      expect(source[0].text, 'Hello');
    });

    test('ignores translations for cue IDs absent from the source', () {
      final result = applyTranslationBatch(
        [const SrtEntry(1, 0, 1000, 'Original')],
        const TranslationBatch(textByCueIndex: {1: '  ', 99: 'Extra'}),
      );

      expect(result.entries.single.text, 'Original');
      expect(result.missingCueIndices, [1]);
    });
  });

  test('capability registry does not claim planned integrations are ready', () {
    expect(capabilityById('translation')!.state, CapabilityState.partial);
    expect(capabilityById('whisper_transcription')!.state, CapabilityState.planned);
    expect(capabilityById('smart_blur_masks')!.state, CapabilityState.planned);
    expect(capabilityById('speech_synthesis')!.state, CapabilityState.partial);
    expect(capabilityById('not-a-feature'), isNull);
  });

  test('transcription request supports byte audio payloads', () {
    final request = TranscriptionRequest(
      audio: Uint8List.fromList([1, 2, 3]),
      language: 'my',
    );
    expect(request.audio, [1, 2, 3]);
    expect(request.detectLanguage, isFalse);
  });
}
