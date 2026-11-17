# RGyi Recap — Feature Integration & Upgrade Roadmap

**Status:** Phase 1 Android CI verified; Phase 2 integration foundation started.  
**Branch:** main  
**Application ID:** `com.rgyi.recap`  
**Scope:** Reuse proven DramaFlow AI foundations in this separate repository. The original DramaFlow AI repository remains unchanged.

## Current verified baseline

- 116 source files migrated into this repository; the private Android signing keystore was intentionally excluded.
- RGyi Recap has its own Android application ID: `com.rgyi.recap`.
- Latest verified Android CI: Flutter analyze, Flutter tests, Android release APK build and artifact upload all passed.
- Existing local project database, SRT tools, Gemini handoff, device/Gemini TTS, timeline, Transformative Editor and native Android renderer are retained.
- Windows desktop build and runtime behavior have not yet been verified.

## Phase 2 progress

The first provider-neutral integration contracts are now in `lib/core/providers.dart`:
- Translation provider contract with Recap and Full Subtitle modes.
- Cue-index-based translation results; applying a batch preserves source cue order, IDs and timestamps and keeps source text for missing translations.
- Transcription provider contract returning timestamped SRT cues.
- Speech synthesis provider contract with explicit offline metadata.
- Capability registry that distinguishes available, partial and planned features.

Regression coverage is in `test/providers_test.dart`. These are interfaces and safety primitives, not claims that Whisper or a translation provider is already connected. Real adapters must be implemented and tested before the UI advertises them as available.

## 1. Product direction

RGyi Recap combines:
- project, subtitle, audio, timeline, render and Transformative Editor foundations;
- AI TTS, recap/full translation, aspect-ratio outputs, blur masks, Whisper subtitle generation and multiple narrator voices;
- a guided end-to-end movie recap pipeline with manual overrides at every stage.

Each feature must pass its acceptance checks before it is labelled ready.

## 2. Existing foundations

| Area | Existing source | Current capability |
|---|---|---|
| Project & local data | `lib/data/project.dart`, `app_db.dart`, `project_repo.dart`, `project_store.dart` | Local SQLite projects and repositories |
| SRT | `lib/core/srt.dart`, `subtitle_ops.dart`, `lib/ui/subtitle_studio_screen.dart` | Parse, validate, split/merge, time shift and edit |
| Recap script | `lib/core/video_recap.dart`, `lib/ui/video_recap_screen.dart` | Gemini-assisted, part-by-part prompt and manual handoff |
| TTS & audio | `lib/ui/audio_panel.dart`, `lib/core/gemini_tts.dart`, `lib/platform/gemini_tts_client.dart` | Device TTS, microphone, imported audio and optional Gemini API TTS |
| Timeline | `lib/core/timeline.dart`, `lib/ui/editor_panel.dart` | Non-destructive clips, crop/zoom, freeze frames, narration/music and subtitle remapping |
| Render | `lib/core/render_plan.dart`, `lib/ui/render_panel.dart`, `render_channel.dart` | 16:9, 9:16, 1:1, 4:5, bars/crop/blur-fill and native MP4 rendering |
| Transformative Editor | `transformative_plan.dart`, `te_compile.dart`, `te_ai.dart`, `transformative_editor_screen.dart` | Proposed edits, validation and non-destructive render plan |
| Video import | `lib/platform/video_import.dart`, `video_info.dart` | Import and metadata path |

## 3. Feature parity and acceptance

### A. Voice Studio
Already present: device TTS where a Burmese voice is installed, recording, imported audio, chunked narration and optional Gemini API TTS.

Next: unified provider catalogue, voice audition, per-chunk controls, batch progress/cancel/retry/resume and audio quality controls.

Acceptance: one chunk can be regenerated without overwriting others; offline/manual paths remain usable without an API key; provider failures are recoverable.

### B. Translation Studio
Next:
- Recap Translation: adapt narration while preserving storytelling tone.
- Full Translation: translate every subtitle cue while preserving cue order and timestamps.
- Per-project glossary and character-name memory.
- Chunked translation, retry/progress and side-by-side review.
- Save translated output separately; never silently rewrite source SRT.

Acceptance: source cue count, IDs and timestamps remain unchanged; partial retries do not duplicate or drop cues.

### C. Whisper subtitles
No native Whisper transcription integration is connected yet. The provider contract now exists.

Next: assess local Whisper model feasibility and Android/Windows performance; implement audio extraction, language detection, chunking, cancellation/resume and SRT handoff only after the chosen runtime is verified.

Acceptance: generated SRT passes existing validation; no offline-support claim until an on-device model is proven on target devices.

### D. Aspect ratio and blur masks
Already present: 16:9, 9:16, 1:1 and 4:5 outputs, bars/crop and experimental blurred-background fill.

Important: blurred background fill is not a privacy blur mask.

Next: platform safe-area presets, draggable focal point and real rectangle/ellipse masks with position, size, feather, strength and time range.

Acceptance: masks affect only selected regions/time ranges; source media remains untouched; preview and render match.

### E. End-to-end production
Connect these stages into a resumable board:
1. Import video and inspect metadata.
2. Generate/import transcript.
3. Translate subtitles or create recap narration.
4. Review/edit script.
5. Generate/record narrator audio.
6. Arrange clips, narration, music and subtitles.
7. Apply ratio, crop and blur masks.
8. Run quality checks and render MP4.
9. Review and export.

Free Mode must keep every existing stage manually accessible. Guided Mode recommends next steps but never locks user data.

## 4. Delivery phases

### Phase 1 — Brand/UI stabilization
**Baseline Android CI passed.** Windows desktop build/runtime remains to be checked.

### Phase 2 — Reuse and integration foundation
- [x] Inspect existing routes and module entry points.
- [x] Add provider-neutral Translation, Transcription and Speech Synthesis contracts.
- [x] Add cue-preserving translation application helper.
- [x] Add capability registry and contract regression tests.
- [ ] Wire capability states into module UI.
- [ ] Add real provider adapters only after provider/runtime selection and tests.

### Phase 3 — Voice Studio upgrade
Voice catalogue, preview, per-chunk settings, batch queue, retry/resume and quality controls.

### Phase 4 — Translation Studio
Recap and Full Translation, glossary, side-by-side review and separate source/target documents.

### Phase 5 — Whisper Transcription
Benchmark local models first; then audio extraction, transcription queue and SRT handoff. Remote transcription remains optional.

### Phase 6 — Advanced Video Editor
Safe-area preview and real time-bounded blur masks; keyframes/tracking only after the base renderer is stable.

### Phase 7 — Production automation & QA
Resumable pipeline, quality checks and Android/Windows validation.

## 5. Non-negotiable safeguards

- Keep the original DramaFlow AI repository unchanged.
- Preserve existing project IDs, SQLite schema and current routes/workflows unless a separately reviewed migration is essential.
- Keep local-first editing, SRT correction, timeline planning and manual audio paths.
- Keep source video and source SRT immutable; derived assets are separate.
- Never expose API keys in logs, URLs, screenshots or committed files.
- Do not claim a provider, voice, Whisper model, blur mask or platform build is supported until tested.
- Run formatter, analyzer, full tests and Android build after meaningful integrations; verify Windows before claiming desktop parity.

## 6. Next engineering actions

1. Wire the capability registry into Home Studio module cards so planned features are clearly distinguished from usable ones.
2. Implement Translation Studio using the cue-preserving contract and existing Gemini/manual handoff patterns.
3. Benchmark Whisper options before choosing a runtime or downloading large models.
4. Upgrade Voice Studio without removing current device TTS, recording or import.
5. Add real blur-mask support only after confirming the native renderer can composite timed mask layers.
