[Variables]
@include=#@#settings.inc
@include2=#@#Styles/styles.inc

[MeterBackground0]
Meter=Image
X=0
y=0
W=400
H=110
SolidColor=200,200,200,0

[MeterBackground1]
Meter=Image
X=5
y=5
W=390
H=100
SolidColor=#BGColor#

[MeterBorder]
Meter=Shape
Shape=Path MyPath2 | StrokeWidth 0 | Stroke Color 41,4,2,255 | Fill Color #AccentColor#
Shape2=Path MyPath3 | StrokeWidth 0 | Stroke Color 41,4,2,255 | Fill Color #AccentColor#
MyPath2=395,5 | LineTo 395,15 | LineTo 385,5 | ClosePath 1
MyPath3=5,(110-5) | LineTo 15,(110-5) | LineTo 5,(110-15) | ClosePath 1


[MeterTitle]
Meter=String
MeterStyle=StyleSecondText
FontFace=Moongloss Display Thick
x=15
y=15
w=120
h=15
FontSize=10
Text=#title#

[meterData]
Meter=String
MeasureName=measureData
MeterStyle=StyleMainText
FontFace=Moongloss Display Thin
X=155
Y=44
W=105
H=60
Text=%1
fontsize=45
StringAlign=right
Percentual=#percentual#
AutoScale=#autoscale#
NumOfDecimals=0


[meterFill]
Meter=Histogram
MeasureName=measureData
X=155
y=15
W=230
H=80
PrimaryColor=#GraphColor#
AntiAlias=1
Autoscale=#autoscale#

