# Definiujemy tablicę z liczbami dziesiętnymi
floats = [1.2, 3.45, 0.91, 7.727, 11.42, 482.911]

# Definiujemy Proc który pobiera liczbę, a następnie przy pomocy metody floor
# zamienia ją w liczbę całkowitą
round_down = Proc.new do |z|
z.floor
end

# Definiujemy zmienną ints która za pomocą metody collect przechodzi przez każdy element
# w bloku - w naszym przypadku każdą liczbę w tablicy, a następnie stosuje do niej wyżej
# zdefiniowany Proc
ints = floats.collect(&round_down)

# Wyświetlamy zawartość zmiennej ints
print ints
