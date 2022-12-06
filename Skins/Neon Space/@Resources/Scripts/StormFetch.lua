function Initialize()
	sErrorConfig = SKIN:GetVariable("CURRENTCONFIG")
	msWebParserMeasure = SKIN:GetMeasure("mStormsFeed")
	iImageHeight = SKIN:GetVariable("MapHeight")
	iImageWidth = SKIN:GetVariable("MapWidth")
	iMofX = SKIN:GetVariable("MoffsetX")
	iMofY = SKIN:GetVariable("MoffsetY")
	
end -- function Initialize

function Update()
		SKIN:Bang('!DisableMeasure mStormsLua')
		sRaw = msWebParserMeasure:GetStringValue()
		bNoActiveStorms = CheckForStorms(sRaw)
		if bNoActiveStorms then
			print(sErrorConfig.." => No storms found  ***")
			SKIN:Bang('!DisableMeasure mStormsLua')
			SKIN:Bang('!SetOption MtActiveStorms Text \"- No Active Storms\"')
			return sErrorConfig.."..No active storms.."
		end

		ReadFeed(sRaw, iNumItems)
print(" number Items = "..iNumItems)		
		for i = 1, iNumItems do
				if tLatitude[i] and tLongitude[i] then	
						-- print('>>>PLOTTING #'..i..' '..tStormName[i]..' Lat: '..tLatitude[i]..' Long: '..tLongitude[i] )	
						sTitleTipText = sTitleTipText.."- "..tStormName[i].."\n"
						SKIN:Bang('!SetOption MtActiveStorms ToolTipText \"'..sTitleTipText..'\"')
						SKIN:Bang('!SetOption StormMeter'..i..' LeftMouseUpAction """['..tStormLink[i]..']"""')
						SKIN:Bang('!ShowMeter' , 'StormMeter'..i..'')		
						SKIN:Bang('!MoveMeter '..(Xpos[i])..' '..(Ypos[i]-16)..' StormMeter'..i..'')						
						SKIN:Bang('!SetOption StormMeter'..i..' ToolTipTitle \"'..tStormName[i]..'\"')
						sStormTipText = "Wind speed:  "..tWind[i].."\n".."Moving:    "..tMoving[i]
						SKIN:Bang('!SetOption StormMeter'..i..' ToolTipText \"'..sStormTipText..'\"')
						iNumStorms = iNumStorms+1
				end		
		end
		if iNumStorms==1 then 
			SKIN:Bang('!SetOption MtActiveStorms Text " and [ '..iNumStorms..' ] Tropical Storm\"')
			else
			SKIN:Bang('!SetOption MtActiveStorms Text "  -  [ '..iNumStorms..' ] Tropical Storms\"')
		end	
		SKIN:Bang('!SetOption MtActiveStorms ToolTipTitle "Active Storms"')
		return "Storms Plotted"
end -- function Update

function CheckForStorms(sRaw, sErrorConfig)
	local bNoActiveStorms = false
	if string.match(sRaw, '<item>.-<title>(.-)%s') == 'No' 
		then 
			bNoActiveStorms = true
		else			
			sRawCounted, iNumItems = string.gsub(sRaw, '<item>',"")
			sPatternOneStorm =  '<item>.-</item>'
			sPatternStormTitle ='<title.->(.-)</title>'
			sPatternStormLink =  '<link.->(.-)</link>'
			sPatternStormWind = 'Wind.-[%s](.-)|'			
			sPatternStormMoving = 'Movement.-[%s](.-)<br'	
			sPatternLatitude = 'Location.-[%s](.-)[%s]'
			sPatternLongitude = 'Location.-[%s].-[%s](.-)[%s]'
			iNumStorms=0
			sTitleTipText = ""
		end	
	return bNoActiveStorms
end -- function CheckForStorms

function ReadFeed(sRaw, iNumItems)
	tStormName = {}	
	tStormLink = {}
	tWind = {}
	tMoving = {}
	tLatitude = {}
	tLongitude = {}
	Xpos = {}
	Ypos = {}
	local iInit = 0
	if iNumItems then
		for i = 1, (iNumItems) do
			iItemStart, iItemEnd = string.find(sRaw, sPatternOneStorm, iInit)
			sItem = string.sub(sRaw, iItemStart, iItemEnd)
			tStormName[i] = string.match(sItem, sPatternStormTitle)		
			if tStormName[i] == '' then tStormName[i] = '(No Name)' end
			tStormLink[i] = string.match(sItem, sPatternStormLink)
			if string.match(sItem, sPatternStormWind) then
				tWind[i] = string.match(sItem, sPatternStormWind)
				tMoving[i] = string.match(sItem, sPatternStormMoving)
			else
				tWind[i] = ''
				tMoving[i] = ''
			end	
			tLatitude[i] = ResolveLatLong(sItem, sPatternLatitude, '[NS]' , 'N' )
			tLongitude[i] = ResolveLatLong(sItem, sPatternLongitude, '[WE]' , 'E' )							
			if tLatitude[i] and tLongitude[i] then		
				Xpos[i]=math.floor( ((((tLongitude[i]+390)%360)/360)*iImageWidth) + iMofX	)
				Ypos[i]=math.floor((((90-tLatitude[i] )/180)*iImageHeight) + iMofY)		
		    end	
			iInit = iItemEnd + 1
		end 
	end	
end -- function ReadFeed

function ResolveLatLong(sItem, sPattern, Cardinal, Positive)
		LatLong=  string.match(sItem, sPattern) 	
		if string.match( LatLong, Cardinal) then			
				local NS=string.match( LatLong, Cardinal)
				local Value =  string.gsub(LatLong, Cardinal, '') 	
				if NS==Positive then 
								LatLong= tonumber( Value )   
						 else LatLong= -tonumber( Value)  
				end
				if LatLong >180  then LatLong=180-(LatLong-180) end			
		else
				LatLong= tonumber( string.match(sItem, sPattern)  )
	    end 				
		return LatLong
end -- function ResolveLatLong