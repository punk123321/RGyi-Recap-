"""Adds AndroidX Media3 and optional secure release signing to the generated app module."""
import os
import sys

app = sys.argv[1]
V = "1.8.0"
mods = ["media3-transformer", "media3-effect", "media3-common"]

for name, kts in (("build.gradle.kts", True), ("build.gradle", False)):
    path = os.path.join(app, name)
    if os.path.exists(path):
        break
else:
    sys.exit("no app build.gradle found in " + app)

s = open(path, encoding="utf-8").read()
if "media3-transformer" not in s:
    lines = []
    for m in mods:
        lines.append('    implementation("androidx.media3:%s:%s")' % (m, V) if kts
                     else "    implementation 'androidx.media3:%s:%s'" % (m, V))
    s += "\ndependencies {\n" + "\n".join(lines) + "\n}\n"

# Release signing values are read only from CI environment variables.
# The keystore itself is decoded to a temporary runner path and is never committed.
if "RGYI_SECURE_RELEASE_SIGNING" not in s:
    if kts:
        signing = """
// RGYI_SECURE_RELEASE_SIGNING
val rgyiKeystorePath = System.getenv("ANDROID_KEYSTORE_PATH")
val rgyiKeystorePassword = System.getenv("ANDROID_KEYSTORE_PASSWORD")
val rgyiKeyAlias = System.getenv("ANDROID_KEY_ALIAS")
val rgyiKeyPassword = System.getenv("ANDROID_KEY_PASSWORD")
if (!rgyiKeystorePath.isNullOrBlank() &&
    !rgyiKeystorePassword.isNullOrBlank() &&
    !rgyiKeyAlias.isNullOrBlank() &&
    !rgyiKeyPassword.isNullOrBlank()) {
    android {
        signingConfigs {
            create("rgyiRelease") {
                storeFile = file(rgyiKeystorePath)
                storePassword = rgyiKeystorePassword
                keyAlias = rgyiKeyAlias
                keyPassword = rgyiKeyPassword
            }
        }
        buildTypes {
            getByName("release") {
                signingConfig = signingConfigs.getByName("rgyiRelease")
            }
        }
    }
}
"""
    else:
        signing = """
// RGYI_SECURE_RELEASE_SIGNING
def rgyiKeystorePath = System.getenv("ANDROID_KEYSTORE_PATH")
def rgyiKeystorePassword = System.getenv("ANDROID_KEYSTORE_PASSWORD")
def rgyiKeyAlias = System.getenv("ANDROID_KEY_ALIAS")
def rgyiKeyPassword = System.getenv("ANDROID_KEY_PASSWORD")
if (rgyiKeystorePath && rgyiKeystorePassword && rgyiKeyAlias && rgyiKeyPassword) {
    android {
        signingConfigs {
            rgyiRelease {
                storeFile file(rgyiKeystorePath)
                storePassword rgyiKeystorePassword
                keyAlias rgyiKeyAlias
                keyPassword rgyiKeyPassword
            }
        }
        buildTypes {
            release {
                signingConfig signingConfigs.rgyiRelease
            }
        }
    }
}
"""
    s += "\n" + signing

open(path, "w", encoding="utf-8").write(s)
print("gradle patched:", path)
