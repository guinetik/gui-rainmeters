[MeterBackground]
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
MyPath3=5,105 | LineTo 15,105 | LineTo 5,95 | ClosePath 1

[meterData]
Meter=String
MeterStyle=StyleMainText
MeasureName=measureData
FontFace=Moongloss Display Thin
X=0
Y=10
W=120
H=60
Text=%1
FontSize=70
FontWeight=200
Percentual=#percentual#

[meterDate1]
Meter=String
MeterStyle=StyleSecondText
MeasureName=measureDate1
FontFace=Moongloss Display Thick
X=250
Y=35
W=100
H=20
Text=%1
FontSize=11
Percentual=#percentual#
StringCase=Upper

[meterDate2]
Meter=String
MeterStyle=StyleSecondText
MeasureName=measureDate2
FontFace=Moongloss Display Thick
X=250
Y=60
W=100
H=25
Text=%1
FontSize=11
Percentual=#percentual#
StringCase=Upper
