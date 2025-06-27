### To generate the environments

```bash
### Run generation environment only

```bash
dart run kappa:env 
  --appName kappa
  --supportedLocales en
  --supportedLocales vi
  --appLocalePath l10n
  --appLocale vi
  --fallbackLocale en
  -f
```

### To generate the build flavors (develop, staging and product)

```bash
dart run kappa:flavor 
  --appName kappa
  --applicationId tech.metalbox
  --bundleId tech.metalbox
  --flavorId
  -f
```

### To generate the localization files

```bash
dart run kappa:l10n 
  --supportedLocales en
  --supportedLocales vi
  --appLocalePath l10n
  --appLocale vi
  --fallbackLocale en
  -f
```

Supported locales:

- English (en)
- Español (es)
- Français (fr)
- 日本語 (ja)
- 한국어 (ko)
- Tiếng Việt (vi)
- 中文 (zh)

