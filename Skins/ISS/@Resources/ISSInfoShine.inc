[MeterLineTop]
Meter=image
BackgroundMode=2
SolidColor2=#ShineColor#
SolidColor=0,0,0,255
X=7
Y=6
W=385
H=1
Hidden=(#BGstyle# = 0) ? 0 : 1
DynamicVariables=1
TransformationMatrix=#Scale#;0;0;#Scale#;#Scale#;#Scale#

[MeterLineLeft]
Meter=image
BackgroundMode=2
SolidColor=0,0,0,255
SolidColor2=#ShineColor#
GradientAngle=90
X=6
Y=7
W=1
H=143
Hidden=(#BGstyle# = 0) ? 0 : 1
DynamicVariables=1
TransformationMatrix=#Scale#;0;0;#Scale#;#Scale#;#Scale#

[MeterLineRight]
Meter=image
BackgroundMode=2
SolidColor=#ShineColor#
SolidColor2=0,0,0,255
GradientAngle=90
X=392
Y=6
W=1
H=143
Hidden=(#BGstyle# = 0) ? 0 : 1
DynamicVariables=1
TransformationMatrix=#Scale#;0;0;#Scale#;#Scale#;#Scale#

[MeterLineBottom]
Meter=image
BackgroundMode=2
SolidColor2=0,0,0,255
SolidColor=#ShineColor#
X=7
Y=149
W=385
H=1
Hidden=(#BGstyle# = 0) ? 0 : 1
DynamicVariables=1
TransformationMatrix=#Scale#;0;0;#Scale#;#Scale#;#Scale#

[MeterReflect]
Meter=IMAGE
X=-11
Y=-11
ImageName=#@#Images\ReflectDrives.png
Hidden=(#BGstyle# = 0) ? 0 : 1
TransformationMatrix=#Scale#;0;0;#Scale#;#Scale#;#Scale#

[MeterShine]
Meter=IMAGE
X=-9
Y=-3
ImageRotate=180
ImageName=#@#Images\Shine01.png
Hidden=(#BGstyle# = 0) ? 0 : 1
ImageTint=#ShineColor#
DynamicVariables=1
Group=shine
TransformationMatrix=#Scale#;0;0;#Scale#;#Scale#;#Scale#

[MeterShine1]
Meter=IMAGE
X=380
Y=-5
ImageName=#@#Images\Shine01.png
Hidden=(#BGstyle# = 0) ? 0 : 1
ImageTint=#ShineColor#
DynamicVariables=1
Group=shine
TransformationMatrix=#Scale#;0;0;#Scale#;#Scale#;#Scale#

;[ShineColorSwitchWhite]
;Measure=calc
;Formula=MeasureNetworkIsLAN + MeasureNetworkIsWAN
;IfConditionMode=1
;IfCondition=ShineColorSwitchWhite = -2
;IfTrueAction=[!SetVariable ShineColor "250,37,37"]
;IfCondition2=ShineColorSwitchWhite = 0
;IfTrueAction2=[!SetVariable ShineColor "255,246,42"]
;IfCondition3=ShineColorSwitchWhite = 2
;IfTrueAction3=[!SetVariable ShineColor "255,255,255,255"]
;DynamicVariables=1
;OnUpdateAction=[!UpdateGroup Shine][!Redraw]
;Disabled=#Shine#