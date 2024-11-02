# WorkFlowPro – Kompleksowa Aplikacja do Zarządzania Firmą

Prosta i zintegrowana aplikacja do automatyzacji wewnętrznych procesów, poprawy komunikacji oraz zarządzania zasobami ludzkimi i operacyjnymi.

## Skład zespołu

**Klasa 3c:**
- Patrycja Jurkiewicz
- Jakub Dąbrowski

## Cel główny projektu

Celem aplikacji **WorkFlowPro** jest uproszczenie zarządzania firmą, projektami, przepływem pracy oraz wewnętrzną komunikacją. Aplikacja umożliwia menedżerom i pracownikom wygodny dostęp do narzędzi niezbędnych do zarządzania zasobami, przydzielania zadań, monitorowania projektów oraz kontrolowania uprawnień. Dzięki automatyzacji i ułatwionej komunikacji aplikacja pozwala firmom na bardziej efektywne zarządzanie codziennymi operacjami.

**Grupa docelowa:** małe i średnie przedsiębiorstwa, które chcą zoptymalizować swoje procesy oraz poprawić komunikację wewnętrzną i zarządzanie zasobami.

## Zakres funkcjonalności

### Moduły
- **Moduł Zarządzania Pracownikami**:  
  Rejestracja pracowników, przypisywanie ról i uprawnień, tworzenie profili z historią zatrudnienia i kwalifikacjami.
  
- **Moduł Zarządzania Strukturą Organizacyjną**:  
  Tworzenie hierarchii firmy, przypisywanie pracowników do stanowisk, wizualizacja struktury firmy.
  
- **Moduł Automatyzacji Przepływu Pracy**:  
  Automatyczne przypisywanie zadań, powiadomienia o zaległościach i nadchodzących terminach.
  
- **Moduł Zarządzania Projektami i Zasobami**:  
  Harmonogramy projektów, przydzielanie ludzi, monitorowanie budżetów.
  
- **Moduł Komunikacji i Współpracy**:  
  Powiadomienia push, tablica ogłoszeń firmowych.
  
- **Moduł Zarządzania Uprawnieniami i Bezpieczeństwem**:  
  Kontrola dostępu, rejestr działań w systemie.

### MVP (Minimum Viable Product)
- Rejestracja i logowanie pracowników.
- Przypisywanie ról i uprawnień.
- Tworzenie zadań i śledzenie postępu.
- Powiadomienia o terminach i zadaniach.

## Technologie

### Języki programowania
- Dart
- C++

### Frameworki
- Flutter

### Narzędzia
- Firebase (autoryzacja, baza danych, powiadomienia)
- Git (kontrola wersji)
- Firestore (baza danych w Firebase)

## Architektura systemu

**Opis:**  
Aplikacja mobilna komunikuje się z backendem, który zarządza danymi dotyczącymi pracowników, projektów i struktury organizacyjnej. Dane są przechowywane w bazie danych **Firestore Database**, a **Firebase** zapewnia autoryzację.

## Harmonogram prac dla 4 etapów

### Etap 1: Implementacja modułu rejestracji i logowania
**Zadania:**
- Projektowanie modelu użytkownika (baza danych)
- Implementacja systemu logowania
- Konfiguracja Firebase dla autoryzacji
- Testy funkcjonalne

### Etap 2: Implementacja modułu zarządzania uprawnieniami i rolami
**Zadania:**
- Stworzenie panelu administratora aplikacji
- Stworzenie panelu administratora firmy/organizacji
- Stworzenie formularza dodawania użytkownika
- Testy funkcjonalne

### Etap 3: Implementacja modułu
**Zadania:**
- Strona dodawania nowych zadań
- Harmonogram/kalendarz nadchodzących zadań
- Tablica firmowa
- Testy użytkowe

### Etap 4: Integracja modułu komunikacji i powiadomień
**Zadania:**
- Implementacja powiadomień push
- Logowanie powiadomień push
- Wyświetlanie komunikatów
- Testy funkcjonalne

## Kryteria sukcesu

- Użytkownicy mogą się logować.
- Administratorzy organizacji mogą dodawać nowych pracowników.
- Zadania są przypisywane do pracowników i monitorowane.
- Powiadomienia push są wysyłane i odbierane w czasie rzeczywistym.
- Menedżerowie mają pełną kontrolę nad uprawnieniami pracowników.

## Potencjalne ryzyka

- Problemy z synchronizacją powiadomień (mitigacja: regularne testy backendu).
- Błędy w przypisywaniu uprawnień (mitigacja: testy przypadków użycia).
- Niska adopcja aplikacji w firmach (mitigacja: promowanie kluczowych funkcji).
