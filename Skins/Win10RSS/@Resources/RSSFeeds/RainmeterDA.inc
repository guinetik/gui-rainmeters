Rainmeter DeviantArt
[Variables]
; Title & URL for main site
FeedName="DA Rainmeter"
FeedNamePhonetic="Deviant Art Latest Rainmeter"
mainURL=https://rainmeter.deviantart.com/gallery/23941137/Skins

;URL for parsing
URL=http://backend.deviantart.com/rss.xml?q=in%3Acustomization%2Fskins%2Fsysmonitor%2Frainmeter+sort%3Atime&type=deviation

;;this variable holds regular expression syntax for parsing 1 XML story section. the variable will be used repeatedly to parse several sections
storysect=<item>.*<title>(.*)</title>.*<link>(.*)</link>.*<media:content url="(.*)".*</item>.*
;					   -2 title			   -1 link			0 image	

; Create variables for use as StringIndex locators
; This automatically sets the index on all child measures
; Captures is the total number of captures in #storysect#
Captures=3
; Location of info in relation to #Captures#
; The last item captured is always zero with declining values for each capture until the first capture in #storysect#
TitleIndex=-2
LinkIndex=-1
ImageIndex=0
