# Android doğrulaması

Tarih: 16 Kasım 2026.

## Ortam

| Bileşen | Doğrulanan sürüm |
| --- | --- |
| Flutter / Dart | 3.50.0 stable / 3.14.0 |
| Java | Eclipse Temurin OpenJDK 21.0.13+9 |
| Gradle | 9.5.0, resmî SHA-256 ile doğrulandı |
| Android derleme platformu | API 36, Build Tools 36.0.0 |
| Android NDK | 28.2.13676358 (r28c) |
| Emülatör | 35.2.10; WHPX hızlandırması kullanılabilir |
| Sanal cihaz | Mini_Katalog / emulator-5554 |
| İşletim sistemi / ABI | Android 15, API 35 / x86_64 |
| Bellek sayfası | 16384 bayt (16 KB) |
| Ekran | 720 × 1280, yoğunluk 320 dpi |

Mevcut SDK/emülatör kullanılmış; eksik Java, Android Command-line Tools, API 36, Build Tools ve NDK eklenmiştir. İndirmeler resmî kaynaklardaki SHA-256/SHA-1 değerleriyle doğrulanmıştır. Makinenin kalıcı PATH veya Windows sanallaştırma ayarları değiştirilmemiştir. Yerel Java/Gradle/AVD verileri `.tools` altında tutulur ve Git'e dahil edilmez.

## Derleme ve kurulum

```powershell
powershell -ExecutionPolicy Bypass -File scripts/flutter.ps1 build apk --debug --target-platform android-x64
```

Sonuç: `build/app/outputs/flutter-apk/app-debug.apk`, ADB ile emülatöre kuruldu (`Success`). Flutter da cihazı desteklenen Android hedefi olarak gördü.

APK yalnızca x86_64 emülatör için debug modunda üretilmiştir; ARM telefon dağıtım paketi değildir. Fiziksel telefon için ayrıca uygun mimaride APK derlenip test edilmelidir. İlk debug açılışı yavaştı; ana sayfanın gerçekten görüntülendiği ayrıca kontrol edilmiştir. Yazılımsal grafik kullanıldığından performans ölçümü yapılmamıştır.

## Cihazda gözlenen sonuçlar

- Ana sayfa, banner ve yerel ürün görselleri açıldı.
- Katalogda 20 ürün gösterildi.
- iPhone 15 Pro kartı doğru ürün detayını açtı; kaydırınca açıklama ve 999 USD fiyat görüldü.
- Sepete ekleme sonrasında 1 ürün ve 999 USD toplam göründü.
- Adet 2 olunca satır ve sepet toplamı 1.998 USD oldu.
- Demo onayını iptal etmek sepeti korudu.
- Simülasyonu onaylamak sepeti temizledi ve boş sepet ekranını gösterdi; gerçek ödeme/sipariş yapılmadı.
- Geri dönüş ürün detayına ulaştı; sayfa kaydırması çalıştı.
- Kontrol sonunda uygulama süreci çalışıyordu; kendi PID'si için `AndroidRuntime:E` ve `flutter:E` günlükleri boştu.

Ekranlar: [ana sayfa](screenshots/android/01-ana-sayfa.png), [katalog](screenshots/android/02-katalog.png), [ürün detayı](screenshots/android/03-urun-detayi.png), [sepet](screenshots/android/04-sepet.png), [boş sepet](screenshots/android/05-bos-sepet.png).

Bu kontrol, tek bir emülatör yapılandırmasını kapsar. Fiziksel Android cihaz ve iOS doğrulaması yapılmamıştır.
