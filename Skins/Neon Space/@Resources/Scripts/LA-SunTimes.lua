--[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]][][][][][][][][][][][][][][][][][][][]
-- Author = Mordasius
-- Name = LA-SunTimes.lua
-- Version =260715
-- Information = Script to calculate sunrise, sunset and twilight based  on date, latitude and longitude.
-- License=Creative Commons BY-NC-SA 3.0
 --  Functions for sunrise, sunset and twilight were converted from javascript on http://praytimes.org/
--[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]][][][][][][][][][][][][][][][][][][][]

function Initialize()	
	    nLatitude = tonumber(SKIN:GetVariable('Latitude'))
		nLongitude = tonumber(SKIN:GetVariable('Longitude'))
		dawnAngle, duskAngle = 6, 6	
end -- function Initialize

function Update()     

	nTimeZone = tonumber(SKIN:GetVariable('tZone')) or 0
-- default values
	local sunRiseSetTimes= {6, 6,6,12,13,18,18,18,24}  
	NoSunRise, NoSunSet, NoNight = False, False, False
	strSunTip, strSunsetTip = '',''

-- set Julian date for calculating rise / set times 
	jDateSun =SKIN:GetVariable('jDate') - (nLongitude/ (15* 24))     				
-- sun time calculations		
	    sunRiseSetTimes = calcSunRiseSet( sunRiseSetTimes )	
		if NoSunRise or NoSunSet then
			if NoSunRise then
				sunRiseSetTimes[2] = 0.01   sunRiseSetTimes[3] = 0.02
				SKIN:Bang('!ToggleMeterGroup', 'Twilight')
				SKIN:Bang('!ToggleMeterGroup', 'Highlights')
			else -- no sunset
				sunRiseSetTimes[1] = 0.001 sunRiseSetTimes[2] = 0
				sunRiseSetTimes[3] = 24 sunRiseSetTimes[4] = 23.99
			end
		else 				
			strSunTip="   Twilight :     "..TimeString(sunRiseSetTimes[1]).."#CRLF#[  Sunrise :      "..TimeString(sunRiseSetTimes[2]).."  ]#CRLF#[  Sunset :       "..TimeString(sunRiseSetTimes[3]).."  ]".."#CRLF#   Twilight :    "..TimeString(sunRiseSetTimes[4])
		end  	
		if NoNight and not NoSunSet then	--  twilight all night 
			sunRiseSetTimes[4]=sunRiseSetTimes[1]-0.01 
			strSunTip="   Twilight : all night#CRLF#[  Sunrise :      "..TimeString(sunRiseSetTimes[2]).."  ]#CRLF#[  Sunset :       "..TimeString(sunRiseSetTimes[3]).."  ]".."#CRLF#   Twilight : all night"
		end
		
--	set angles for sun and twilight times	
		SKIN:Bang('!SetOption', 'mTwilightMorning' , 'Formula', TimeAngle(sunRiseSetTimes[1]) )		
		SKIN:Bang('!SetOption', 'mSunRise' , 'Formula', TimeAngle(sunRiseSetTimes[2]) )	
		SKIN:Bang('!SetOption', 'mSunSet' , 'Formula', TimeAngle(sunRiseSetTimes[3]) )

		if sunRiseSetTimes[4] >= 24 then
			SKIN:Bang('!SetOption', 'mTwilightEvening' , 'Formula', TimeAngle((sunRiseSetTimes[4] - 24)) )	
			else
			SKIN:Bang('!SetOption', 'mTwilightEvening' , 'Formula', TimeAngle(sunRiseSetTimes[4]) )
		end
 
 -- set sun meter tooltip text
		SKIN:Bang('!SetOption', 'MtTimeNow' , 'ToolTipText', ''..strSunTip..'')
			
-- set date string and update the meter		
		local dd, mm, yy =Gregorian(SKIN:GetVariable('jDate'))
		local DateShown = os.time{year=yy, month=mm, day=dd} 
	 return "[ Sun data for "..dd..os.date(" %B %Y", DateShown).." ]"

 end -- function Update		
-----------------------------------------------------------------------

-----------  [   sun time calaculations   ]  ---
function  midDay(Ftime) 
		local eqt = sunPosition( jDateSun+ Ftime, 0 )
		local noon = DMath.fixHour(12- eqt)
		return noon
end  

function  sunAngleTime(angle, Ftime, direction) --time at which sun reaches a specific angle below horizon
		local decl = sunPosition(jDateSun+ Ftime, 1)	
		local noon = midDay(Ftime)	
		local t = (-DMath.Msin(angle)- DMath.Msin(decl)* DMath.Msin(nLatitude))/(DMath.Mcos(decl)* DMath.Mcos(nLatitude)	)		
		if  t  >1 then    -- The sun doesn't rise today
				NoSunRise=true
				strSunTip="#CRLF#The sun is below the#CRLF#horizon all day today"
				return noon		
		elseif t < -1.0 then  -- The sun doesn't set today
				NoSunSet=true
				strSunTip="#CRLF#No sunrise / no sunset#CRLF#The sun is up all day"					
				return noon
		end
		t = 1/15* DMath.arccos( t )
		return noon +( (direction == "CCW") and -t or t)				
end 

function  asrTime(factor, Ftime) -- compute asr time
		local decl = sunPosition(jDateSun+ Ftime, 1)
		local angle = -DMath.arccot(factor+ DMath.Mtan(math.abs(nLatitude- decl)))		
		return sunAngleTime(angle, Ftime, "ASR")
end  

function sunPosition(jd, Declination) -- compute declination angle of sun 
		local D = jd - 2451545
		local g = DMath.fixAngle(357.529 + 0.98560028* D)
		local q = DMath.fixAngle(280.459 + 0.98564736* D)
		local L = DMath.fixAngle(q + 1.915* DMath.Msin(g) + 0.020* DMath.Msin(2*g))
		local R = 1.00014 - 0.01671* DMath.Mcos(g) - 0.00014* DMath.Mcos(2*g)
		local e = 23.439 - 0.00000036* D
		local RA = DMath.arctan2(DMath.Mcos(e)* DMath.Msin(L), DMath.Mcos(L))/ 15
		local eqt = q/15 - DMath.fixHour(RA)
		local decl = DMath.arcsin(DMath.Msin(e)* DMath.Msin(L))	
		 if  Declination==1  then return decl else return eqt end
end

function  julian(year, month, day) --  convert Gregorian date to Julian day
		if (month<=2) then	year = year-1  month = month+12	end
		local A = math.floor(year/ 100)
		local B = 2- A+ math.floor(A/ 4)
		JD = math.floor(365.25* (year+ 4716))+ math.floor(30.6001* (month+ 1))+ day+ B-1524.5
		return JD
end 
	
function  setTimes( Ftimes) 
		Ftimes = dayPortion(  Ftimes )		
		 local sunrise = sunAngleTime(riseSetAngle(), Ftimes[3], "CCW")
		 local sunset  = sunAngleTime(riseSetAngle(), Ftimes[8],"CW")	 
		 local dawn    = duskAngleTime(dawnAngle, Ftimes[2], "CCW")				 
		 local dusk    = duskAngleTime(duskAngle, Ftimes[7],"CW") 		 
		return {dawn, sunrise, sunset,  dusk}			
end -- of function setTimes

function  duskAngleTime(angle, Ftime, direction) --twilight times 
		local decl = sunPosition(jDateSun+ Ftime, 1)	
		local noon = midDay(Ftime)	
		local t = (-DMath.Msin(angle)- DMath.Msin(decl)* DMath.Msin(nLatitude))/(DMath.Mcos(decl)* DMath.Mcos(nLatitude))		
		if  t  >1 then  
			NoNight = true				
			return 0	
			elseif t < -1.0 then  -- twilight all night
			NoNight = true		
 			return 0
		end			
		t = 1/15* DMath.arccos( t )
		return noon +( (direction == "CCW") and -t or t)				
end 

function  calcSunRiseSet( Ftimes )
		Ftimes = setTimes( Ftimes )		
		return adjustTimes( Ftimes )		
end -- of function calcSunRiseSet

function adjustTimes(  Ftimes )     			 
		for i = 1, #Ftimes do Ftimes[i] = Ftimes[i] + (nTimeZone - nLongitude/ 15) end	
		Ftimes = adjustHighLats( Ftimes )	
		return Ftimes
end

function riseSetAngle()  --  sun angle for sunset/sunrise
		local angle = 0.0347
		return 0.833+ angle
end

function adjustHighLats(Ftimes)  --  adjust times for higher latitudes
		local nightTime = timeDiff(Ftimes[3], Ftimes[2])
		Ftimes[1] = refineHLtimes(Ftimes[1], Ftimes[2], (dawnAngle), nightTime, "CCW")	
		return Ftimes
end

function refineHLtimes(Ftime, base, angle, night, direction)  --  refine time for higher latitudes
		portion = night/2
		FtimeDiff = (direction == "CCW") and  timeDiff(Ftime, base) or timeDiff(base, Ftime)
		if not  ((Ftime*2) > 2 )  or  (FtimeDiff > portion) 
			then
				Ftime = base+ ((direction == "CCW") and -portion or portion)
			end
		return Ftime
end 

function	dayPortion(Ftimes) --  convert hours to day portions	
				for i = 1, #Ftimes do Ftimes[i] = Ftimes[i] / 24	end		
		return Ftimes
end 
	
function timeDiff(time1, time2) --	difference between two times
		return DMath.fixHour(time2- time1)
end

------------------------------------------------------------------------
--	Convert Julian date  to Gregorian year, month, day.
function Gregorian(td)
	local z, f, a, alpha, b, c, d, e, dd, mm, yy
	td = td + 0.5
	z = math.floor(td)
	f = td - z
	if (z < 2299161)  then
		a = z
	else 
		alpha = math.floor((z - 1867216.25) / 36524.25)
		a = z + 1 + alpha - math.floor(alpha / 4)
	end
	b = a + 1524
	c = math.floor((b - 122.1) / 365.25)
	d = math.floor(365.25 * c)
	e = math.floor((b - d) / 30.6001)
	dd =  (b - d - math.floor(30.6001 * e) + f)
	if e < 14 then mm = e - 1 else mm = e - 13 end
	if mm > 2 then yy = c - 4716 else yy = c - 4715 end	 
	return dd,mm,yy
end -- function Gregorian

function getTimeOffset()
   return (os.time() - os.time(os.date('!*t')) + (os.date('*t')['isdst'] and 3600 or 0)) 
end

function  twoDigitsFormat(num)  --	add a leading 0 
	if (num<10)  then return "0"..tostring(num) 
		else return tostring(num) 
	end
end -- function twoDigitsFormat

function  TimeString( Ftime )  -- put string in Hrs : mins format - 24h version
		local hours = math.floor(Ftime)
		local minutes = math.floor( (Ftime- hours)* 60)
		return twoDigitsFormat(hours)..":"..twoDigitsFormat(minutes)
end -- function TimeString

function  TimeAngle( Ftime )  -- put time into angle 0-360 degrees
		local hours = math.floor(Ftime)
		local minutes = math.floor( (Ftime- hours)* 60) * 0.25
		return (hours*15)+minutes
end -- function TimeAngle	

-------------[  math functions  ] ---------------------
function fix(a, b) 
		a = a- b* (math.floor(a/ b))
		return (a < 0) and a+ b or a
end

function dtr(d)  return (d * math.pi) / 180 end
function rtd(r) return (r * 180) / math.pi end

DMath = {	
		Msin = function(d) return math.sin(dtr(d)) end,
		Mcos = function(d) return math.cos(dtr(d)) end,
		Mtan = function(d)  return math.tan(dtr(d)) end,
		arcsin =  function(d)  return rtd(math.asin(d)) end,
		arccos =  function(d)  return rtd(math.acos(d)) end,
		arctan =  function(d)  return rtd(math.atan(d)) end,
		arccot =  function(x)  return rtd(math.atan(1/x)) end,
		arctan2 =  function(y, x)  return rtd(math.atan2(y, x)) end,
		fixAngle =  function(a)  return fix(a, 360) end,
		fixHour =   function(a)  return fix(a, 24 ) end       
	}