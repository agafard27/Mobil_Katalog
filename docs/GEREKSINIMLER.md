# Yönerge ile uygulama eşlemesi

Kaynak: “Mobil Uygulama Geliştirme; Android _ iOS Proje Yönergesi.pdf”, 5 sayfa.

| Beklenen | Uygulama / kanıt |
| --- | --- |
| Flutter + Dart | Flutter 3.50.0 / Dart 3.14.0; Android/iOS/web proje iskeletleri |
| material.dart, ek paket yok | pubspec.yaml: yalnızca Flutter; test için SDK flutter_test |
| Stateless/Stateful widget | HomeScreen / CatalogScreen / MiniKatalogApp |
| Ana sayfa, liste, detay | lib/screens altında ilgili ekranlar |
| Navigasyon / argument | app.dart: MaterialPageRoute, RouteSettings.arguments; kartlarda pushNamed, geri dönüşte pop |
| Model, fromJson/toJson | lib/models/product.dart ve dönüşüm testi |
| JSON simülasyonu | assets/data/products.json ve CatalogRepository |
| Image.asset / asset yönetimi | 20 ürün görseli + banner ve pubspec.yaml tanımları |
| GridView kartları | ProductGrid / ProductCard |
| ListView.builder | Katalog liste görünümü ve sepet satırları |
| Arama/filtreleme | Türkçe harf normalleştirme, kategori, fiyat/ad sıralama |
| State / sepet simülasyonu | setState ve SDK ChangeNotifier/ListenableBuilder; adet, toplam, silme, demo onayı |
| Tema / klasörleme | theme, models, data, state, screens, widgets, utils |
| README ve sürüm bilgisi | README.md |
| Ekran görüntüleri | docs/screenshots: web görüntüleri; android/ altında 5 gerçek Android emülatör görüntüsü |
| Public GitHub URL | Depo kullanıcı tarafından hazırlandı; public durumu ve URL bu çalışma içinde doğrulanmadı |
| Android emülatör / cihaz | Android 15, x86_64, 16 KB emülatörde APK kurulumu ve temel akışlar geçti |
| VS Code / Android Studio | VS Code mevcut; Android Studio kısayolu uygulama envanterinde var, çalışır kurulumu ve SDK'sı doğrulanamadı |

## Kabul senaryoları

1. Koleksiyonu aç; 20 ürün gör.
2. “HomePod Mini” ara; tek ürün gör. Olmayan kelime ara; boş sonuçtan filtreleri temizle.
3. Kategori, sıralama ve liste/ızgara görünümünü değiştir.
4. Ürüne dokun; doğru ad/fiyat/görsel/özelliklerle detay açılsın.
5. Sepete ekle; sayfalar arasında sepet sayısı korunsun.
6. Adet artır/azalt; toplamı doğrula. Son adedi azalt veya kaldır; boş sepeti gör.
7. Demo tamamlamayı iptal et; sepet korunsun. Onayla; ödeme almadan sepet temizlensin.
8. Geri dön; detay ve katalog navigasyonu korunsun.

## Doğrulama kapsamı

Flutter testleri, web release derlemesi ve Android debug APK derlemesi yerelde çalıştırılmıştır. Widget testleri aynı yerel JSON ürünlerini bellekten yükler; gerçek asset yüklemesi ayrıca tarayıcıda ve Android emülatöründe kontrol edilmiştir. Fiziksel cihaz ve iOS testi yapılmamıştır.

16 Kasım 2026 doğrulama sonucu: `flutter test` 6/6 geçti; `flutter analyze` sorun bulmadı; web release ve Android debug APK derlemeleri başarılı. Chrome'da ana sayfa, katalog, arama, ürün detayı ve sepete ekleme kontrol edildi. Android emülatöründe ayrıca adet/toplam değişimi, demo iptal/onayı, boş sepet ve geri navigasyon doğrulandı. AndroidRuntime/Flutter hata günlüğü boş. [Android test kaydı](ANDROID_TEST.md).
