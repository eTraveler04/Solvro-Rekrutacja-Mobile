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
![image](https://github.com/user-attachments/assets/201077bd-ee73-42bd-82d2-9b6d7c14f806)
![image](https://github.com/user-attachments/assets/18298a0a-ec67-4404-85ff-ca1134a81cb0)
![image](https://github.com/user-attachments/assets/7f5aee7f-2bd6-4efd-b070-fc9d168e5dc0)
![image](https://github.com/user-attachments/assets/d7f6457a-f909-482f-a47f-5e757cd36807)


## 📁 Struktura projektu *(skrótowo)*  
![image](https://github.com/user-attachments/assets/647824f2-725d-45ed-8e52-84da93d6aae5)


## 📌 Uwagi końcowe  

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
