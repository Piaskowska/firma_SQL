# firma_SQL

![firma](https://user-images.githubusercontent.com/100967381/167212259-7b40a82e-8fde-46f0-88c4-0f65ff75365f.png)


Baza pracowników pewnej firmy. Jest w niej zawarta informacja w jakim oddziale firmy dany pracownik pracuje, a także przechowywane są tam informacje o osobach, które dany pracownik ma na utrzymaniu.

Liczba tabel w tej bazie wynosi 3- PRACOWNIK (dane o pracownikach firmy), ODDZIALY FIRMY (dane oddziałów firmy), CZLONKOWIE RODZIN (dane o osobach, których pracownicy mają na utrzymaniu).

Związki to:

    •	rekurencyjny związek jeden do wielu w tabelce PRACOWNIK opcjonalny z obu stron. (Informacje kto jest czyim przełożonym, a kto komu podlega).
  
    •	związek identyfikujący z tabeli PRACOWNIK  do tabeli CZLONKOWIE RODZIN. (Informacje kogo pracownik ma na utrzymaniu, a kto jest na utrzymaniu pracownika).
  
    •	związek jeden do wielu z tabeli ODDZIALY FIRMY do tabeli PRACOWNICY, opcjonalny po stronie ODDZIALY FIRMY. (Informacje, którzy pracownicy pracują w danym oddziale firmy. Jeden oddział może mieć wielu pracowników, a pracownik jest w jednym oddziale firmy).
  
    •	związek jeden do jednego z tabelki PRACOWNIK do tabelki ODDZIALY FIRMY, opcjonalny z obu stron. (Informacja o tym, który pracownik jest kierownikiem danego oddziału).
  
  
Podzapytania SELECT umożliwiające:

    •	wyświetlanie nazwiska, imienia, poziomu w hierarchii pracowników i ich wieku,
  
    •	wyświetlanie ilu jest pracowników w każdym z oddziałów,
  
    •	wyświetlanie pracowników wraz z ich przełożonymi, a także oddziału firmy, w którym pracują,
  
    •	wyświetlanie pracowników, którzy są przełożonymi.
  
