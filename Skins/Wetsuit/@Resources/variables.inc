[Variables]

; ===== CONTROLS

; All skins can be individually refreshed with MMB.

; ColorPicker
; Drag: Select color from wallpaper (does not work with animated wallpapers)
; Context Menu: Edit preset themes, refresh all skins

; Launcher
; Context Menu: Edit shortcuts (Opens shortcuts.inc)

; Music, MusicSmall
; LMB: Play/Pause	Double-click: Next Track
; MMB: Open Player (if WebNowPlaying, opens Spotify)
; Context Menu: Switch plugins (NowPlaying.dll / WebNowPlaying.dll)

; PictureFrame
; LMB: Random Image
; Context Menu: Open image folder, set as desktop background

; RecycleBin
; LMB: Open Bin		RMB: Empty Bin

; Volume
; Context Menu: Open windows 10 sound settings

; VolumeSmall
; LMB: Next Output	RMB: Previous Output

; Hovering over the bottom-right icon will display a tooltip containing extra/reformatted data.


; ===== VARIABLES

PlayerName=CAD
; Sets the default player for Music/MusicSmall.ini.
; https://docs.rainmeter.net/manual/measures/nowplaying/#playerlist

ClockType=12
; Sets the clock type for Time.ini.
; Options are 12 & 24.

WeekStart=Sunday
; Defines the first day of the week for Date.ini.
; Options are Sunday and Monday.

Drive1=C:
Drive2=D:
Drive3=E:
; The drives used and displayed by HDD.ini.
; By default, HDDSmall.ini will use Drive1.

NetMaxDown=10
NetMaxUp=2
; Sets MaxValue for MeasureDownload and MeasureUpload in Network/NetworkAlt.ini (in megabytes).
; NetworkSmall.ini will use both values added together.

BinMaxSize=100
; Sets MaxValue for MeasureBinSize in RecycleBin.ini. The bar will display as completely filled at N megabytes.

PercentThreshold=95
; The bar percentage at which the top-right square will light up in CPU/GPU/RAM/HDDSmall.ini.

SecondaryLineColor=180,180,180
; Represents GPU/Upload in SystemAlt/NetworkAlt.ini.
; Default is 180,180,180.


; === Variables for PictureFrame.ini

FrameWidth=4
FrameHeight=3
; Width/Height of the image in PictureFrame.ini (determined by IconSize * N + IconSpacing * (N - 1)).

ImageFolder=%USERPROFILE%\Pictures
; The folder used by PictureFrame.ini.
; Default is %USERPROFILE%\Pictures.

IncludeSubfolders=1
; If enabled, PictureFrame.ini will also look through ImageFolder's subfolders for images.

ImageUpdateInterval=-1
; The frequency at which PictureFrame.ini changes images (in minutes).
; Use -1 to disable altogether.


; === Style settings

ActiveColor=195961
PassiveColor=80,80,80
BackgroundColor=0,0,0,220
; Note that the above values can be overwritten by ColorPicker.ini.

IconSize=30
IconSpacing=12
IconCornerRadius=6
BackgroundCornerRadius=12
; Defaults are 30, 12, 6 and 12 (5:2:1:2).
