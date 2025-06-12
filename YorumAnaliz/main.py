import time
import google.generativeai as genai
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from selenium import webdriver
from selenium.webdriver.chrome.service import Service as ChromeService
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager

# ✅ Gemini API key
genai.configure(api_key="AIzaSyDy-7X90nukqgXkHlNF1xWgl6-Zrreaf1I")

# ✅ Gemini model tanımı
model = genai.GenerativeModel(model_name="gemini-2.0-flash")

# ✅ FastAPI başlat
app = FastAPI()

# ✅ CORS ayarları (Flutter için açık)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ✅ Çerezleri kabul etme fonksiyonu
def accept_cookies(driver):
    try:
        cookie_button = driver.find_element(By.ID, "onetrust-accept-btn-handler")
        cookie_button.click()
        time.sleep(1)
    except:
        pass  # Buton yoksa devam et

# ✅ Trendyol yorumlarını Selenium ile çekme (sonsuz kaydırmalı)
def scrape_trendyol_comments(url: str, max_comments: int = 100) -> str:
    try:
        chrome_options = Options()
        chrome_options.add_argument("--start-maximized")
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_options.add_argument("--disable-gpu")

        prefs = {"profile.default_content_setting_values.notifications": 2}
        chrome_options.add_experimental_option("prefs", prefs)

        driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()), options=chrome_options)
        driver.get(url)

        accept_cookies(driver)
        time.sleep(2)

        comments = set()
        scroll_pause_time = 2
        same_scroll_count = 0
        last_height = driver.execute_script("return document.body.scrollHeight")

        while len(comments) < max_comments and same_scroll_count < 3:
            comment_elements = driver.find_elements(By.CLASS_NAME, "comment-text")
            for el in comment_elements:
                text = el.text.strip()
                if text:
                    comments.add(text)
                if len(comments) >= max_comments:
                    break

            driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
            time.sleep(scroll_pause_time)

            new_height = driver.execute_script("return document.body.scrollHeight")
            if new_height == last_height:
                same_scroll_count += 1
            else:
                same_scroll_count = 0
            last_height = new_height

        driver.quit()

        if not comments:
            return "Yorum bulunamadı."

        # ❗ Her yorumun sonuna '.\n' ekle
        formatted_comments = [comment + ".\n" for comment in comments]
        return "".join(formatted_comments)

    except Exception as e:
        return f"Scraping hatası: {e}"

# ✅ Prompt oluşturma
def generate_prompt(all_comments: str) -> str:
    prompt = (
        "Aşağıda birçok kullanıcı yorumları verilmiştir. "
        "Lütfen şu analizleri yap:\n"
        "1. Genel kullanıcı eğilimini 2-3 cümlede özetle.\n"
        "2. Yorumların yüzdelik dağılımını şu şekilde ver:\n"
        "Olumlu: %x, Olumsuz: %x, Nötr: %x\n\n"
        f"{all_comments}"
    )
    return prompt



# ✅ /analyze endpoint
@app.post("/analyze")
async def analyze_link(request: Request):
    data = await request.json()
    url = data.get("url", "")

    if not url or "trendyol.com" not in url:
        return {"detay": "Geçerli bir Trendyol linki giriniz."}

    all_comments = scrape_trendyol_comments(url)

    if "hata" in all_comments.lower() or "bulunamadı" in all_comments.lower():
        return {"detay": all_comments}

    prompt = generate_prompt(all_comments)

    try:
        response = model.generate_content(prompt)
        
        # ❗ Doğru cevabı al: Gemini bazen .text yerine candidates altında döner
        if hasattr(response, 'candidates') and response.candidates:
            text = response.candidates[0].content.parts[0].text
        else:
            text = response.text.strip() if response.text else "Analiz yapılamadı."

        return {"detay": text}

    except Exception as e:
        return {"detay": f"Gemini API hatası: {e}"}
