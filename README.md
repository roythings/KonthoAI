# KonthoAI — কণ্ঠএআই | Bangla Voice Assistant

> বাংলায় বলুন, বাংলায় শুনুন. Speak in Bangla, hear answers in Bangla.

KonthoAI spreads Bangla/Bengali language and its development — starting with a **100% free, browser-based Bangla voice assistant**. No signup, no cost, no backend needed for v0.1.

**Live demo:** press 🎙️, speak Bangla (bn-BD), hear the answer. Works best in Chrome/Edge.

## ✨ v0.1 Features

- 🎙️ Bangla speech-to-text via Web Speech API (`bn-BD`)
- 🔊 Bangla text-to-speech with auto-speak + speed control
- 🧠 Offline Bangla brain: greetings, স্বরবর্ণ, ব্যঞ্জনবর্ণ, সংখ্যা ১-১০, সময়/তারিখ, দৈনন্দিন বাক্য
- 🌐 Optional OpenAI BYOK (key stays in your browser `localStorage`) for smarter answers
- 🔤 Learning cards: vowels, consonants, numbers, daily phrases — tap to hear
- 📱 Responsive, Bangla-first UI, single static file

## 🚀 Run locally

Static site — no build needed:

```bash
# preview dist/
python3 -m http.server 3000 --directory dist --bind 0.0.0.0
# open http://localhost:3000
```

OMGithub / production:

```bash
./startup.sh   # verify dist/index.html
PORT=3000 ./start.sh
```

## 🗺️ Roadmap to success

- [x] v0.1 Landing + browser voice demo (this commit)
- [ ] v0.2 Whisper STT + higher-quality Bangla TTS (Coqui XTTS / ElevenLabs)
- [ ] v0.3 Learning app: alphabet quiz, pronunciation scoring, stories
- [ ] v0.4 Open Bangla voice corpus (MIT-licensed dataset)
- [ ] Community: `good first issue`, Bangla+English CONTRIBUTING, demo video

## 🤝 Contribute

1. Add phrases to the offline brain (`brain()` in `dist/index.html` / `index.html`)
2. Add learning content (words, stories, audio)
3. Report Bangla TTS/STT issues with browser + OS
4. Remix on OMGithub

Source of truth: `index.html` (root) → copied to `dist/index.html` for deployment. Keep them in sync.

## 📄 License

MIT — see [LICENSE](LICENSE).

<!-- omgithub:readme:start -->
## 🚀 Build, play, and remix with OMGithub

**Remixed using [OMGithub.com](https://omgithub.com).**

[![OMGithub](https://img.shields.io/badge/OMGithub-Open%20project-orange?style=for-the-badge)](https://omgithub.com/roythings/KonthoAI)
[![GitHub](https://img.shields.io/badge/GitHub-Source-181717?logo=github&style=for-the-badge)](https://github.com/roythings/KonthoAI)

- 🎮 [Open the project](https://omgithub.com/roythings/KonthoAI).
- ✨ [Remix this project](https://omgithub.com/?remix=roythings%2FKonthoAI).
- 💻 [Explore the source](https://github.com/roythings/KonthoAI).
- 🛠️ [Check build runs](https://github.com/roythings/KonthoAI/actions).
- 🐛 [Report an issue](https://github.com/roythings/KonthoAI/issues).
- 👤 [Explore the creator's projects](https://omgithub.com/roythings).
- 🌍 [Create with OMGithub](https://omgithub.com).
- 🧬 [Explore the remix source](https://github.com/roythings/KonthoAI).
<!-- omgithub:readme:end -->
