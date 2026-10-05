# Changelog

## [0.2.0](https://github.com/wendirad/emi-flutter-template/compare/flutter_template-v0.1.0...flutter_template-v0.2.0) (2026-10-05)


### Features

* add issue templates for bug reports and feature requests, and configure dependabot ([7b23b69](https://github.com/wendirad/emi-flutter-template/commit/7b23b690ac70226ebcb42cd67f7db12d09b72a78))
* **l10n:** add localization scaffold with English and Amharic ([e0e3dfe](https://github.com/wendirad/emi-flutter-template/commit/e0e3dfe7810238ad3bf4b238b360662066235c7f))
* **l10n:** move every user-facing string into English and Amharic ([7bdfb16](https://github.com/wendirad/emi-flutter-template/commit/7bdfb164ac84f4500d212e74fa835cb71ba1440d))
* **theme:** bundle Poppins instead of fetching it at runtime ([0ee9976](https://github.com/wendirad/emi-flutter-template/commit/0ee99766c24aec017a1154438402b9fde146edb4))


### Bug Fixes

* **app:** limit Firebase test settings to debug builds ([2d9bf57](https://github.com/wendirad/emi-flutter-template/commit/2d9bf571e7be460686e4de7fd14d91246f4bc151))
* **auth:** await sign-up rollback and use StoreName.user ([b963160](https://github.com/wendirad/emi-flutter-template/commit/b9631608a66992b3a06be5395f35fd38e0bf7163))
* **auth:** correct email, text and sign-in password validation ([65c2c13](https://github.com/wendirad/emi-flutter-template/commit/65c2c137217fecdaf0ec529e03e8ea40100ff530))
* **auth:** keep lastSignInTime in AuthUserModel.copyWith ([64aa376](https://github.com/wendirad/emi-flutter-template/commit/64aa376285c1c14e3bb3c99ccf4bf512f2840bca))
* **auth:** let state copyWith clear the error ([a036f45](https://github.com/wendirad/emi-flutter-template/commit/a036f45c0a9df3e58e66b965300c3fa78d797c8d))
* **auth:** stop persisting the password on sign-in ([b55c468](https://github.com/wendirad/emi-flutter-template/commit/b55c468f28d6cc35c6c1c6213aeb7da29c2c059a))
* **auth:** stop wiping the avatar on profile edits ([1da147d](https://github.com/wendirad/emi-flutter-template/commit/1da147dd9f0c54c7c339f01c032453cb7041f7ed))
* **auth:** subscribe AuthSessionBloc to the auth stream ([c0c5b17](https://github.com/wendirad/emi-flutter-template/commit/c0c5b17c258c25a64c617eba266efb09c32d9b62))
* **auth:** type the password reset route arguments ([b6b2906](https://github.com/wendirad/emi-flutter-template/commit/b6b2906ef5ddd7018cdc2aa9fbf94d2482dd593f))
* **core:** remove nav bar listener leak and stacking tabs ([06bb118](https://github.com/wendirad/emi-flutter-template/commit/06bb11853a3e65ed410998c9d1e2865b6199ce64))
* **core:** stop AppButton from hiding itself on short navigation history ([2d055f1](https://github.com/wendirad/emi-flutter-template/commit/2d055f14f86585309f26b801adc9626e4c403ccd))
* **deps:** migrate to flutter_modular 7 and google_fonts 9 ([13cb979](https://github.com/wendirad/emi-flutter-template/commit/13cb979d256854ef3dd393d3b695b1ee97ee5150))
* **firebase:** ship rules that match what the app does ([15c6d66](https://github.com/wendirad/emi-flutter-template/commit/15c6d661e962aefedb1fd81763238cef9eb90aca))
* **firebase:** track the firebase_options placeholder ([86a4231](https://github.com/wendirad/emi-flutter-template/commit/86a42316baa592621c815b87cd424a2766fad3b7))
* **l10n:** commit the generated localizations exactly as gen-l10n writes them ([687256f](https://github.com/wendirad/emi-flutter-template/commit/687256f105a4281de6837981acc19c7cd60a99c8))
* restore the project name and description placeholders ([75d3df4](https://github.com/wendirad/emi-flutter-template/commit/75d3df4d3b4c93fb5f27492b717a4ef8a6121f5a))
* **settings:** fetch the user once and handle a missing user ([adf36dc](https://github.com/wendirad/emi-flutter-template/commit/adf36dc3f70c05a52dd33a98be11f1d3eb3c2296))
* **theme:** load the theme before runApp and toggle the effective brightness ([0d53df4](https://github.com/wendirad/emi-flutter-template/commit/0d53df4a694659265d8367e2b19e28f768d6b586))
