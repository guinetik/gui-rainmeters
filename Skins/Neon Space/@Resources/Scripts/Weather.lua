function Initialize()
	msWindNow = SKIN:GetMeasure('mWindSpeed')
	msWindToday = SKIN:GetMeasure('mTodayWindSpeed')
	msWindTonight = SKIN:GetMeasure('mTonightWindSpeed')
	msWindTomorrow = SKIN:GetMeasure('mWindSpeedTomorrow')
	msWindAfter = SKIN:GetMeasure('mWindSpeedAfter')
	msWindAfterA = SKIN:GetMeasure('mWindSpeedAfterA')
	sUnits = SKIN:GetVariable('Units')
	msPressure = SKIN:GetMeasure('mPressureNow')
	msChange = SKIN:GetMeasure('mPressureChange')
	msRainTonight = SKIN:GetMeasure('mTonightRain')
	msRainToday = SKIN:GetMeasure('mTodayRain')
	msRainTomorrow = SKIN:GetMeasure('mRainTomorrow')
	msRainAfter = SKIN:GetMeasure('mRainAfter')
	msRainAfterA = SKIN:GetMeasure('mRainAfterA')
end -- Initialize

function Update()
	SKIN:Bang("!DisableMeasure mLuaScript")
	sDayNightSwitch = SKIN:GetVariable('ForecastFor')	
	if sDayNightSwitch == "Tonight" 
	    then 
			SKIN:Bang('!SetOption "ForecastIcon" "MeasureName" "mTonightIcon"') 
			SKIN:Bang('!SetVariable "ForeCastDescription" "[mTonightDescription]"') 
			SKIN:Bang('!SetVariable "ForeCastTemp" "Low of \%2\%1"')	
			SKIN:Bang('!SetVariable', 'ForeCastWind', ''..windclass( tonumber( msWindTonight:GetStringValue()))..' from the [mTonightWindDirection]'	)		
			SetRainNow( 'ForeCastRain', tonumber( msRainTonight:GetStringValue())  )	
		else
			SKIN:Bang('!SetOption "ForecastIcon" "MeasureName" "mTodayIcon"') 
			SKIN:Bang('!SetVariable "ForeCastDescription" "[mTodayDescription]"') 
			SKIN:Bang('!SetVariable "ForeCastTemp" "\%2\%1 - \%3\%1"')	
			SKIN:Bang('!SetVariable', 'ForeCastWind', ''..windclass( tonumber( msWindToday:GetStringValue()))..' from the [mDayWindDirection]'	)						
			SetRainNow( 'ForeCastRain', tonumber( msRainToday:GetStringValue())  )	
		end  	
	 
-- SET WIND CLASSIFICATIONS
		if tonumber( msWindNow:GetStringValue()) > 0 then
				SKIN:Bang('!SetVariable', 'NowWind', ''..windclass( tonumber( msWindNow:GetStringValue()))..' at [mWindSpeed] [mWindSpeedUnits] from the [mWindDirection]'	)
				SKIN:Bang('!SetOption', 'MtWindIndicator', 'ToolTipText', windclass( tonumber( msWindNow:GetStringValue()))..' at [mWindSpeed] [mWindSpeedUnits]#CRLF#from the [mWindDirection]'	)					
		else
				SKIN:Bang('!SetVariable', 'NowWind', 'It is calm without even the lightest breeze'	)
				SKIN:Bang('!SetOption', 'MtWindIndicator', 'ToolTipText', 'It is calm without wind'	)						
		end		
		SKIN:Bang('!SetOption', 'TomorrowWindSpeed', 'Text', 'Wind:   '..windclass( tonumber( msWindTomorrow:GetStringValue())))	
		SKIN:Bang('!SetOption', 'AfterWindSpeed', 'Text', 'Wind:   '..windclass( tonumber( msWindAfter:GetStringValue())))
		SKIN:Bang('!SetOption', 'AfterWindSpeedA', 'Text', 'Wind:   '..windclass( tonumber( msWindAfterA:GetStringValue())))			
	
-- SET BAROMETER TEXT ( adapted from JSBarometer.lua by JSMorley )
		sCurrentPressure = msPressure:GetStringValue()
		sCurrentChange = msChange:GetStringValue()
		sCurrentDescription = "Pressure Leakage"
		if string.lower(sUnits) == "m" 
			then  InchesHg = round(tonumber(sCurrentPressure) / 33.8639, 2)
			else   InchesHg = round(tonumber(sCurrentPressure),2) 
		end		
				
-- SET FORCAST RAIN METERS		
		SetRainForcast( 'TomorrowRain', tonumber( msRainTomorrow:GetStringValue())  )	
		SetRainForcast( 'AfterRain', tonumber( msRainAfter:GetStringValue())  )	
		SetRainForcast( 'AfterRainA', tonumber( msRainAfterA:GetStringValue())  )

		if InchesHg <= 28.59 then
			if sCurrentChange == "falling" then
				sCurrentDescription = "Increasingly Stormy"
			elseif sCurrentChange == "steady" then
				sCurrentDescription = "Rain and Stormy"
			elseif sCurrentChange == "rising" then
				sCurrentDescription = "Stormy but improving"
			end
		end	
		if InchesHg >= 28.6 and InchesHg <= 29.59 then
			if sCurrentChange == "falling" then
				sCurrentDescription = "more rain likely"
			elseif sCurrentChange == "steady" then
				sCurrentDescription = "Rainy"
			elseif sCurrentChange == "rising" then
				sCurrentDescription = "Rainy but improving"
			end
		end
		if InchesHg >= 29.6 and InchesHg <= 30.09 then
			if sCurrentChange == "falling" then
				sCurrentDescription = "changing to Rain"
			elseif sCurrentChange == "steady" then
				sCurrentDescription = "between Rain & Fair"
			elseif sCurrentChange == "rising" then
				sCurrentDescription = "changing to Fair"
			end
		end
		if InchesHg >= 30.1 and InchesHg <= 30.59 then
			if sCurrentChange == "falling" then
				sCurrentDescription = "Fair but worsening"
			elseif sCurrentChange == "steady" then
				sCurrentDescription = "Fair"
			elseif sCurrentChange == "rising" then
				sCurrentDescription = "Fair and improving"
			end
		end
		if InchesHg >= 30.6 then
			if sCurrentChange == "falling" then
				sCurrentDescription = "Very Dry, getting drier"
			elseif sCurrentChange == "steady" then
				sCurrentDescription = "Very Dry"
			elseif sCurrentChange == "rising" then
				sCurrentDescription = "Very Dry but improving"
			end		
		end
		SKIN:Bang('!SetVariable "NowBarometer" "'..round( (InchesHg*33.8639),0)..' mb and [mPressureChange] - '..sCurrentDescription..'"') 
		SKIN:Bang('!SetOption', 'MtBarometer', 'ToolTipText' , ''..round( (InchesHg*33.8639),0)..' mb and [mPressureChange]#CRLF#'..sCurrentDescription..'') 
		
	return 'meters set'
end -- function Update

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function windclass(speed)
    local description = 'Calm' 
    if speed > 1 and speed <=5 then description = 'Light Air' 
			elseif speed > 5 and speed <=11 then description = 'Light Breeze'  
			elseif speed > 11 and speed <=19 then description = 'Gentle Breeze'  
			elseif speed > 19 and speed <=28 then description = 'Moderate Breeze'  
			elseif speed > 29 and speed <=38 then description = 'Fresh Breeze'  
			elseif speed > 38 and speed <=49 then description = 'Strong Breeze'  
			elseif speed > 49 and speed <=61 then description = 'Moderate Gale'  
			elseif speed > 61 and speed <=74 then description = 'Fresh Gale'  
			elseif speed > 74 and speed <=88 then description = 'Strong Gale'  
			elseif speed > 88 and speed <=102 then description = 'Full Gale'  
			elseif speed > 102 and speed <=117 then description = 'Storm'  
			elseif speed > 117 then description = 'Hurricane'
	end 
	return description
end	

function SetRainNow(VarName,Value)
	if Value > 0 then
		SKIN:Bang('!SetVariable', VarName, ''..Value..'% chance of precipitation')
		else
		SKIN:Bang('!SetVariable', VarName, 'No rain or snow forecast')
	end
end -- SetRainNow

function SetRainForcast(Meter,Value)
	if Value > 0 then
		SKIN:Bang('!SetOption',Meter,'Text', 'Chance of rain:   '..Value..'%')
		else
		SKIN:Bang('!SetOption',Meter,'Text', 'No chance of rain')
	end
end -- SetRainForcast