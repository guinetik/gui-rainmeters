[Variables]
@include=#@#settings.inc
@include2=#@#Styles/styles.inc

[MeterBackground0]
Meter=Image
X=0
y=0
W=#width#
H=#height#
SolidColor=200,200,200,0

[MeterBackground1]
Meter=Image
X=5
y=5
W=(#width#-10)
H=(#height#-10)
SolidColor=#BGColor#

[MeterBorder]
Meter=Shape
Shape=Path MyPath2 | StrokeWidth 0 | Fill Color #AccentColor#
Shape2=Path MyPath3 | StrokeWidth 0 | Fill Color #AccentColor#
MyPath2=(#width#-5),5 | LineTo (#width#-5),15 | LineTo (#width#-15),5 | ClosePath 1
MyPath3=5,(#height#-5) | LineTo 15,(#height#-5) | LineTo 5,(#height#-15) | ClosePath 1
