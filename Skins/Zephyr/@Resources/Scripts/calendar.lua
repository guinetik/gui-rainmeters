function Initialize()
	
end

function Update()
	for i = 1,42,1 do
		SKIN:Bang('!SetOption', 'measureD'..i,'Text', '.')
		SKIN:Bang('!SetOption', 'measureD'..i,'MeterStyle', 'styleCalUnselect')
	end

	monthEnds = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
	
	Date = os.date('*t')
	
	if Date.year%4 == 0 then monthEnds[2] = 29 end
	
	month = Date.month
	startday = ((Date.wday -Date.day)%7) +1
	
	--wday is 0-6
	
	if startday <= 0 then startday = 7 + startday end
	
	v=1;
	
	for i = 1,monthEnds[month],1 do
		SKIN:Bang('!SetOption', 'measureD'..startday,'Text', v)
		if(v == Date.day) then SKIN:Bang('!SetOption', 'measureD'..startday,'MeterStyle', 'styleCalSelect') end
		startday=startday+1
		v=v+1
	end
end
