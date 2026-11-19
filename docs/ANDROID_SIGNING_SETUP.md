# RGyi Recap Android release signing

The release keystore is a permanent app identity. Keep it private and back it up.
Do not upload the keystore, passwords, or Base64 text to the repository or chat.

## 1. Generate the permanent keystore on Windows

Install a JDK (the Android Studio JDK is fine), open PowerShell, and run:

```powershell
keytool -genkeypair -v -keystore "$HOME\rgyi-release.jks" -alias rgyi-release -keyalg RSA -keysize 4096 -validity 10000
```

When prompted, create a strong keystore password and key password. You may use
the same password for both. Keep the alias exactly `rgyi-release`.

Verify that the key exists:

```powershell
keytool -list -v -keystore "$HOME\rgyi-release.jks" -alias rgyi-release
```

Make at least two secure offline backups of `rgyi-release.jks`. Store the
passwords and alias separately from the backups. Never regenerate this key
for later updates.

## 2. Prepare the Base64 value for GitHub

In the same PowerShell window:

```powershell
$keystore = Join-Path $HOME "rgyi-release.jks"
$base64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($keystore))
Set-Clipboard $base64
```

The Base64 value is now on the clipboard. Paste it directly into the GitHub
secret field; do not put it in a source file or commit it.

## 3. Add four GitHub Actions repository secrets

Open the repository on GitHub:

**Settings → Secrets and variables → Actions → New repository secret**

Create these exact secret names:

| Secret name | Value |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | The Base64 value copied above |
| `ANDROID_KEYSTORE_PASSWORD` | The keystore password |
| `ANDROID_KEY_ALIAS` | `rgyi-release` |
| `ANDROID_KEY_PASSWORD` | The key password |

Do not send any of these values in ChatGPT.

## 4. Build policy

The workflow decodes the keystore only into the temporary GitHub runner.
It never writes the keystore into the repository. If any secret is missing,
the signed release build is skipped. CI still runs Flutter analysis, tests,
and an Android debug compilation check.

APK artifact publishing is intentionally disabled until the owner explicitly
authorizes it. A successful CI run is not the same as a phone installation
test.

## Important update warning

The original signing keystore was not retained. This is a new permanent key.
An app installed with a different previous signing key cannot normally be
updated in place with this key; it may require uninstalling the old app first.
Back up the new keystore and passwords permanently. Losing them prevents
normal signed updates under this app identity.
