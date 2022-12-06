[Variables]
UnitsOfMeasure=(?siU)<head>.*<locale>(.*)</locale>.*<form>(.*)</form>.*<ut>(.*)</ut>.*<ud>(.*)</ud>.*<us>(.*)</us>.*<up>(.*)</up>.*<ur>(.*)</ur>.*</head>
Location=(?siU)<loc id="(.*)".*<dnam>(.*),.*</dnam>.*<tm>(.*)</tm>.*<lat>(.*)</lat>.*<lon>(.*)</lon>.*<sunr>(.*)</sunr>.*<suns>(.*)</suns>.*<zone>(.*)</zone>.*</loc>
CurrentConditions=(?siU)<cc>.*<lsup>(.*)</lsup>.*<obst>(.*)</obst>.*<tmp>(.*)</tmp>.*<flik>(.*)</flik>.*<t>(.*)</t>.*<icon>(.*)</icon>
CurrentBarometric=(?siU)<cc>.*<bar>.*<r>(.*)</r>.*<d>(.*)</d>.*</bar>
CurrentWind=(?siU)<cc>.*<wind>.*<s>(.*)</s>.*<gust>(.*)</gust>.*<d>(.*)</d>.*<t>(.*)</t>.*</wind>
CurrentElements=(?siU)<cc>.*<hmid>(.*)</hmid>.*<vis>(.*)</vis>.*<uv>.*<i>(.*)</i>.*<t>(.*)</t>.*</uv>.*<dewp>(.*)</dewp>.*<moon>.*<icon>(.*)</icon>.*<t>(.*)</t>.*</moon>.*</cc>
TodayGeneral=(?siU)<dayf>.*<lsup>(.*)</lsup>.*<day d="0".*t="(.*)".*dt="(.*)".*<hi>(.*)</hi>.*<low>(.*)</low>.*<sunr>(.*)</sunr>.*<suns>(.*)</suns>
DayNightSwitch=(?siU)<day d="0".*<part p="d">.*<icon>.*</icon>.*<part p="n">
TodayConditions=(?siU)<day d="0".*<part p="[d|n]">.*<icon>(.*)</icon>.*<t>(.*)</t>
TodayWindRain=(?siU)<day d="0".*<part p="[d|n]">.*<wind>.*<s>(.*)</s>.*<gust>(.*)</gust>.*<d>(.*)</d>.*<t>(.*)</t>.*</wind>.*<ppcp>(.*)</ppcp>.*<day d="1"
TodayElements=(?siU)<day d="0".*<part p="[d|n]">.*<bt>(.*)</bt>.*<ppcp>(.*)</ppcp>.*<hmid>(.*)</hmid>.*</part>.*<day d="1"
TonightForecast=(?siU)<part p="n">.*<icon>(.*)</icon>.*<t>(.*)</t>.*<wind>.*<s>(.*)</s>.*<gust>.*</gust>.*<d>(.*)</d>.*  <t>(.*)</t>.*</wind>.*<ppcp>(.*)</ppcp>.*</part>
TomorrowForecast=(?siU)</day><day d="1" t="(.*)" dt=.*<hi>(.*)</hi>.*<low>(.*)</low>.*  <icon>(.*)</icon>.*<t>(.*)</t>.*<wind>.*<s>(.*)</s>.*  <t>(.*)</t>.*</wind>.*<ppcp>(.*)</ppcp>.*</part>.*
DayAfterForecast=(?siU)</day><day d="2" t="(.*)" dt=.*<hi>(.*)</hi>.*<low>(.*)</low>.*  <icon>(.*)</icon>.*<t>(.*)</t>.*<wind>.*<s>(.*)</s>.*  <t>(.*)</t>.*</wind>.*<ppcp>(.*)</ppcp>.*</part>.*
DayAfterAfter=(?siU)</day><day d="3" t="(.*)" dt=.*<hi>(.*)</hi>.*<low>(.*)</low>.*  <icon>(.*)</icon>.*<t>(.*)</t>.*<wind>.*<s>(.*)</s>.*  <t>(.*)</t>.*</wind>.*<ppcp>(.*)</ppcp>.*</part>.*