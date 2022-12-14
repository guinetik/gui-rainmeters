; ARSTechnica
[Variables]
; Title & URL for main site
FeedName="ABC News"
FeedNamePhonetic="A B C"
mainURL=http://abcnews.go.com/

;URL for parsing
URL=http://abcnews.go.com/abcnews/topstories

;;this variable holds regular expression syntax for parsing 1 XML story section. the variable will be used repeatedly to parse several sections
storysect=<item>.*<media:thumbnail url="(.*)".*<title>(.*)</title>.*<link>(.*)</link>.*</item>.*
; CAPTURES:								1-image		2-title				3-link


; Create variables for use as StringIndex locators
; This automatically sets the index on all child measures
; Captures is the total number of captures in #storysect#
Captures=3
; Location of info in relation to #Captures#
; The last item captured is always zero with declining values for each capture until the first capture in #storysect#
TitleIndex=-1
LinkIndex=0
ImageIndex=-2
