# 🍹 Cocktail Browser – Aplikacja mobilna  
Rekrutacja do sekcji aplikacji mobilnych Koła Naukowego Solvro  

## 📱 Opis projektu  
Aplikacja mobilna umożliwiająca przeglądanie listy drinków wraz ze szczegółami takimi jak zdjęcie, składniki, instrukcja przygotowania itp. Aplikacja korzysta z publicznego **Cocktail API** i wspiera wyszukiwanie oraz oznaczanie ulubionych pozycji.  

## ✅ Zrealizowane funkcjonalności (MVP)  
- Lista koktajli z nazwą i zdjęciem  
- Szczegóły drinka – składniki, instrukcje, dodatkowe dane  
- Wyszukiwanie drinków (SearchBar)  

## ⭐ Dodatkowe funkcjonalności (Nice to have)  
- **Infinite scroll (paginacja)**  
- **Dark mode / Tryb ciemny**  
- **Dodawanie drinków do ulubionych**  
- **Panel przeglądania ulubionych drinków w stylu Tinder Cards**  
  - Przesunięcie karty w lewo usuwa drinka z ulubionych  
  - Przesunięcie w prawo pozwala przeglądać dalej  
  - Interaktywny i intuicyjny sposób zarządzania ulubionymi  

## 🛠 Technologie  
- **Swift / SwiftUI**  
- Środowisko: **Xcode**  

## 🔍 API  
Aplikacja korzysta z:  
➡️ [https://cocktails.solvro.pl/](https://cocktails.solvro.pl/)  

## 📸 Zrzuty ekranu  
![image](https://github.com/user-attachments/assets/27726f5d-576f-454d-9b7c-7e2077507e7e)
![image](https://github.com/user-attachments/assets/f476168e-e2f5-4603-8ccf-ea0f2f379ba6)
![image](https://github.com/user-attachments/assets/d4f02da3-b5f7-4f62-a0a0-1233584bf35c)
![image](https://github.com/user-attachments/assets/3829607f-e7d5-4569-a459-d83486bfad81)
![image](https://github.com/user-attachments/assets/2175dc72-9856-432c-a11d-f75c58bb39a5)


## 📁 Struktura projektu *(skrótowo)*  
- `/Views/` – główne ekrany aplikacji  
- `/Components/` – komponenty interfejsu (np. karta drinka)  
- `/Models/` – struktury danych  
- `/Services/` – obsługa zapytań do API  
- `/Utils/` – pomocnicze funkcje  

## 📌 Uwagi końcowe  
### Wygląd
Jest w tym projekcie parę spraw wizualnych, które wymagałyby poprawy, jak np. paddingi miedzy elementami, różniący się drink detials popup w favorite i wszystkich drinkach.
Różnice i niedociągnięcia spowodowane są tym, że niektóre struktury napisane są w swift, a niektóre za pomocą swiftui. Wiec, czasami niektóre elementy musiałem owarpować w coś rodzeaju konwertera. 
Co powodowało zmianę wizualną. Napewno da się to łatwo ogarnąć, ale zabrałko już czasu. Mam nadzieję, że te minusy, zrękompensuję grafiką karty oraz specjalnym tłem :D

### Symulator a Preview 
Uwaga! Od razu ostrzegam, że widok w preview różni się od widoku w symulatorze. Proszę, odpalajcie tylko symulator. 

### Funkcjonalności 
Najważniejsze jest to, że tabele i aktualizacja przycisku dodwania do ulubionych ( gwiazdka ), działa poprawnie, odświeża się autoamtycznie, jeżeli została zmieniona w innym widoku.
Lista ulubionych koktajli, jest specjalnie zrobiona tak, żeby odpolubione koktajle od razu nie znikały, jeżeli przez przypadek zostały usunięte.
Koktajlowa karta, też jest zabezpieczona. Nie da się tam zablokować. 
Paginacja i tabela drinków, również działa poprawnie. Komórki tablicy na bieżąco są odświeżane, zeby nie było problemu np. z pobieraniem image url.
Jest zrobione cachowanie składników koktajli. 

## 📬 Kontakt  
W razie pytań: 280479@student.pwr.edu.pl lub Szymon Protyński ( Messenger )
