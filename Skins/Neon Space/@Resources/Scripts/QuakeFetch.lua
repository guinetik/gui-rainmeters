function Initialize()
	sErrorConfig = SKIN:GetVariable("CURRENTCONFIG")
	msWebParser = SKIN:GetMeasure("mQuakesFeed")
	iImageHeight = SKIN:GetVariable("MapHeight")
	iImageWidth = SKIN:GetVariable("MapWidth")
	iMofX = SKIN:GetVariable("MoffsetX")
	iMofY = SKIN:GetVariable("MoffsetY")
end -- function Initialize

function Update()
	SKIN:Bang('!DisableMeasure mQuakesLua')
	sRaw = msWebParser:GetStringValue()
	ReadFeed( sRaw )

	for i = 1, #tQuakeTitle do
		SKIN:Bang('!ShowMeter' , 'QuakeMeter'..i..'')		
		SKIN:Bang('!SetOption QuakeMeter'..i..' LeftMouseUpAction """['..tQuakeLink[i]..']"""')
		SKIN:Bang('!SetOption', 'QuakeMeter'..i..'' , 'ImageName', '#@#images\\stormquake\\c.png')
		SKIN:Bang('!SetOption QuakeMeter'..i..' ToolTipTitle \"'..tQuakeTitle[i]..'\"')
		sStormTipText ="Event Time:  "..os.date( "%H:%M on %d %B", LocalEventTime( tQuakeTime[i]) ).."\n".. "Magnitude:  "..tMagnitude[i].."\n".."Depth:  "..tDepth[i]
		SKIN:Bang('!SetOption QuakeMeter'..i..' ToolTipText \"'..sStormTipText..'\"')	
		SKIN:Bang('!MoveMeter '..(Xpos[i]) ..' '..(Ypos[i] -16 )..' QuakeMeter'..i..'')
	
		
	end
	SKIN:Bang('!MoveMeter '..(iMofX)..' '..(Ypos[1] )..' QuakeHorizontal')
	SKIN:Bang('!MoveMeter '..(Xpos[1] )..' '..(iMofY+12)..' QuakeVertical')
	SKIN:Bang('!SetOption MtEarthQuakes Text "[ '..#tQuakeTitle..' ] Earthquakes\"')
	SKIN:Bang('!UpdateMeter' , 'MtEarthquakes')		
	SKIN:Bang('!ShowMeter' , 'MtActiveStorms')		
	return "Earthquakes Displayed"

end -- function Update

function ReadFeed(sRaw)	
	local	sPatternOneQuake = '.<entry><id>.-</entry>'
	local	sPatternQuakeTitle = '.-<title>M%s.--%s(.-)</title>'
	local	sPatternQuakeLink = '.-</title>.*type="text/html" href="(.-)"/><'
	local	sPatternQuakeTime = '.-Time</dt><dd>(.-) UTC'
	local	sPatternQuakeMag = '.-<title>M%s(.-)%s'
	local	sPatternQuakeDepth = '.-Depth</dt><dd>(.-)%('	
	local	sPatternLatitude = '.-<georss:point>(.-)%s'
	local	sPatternLongitude = '.-<georss:point>.-%s(.-)</georss:point>'	
	
	tQuakeTitle = {}
	tQuakeLink = {}
	tQuakeTime = {}
	tMagnitude = {}
	tDepth = {}
	Xpos = {}
	Ypos = {}
	for sItem in string.gmatch(sRaw,sPatternOneQuake) do		
			table.insert( tQuakeTitle, 	string.match(sItem, sPatternQuakeTitle)	)
			table.insert( tQuakeLink,   string.match(sItem, sPatternQuakeLink) )
			table.insert( tQuakeTime,   string.match(sItem, sPatternQuakeTime) )
			table.insert( tMagnitude,   string.match(sItem, sPatternQuakeMag) )
			table.insert( tDepth,   string.match(sItem, sPatternQuakeDepth) )
			table.insert( Xpos , math.floor( ((((tonumber(string.match(sItem, sPatternLongitude))+390)%360)/360)*iImageWidth) ) + iMofX)
			table.insert( Ypos,  math.floor((((90-tonumber(string.match(sItem, sPatternLatitude) ))/180)*iImageHeight) ) + iMofY )

	end -- of each quake
	
end -- function ReadFeed
 
 function LocalEventTime(s)   -- Convert Event Time (UTC) to local time
    local Date = {}			
	local MatchTime ='(%d+)%-(%d+)%-(%d+)%s(%d+)%:(%d+)%:(%d+%.?%d*)$'	
	Date.year, Date.month, Date.day, Date.hour, Date.min, Date.sec = s:match(MatchTime)
      local UTC             = os.date('!*t')
      local LocalTime       = os.date('*t')
      local DaylightSavings = LocalTime.isdst and 3600 or 0
      local LocalOffset     = os.time(LocalTime) - os.time(UTC) + DaylightSavings
	   Date     = os.time(Date) + LocalOffset
     return Date
end
	
