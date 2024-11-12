# WorkFlowPro – Kompleksowa Aplikacja do Zarządzania Firmą

Prosta i zintegrowana aplikacja do automatyzacji wewnętrznych procesów, poprawy komunikacji oraz zarządzania zasobami ludzkimi i operacyjnymi.

## Skład zespołu

**Klasa 3c:**
- Patrycja Jurkiewicz
- Jakub Dąbrowski

## Cel główny projektu

Celem aplikacji **WorkFlowPro** jest uproszczenie zarządzania firmą, projektami, przepływem pracy oraz wewnętrzną komunikacją. Aplikacja umożliwia menedżerom i pracownikom wygodny dostęp do narzędzi niezbędnych do zarządzania zasobami, przydzielania zadań, monitorowania projektów oraz kontrolowania uprawnień. Dzięki automatyzacji i ułatwionej komunikacji, aplikacja pozwala firmom na bardziej efektywne zarządzanie codziennymi operacjami.

**Grupa docelowa:** małe i średnie przedsiębiorstwa, które chcą zoptymalizować swoje procesy oraz poprawić komunikację wewnętrzną i zarządzanie zasobami.

## Zakres funkcjonalności

### Moduły:
- **Moduł Zarządzania Pracownikami:**  
  Rejestracja pracowników, przypisywanie ról i uprawnień, tworzenie profili z historią zatrudnienia i kwalifikacjami.
  
- **Moduł Zarządzania Struktura Organizacyjną:**  
  Tworzenie hierarchii firmy, przypisywanie pracowników do stanowisk, wizualizacja struktury firmy.
  
- **Moduł Automatyzacji Przepływu Pracy:**  
  Automatyczne przypisywanie zadań, powiadomienia o zaległościach i nadchodzących terminach, automatyczne ścieżki akceptacji.
  
- **Moduł Zarządzania Projektami i Zasobami:**  
  Harmonogramy projektów, przydzielanie zasobów, monitorowanie budżetów.
  
- **Moduł Komunikacji i Współpracy:**  
  Powiadomienia push, tablica ogłoszeń firmowych.
  
- **Moduł Zarządzania Uprawnieniami i Bezpieczeństwem:**  
  Kontrola dostępu, wielopoziomowa autoryzacja, rejestr działań w systemie.

### MVP (Minimum Viable Product):
- Rejestracja i logowanie pracowników.
- Przypisywanie ról i uprawnień.
- Tworzenie zadań i śledzenie postępu.
- Powiadomienia o terminach i zadaniach.

## Technologie

### Języki programowania:
- Dart
- C++

### Frameworki:
- Flutter

### Narzędzia:
- Firebase (autoryzacja, baza danych, powiadomienia)
- Git (kontrola wersji)
## Architektura systemu

**Opis:**  
Aplikacja mobilna komunikuje się z backendem, który zarządza danymi dotyczącymi pracowników, projektów i strukturą organizacyjną. Dane są przechowywane w bazie danych PostgreSQL, a Firebase zapewnia autoryzację i powiadomienia push.

## Harmonogram prac dla 4 etapów

### Etap 1: Implementacja modułu rejestracji i logowania
**Zadania:**
- Projektowanie modelu użytkownika (baza danych) 
- Implementacja systemu rejestracji i logowania 
- Konfiguracja Firebase dla autoryzacji 
- Testy funkcjonalne 

### Etap 2: Implementacja modułu zarządzania zadaniami
**Zadania:**
- Tworzenie modelu danych dla zadań 
- Widok zadań i przypisywanie ich pracownikom 
- Mechanizm przypisywania zadań automatycznie 
- Testy funkcjonalne 

### Etap 3: Implementacja modułu zarządzania uprawnieniami i rolami
**Zadania:**
- Tworzenie modelu uprawnień i ról 
- Przypisywanie uprawnień i dostępów 
- Testy zarządzania uprawnieniami 

### Etap 4: Integracja modułu komunikacji i powiadomień
**Zadania:**
- Implementacja powiadomień push 
- Backend: zapis komunikatów 
- Frontend: wyświetlanie komunikatów 
- Testy funkcjonalne 

## Kryteria sukcesu

- Użytkownicy mogą rejestrować się i logować.
- Zadania są przypisywane do pracowników i monitorowane.
- Powiadomienia push są wysyłane i odbierane w czasie rzeczywistym.
- Menedżerowie mają pełną kontrolę nad uprawnieniami pracowników.

## Potencjalne ryzyka

- Problemy z synchronizacją powiadomień (mitigacja: regularne testy backendu).
- Błędy w przypisywaniu uprawnień (mitigacja: testy przypadków użycia).
- Niska adopcja aplikacji w firmach (mitigacja: promowanie kluczowych funkcji).
