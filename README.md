# AI Interviews Download

Publieke downloadsite voor de mobiele **AI Interviews** app.

- Website: https://download.airecruiterapp.nl
- QR/direct-download: https://download.airecruiterapp.nl/?download=1
- Vast APK-bestand in GitHub Releases: `AI-Interviews.apk`

## Nieuwe mobiele build publiceren

Voer dit uit vanuit de lokale `mobile` projectmap nadat een Android `preview` EAS-build succesvol is afgerond:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Buffert99/AI-Interviews-Download/main/publish-latest-eas-apk.sh)
```

Het script zoekt de nieuwste geslaagde Android preview-build in EAS en start vervolgens de GitHub Action die de APK als `AI-Interviews.apk` publiceert.

De downloadpagina controleert GitHub Releases automatisch. Zodra de release klaar is, hoeft de website of QR-code niet opnieuw aangepast te worden.
