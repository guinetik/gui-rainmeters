


;-------------------------------------------------measures-------------

[Variables]

[mPlayer]
Measure=Plugin
Plugin=NowPlaying.dll
PlayerName=#MusicPlayer#
PlayerType=TITLE
DynamicVariables=1
PlayerPath=
DisableLeadingZero=1
Substitute="":"Track" 

[mPlayerState]
Measure=PLUGIN
Plugin=NowPlaying.dll
PlayerName=[mPlayer]
PlayerType=STATE


[mArtist]
Measure=PLUGIN
Plugin=NowPlaying.dll
PlayerName=[mPlayer]
PlayerType=ARTIST
Substitute="":"Artist" 

[mAlbum]
Measure=PLUGIN
Plugin=NowPlaying.dll
PlayerName=[mPlayer]
PlayerType=ALBUM
Group=mPlayer

[mYear]
Measure=PLUGIN
Plugin=NowPlaying.dll
PlayerName=[mPlayer]
PlayerType=Year
Group=mPlayer



[mStateButton]
Measure=PLUGIN
Plugin=NowPlaying.dll
PlayerName=[mPlayer]
PlayerType=STATE
Substitute="0":"Play.png","1":"Pause.png","2":"Play.png"
Group=mPlayer

[mPosition]
Measure=PLUGIN
Plugin=NowPlaying.dll
PlayerName=[mPlayer]
PlayerType=POSITION
Group=mPlayer

[mDuration]
Measure=PLUGIN
Plugin=NowPlaying.dll
PlayerName=[mPlayer]
PlayerType=DURATION
Group=mPlayer

[mPosition]
Measure=Plugin
Plugin=NowPlaying
PlayerName=[mPlayer]
PlayerType=Position
IfCondition=mPosition < 1
IfTrueAction=[!SetOption MtPrevious LeftMouseUpAction """[!CommandMeasure mPlayer "Previous"]"""]
IfFalseAction=[!SetOption MtPrevious LeftMouseUpAction """[!CommandMeasure mPlayer "SetPosition 0"]"""]
Group=mPlayer

[mSmoothProgress]
Measure=SCRIPT
ScriptFile=#@#Scripts\SmoothProgress.lua
UpdatePeriod=10000
ResetInterval=10
SafetyRange=2
Adjustment=1


[mCover]
Measure=Plugin
Plugin=NowPlaying.dll
PlayerName=[mPlayer]
PlayerType=COVER
Substitute="":"#@#Images/musiccover/Default.png"


;-------------------



;-------------------------------------------------WebNowplaying

[MeasureStatus]
Measure=Plugin
Plugin=WebNowPlaying
PlayerType=Status

[MeasureTitlewebnow]
Measure=Plugin
Plugin=WebNowPlaying
PlayerType=Title
UpdateDivider = 5
Substitute="":"N/A"

[MeasureArtistwebnow]
Measure=Plugin
Plugin=WebNowPlaying
PlayerType=Artist
UpdateDivider = 5
Substitute="":"N/A"

[MeasurePositionwebnow]
Measure=Plugin
Plugin=WebNowPlaying
PlayerType=Position
UpdateDivider = 5
Substitute="":"N/A"

[MeasurePlayPausewebnow]
Measure=Plugin
Plugin=WebNowPlaying
PlayerType=State
Substitute="0":"Play","1":"Pause","2":"Play","3":"Replay"


[MeasureCoverwebnow]
Measure=Plugin
Plugin=WebNowPlaying
PlayerType=Cover
DefaultPath=#@#Images/MusicCover/Default.png
CoverPath=#@#Images/MusicCover/Cover.png
