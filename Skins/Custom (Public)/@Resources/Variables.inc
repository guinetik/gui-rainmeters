[Variables]
BrowserAgent=Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0


;---------------------------------Colors-----------------------------------------

;Main Suite Color (must be RGB)
AccentColor1=0,114,114

;Secondary Colors
AccentColor2=0,38,51
AccentColor3=800551
AccentColor4=6e0f31
AccentColor5=4f1923

BackgroundColor1=101010
BackgroundColor2=322f31
BackgroundColor3=969696

TransparentColor=0,0,0,1
TextEffect=None

;---------------------------Market Price Colors-------------------------------------

ColorSteady=bababa
ColorUp=00FF00
ColorDown=FF0000


;-----------------------------Font and Positioning----------------------------------

;Font color (must be RGB)
ColorDefault=255,255,255

TextFont=Fira Code
FontHeight=8
Col1XPos=10
Col2XPos=120
Col3XPos=135
Col4XPos=155
Col5XPos=235
Row1YPos=32
Yspace=18r
Yspace2=15r
Yspace3=22r

[TextStyleLeft]
FontFace=#TextFont#
StringAlign=LEFT
FontSize=#FontHeight#
FontColor=#ColorDefault#
y=r
ClipString=1
Antialias=1
Group=2

[TextStyleHover]
FontFace=#TextFont#
StringAlign=LEFT
FontSize=#FontHeight#
FontColor=#ColorDefault#
MouseOverAction=[!SetOption "#CURRENTSECTION#" FontColor #AccentColor1#] [!Update]
MouseLeaveAction=[!SetOption "#CURRENTSECTION#" FontColor ""] [!Update]
y=r
ClipString=1
Antialias=1
Group=2

[TextStyleCenter]
FontFace=#TextFont#
StringAlign=CENTER
FontSize=#FontHeight#
FontColor=#ColorDefault#
y=r
ClipString=1
Antialias=1
Group=2

[TextStyleRight]
FontFace=#TextFont#
StringAlign=RIGHT
FontSize=#FontHeight#
FontColor=#ColorDefault#
DynamicVariables=1
y=r
ClipString=1
Antialias=1
Group=2
