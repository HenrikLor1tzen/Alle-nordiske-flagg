use context essentials2021
#a
include shared-gdrive(
  "dcic-2021",
  "1wyQZj_L0qqV9Ekgr9au6RX2iqt2Ga8Ep")
  
include gdrive-sheets
include data-source
ssid = "1RYN0i4Zx_UETVuYacgaGfnFcv4l9zd9toQTTdkQkj7g"

  Energiforbrukstabellen = load-table: komponent, energi
  source: load-spreadsheet(ssid).sheet-by-name("kWh", true)
  sanitize energi using string-sanitizer
end

Energiforbrukstabellen

#b
fun energi-to-number(s :: String) -> Number:
  cases(Option) string-to-number(s):
    | some(a) => a
    | none=> 0
  end
where:
  energi-to-number("") is 0
  energi-to-number("30") is 30
  energi-to-number("37") is 37
  energi-to-number("5") is 5
  energi-to-number("4") is 4
  energi-to-number("15") is 15
  energi-to-number("48") is 48
  energi-to-number("12") is 12
  energi-to-number("4") is 4
end

#c
Energiforbrukstabellen

ny-FTabell = transform-column(Energiforbrukstabellen, "energi", energi-to-number)

ny-FTabell
fun sum-on-energi():
  t =transform-column(Energiforbrukstabellen, "energi", energi-to-number)
    sum(t, "energi")
end

#d
  distance-travelled-per-day = 27
distance-per-unit-of-fuel = 20
energy-per-unit-of-fuel = 18

energi-per-dag = ( distance-travelled-per-day / distance-per-unit-of-fuel ) * energy-per-unit-of-fuel

fun add-bil(value :: Number) -> Number:
if value == 0: energi-per-dag else: value 
end 
end


t2 = transform-column(ny-FTabell, "energi", add-bil)
   
t2

#e 
t2henrik-diagram =
  table: komponent :: String, energi :: Number 
    row: "bil", 24.3
    row: "fly", 30
    row: "ovnk", 37
    row: "lys", 5
    row: "dingser", 4
    row: "mlk", 15
    row: "varer", 48
    row: "varetransport", 12
    row: "offtjen", 4 
  end
  
bar-chart(t2henrik-diagram, "komponent", "energi")
  