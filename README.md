# RGyi Recap — AI Movie Production Studio

A dedicated Flutter-based workspace for Burmese movie-recap production, migrated from the DramaFlow AI foundation while keeping the original DramaFlow repository unchanged.

## Included foundations
- Cinematic RGyi Recap dashboard and responsive navigation
- Local SQLite projects and project library
- Subtitle Studio, SRT parsing and editing tools
- Gemini-assisted recap and script workflow
- Audio Studio, device TTS, recording and audio import
- Timeline editor, Transformative Editor and native Android rendering
- Existing regression tests and engineering roadmap

## Android identity
- Application ID: `com.rgyi.recap` (separate from DramaFlow AI)
- The original DramaFlow package and repository are not modified.
- The private signing keystore is intentionally not included in this public repository. CI uses generated debug signing for the release artifact; this APK will not update an install signed with the original DramaFlow key.

## Build
GitHub Actions runs the **Build APK** workflow on pushes to `main`. The workflow runs Flutter analyze, tests and the Android release build, then uploads the APK artifact when successful.

## Roadmap
See `docs/v3/RGyi_Recap_Feature_Integration_Roadmap.md` for the staged integration plan. Features are not considered complete until tested on the target platform.
