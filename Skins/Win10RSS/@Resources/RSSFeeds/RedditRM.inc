; Rainmeter Reddit
[Variables]
; Title & URL for main site
FeedName="RM [Reddit]"
FeedNamePhonetic="Rainmeter on Reddit"
mainURL=http://www.reddit.com/r/Rainmeter/

;URL for parsing
URL=https://www.reddit.com/r/Rainmeter/.rss

;;this variable holds regular expression syntax for parsing 1 XML story section. the variable will be used repeatedly to parse several sections
storysect=<entry>.*img src=&quot;(.*)&quot;.*<link href="(.*)".*<title>(.*)</title>.*</entry>.*
; CAPTURES:						1-image					2-link			3-title			

; Create variables for use as StringIndex locators
; This automatically sets the index on all child measures
; Captures is the total number of captures in #storysect#
Captures=3
; Location of info in relation to #Captures#
; The last item captured is always zero with declining values for each capture until the first capture in #storysect#
TitleIndex=0
LinkIndex=-1
ImageIndex=-2
