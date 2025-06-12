import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const YorumAnalizApp());
}

class YorumAnalizApp extends StatelessWidget {
  const YorumAnalizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yorum Analizi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  String _sonuc = "";
  bool _loading = false;

  Future<void> _analizYap() async {
    final url = _controller.text.trim();

    if (url.isEmpty) {
      _showUyariDialog("Lütfen bir ürün linki girin.");
      return;
    }

    if (!url.contains("yorumlar")) {
      _showUyariDialog(
        "Lütfen yalnızca ürünün yorumlar sayfasına ait bir link girin.\n\n"
        "Örnek: https://www.trendyol.com/urun/xyz/yorumlar",
      );
      return;
    }

    setState(() {
      _loading = true;
      _sonuc = "";
    });

    try {
      final response = await http.post(
        Uri.parse(
          "http://192.168.124.67:8000/analyze",
        ), // IP'yi kendi sunucuna göre ayarla
        headers: {"Content-Type": "application/json"},
        body: json.encode({"url": url}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _sonuc = data['detay'] ?? "Veri alınamadı.";
        });
      } else {
        setState(() {
          _sonuc = "Sunucu hatası: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _sonuc = "Hata oluştu: $e";
      });
    }

    setState(() {
      _loading = false;
    });
  }

  void _showUyariDialog(String mesaj) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("⚠️ Uyarı"),
            content: Text(mesaj, style: const TextStyle(fontSize: 14)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Tamam"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          "Trendyol Yorum Analizi",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ürün Yorum Linki",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "https://www.trendyol.com/ürün/xyz/yorumlar",
                  labelText: "Linki buraya yapıştırın",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  prefixIcon: const Icon(Icons.link),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _analizYap,
                  icon: const Icon(Icons.analytics),
                  label: const Text("Analizi Başlat"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 16,
                    ),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (_loading)
                const Center(child: CircularProgressIndicator())
              else if (_sonuc.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SelectableText(
                    _sonuc,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
