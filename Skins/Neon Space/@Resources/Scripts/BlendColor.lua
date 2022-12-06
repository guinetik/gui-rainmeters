-- BlendColor is a LUA script for processing multiple color scales to output
-- RGBA notation within Rainmeter INIs.

-- Each scale is composed of "Start Percentrage, End Percentage, Start Color Value, End Color Value" notation
-- e.g.: Fade a color in gradually over 100% would be "0,100,0,255"

-- You can add more scales via a pipe '|' delimiter
-- The below examples are the equivalent of "0,100,0,255"
-- "0,50,0,128|50,100,128,255"
-- "0,25,0,64|25,50,64,128|75,50,128,192|75,100,192,255"

-- There is no limit to how many scales provided per option
-- Only RedScale, BlueScale, GreenScale, and AlphaScale options are available.

-- The measure fed to the script must have a MinValue and MaxValue set as it is based on percentages.

-- Scales support variables, however, scales are only evaluated at startup.
-- So dynamic variables will not be updated. (This support could be added, but doesn't make practical sense.)

-- The below example will keep the color green until 50%, then fade green down to 0 from 50% to 75%.
-- It also fades red in starting at 50% and makes sure it's full red from 75% to 100%
-- It also keeps the alpha level at 64 from 0-50%, then fades more in from 50-100%

--[ExampleColorMeasure]
--Measure=Script
--ScriptFile=BlendColor.lua
--MeasureToBlend=SomeMeasureWithMinMaxSet
--RedScale=50,75,0,255|75,100,255,255
--GreenScale=0,50,255,255|50,75,255,0
--AlphaScale=0,50,64,64|50,100,64,255

--Using this measure is as simple as:
--LineColor=[ExampleColorMeasure]


function Initialize()
	RedScale = load_scales('RedScale')
	GreenScale = load_scales('GreenScale')
	BlueScale = load_scales('BlueScale')
	AlphaScale = load_scales('AlphaScale')
end

function Update()
	local inputMeterName = SELF:GetOption('MeasureToBlend')
	local inputMeter = SKIN:GetMeasure(inputMeterName)
	local meterValue = inputMeter:GetRelativeValue() * 100

    local red = multi_scale_color(meterValue, RedScale)
    local green = multi_scale_color(meterValue, GreenScale)
    local blue = multi_scale_color(meterValue, BlueScale)
    local alpha = multi_scale_color(meterValue, AlphaScale)

    --Simplify since Color::MakeARGB doesn't really care about decimals
    --Also makes printing these less painful to look at
    red = math.floor(red + 0.5)
    green = math.floor(green + 0.5)
    blue = math.floor(blue + 0.5)
    alpha = math.floor(alpha + 0.5)

    local result = red .. ',' .. green .. ',' .. blue .. ',' .. alpha

	return result
end

function load_scales(scaleOption)
	local scaleString = SELF:GetOption(scaleOption)
	scalestring = SKIN:ReplaceVariables(scaleString)
	local result = {}
	for i in string.gmatch(scaleString, "([^|]+)") do
		local scale = {}
		for x in string.gmatch(i, "([^,]+)") do
			local number = tonumber(x)
			if number == nil then
				disable_me()
				error('Value in ' .. scaleOption .. ' option is not a number. Expecting number within group "' .. i .. '" at "' .. x .. '"')
			end

			table.insert(scale, number)
		end
		table.insert(result, scale)
	end

	return result
end

function scale(value, oldMin, oldMax, newMin, newMax)
	local oldRange = oldMax - oldMin
	local newRange = newMax - newMin
	local scaled = (((value - oldMin) * newRange) / oldRange) + newMin
	return scaled
end

--Expects lower percentage bound, upper percentage bound, lower color bound, upper color bound
function multi_scale_color(percentage, colorScaleTable)
	if type(colorScaleTable) ~= 'table' then
			disable_me()
			error('"' .. colorScaleTable .. '" is not a table.')
	end

	for i, value in ipairs(colorScaleTable) do
		if type(value) ~= 'table' then
			disable_me()
			error('Value (' .. value ..') at key ' .. i .. ' is not a table.')
		end

		if table.getn(value) ~= 4 then
			disable_me()
			error('Four values are required in the table, key ' .. i .. ' has only ' .. table.getn(value) .. ' values.')
		end

		if percentage >= value[1] and percentage <= value[2] then
			return scale(percentage, value[1], value[2], value[3], value[4])
		end
	end

	--Nothing was found to do
	return 0
end

function disable_me()
	SELF:Disable()
	print('Disabling Measure: ' .. SELF:GetName())
end