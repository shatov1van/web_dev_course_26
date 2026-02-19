require 'date'

def sport_calendar(fcomand, dbegin, dend, fkalend)
  if !File.exist?(fcomand)
    puts "Файл с командами и городами не найден!"
  elsif !File.exist?(fkalend)
    puts "Файл с календарем не найден"
  end

  dfirst = Date.parse(dbegin)
  dlast = Date.parse(dend)
  puts "Период #{dfirst} -  #{dlast}"
  dif = (dlast - dfirst).to_i
  puts "Кол-во дней в диапазоне #{dif}"

  footcom = []
  footcity = []
  File.foreach(fcomand) do |line|
    line = line.chomp
    clean_line = line.sub(/^\d+\.\s*/, '')

    puts clean_line
  end
end

sport_calendar(ARGV[0], ARGV[1], ARGV[2], ARGV[3])