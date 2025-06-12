# 🛍️ Trendyol Ürün Yorumlarının Duygu Analizi

Bu proje, Trendyol e-ticaret platformundaki ürün yorumlarını otomatik olarak toplayarak **Google Gemini API** yardımıyla **olumlu, olumsuz ve nötr** şeklinde sınıflandıran bir mobil analiz uygulamasıdır. Flutter ile geliştirilen ön yüz (frontend) ve Python tabanlı FastAPI ile geliştirilen arka yüz (backend), kullanıcıdan alınan bağlantı üzerinden gerçek zamanlı duygu analizi yapar.

---

## 🎯 Amaç

- Kullanıcıların, ürün yorumlarını analiz ederek **daha bilinçli kararlar** vermesini sağlamak.
- Teknik bilgiye ihtiyaç duymadan yorumlardan **genel eğilimi çıkarmak**.
- Trendyol’daki ürünlerin yorumlar sayfasından veriyi otomatik çekerek zaman kazandırmak.

---

## ⚙️ Kullanılan Teknolojiler

| Bileşen | Teknoloji |
|--------|-----------|
| Frontend | Flutter (Dart) |
| Backend | Python, FastAPI |
| Web Scraping | Selenium |
| Yapay Zeka API | Google Gemini |
| HTTP İletişimi | `http` (Flutter paketi) |
| Sunucu CORS Ayarı | FastAPI CORS middleware |

---

## 🔧 Sistem Mimarisi

1. Kullanıcı, Trendyol’daki bir ürünün **yorumlar sayfası linkini** uygulamaya yapıştırır.
2. Flutter uygulaması bu bağlantıyı FastAPI sunucusuna gönderir.
3. FastAPI, Selenium ile yorumları sayfadan çeker.
4. Tüm yorumlar birleştirilir, özel bir prompt ile **Google Gemini API** üzerinden duygu analizi yapılır.
5. API çıktısı yüzdelik dağılım ve özet yorum olarak kullanıcıya sunulur.

---

## 📱 Uygulama Özellikleri

- 🔗 **Link Girişi:** Sadece ürün yorum sayfası linki yeterlidir.
- ⚡ **Gerçek Zamanlı Analiz:** Yorumlar anında toplanır ve analiz edilir.
- 📊 **Yüzdelik Dağılım:** Olumlu, olumsuz ve nötr yüzdeleri net biçimde gösterilir.
- ⚠️ **Uyarı Sistemi:** Yanlış linkler için kullanıcı bilgilendirmesi yapılır.

---
