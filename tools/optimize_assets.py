#!/usr/bin/env python3
"""Regenerate compact launcher icons + splash for Spot the Scam.

Source of truth: the 1254x1254 brand logo. Produces correctly sized,
optimized PNGs and removes the oversized per-density/orientation splash
copies that bloated earlier APKs.
"""
import os
import shutil
from PIL import Image, ImageDraw

ROOT = os.path.join(os.path.dirname(__file__), "..")
RES = os.path.join(ROOT, "android", "app", "src", "main", "res")
LOGO = "/home/noneya/Desktop/Spot The Scam 1.0.0 Logo.png"

logo = Image.open(LOGO).convert("RGBA")

# Square-crop the logo so it centers cleanly.
w, h = logo.size
s = min(w, h)
logo = logo.crop(((w - s) // 2, (h - s) // 2, (w - s) // 2 + s, (h - s) // 2 + s))


def save_png(img, path):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    img.save(path, "PNG", optimize=True)


# ---- Launcher icons (legacy square + round) ----
LAUNCHER = {"ldpi": 36, "mdpi": 48, "hdpi": 72, "xhdpi": 96,
            "xxhdpi": 144, "xxxhdpi": 192}
# Adaptive foreground canvas sizes (108dp).
FOREGROUND = {"ldpi": 81, "mdpi": 108, "hdpi": 162, "xhdpi": 216,
              "xxhdpi": 324, "xxxhdpi": 432}

for dpi, px in LAUNCHER.items():
    d = os.path.join(RES, "mipmap-" + dpi)
    sq = logo.resize((px, px), Image.LANCZOS)
    save_png(sq, os.path.join(d, "ic_launcher.png"))

    mask = Image.new("L", (px * 4, px * 4), 0)
    ImageDraw.Draw(mask).ellipse((0, 0, px * 4, px * 4), fill=255)
    mask = mask.resize((px, px), Image.LANCZOS)
    rnd = sq.copy()
    rnd.putalpha(mask)
    save_png(rnd, os.path.join(d, "ic_launcher_round.png"))

for dpi, px in FOREGROUND.items():
    d = os.path.join(RES, "mipmap-" + dpi)
    canvas = Image.new("RGBA", (px, px), (0, 0, 0, 0))
    inner = int(px * 0.66)  # keep logo inside the adaptive safe zone
    li = logo.resize((inner, inner), Image.LANCZOS)
    canvas.paste(li, ((px - inner) // 2, (px - inner) // 2), li)
    save_png(canvas, os.path.join(d, "ic_launcher_foreground.png"))


# ---- Splash: one optimized black drawable for all densities ----
SPLASH = 768
splash = Image.new("RGB", (SPLASH, SPLASH), (0, 0, 0))
ls = int(SPLASH * 0.62)
li = logo.resize((ls, ls), Image.LANCZOS)
splash.paste(li.convert("RGB"), ((SPLASH - ls) // 2, (SPLASH - ls) // 2),
             li.split()[3])
splash_q = splash.quantize(colors=256, method=Image.MEDIANCUT)
save_png(splash_q, os.path.join(RES, "drawable", "splash.png"))

# Remove every other splash.png copy and the now-empty density dirs.
removed = 0
for name in os.listdir(RES):
    if not name.startswith("drawable"):
        continue
    if name == "drawable" or name == "drawable-v24":
        continue
    p = os.path.join(RES, name, "splash.png")
    if os.path.isfile(p):
        os.remove(p)
        removed += 1
    # drop the directory entirely if nothing else remains
    dpath = os.path.join(RES, name)
    if os.path.isdir(dpath) and not os.listdir(dpath):
        os.rmdir(dpath)

# ---- Shrink the @capacitor/assets source files (repo hygiene) ----
src_icon = Image.new("RGBA", (1024, 1024), (0, 0, 0, 0))
src_icon.paste(logo.resize((1024, 1024), Image.LANCZOS))
save_png(src_icon, os.path.join(ROOT, "assets", "icon.png"))

src_splash = Image.new("RGB", (2732, 2732), (0, 0, 0))
sl = int(2732 * 0.35)
sli = logo.resize((sl, sl), Image.LANCZOS)
src_splash.paste(sli.convert("RGB"), ((2732 - sl) // 2, (2732 - sl) // 2),
                 sli.split()[3])
save_png(src_splash.quantize(colors=256), os.path.join(ROOT, "assets", "splash.png"))

print("splash copies removed:", removed)
print("done")
