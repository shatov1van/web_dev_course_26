require 'date'

def sport_calendar(fcomand, dbegin, dend, fkalend)

  if !File.exist?(fcomand)
    puts "Файл с командами и городами не найден!"
    exit
  elsif !File.exist?(fkalend)
    puts "Файл с календарем не найден"
    exit
  end

  dfirst = Date.parse(dbegin)
  dlast = Date.parse(dend)

  if (dlast - dfirst).to_i.negative?
        puts "Диапазон не может быть отрицательным!"
        exit
  end

  commandinfo = Hash.new

  File.foreach(fcomand) do |line|
    clean_line = line.sub(/^\d+\.\s*/, "").strip
    parts = clean_line.split(" — ")
    commandinfo[parts[0]] = parts[1]
  end

  matches = commandinfo.size*(commandinfo.size - 1)/2 #Кол-во вариантов матчей
  validday = [] #Все пятницы-воскресенья в диапазоне

  for day in dfirst..dlast
        if day.wday == 5 || day.wday == 6 || day.wday == 0
                    validday << day
        end
  end

  coef = matches / validday.count.to_f
  
  if coef > 6.0
        puts "Кол-во матчей превышает допустимый объем проведения матчей"
        exit
  end

  flr = coef.floor #Коэффициент того сколько нужно для равномерного распределения провести игр в день
  y = matches - flr * validday.count #Кол-во дней в которые проходят flr + 1 игр
  x = validday.count - y #Кол-во дней в которые проходят flr игр

  arrday = Array.new(validday.count, flr) #Массив в котором равномерно распределено кол-во игр в день
  step = arrday.length.to_f / y

  for i in 0...y
        index = (i*step).round
        index = arrday.length - 1 if index > arrday.length - 1
        arrday[index] = flr + 1
  end

  arrMatchs = []
  teams = commandinfo.keys
  (0...teams.length).each do |i|
        (i+1...teams.length).each do |j|
                    arrMatchs << "Команда '#{teams[i]}' vs Команда '#{teams[j]}' | Города команд [#{commandinfo[teams[i]]}/#{commandinfo[teams[j]]}]"

        end
  end

  const = 0
  File.open(fkalend, "w") do |f|
        arrday.each_with_index do |cntmatch, i|
        currday = validday[i]
        time_day = {"12:00" => 0, "15:00" => 0, "17:00" => 0}

        for j in 1..cntmatch
          time = time_day.find{|_, cnt| cnt < 2}&.first
          time_day[time] += 1
          File.open(fkalend, "a") do |file|
                        file.puts "#{currday} #{time} #{arrMatchs[const]}"
          end
          const += 1
        end
  end
  end
end

sport_calendar(ARGV[0], ARGV[1], ARGV[2], ARGV[3])