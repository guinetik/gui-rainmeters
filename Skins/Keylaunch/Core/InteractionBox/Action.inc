[Rainmeter]
SkinWidth=#Sec.W#

[Variables]
Sec.W=(500*#Sec.S#)
Sec.H=(700*#Sec.S#)
Sec.Size1=(180*#Sec.S#)
Sec.Size2=0
AniDir=Bottom
Sec.SaveLocation=#SKINSPATH#..\CoreData\Keylaunch\Act.inc
@includeSkinActions=#SKINSPATH#..\CoreData\Keylaunch\Act.inc


[moveX]
Formula=(#SCREENAREAWIDTH#/2)
[moveY]
Formula=(#SCREENAREAHEIGHT#/2)
[anchorX]
Formula=50
[anchorY]
Formula=50

[ActionTimer]
Custom1=

; ---------------------------------------------------------------------------- ;
;                                   Function                                   ;
; ---------------------------------------------------------------------------- ;

[Choose:M]
Measure=Plugin
Plugin=FileChoose
UseNewStyle=0
GetTarget=0
AllowNonstorageFolder=1
CopyLink=1
GetIcon=1
IconCache=#SKINSPATH#..\CoreData\Keylaunch\IconCache\
IconSize=3
ReturnValue=WholePath
FileInitialDirectory=
ImageInitialDirectory=#CurrentPath#IconCache\
DynamicVariables=1
Command1=[!UpdateMEasure #CURRENTSECTION#][!CommandMeasure GenPs1 """WriteTo -index "#Sec.arg1#" -param1 "$Name$" -param2 "`[`"$Path$`"`]" -param3 "$Name$_$Ext$"""" "#JaxCore\Main"]
Command2=[!UpdateMEasure #CURRENTSECTION#][!CommandMeasure GenPs1 """WriteTo -index "#Sec.arg1#" -param1 "$Name$" -param2 "`[`"$Path$`"`]" """ "#JaxCore\Main"]


; ---------------------------------------------------------------------------- ;
;                                  MeterStyles                                 ;
; ---------------------------------------------------------------------------- ;


[Button.Shape:S]
X=((50/2)*#Sec.S#+#Sec.P#)r
Y=(-50/2*#Sec.S#)r
Shape=Rectangle 0,0,(50*#Sec.S#),(50*#Sec.S#),(#Sec.R#/2) | StrokeWidth 0 | Extend This
This=fill Color [&Func:LocalVar('#CURRENTSECTION#', 'ColorLeave')]
DynamicVariables=1
MouseOverAction=[!SetOption #CURRENTSECTION# this "Fill Color [&Func:LocalVar('#CURRENTSECTION#', 'ColorOver')]"][!UpdateMeter #CURRENTSECTION#][!Redraw]
MouseLeaveAction=[!SetOption #CURRENTSECTION# this "Fill Color [&Func:LocalVar('#CURRENTSECTION#', 'ColorLeave')]"][!UpdateMeter #CURRENTSECTION#][!Redraw]
ColorLeave=100,100,100,100
ColorOver=100,100,100,200

[Button.String:S]
X=(50/2*#Sec.S#)r
Y=(50/2*#Sec.S#)r
FontFace=Material Icons round
FontSize=(16*#Sec.S#)
DynamicVariables=1
StringAlign=CenterCenter

[Path:M]
Measure=String
String=
; RegexpSubstitute=1
Substitute="\":"\\"

[Input:M]
Measure=Plugin
Plugin=InputText
SolidColor=#Set.Pri_Color#
FontColor=#Set.Text_Color#
FontFace=#Set.Font#
FontSize=(10*#Sec.S#)
StringAlign=Center
X=(#Sec.P#)
Y=(#Sec.P#)
W=(#Sec.W#-#sec.P#*2)
H=([KeyLabel:H])
DynamicVariables=1
DefaultValue="[##Editing#]"
Command1=[!CommandMeasure GenPs1 """WriteTo -index "#Sec.arg1#" -param1 "$UserInput$" """ "#JaxCore\Main"]
Command2=[!CommandMeasure GenPs1 """WriteTo -index "#Sec.arg1#" -param2 "$UserInput$" """ "#JaxCore\Main"]
Command3=[!CommandMeasure GenPs1 """WriteTo -index "#Sec.arg1#" -param3 "$UserInput$" """ "#JaxCore\Main"]

; ---------------------------------------------------------------------------- ;
;                                    Content                                   ;
; ---------------------------------------------------------------------------- ;


[KeyLabel]
Meter=String
X=(#Sec.W#/2)
Y=(#Sec.P#)
W=(#Sec.W#-#Sec.P#*2)
ClipString=2
FontSize=(10*#SEc.S#)
FontColor=#Set.Subtext_Color#
Text=Editing #Sec.arg1# #CRLF#Click on anything to edit their values, or click Quick start to generate them. Icons must be name of images from IconCache folder in Keylaunch's @Resources folder. Actions must be in Rainmeter's bang format, that is in square brackets
inlinepattern=#CRLF#.*
inlinesetting=Size | (8*#Sec.S#)
DynamicVariables=1
StringAlign=Center
MeterStyle=Sec.String:S

[Image]
MEter=Image
X=(#Sec.W#/2-#Sec.Size1#/2)
Y=(#Sec.H#/2-(#Sec.Size1#+[Name:H]+[Act:H])/2)
W=(#Sec.Size1#)
H=(#Sec.Size1#)
ImageAlpha=255
DynamicVariables=1
ImageName=#SKINSPATH#..\CoreData\Keylaunch\IconCache\[##Sec.arg1#Icon].png

[Name]
Meter=String
X=(#Sec.W#/2)
Y=(#Sec.P#*2)R
FontSize=(20*#Sec.S#)
FontFace=#Set.Font# 
FontWeight=(650)
Text=[##Sec.arg1#Name]
Prefix="> "
Postfix=" <"
DynamicVariables=1
Leftmouseupaction=[!SetVariable Editing "#Sec.arg1#Name"][!CommandMeasure Input:M "ExecuteBatch 1"]
StringAlign=CenterCenter
MeterStyle=Sec.String:S

[Act]
Meter=String
X=(#Sec.W#/2)
Y=(10)R
Prefix="Action: "
Postfix=""
FontSize=(10*#Sec.S#)
Text=[##Sec.arg1#Action]
DynamicVariables=1
StringAlign=CenterCenter
Leftmouseupaction=[!SetVariable Editing "#Sec.arg1#Action"][!CommandMeasure Input:M "ExecuteBatch 2"]
MeterStyle=Sec.String:S
W=(#Sec.W#-#Sec.P#*2)
ClipString=2

[ImageName]
Meter=String
X=(#Sec.W#/2)
Y=(10*#Sec.S#)R
FontSize=(10*#Sec.S#)
Text=ImageName: "[##Sec.arg1#Icon]"
DynamicVariables=1
StringAlign=CenterCenter
Leftmouseupaction=[!SetVariable Editing "#Sec.arg1#Icon"][!CommandMeasure Input:M "ExecuteBatch 3"]
MeterStyle=Sec.String:S
W=(#Sec.W#-#Sec.P#*2)
ClipString=2

[Button1.Shape]
Meter=Shape
X=(#Sec.W#/2-((50*4)*#Sec.S#+#Sec.P#*3)/2)
Y=(20*#Sec.S#)R
LeftMouseUpAction=[!CommandMeasure Choose:M "ChooseFile 1"]
MeterStyle=Button.Shape:S
[Button1.String]
Meter=String
Text=[\xe873]
MEterStyle=Sec.String:S | Button.String:S

[Button2.Shape]
Meter=Shape
LeftMouseUpAction=[!CommandMeasure Choose:M "ChooseFolder 2"]
MeterStyle=Button.Shape:S
[Button2.String]
Meter=String
Text=[\xe2c7]
MEterStyle=Sec.String:S | Button.String:S

[Button3.Shape]
Meter=Shape
ColorLeave=100,100,0,150
ColorOver=100,100,0,250
Leftmouseupaction=["#SKINSPATH#..\CoreData\Keylaunch\IconCache\"]
MeterStyle=Button.Shape:S
[Button3.String]
Meter=String
Text=[\xe3b6]
MEterStyle=Sec.String:S | Button.String:S

[Button4.Shape]
Meter=Shape
ColorLeave=0,100,0,150
ColorOver=0,100,0,250
Leftmouseupaction=[!Refresh "#JaxCore\Main"][!Refresh "#Skin.Name#\Main"][!CommandMeasure ActionTimer "Execute 2"]
MeterStyle=Button.Shape:S
[Button4.String]
Meter=String
Text=[\xe876]
MEterStyle=Sec.String:S | Button.String:S
