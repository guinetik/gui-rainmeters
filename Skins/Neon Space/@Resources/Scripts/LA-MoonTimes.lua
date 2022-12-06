--[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]][][
-- Name = LA-MoonTimes.lua
-- Version =240715
-- Script to calculate moonrise, moonset and other moon data based  on date and latitude.
--	Most of the time calculations are a translation from C-source code to Lua script by Stone.
--	Original moon rise & set calculations by Stephen R. Schmitt and translated to C by Guido Trentalancia.
--	Distance, illumination and several other calculations originate from Moontool by John Walker (http://www.fourmilab.ch/).            
--  Functions to display moon shade and rotate the images according to latitude by Mordasius. 
--  Moon shade images by Benjam Welker (http://iohelix.net)
-- License=Creative Commons BY-NC-SA 3.0
--[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]]
function Initialize()	
	    nLatitude = tonumber(SKIN:GetVariable('Latitude'))
		nLongitude = tonumber(SKIN:GetVariable('Longitude'))
		tMonths = {'January', 'February', 'March','April', 'May','June', 'July', 'August', 'September', 'October', 'November', 'December'}
		OldTimes = nil
		M_PI = math.pi
		DR = M_PI / 180
		K1 = 15 * M_PI * 1.0027379 / 180
		Rise_az = 0
		Set_az = 0
		setRotation(nLatitude)  -- moon and moon shade rotation based on Latitude	
		timeZone=getTimeOffset()/3600	 -- time zone from o.s.	
		SKIN:Bang('!SetVariable tZone  "'.. timeZone..'"' )
		
end -- function Initialize
------------------------------------------------------------------------
function Update()
-- reset default values
		Sky = {0,0,0}	Dec = {0,0,0}	VHz = {0,0,0}	RAn = {0,0,0}  rsTime =  {0,0}	
-- get system date / time
		lDate = os.date("*t", os.time())	
-- set Julian date
		JDate=julian_day(0,0,0,lDate.day, lDate.month, lDate.year)
		SKIN:Bang('!SetVariable JDate  "'..JDate..'"')	
-- previous and next rise/set times		
		iPrevRise, iPrevSet = calcMoonRiseSet( nLatitude, nLongitude,(JDate-1) , -timeZone)
		iNextRise, iNextSet = calcMoonRiseSet( nLatitude, nLongitude,(JDate+1) , -timeZone)
-- moon rise and set today
		rsTime =  {0,0}   		
		local r0, s0 = calcMoonRiseSet( nLatitude, nLongitude, JDate , -timeZone)	
-- calculate Illumination % and shade image 	
		phase(julian_day(lDate.sec, lDate.min, lDate.hour, lDate.day, lDate.month, lDate.year))
		phasehunt(julian_day(lDate.sec, lDate.min, lDate.hour, lDate.day, lDate.month, lDate.year))
-- set moon calcs and string meters
		SetMoonMeters()	
	return "[ Moon shade/illumination updated at ".. lDate.hour..":".. lDate.min.." ]"
end -- function Update
--------------------------------------------------------------------------

function SetMoonMeters()	
		if rsTime[1] == 0 then 	
			StrMoonRiseTip=' Moonrise: Last night ' 
			rsTime[1]=iPrevRise	
		end
		if rsTime[2] == 0 then 	
			StrMoonSetTip= ' Moonset: Tomorrow ' 
			rsTime[2]=iNextSet			
		end
---------------------------------------------		
local iMoonUp,  iMoonDown,	iPrevMoonSet 	
			
		if rsTime[2] > rsTime[1] then	-- moon set after moon rise day
			iMeridian = ( (rsTime[1] +(rsTime[2] - rsTime[1]) /2 ) )
			iMoonUp = TimeAngle(rsTime[2] - rsTime[1])
			iMoonDown = TimeAngle(24 - iPrevSet + rsTime[1]  )	
			iPrevMoonSet = TimeAngle( 24 - iPrevSet )				
			SKIN:Bang('!SetOption', 'mMoonRise' , 'Formula', (TimeAngle(rsTime[1]) ) )	
			if  (((lDate.hour+((lDate.min)/60))*15 ) >=  TimeAngle( rsTime[2] ) ) 
			then -- moon has set today	
				iPrevMoonSet = -TimeAngle( rsTime[2]  )		
				iMoonDown = TimeAngle(24 - rsTime[2] + iNextRise  )		
			end	
		end

		if rsTime[1] > rsTime[2] then	---  moon set before moon rise today
			 iMeridian = (iPrevRise - 24 + ((24-iPrevRise) + rsTime[2]) /2)			 
			iMoonUp = TimeAngle((24-iPrevRise) + rsTime[2])	
			iMoonDown = TimeAngle( rsTime[1] - rsTime[2])			
			iPrevMoonSet = TimeAngle( 24 - iPrevSet )	
			SKIN:Bang('!SetOption', 'mMoonRise' , 'Formula', (-TimeAngle(24 - iPrevRise) ) )		
			if  ((lDate.hour+((lDate.min)/60)) ) >=  rsTime[2] 
			then  -- moon has set today	
				iPrevMoonSet = -TimeAngle( rsTime[2]  )		
				iMoonDown = TimeAngle( rsTime[1] - rsTime[2])							
				SKIN:Bang('!SetOption', 'mMoonRise' , 'Formula', TimeAngle( rsTime[1] )  ) 	
			end			
		end
		SKIN:Bang('!SetOption', 'mMoonSet' , 'Formula', (TimeAngle(rsTime[2]) ) )		
		sMoonTip  = ''..StrMoonRiseTip..'#CRLF#'..StrMoonSetTip		
----  shows moon info
		SKIN:Bang('!SetOption', 'MtMoonImage',  'ToolTipText', '   #Phase##CRLF#       #MoonAge# days old#CRLF#   #Illumination#% Illumination#CRLF#'..sMoonTip..'#CRLF#   '..strNextPhase   )	
		SKIN:Bang('!SetVariable iMoonUp "'..iMoonUp..'"')		
		SKIN:Bang('!SetVariable iMoonDown "'..iMoonDown..'"')		
		SKIN:Bang('!SetVariable iPrevMoonSet "'..iPrevMoonSet.."")	
		
end -- function set moon meters
	
function setRotation(lat)
	local Angle = 0	
	if lat<-24 then Angle=180
	elseif lat<=12.5 then Angle= 90-((lat-12.5)*(90/36.5))	
	elseif lat<=48 then Angle= 90+(-(lat-12.5)*90/36.5)
	end
	SKIN:Bang('!SetOption', 'mRotation', 'Formula', (""..(Angle/360)..""))
end  -- of function setRotation

-----------------------------------------------------------------------------------
--	START: Code translated by Stone from Moon rise & set calculations written by Stephen R. Schmitt and translated to C by Guido Trentalancia.
----------------------------------------------------------------------------------
function sgn(x)   -- returns value for sign of argument
    local rv
 	if x > 0 then
		rv = 1
    else
		if x < 0 then
			rv = -1
		else
			rv = 0
		end
	end
    return rv
end  -- function sgn(x)

-- determine Julian day from calendar date & time
-- (Jean Meeus, "Astronomical Algorithms", Willmann-Bell, 1991)
function julian_day(second,minute,hour,day, month, year)
    local a, b, jd, gregorian
	if year < 1583 then gregorian = 0 else gregorian = 1 end
    if ((month == 1) or (month == 2)) then
		year = year - 1	month = month + 12
    end
    a = math.floor(year / 100)
    if gregorian==1 then b = 2 - a + math.floor(a / 4) else b = 0	end
	return math.floor(365.25 * (year + 4716)) + math.floor(30.6001 * (month + 1)) + day + b - 1524.5 + ((second + 60 * (minute + 60 *hour)) / 86400)
end

-- moon's position using fundamental arguments (Van Flandern & Pulkkinen, 1979)
function moon(jd)
    local d, f, g, h, m, n, s, u, v, w
    h = 0.606434 + 0.03660110129 * jd
    m = 0.374897 + 0.03629164709 * jd
    f = 0.259091 + 0.0367481952 * jd
    d = 0.827362 + 0.03386319198 * jd
    n = 0.347343 - 0.00014709391 * jd
    g = 0.993126 + 0.0027377785 * jd

    h = h - math.floor(h)
    m = m - math.floor(m)
    f = f - math.floor(f)
    d = d - math.floor(d)
    n = n - math.floor(n)
    g = g - math.floor(g)

    h = h * 2 * M_PI
    m = m * 2 * M_PI
    f = f * 2 * M_PI
    d = d * 2 * M_PI
    n = n * 2 * M_PI
    g = g * 2 * M_PI

    v = 0.39558 * math.sin(f + n)
    v = v + 0.082 * math.sin(f)
    v = v + 0.03257 * math.sin(m - f - n)
    v = v + 0.01092 * math.sin(m + f + n)
    v = v + 0.00666 * math.sin(m - f)
    v = v - 0.00644 * math.sin(m + f - 2 * d + n)
    v = v - 0.00331 * math.sin(f - 2 * d + n)
    v = v - 0.00304 * math.sin(f - 2 * d)
    v = v - 0.0024 * math.sin(m - f - 2 * d - n)
    v = v + 0.00226 * math.sin(m + f)
    v = v - 0.00108 * math.sin(m + f - 2 * d)
    v = v - 0.00079 * math.sin(f - n)
    v = v + 0.00078 * math.sin(f + 2 * d + n)

    u = 1 - 0.10828 * math.cos(m)
    u = u - 0.0188 * math.cos(m - 2 * d)
    u = u - 0.01479 * math.cos(2 * d)
    u = u + 0.00181 * math.cos(2 * m - 2 * d)
    u = u - 0.00147 * math.cos(2 * m)
    u = u - 0.00105 * math.cos(2 * d - g)
    u = u - 0.00075 * math.cos(m - 2 * d + g)

    w = 0.10478 * math.sin(m)
    w = w - 0.04105 * math.sin(2 * f + 2 * n)
    w = w - 0.0213 * math.sin(m - 2 * d)
    w = w - 0.01779 * math.sin(2 * f + n)
    w = w + 0.01774 * math.sin(n)
    w = w + 0.00987 * math.sin(2 * d)
    w = w - 0.00338 * math.sin(m - 2 * f - 2 * n)
    w = w - 0.00309 * math.sin(g)
    w = w - 0.0019 * math.sin(2 * f)
    w = w - 0.00144 * math.sin(m + n)
    w = w - 0.00144 * math.sin(m - 2 * f - n)
    w = w - 0.00113 * math.sin(m + 2 * f + 2 * n)
    w = w - 0.00094 * math.sin(m - 2 * d + g)
    w = w - 0.00092 * math.sin(2 * m - 2 * d)
    s = w / math.sqrt(u - v * v)	-- compute moon's right ascension ... 
    Sky[1] = h + math.atan(s / math.sqrt(1 - s * s))

    s = v / math.sqrt(u)		-- declination ...
    Sky[2] = math.atan(s / math.sqrt(1 - s * s))
    Sky[3] = 60.40974 * math.sqrt(u)	-- and parallax
end -- of function moon

function test_moon(k, t0, nLatitude, plx)   -- test an hour for an event
    ha = {0,0,0}
    local a, b, c, d, e, s, z
    local _time
    local az, hz, nz, dz
    if (RAn[3] < RAn[1]) then
		RAn[3] = RAn[3] + 2 * M_PI
	end
    ha[1] = t0 - RAn[1] + (k * K1)
    ha[3] = t0 - RAn[3] + (k * K1) + K1
    ha[2] = (ha[3] + ha[1]) / 2	-- hour angle at half hour
    Dec[2] = (Dec[3] + Dec[1]) / 2	-- declination at half hour
    s = math.sin(DR * nLatitude)
    c = math.cos(DR * nLatitude)

    -- refraction + sun semidiameter at horizon + parallax correction
    z = math.cos(DR * (90.567 - 41.685 / plx))

    if (k <= 0) then			-- first call of function
		VHz[1] = s * math.sin(Dec[1]) + c * math.cos(Dec[1]) * math.cos(ha[1]) - z
	end
    VHz[3] = s * math.sin(Dec[3]) + c * math.cos(Dec[3]) * math.cos(ha[3]) - z
    if (sgn(VHz[1]) == sgn(VHz[3])) then
		return VHz[3]		-- no event this hour
	end
    VHz[2] = s * math.sin(Dec[2]) + c * math.cos(Dec[2]) * math.cos(ha[2]) - z
    a = 2 * VHz[3] - 4 * VHz[2] + 2 * VHz[1]
    b = 4 * VHz[2] - 3 * VHz[1] - VHz[3]
    d = b * b - 4 * a * VHz[1]
	
    if (d < 0) then
		return VHz[3]		-- no event this hour
	end
    
	d = math.sqrt(d)
    e = (-b + d) / (2 * a)
    if ((e > 1) or (e < 0)) then
		e = (-b - d) / (2 * a)
	end	
    _time = k + e + 1 / 120	-- time of an event + round up
	
    if ((VHz[1] < 0) and (VHz[3] > 0)) then
	    rsTime[1] = _time
		StrMoonRiseTip= '[  Moonrise :   '..TimeString(rsTime[1])..'  ]'
    end
	
    if ((VHz[1] > 0) and (VHz[3] < 0)) then
		rsTime[2] = _time
		StrMoonSetTip= '[  Moonset :    '..TimeString(rsTime[2])..'  ]'
    end
	
    return VHz[3]
end -- of function testmoon

-- Local Sidereal Time for zone
function lst(lon, jd, z)
    s = 24110.5 + 8640184.812999999 * jd / 36525 + 86636.6 * z + 86400 * lon
    s = s / 86400
    s = s - math.floor(s)
    return s * 360 * DR
end -- of function lst

function interpolate(f0, f1, f2, p)  -- 3-point interpolation
	a = f1 - f0
	b = f2 - f1 - a
	f = f0 + p * (2 * a + b * (2 * p - 1))
    return f
end -- of function  interpolate

function calcMoonRiseSet( lat ,  lon,  jDm,  zone ) -- calculate moonrise and moonset times
    local i, j, k	
    local ph
	jd=jDm- 2451545	-- Julian day relative to Jan 1.5, 2000
    local mp={}
    lon_local = lon
	for i = 1,3 do
		mp[i]={}
		for j = 1,3 do
			mp[i][j] = 0
		end
	end
    lon_local = lon / 360
    tz = zone / 24
    t0 = lst(lon_local, jd, tz)	-- local sidereal time
    jd = jd + tz		-- get moon position at start of day
    for k = 1,3 do
		moon(jd)
		mp[k][1] = Sky[1]
		mp[k][2] = Sky[2]
		mp[k][3] = Sky[3]
		jd = jd + 0.5
    end
	
    if (mp[2][1] <= mp[1][1]) then
		mp[2][1] = mp[2][1] + 2 * M_PI
	end
    if (mp[3][1] <= mp[2][1]) then
		mp[3][1] = mp[3][1] + 2 * M_PI
	end
    RAn[1] = mp[1][1]
    Dec[1] = mp[1][2]
	
    for k = 0,23 do	-- check each hour of this day
		ph = (k + 1) / 24
		RAn[3] = interpolate(mp[1][1], mp[2][1], mp[3][1], ph)
		Dec[3] = interpolate(mp[1][2], mp[2][2], mp[3][2], ph)
		VHz[3] = test_moon(k, t0, lat, mp[2][3])
		RAn[1] = RAn[3]	-- advance to next hour
		Dec[1] = Dec[3]
		VHz[1] = VHz[3]
    end	
		return  rsTime[1],  rsTime[2]
		
end  -- end of function calcMoonRiseSet

------------------------------------------------------------------------------------
--	START: Code tanslated by Stone from Moontool by John Walker (http://www.fourmilab.ch/).
------------------------------------------------------------------------------------
-- Deg->Rad 
function torad(d) 
	return (d * (math.pi / 180))
end

 -- Rad->Deg 
function todeg(d) 
	return (d * (180 / math.pi))
end

-- Fix angle
function fixangle(a) 
	return((a) - 360 * (math.floor(a / 360)))
end

--	Sin from deg
function dsin(x)
	return (math.sin(torad((x))))
end

--	Cos from deg
function dcos(x)
	return (math.cos(torad((x)))) 
end

--	JYEAR - Gregorian
--	Convert Julian date  to Gregorian year,  month, day.
function jyear(td)
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
end

--	JHM
--	Convert Julian time to hour, minutes.
function jhm(j)
	local ij
	j = j + 0.5										--	Astronomical to civil
	ij = ((j - math.floor(j)) * 86400) + 0.5		--	Round to nearest second
	return (ij / 3600), ((ij / 60) % 60)
end

--	JWDAY
--	Determine day of the week for a given Julian day.
function jwday(j)
	return ((j + 1.5)% 7)
end

--	MEANPHASE  
--	Calculates  time  of  the mean new Moon for a given base date.  The argument K to this function is the precomputed synodic month index, given by: K = (year - 1900) * 12.3685 where year is expressed as a year and fractional year.
function meanphase(sdate, k)
	local t, t2, t3, nt1
	--	Time in Julian centuries from 1900 January 0.5
	t = (sdate - 2415020) / 36525
	t2 = t * t			-- Square for frequent use
	t3 = t2 * t			-- Cube for frequent use
	nt1 = 2415020.75933 + synmonth * k + 0.0001178 * t2 - 0.000000155 * t3 + 0.00033 * dsin(166.56 + 132.87 * t - 0.009173 * t2)
	return nt1
end

--	TRUEPHASE
--	Given a K value used to determine the mean phase of the new moon, and a phase selector (0.0, 0.25, 0.5, 0.75), obtain the true, corrected phase time.
function truephase(k, phase)
	local t, t2, t3, pt, m, mprime, f
	k = k + phase					-- Add phase to new moon time 
	t = k / 1236.85				-- Time in Julian centuries from 1900 January 0.5 
	t2 = t * t						-- Square for frequent use 
	t3 = t2 * t						-- Cube for frequent use 
	-- Mean time of phase
	pt = 2415020.75933+ synmonth * k + 0.0001178 * t2 - 0.000000155 * t3  + 0.00033 * dsin(166.56 + 132.87 * t - 0.009173 * t2)
	m = 359.2242 + 29.10535608 * k  - 0.0000333 * t2- 0.00000347 * t3						-- Sun's mean anomaly
	mprime = 306.0253+ 385.81691806 * k+ 0.0107306 * t2+ 0.00001236 * t3				-- Moon's mean anomaly
	f = 21.2964 + 390.67050646 * k - 0.0016528 * t2- 0.00000239 * t3						-- Moon's argument of Latitude 

	if ((phase < 0.01) or (math.abs(phase - 0.5) < 0.01))  then
		--  Corrections for New and Full Moon 
		pt = pt + (0.1734 - 0.000393 * t) * dsin(m)+ 0.0021 * dsin(2 * m)- 0.4068 * dsin(mprime) + 0.0161 * dsin(2 * mprime) - 0.0004 * dsin(3 * mprime) + 0.0104 * dsin(2 * f) - 0.0051 * dsin(m + mprime) - 0.0074 * dsin(m - mprime)+ 0.0004 * dsin(2 * f + m) - 0.0004 * dsin(2 * f - m) - 0.0006 * dsin(2 * f + mprime) + 0.0010 * dsin(2 * f - mprime)+ 0.0005 * dsin(m + 2 * mprime)
	else
		if ((math.abs(phase - 0.25) < 0.01 or (math.abs(phase - 0.75) < 0.01)))  then
			pt = pt + (0.1721 - 0.0004 * t) * dsin(m) + 0.0021 * dsin(2 * m) - 0.6280 * dsin(mprime) + 0.0089 * dsin(2 * mprime) - 0.0004 * dsin(3 * mprime) + 0.0079 * dsin(2 * f)- 0.0119 * dsin(m + mprime)- 0.0047 * dsin(m - mprime)+ 0.0003 * dsin(2 * f + m)- 0.0004 * dsin(2 * f - m) - 0.0006 * dsin(2 * f + mprime) + 0.0021 * dsin(2 * f - mprime) + 0.0003 * dsin(m + 2 * mprime) + 0.0004 * dsin(m - 2 * mprime) - 0.0003 * dsin(2 * m + mprime)
			if (phase < 0.5) then
				--  First quarter correction 
				pt = pt+0.0028 - 0.0004 * dcos(m) + 0.0003 * dcos(mprime)
			else
				--  Last quarter correction 
				pt = pt -0.0028 + 0.0004 * dcos(m) - 0.0003 * dcos(mprime)
			end
		end
	end
	return pt
end

--	PHASEHUNT
--  Find time of phases of the moon which surround the current date.  Five phases are found, starting and ending with the new moons which bound the  current lunation.
function phasehunt(sdate)
	local adate, k1, k2, nt1, nt2, yy, mm, dd
	adate = sdate - 45
	dd,mm,yy= jyear(adate)
	k1 = math.floor((yy + ((mm - 1) * (1 / 12)) - 1900) * 12.3685)
	nt1 = meanphase(adate, k1)
	adate = nt1
--	'safe'-variable added by Stone (beacuse an error in the C->Lua translation caused this loop to continue forever). The error has been corrected, but I left the variable to make sure this Lua-script doesn't make Rainmeter lock-up.
	safe=0
	while (true and safe<10000) do
		adate = adate + synmonth
		k2 = k1 + 1
		nt2 = meanphase(adate, k2)
		if ((nt1 <= sdate) and (nt2 > sdate)) then break end
		nt1 = nt2
		k1 = k2
		safe=safe+1
	end
---------------------------------------------------------------------	
	local npn =  (PhaseTime(truephase(k1,0.5))) 
	if tonumber( npn[1] ) > 0 then -- next phase is full moon
			strNextPhase = 'Full Moon : '..npn[2]..' '..tMonths[npn[3]]
	 else -- next phase is new moon
			npn =  (PhaseTime(truephase(k2,0))) 
			strNextPhase = 'New Moon : '..npn[2]..' '..tMonths[npn[3]]
	 end
end

function  PhaseTime( j )
	local HH, MM = jhm(j)
	local dd, mm, yy = jyear(j)	
	return {timediff(math.floor(HH), math.floor(MM), math.floor(dd), math.floor(mm), math.floor(yy)), math.floor(dd), mm}
end  -- function PhaseTime

function ConvertBang(VarName, j)
	local HH, MM = jhm(j)
	local dd, mm, yy = jyear(j)	
	HH = timediff(math.floor(HH), math.floor(MM), math.floor(dd), math.floor(mm), math.floor(yy))
	SKIN:Bang('!SetVariable '..VarName..' '..HH)
end

function timediff(HH, MM, dd, mm, yy)
	local localtime = os.time({year = yy, month = mm, day = dd, hour = HH, min = MM }) + timeZone
	local settime = os.time({year = lDate.year, month = lDate.month, day = lDate.day, hour = lDate.hour, min = lDate.min }) + timeZone
	local diff = os.difftime(localtime, settime) / 86400
	return string.format('%.2f',diff)
end

-- KEPLER     Solve the equation of Kepler.
function kepler(m,ecc)
	local e, delta
	EPSILON = 1E-6
	e = torad(m)
	m = torad(m)

	delta = e - ecc * math.sin(e) - m
	while (math.abs(delta) > EPSILON) do
		delta = e - ecc * math.sin(e) - m
		e = e - delta / (1 - ecc * math.cos(e))
	end
	return e
end

-- phase(pdate)   Calculate phase Illumination %, age and distance) of moon.
-- The  argument (pdate) is  the  time  for  which  the  data is requested,
-- expressed as a Julian date and fraction.

function phase(pdate)
	local Day, N, M, Ec, Lambdasun, ml, MM, MN, Ev, Ae, A3, MmP, mEc, A4, lP, V, lPP, NP, y, x, Lambdamoon, BetaM, MoonAge, MoonPhase,MoonDist, MoonDFrac, MoonAng, MoonPar, F, SunDist, SunAng, Elongation
	elonge = 278.833540		-- Ecliptic nLongitude of the Sun at epoch 1980.0 
	elongp = 282.596403		-- Ecliptic nLongitude of the Sun at perigee 
	eccent = 0.016718		-- Eccentricity of Earth's orbit
	sunsmax = 1.495985e8	-- Semi-major axis of Earth's orbit, km
	sunangsiz = 0.533128	-- Sun's angular size, degrees, at semi-major axis distance
	epoch = 2444238.5		-- 1980 January 0.0 

	-- Elements of the Moon's orbit, epoch 1980.0
	mmlong = 64.975464		-- Moon's mean nLongitude at the epoch
	mmlongp = 349.383063	-- Mean nLongitude of the perigee at the epoch
	mlnode = 151.950429		-- Mean nLongitude of the node at the epoch
	minc = 5.145396			-- Inclination of the Moon's orbit 
	mecc = 0.054900			-- Eccentricity of the Moon's orbit
	mangsiz = 0.5181		-- Moon's angular size at distance a from Earth
	msmax = 384401.0		-- Semi-major axis of Moon's orbit in km
	synmonth = 29.53058868	-- Synodic month (new Moon to new Moon)
	mparallax = 0.9507		-- Parallax at distance a from Earth

	-- Calculation of the Sun's position
	Day = pdate - epoch						-- Date within epoch 
	N = fixangle((360 / 365.2422) * Day)	-- Mean anomaly of the Sun 
	M = fixangle(N + elonge - elongp)		-- Convert from perigee co-ordinates to epoch 1980.0
	Ec = kepler(M, eccent)					-- Solve equation of Kepler
	Ec = math.sqrt((1 + eccent) / (1 - eccent)) * math.tan(Ec / 2)
	Ec = 2 * todeg(math.atan(Ec))			-- True anomaly
	Lambdasun = fixangle(Ec + elongp)		-- Sun's geocentric ecliptic Longitude

	-- Orbital distance factor
	-- F = ((1 + eccent * math.cos(torad(Ec))) / (1 - eccent * eccent))
	-- SunDist = sunsmax / F                  -- Distance to Sun in km
	-- SunAng = F * sunangsiz                 -- Sun's angular size in degrees

	-- Calculation of the Moon's position
	-- Moon's mean Longitude
	ml = fixangle(13.1763966 * Day + mmlong)
	-- Moon's mean anomaly
	MM = fixangle(ml - 0.1114041 * Day - mmlongp)
	-- Moon's ascending node mean Longitude 
	MN = fixangle(mlnode - 0.0529539 * Day)
	-- Evection
    Ev = 1.2739 * math.sin(torad(2 * (ml - Lambdasun) - MM))
	-- Annual equation
	Ae = 0.1858 * math.sin(torad(M))
	-- Correction term
	A3 = 0.37 * math.sin(torad(M))
	-- Corrected anomaly 
	MmP = MM + Ev - Ae - A3
	-- Correction for the equation of the centre
	mEc = 6.2886 * math.sin(torad(MmP))
	-- Another correction term
	A4 = 0.214 * math.sin(torad(2 * MmP))
	-- Corrected Longitude
	lP = ml + Ev + mEc - Ae + A4
	-- Variation 
	V = 0.6583 * math.sin(torad(2 * (lP - Lambdasun)))
	-- True Longitude
	lPP = lP + V
	-- Corrected Longitude of the node
	NP = MN - 0.16 * math.sin(torad(M))
	-- Y inclination coordinate 
	y = math.sin(torad(lPP - NP)) * math.cos(torad(minc))
	-- X inclination coordinate
	x = math.cos(torad(lPP - NP))
	-- Ecliptic Longitude
	Lambdamoon = todeg(math.atan2(y, x))
	Lambdamoon = Lambdamoon + NP
	-- Ecliptic Latitude
	BetaM = todeg(math.asin(math.sin(torad(lPP - NP)) * math.sin(torad(minc))))
	-- Age of the Moon in degrees and days
	MoonAge = lPP - Lambdasun
	SKIN:Bang('!SetVariable MoonAge "'..string.format('%.0f',((fixangle(MoonAge)/360*29.53058868)))..'"')	
	-- Phase of the Moon / percentage of moon illuminated ( 0.0 - 1.0 )
	MoonPhase = (1 - math.cos(torad(MoonAge))) / 2
	SKIN:Bang('!SetVariable Illumination "'..string.format('%.0f',(100*MoonPhase))..'"')	
	-- Moon shade image
	ImageNumber = (math.floor(((fixangle(MoonAge) )-2)/4)*4)+2
	SKIN:Bang('!SetVariable ShadeImage "'..string.format('%.0f',ImageNumber)..'"')
	-- Calculate distance of moon from the centre of the Earth
	MoonDist = (msmax * (1 - mecc * mecc)) / (1 + mecc * math.cos(torad(MmP + mEc)))
	-- Calculate Moon's angular diameter
	MoonDFrac = MoonDist / msmax
	MoonAng = mangsiz / MoonDFrac
-- print("moon angle: "..MoonAng)	
	-- Calculate Moon's parallax 
	MoonPar = mparallax / MoonDFrac
	-- Set the Current Phase
	SKIN:Bang('!SetVariable Phase "'..phase1(100*MoonPhase,(synmonth * (fixangle(MoonAge) / 360))<(29.530588853/2))..' '..phase2(100*MoonPhase)..'"')

end
----------------------------------------------------------------------------
--	END: Code from Moontool by John Walker (http://www.fourmilab.ch/).
----------------------------------------------------------------------------
--	Phase is implemented after description found in Wikipedia.
--	parameter I is illumination (percentage), FirstHalf is true in the first half of the month (from New Moon to Full Moon) - a month is 29.530588853 days.
function phase1(I,FirstHalf)
	if I<1 then return 'New' end
	if I>99 then return 'Full' end
	if FirstHalf then
		if (I>49 and I<51) then return 'First' end
		if ((I>=1 and I<=49) or (I>=51 and I<=99)) then return 'Waxing' end
	else
		if (I>49 and I<51) then return 'Third' end
		if ((I>=1 and I<=49) or (I>=51 and I<=99)) then return 'Waning' end
	end
end

function phase2(I)
	if (I<1 or I>99) then return 'Moon' end
	if (I>49 and I<51) then return 'Quarter' end
	if (I>=1 and I<=49) then return 'Crescent' end
	if (I>=51 and I<=99) then return 'Gibbous' end
end
----------------------------------------------------------

----  OTHER FUNCTIONS --
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
	
