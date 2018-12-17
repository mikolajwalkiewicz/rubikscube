#!/usr/bin/env ruby

class ObliczProcent

    def initialize(liczba, procent)
        @liczba = liczba
        @procent = procent
    end

    def Przeliczenie
        podzielnik = 100
        obliczenie = @liczba * @procent / podzielnik
        wynik = @liczba - obliczenie
        puts "#{@procent}% z liczby #{@liczba} to #{obliczenie}."
        puts "Podstawowa kwota minus procent rowna sie: #{wynik}"
    end
end

puts "Podaj liczbe: "
var1 = gets.chomp.to_i

puts "Podaj %: "
var2 = gets.chomp.to_i

obiekt = ObliczProcent.new(var1, var2)
obiekt.Przeliczenie
