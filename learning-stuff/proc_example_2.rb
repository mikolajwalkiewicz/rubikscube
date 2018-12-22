# Definiujemy grupy liczb
group_1 = [4.1, 5.5, 3.2, 3.3, 6.1, 3.9, 4.7]
group_2 = [7.0, 3.8, 6.2, 6.1, 4.4, 4.9, 3.0]
group_3 = [5.5, 5.1, 3.9, 4.3, 4.9, 3.2, 3.2]

# Definiujemy Proc w którym sprawdzamy czy dana liczbą jest większa bądź równa 4
over_4_feet = Proc.new do |x|
x >=4
end

# Używamy Proc by sprawdzić zawartość tablic.
can_ride_1 = group_1.select(&over_4_feet)
can_ride_2 = group_2.select(&over_4_feet)
can_ride_3 = group_3.select(&over_4_feet)

# Wyświetlamy wynik.
puts can_ride_1
puts can_ride_2
puts can_ride_3
