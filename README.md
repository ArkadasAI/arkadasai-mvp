# ArkadaşAI Mobil Uygulaması

Bu depo, ArkadaşAI Android uygulamasının bulut ortamında geliştirilen MVP sürümünü içerir. Uygulama Flutter ile yazılmıştır ve Material 3 teması, çok dilli destek (Türkçe, İngilizce, Arapça), kullanıcı onboarding akışı, sohbet arayüzü, plan yönetimi ve paywall özelliklerini barındırır. Tüm veriler ve API çağrıları bulutta barındırılan mock sunucu üzerinden gerçekleşir.

## Özellikler

- **Onboarding Akışı:** Kullanıcı adı, doğum tarihi, cinsiyet ve tercihlerin toplandığı adımlar.
- **Auth Ekranı:** Google, e-posta veya misafir girişi seçeneği.
- **Plan & Paywall:** Free kullanıcılar için 5 mesaj limiti, Plus/Pro planları için limitsiz mesaj ve TTS butonu.
- **Sohbet:** Karakter listesi ve gerçek zamanlı mesajlaşma arayüzü.

## CI/CD ve APK Release

Bu proje için bir GitHub Actions iş akışı tanımlanmıştır. Workflow, her `main` dalına yapılan push’ta uygulamanın sürüm numarasını otomatik olarak arttırır, bir release APK üretir ve bu APK’yı GitHub Releases sayfasına yükler. Böylece uygulamanın son sürümüne kolayca erişebilirsiniz.

Workflow dosyası `.github/workflows/build_release.yml` altında bulunur ve aşağıdaki adımları içerir:

1. Flutter kurulumu (stable channel).
2. Bağımlılıkların indirilmesi (`flutter pub get`).
3. Release APK derlenmesi (`flutter build apk --release`).
4. `pubspec.yaml` içindeki sürüm numarasının artması ve commit edilmesi.
5. Yeni bir Git tag’i ve GitHub Release oluşturulması.
6. Üretilen APK dosyasının release’e eklenmesi.

### APK Nasıl İndirilir ve Yüklenir?

1. Bu repo’nun [Releases](../../releases) sekmesine gidin.
2. En son sürüm numarasına sahip release’i seçin (örn. `1.0.0+2`).
3. Assets altında yer alan `app-release-<sürüm>.apk` dosyasını indirin.
4. Android cihazınızda bilinmeyen kaynaklardan uygulama yüklemeye izin verdiğinizden emin olun.
5. İndirilen `.apk` dosyasını açarak yüklemeyi tamamlayın.

> Not: APK yalnızca Android 5.0 ve üzeri cihazlarda çalışır. Kurulum sırasında güvenlik uyarıları çıkabilir; ArkadaşAI uygulaması resmi GitHub hesabından indirildiği sürece güvenlidir.
