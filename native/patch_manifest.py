"""Adds what Phase 5 needs to the generated AndroidManifest.xml:
RECORD_AUDIO (microphone recording) and a <queries> entry so the app can see
the phone's text-to-speech engine. Safe to run twice."""
import sys

path = sys.argv[1]
s = open(path, encoding="utf-8").read()

perm = '<uses-permission android:name="android.permission.RECORD_AUDIO"/>'
queries = (
    '<queries><intent><action android:name="android.intent.action.TTS_SERVICE"/></intent></queries>'
)

changed = False
i = s.index("<manifest")
j = s.index(">", i) + 1
add = ""
if "android.permission.INTERNET" not in s:
    add += "\n    " + '<uses-permission android:name="android.permission.INTERNET"/>'
if "android.permission.RECORD_AUDIO" not in s:
    add += "\n    " + perm
if "android.intent.action.TTS_SERVICE" not in s:
    add += "\n    " + queries
for perm_name in (
    "android.permission.FOREGROUND_SERVICE",
    "android.permission.FOREGROUND_SERVICE_DATA_SYNC",
    "android.permission.POST_NOTIFICATIONS",
    "android.permission.WAKE_LOCK",
):
    if perm_name not in s and perm_name not in add:
        add += '\n    <uses-permission android:name="%s"/>' % perm_name
if add:
    s = s[:j] + add + s[j:]
    changed = True

# Set the installed Android app name (launcher label) to the standalone brand.
app_start = s.index("<application")
app_end = s.index(">", app_start)
app_tag = s[app_start:app_end]
label = 'android:label="RGyi Recap"'
if 'android:label=' in app_tag:
    import re
    updated_tag = re.sub(r'android:label="[^"]*"', label, app_tag)
else:
    updated_tag = app_tag + " " + label
if updated_tag != app_tag:
    s = s[:app_start] + updated_tag + s[app_end:]
    changed = True

# Foreground service that keeps a render alive in the background.
svc = '<service android:name="com.rgyi.recap.RenderService" android:exported="false" android:foregroundServiceType="dataSync"/>'
if "com.dramaflow.aistudio.RenderService" not in s:
    k = s.rindex("</application>")
    s = s[:k] + "    " + svc + "\n    " + s[k:]
    changed = True
open(path, "w", encoding="utf-8").write(s)
print("manifest patched" if changed else "manifest already patched")
