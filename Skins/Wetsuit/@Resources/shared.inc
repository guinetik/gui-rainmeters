[Rainmeter]
ContextTitle=Edit variables...
ContextAction=["#CONFIGEDITOR#" "#@#variables.inc"]
MiddleMouseUpAction=!Refresh
Group=Wetsuit

; ===== STYLES

[Small]
Shape=Rectangle 0,0,#IconSize#,#IconSize#,#IconCornerRadius# | StrokeWidth 0 | Extend ShapeColor
X=#IconSpacing#R
Y=r
UpdateDivider=-1

[Long]
Shape=Rectangle 0,0,#IconSize#,((#IconSize#*2)+#IconSpacing#),#IconCornerRadius# | StrokeWidth 0 | Extend ShapeColor
X=#IconSpacing#R
Y=r
UpdateDivider=-1

[Custom]
Shape=Rectangle 0,0,(#IconSize#+(#CustomWidth#-1)*(#IconSize#+#IconSpacing#)),(#IconSize#+(#CustomHeight#-1)*(#IconSize#+#IconSpacing#)),#IconCornerRadius# | StrokeWidth 0 | Extend ShapeColor
X=#IconSpacing#R
Y=r
UpdateDivider=-1

[Icon]
ShapeColor=Fill Color #PassiveColor#
MouseOverAction=[!SetOption #CURRENTSECTION# ShapeColor "Fill Color #ActiveColor#"][!UpdateMeter #CURRENTSECTION#][!Redraw]
MouseLeaveAction=[!SetOption #CURRENTSECTION# ShapeColor ""][!UpdateMeter #CURRENTSECTION#][!Redraw]

[Bar]
W=[#CURRENTSECTION#Container:W]
H=[#CURRENTSECTION#Container:H]
Container=#CURRENTSECTION#Container
SolidColor=#PassiveColor#
BarColor=#ActiveColor#
Flip=1

[Meter]
W=(#IconSize#+(#CustomWidth#-1)*(#IconSize#+#IconSpacing#))
H=(#IconSize#+(#CustomHeight#-1)*(#IconSize#+#IconSpacing#))
Container=#CURRENTSECTION#Container
SolidColor=#PassiveColor#

[SimpleImage]
W=#IconSize#
H=#IconSize#
X=r
Y=#IconSpacing#R
ImageTint=#ActiveColor#
UpdateDivider=-1

[ImageToolTip]
W=#IconSize#
H=#IconSize#
X=r
Y=r
FontColor=0,0,0,0
Text=0
MouseOverAction=[!Delay 50][!UpdateMeter #CURRENTSECTION#]
ToolTipWidth=200

[Start]
X=#IconSpacing#
Y=#IconSpacing#

[Next]
X=#IconSpacing#
Y=#IconSpacing#R

[Background]
Meter=Shape
Shape=Rectangle 0,0,(#CURRENTCONFIGWIDTH#+#IconSpacing#),(#CURRENTCONFIGHEIGHT#+#IconSpacing#),#BackgroundCornerRadius# | Fill Color #BackgroundColor# | StrokeWidth 0
DynamicVariables=1
UpdateDivider=-1