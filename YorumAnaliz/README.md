# Ürün Yorum Analizi

Bu uygulama, e-ticaret sitelerindeki (örneğin Trendyol) ürün yorumlarını analiz ederek duygu analizi yapar ve sonuçları kullanıcıya sunar.

## Özellikler

- Selenium ile dinamik web sayfalarından yorumları otomatik çekme
- Yorumların duygu analizi (Olumlu/Olumsuz/Nötr)
- Yüzdesel dağılım gösterimi
- Örnek yorumların gösterimi

## Kurulum

1. Google Chrome tarayıcısının yüklü olduğundan emin olun

2. Chrome WebDriver'ı indirin:
   - https://chromedriver.chromium.org/downloads adresine gidin
   - Chrome tarayıcınızın versiyonuna uygun WebDriver'ı indirin
   - İndirdiğiniz `chromedriver.exe` dosyasını projenin ana dizinine koyun

3. Gerekli Python paketlerini yükleyin:
```bash
pip install -r requirements.txt
```

4. Uygulamayı çalıştırın:
```bash
python main.py
```

## Kullanım

1. Uygulamayı başlatın
2. Analiz etmek istediğiniz ürünün URL'sini girin
3. Sonuçları görüntüleyin
4. Çıkmak için 'q' tuşuna basın

## Gereksinimler

- Python 3.7+
- Google Chrome tarayıcısı
- Chrome WebDriver (chromedriver.exe)
- selenium
- nltk
- textblob
- pandas

## Notlar

- Uygulama varsayılan olarak headless modda çalışır (tarayıcı görünmez)
- Her analiz için ilk 3 sayfa yorum çekilir
- Yorumlar otomatik olarak sayfalandırılır
- Chrome WebDriver versiyonu, Chrome tarayıcınızın versiyonu ile aynı olmalıdır 
