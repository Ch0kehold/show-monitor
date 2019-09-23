; ============================================================================ ;
; ============================================================================ ;
;                             TV Show Pre Monitor                              ;
; ============================================================================ ;
; ============================================================================ ;
;                                                                              ;
; Author: Chokehold|                                                           ;
; Script version: 1.2                                                          ;
; mIRC version: 7.56+                                                          ;
;                                                                              ;
; ---------------------------------------------------------------------------- ;

;;;;;;;;;;;;;;;
; OPEN DIALOG ;
;;;;;;;;;;;;;;;

alias showmon {
var %sm.version v1.2 build 190924
  writeini %sm.settingsfile General Version %sm.version  
  set %sm.datadir $scriptdir $+ showmonitor_files
  if ($exists($+(%sm.datadir,\,showmonitor_poster.jpg)) == $false) { 
    sm.poster https://static.tvmaze.com/images/tvm-header-logo.png
    var %noposter 1 
  }
  if (($exists($+(%sm.datadir,\,showmonitor_poster.jpg)) == $true) && ($exists($+(%sm.datadir,\,showmonitor_poster.png)) == $true)) { 
    .remove $qt($+(%sm.datadir,\,showmonitor_poster.png)) 
  }
  if ($exists(%sm.datadir) == $false) {
    echo -a $brkt(text,Preparing for first run...)
    var %runinit $?!="This seems to be the first time you're running this script. $crlf $+ $&
      Do you want to run automatic initialization?"
    if (%runinit == $true) { sm.init }
  }
  else { $iif(%noposter == 1,.timerdialog 1 1 ) dialog -m showmon showmon }
}

menu channel,query,status {
  TV Show Pre Monitor:/showmon
}

alias sm.init {
  set %sm.datadir $scriptdir $+ showmonitor_files
  set %sm.showfile $scriptdir $+ showmonitor_files\showmonitor_shows.ini
  set %sm.settingsfile $scriptdir $+ showmonitor_files\showmonitor_settings.ini
  set %sm.skiplistfile $scriptdir $+ showmonitor_files\showmonitor_skiplist.txt
  set %sm.premonitorfile $scriptdir $+ showmonitor_files\showmonitor_premonitor.ini
  if ($exists(%sm.datadir) == $false) {
    echo -a $brkt(text,Data directory not found $+ $chr(44) creating directory and generating necessary files...)
    mkdir $qt(%sm.datadir)
    echo -a $brkt(text,Create directory: $iif($exists(%sm.datadir) == $true,9OK,5Failed)) 
    write -c %sm.skiplistfile
    echo -a $brkt(text,Generate skiplist file: $iif($exists(%sm.skiplistfile),9OK,5Failed)) 
    writeini %sm.settingsfile Initialize Initialization Success
    echo -a $brkt(text,Generate monitor settings file: $iif($exists(%sm.settingsfile),9OK,5Failed)) 
    writeini %sm.premonitorfile Initialize Initialization Success
    echo -a $brkt(text,Generate prebot monitor file: $iif($exists(%sm.premonitorfile),9OK,5Failed)) 
    writeini %sm.showfile Initialize Initialization Success
    echo -a $brkt(text,Generate show information file: $iif($exists(%sm.showfile),9OK,5Failed)) 
    remini %sm.settingsfile Initialize
    echo -a $brkt(text,Initialize monitor settings file: $iif($file(%sm.settingsfile).size == 0,9OK,5Failed)) 
    remini %sm.premonitorfile Initialize
    echo -a $brkt(text,Initialize prebot monitor file: $iif($file(%sm.premonitorfile).size == 0,9OK,5Failed)) 
    remini %sm.showfile Initialize
    echo -a $brkt(text,Initialize show information settings file: $iif($file(%sm.showfile).size == 0,9OK,5Failed)) 
  }
  echo -a $brkt(text,End of initialization $+ $chr(44) type 9/showmon 14to get started!)
}

;;;;;;;;;;;;;;;;;;;;;;;;;;
; SETTINGS DIALOG PARAMS ;
;;;;;;;;;;;;;;;;;;;;;;;;;;

dialog showmon {
  title [ TV Show Pre Monitor $readini(%sm.settingsfile,General,Version) ]
  size -1 -1 450 147
  option dbu
  tab "TV Show Settings", 23, 0 -1 445 124
  button "Add new...", 6, 122 109 37 12, tab 23
  button "Show", 4, 122 14 37 12, tab 23
  edit "", 5, 234 22 132 10, tab 23 read
  edit "", 7, 234 43 132 10, tab 23
  combo 1, 234 64 48 41, tab 23 sort drop
  text "Source", 9, 234 56 48 8, tab 23
  text "Pre text to match", 10, 234 35 132 8, tab 23
  button "Save", 11, 234 109 133 12, tab 23
  text "Show name", 12, 234 14 132 8, tab 23
  link "PogDesign TV Calendar", 13, 167 111 57 8, tab 23
  link "IMDB info", 15, 294 56 33 8, tab 23
  edit "", 14, 294 64 35 10, tab 23
  link "TVMaze info", 16, 336 56 31 8, tab 23
  text "Status:", 17, 294 75 72 8, tab 23
  list 2, 2 14 116 107, tab 23 sort size
  button "Remove", 3, 122 29 37 12, tab 23
  edit "", 42, 331 64 35 10, tab 23
  icon 44, 371 15 70 105, %sm.posterfile, 0, tab 23 noborder
  text "Next Episode:", 38, 294 82 72 27, tab 23
  button "Filters...", 39, 234 94 49 12, tab 23
  tab "Global Settings", 18
  combo 20, 9 22 58 98, tab 18 sort size
  button "Add", 21, 71 22 37 12, tab 18
  button "Remove", 22, 71 37 37 12, tab 18
  list 48, 282 21 71 48, tab 18 size
  edit "", 25, 155 21 56 10, tab 18
  text "Network", 26, 120 22 34 8, tab 18
  edit "", 29, 155 45 56 10, tab 18
  edit "", 28, 155 33 56 10, tab 18
  text "Pre channel", 27, 120 34 34 8, tab 18
  text "Prebot nick", 30, 120 46 34 8, tab 18
  text "Monitor window name:", 32, 360 21 54 8, tab 18
  edit "", 33, 360 30 71 10, tab 18
  check "Flash on match", 34, 360 42 50 10, tab 18
  check "Play sound on match", 35, 360 54 60 10, tab 18
  check "Balloon on match", 36, 360 66 53 10, tab 18
  button "Get active window", 41, 231 54 49 12, tab 18
  button "Remove", 37, 243 39 37 12, tab 18
  button "Add", 46, 243 24 37 12, tab 18
  text "Example line", 49, 120 77 31 8, tab 18
  text "Result", 51, 120 101 16 8, tab 18
  text "Max:", 52, 332 98 19 8, tab 18
  text "Definition token: $", 54, 277 98 46 8, tab 18
  edit "", 45, 120 85 233 10, tab 18 autohs
  edit "", 55, 320 97 11 10, tab 18 limit 1
  edit "", 56, 120 109 233 10, tab 18 read autohs
  box "Skiplist settings", 19, 3 13 113 110, tab 18
  box "Pre monitor settings", 24, 117 13 238 110, tab 18
  box "Notification settings", 31, 356 13 89 110, tab 18
  button "Save and close", 8, 402 128 44 12
  button "Uninstall script", 43, 3 128 50 12
  text "", 40, 56 125 343 20, center
}

;;;;;;;;;;;
; FILTERS ;
;;;;;;;;;;;

on 1:dialog:showmon:sclick:39:{
  if ($did(showmon,5).text != $null) { dialog -m sm.filters sm.filters }
}

on 1:dialog:sm.filters:init:0:{
  did -h sm.filters 13
  did -o sm.filters 3 1 $did(showmon,5).text
  sm.filters
}

dialog -l sm.filters {
  title "Filters"
  size -1 -1 150 120
  option dbu
  button "Cancel", 1, 42 105 37 12, cancel
  edit "", 3, 2 3 146 10, read center
  button "Save", 2, 3 105 37 12
  edit "", 4, 82 15 14 10
  check "Limit to single season", 5, 4 15 62 10
  text "S", 6, 78 16 4 8
  check "Limit to release group", 7, 4 26 62 10
  edit "", 8, 82 26 59 10
  check "Limit to chosen source", 9, 4 37 65 10
  edit "", 10, 82 37 59 10, read
  check "Limit to single resolution", 11, 4 48 68 10
  combo 12, 82 48 59 50, drop
  edit "", 13, 82 59 59 10
}

on 1:dialog:sm.filters:sclick:2:{
  ;This is the save button
  ;Season filter
  writeini -n %sm.showfile $qt($did(sm.filters,3).text) Filter.Season.Check $did(sm.filters,5).state
  if ($did(sm.filters,4).text == $null) { remini %sm.showfile $qt($did(sm.filters,3).text) Filter.Season.Text }
  else { writeini -n %sm.showfile $qt($did(sm.filters,3).text) Filter.Season.Text $iif($len($did(sm.filters,4).text) == 1,$+(0,$did(sm.filters,4).text),$did(sm.filters,4).text) }
  ;Release group filter
  writeini -n %sm.showfile $qt($did(sm.filters,3).text) Filter.Group.Check $did(sm.filters,7).state
  if ($did(sm.filters,8).text == $null) { remini %sm.showfile $qt($did(sm.filters,3).text) Filter.Group.Text }
  else { writeini -n %sm.showfile $qt($did(sm.filters,3).text) Filter.Group.Text $did(sm.filters,8).text }
  ;Source filter
  writeini -n %sm.showfile $qt($did(sm.filters,3).text) Filter.Source.Check $did(sm.filters,9).state
  ;Resolution filter
  writeini -n %sm.showfile $qt($did(sm.filters,3).text) Filter.Resolution.Check $did(sm.filters,11).state
  writeini -n %sm.showfile $qt($did(sm.filters,3).text) Filter.Resolution.Choice $did(sm.filters,12).sel
  if (($did(sm.filters,12).sel == 5) && ($did(sm.filters,13).text == $null)) { 
    echo $brkt(text,Cannot save custom resolution filter without entering custom value.)
    halt
  }
  elseif (($did(sm.filters,12).sel == 5) && ($did(sm.filters,13).text != $null)) { 
    writeini -n %sm.showfile $qt($did(sm.filters,3).text) Filter.Resolution.Text $did(sm.filters,13).text 
  }
  dialog -x sm.filters
}

on 1:dialog:sm.filters:sclick:1:{
  ;This is the cancel button
  dialog -x sm.filters
}

alias sm.filters {
  ;This alias populates the saved data for the selected show
  var %i 1
  did -a sm.filters 12 SD
  writeini -n %sm.settingsfile FilterResDef %i SD
  inc %i
  did -a sm.filters 12 720p
  writeini -n %sm.settingsfile FilterResDef %i 720p
  inc %i
  did -a sm.filters 12 1080p
  writeini -n %sm.settingsfile FilterResDef %i 1080p
  inc %i
  did -a sm.filters 12 2160p
  writeini -n %sm.settingsfile FilterResDef %i 2160p
  inc %i
  did -a sm.filters 12 Other
  writeini -n %sm.settingsfile FilterResDef %i Other
  inc %i
  did $iif($readini(%sm.showfile,$qt($did(sm.filters,3).text),Filter.Season.Check) == 1,-c,-u) sm.filters 5
  did $iif($readini(%sm.showfile,$qt($did(sm.filters,3).text),Filter.Group.Check) == 1,-c,-u) sm.filters 7
  did $iif($readini(%sm.showfile,$qt($did(sm.filters,3).text),Filter.Source.Check) == 1,-c,-u) sm.filters 9
  did $iif($readini(%sm.showfile,$qt($did(sm.filters,3).text),Filter.Resolution.Check) == 1,-c,-u) sm.filters 11 
  did -c sm.filters 12 $readini(%sm.showfile,$qt($did(sm.filters,3).text),Filter.Resolution.Choice)
  did -o sm.filters 4 1 $readini(%sm.showfile,$qt($did(sm.filters,3).text),Filter.Season.Text)
  did -o sm.filters 8 1 $readini(%sm.showfile,$qt($did(sm.filters,3).text),Filter.Group.Text)
  did -o sm.filters 10 1 $readini(%sm.settingsfile,SourceDef,$readini(%sm.showfile,$qt($did(sm.filters,3).text),ShowSource))
  if ($did(sm.filters,12).sel == 5) { 
    did -o sm.filters 13 1 $readini(%sm.showfile,$qt($did(sm.filters,3).text),Filter.Resolution.Text) 
    did -v sm.filters 13
  }
}

on 1:dialog:sm.filters:sclick:12:{
  if ($did(sm.filters,12).sel == 5) { 
    did -v sm.filters 13 
  }
  if ($did(sm.filters,12).sel != 5) { 
    did -h sm.filters 13 
  }
}

;;;;;;;;;;;;;;;;;;;
; MONITOR REFRESH ;
;;;;;;;;;;;;;;;;;;;

alias sm.refresh {
  ;Clear everything first
  did -r showmon 2,1,20,14,42,5,7,48,25,28,29,45,55,48
  did -u showmon 2,20
  did -h showmon 44,38
  ;Populate shows list
  var %i 1
  while (%i <= $ini(%sm.showfile, 0)) {
    did -a showmon 2 $ini(%sm.showfile, %i)
    inc %i
  }
  ;Populate skiplist
  var %i2 1
  while (%i2 <= $lines(%sm.skiplistfile)) {
    did -a showmon 20 $read(%sm.skiplistfile,%i2)
    inc %i2
  }
  ;Populate source dropdown list
  var %sourcedef 1
  did -a showmon 1 Any
  writeini -n %sm.settingsfile SourceDef %sourcedef Any
  inc %sourcedef
  did -a showmon 1 BDRip
  writeini -n %sm.settingsfile SourceDef %sourcedef BDRip
  inc %sourcedef
  did -a showmon 1 Bluray
  writeini -n %sm.settingsfile SourceDef %sourcedef Bluray
  inc %sourcedef
  did -a showmon 1 HDTV
  writeini -n %sm.settingsfile SourceDef %sourcedef HDTV
  inc %sourcedef
  did -a showmon 1 Web
  writeini -n %sm.settingsfile SourceDef %sourcedef Web
  inc %sourcedef
  did -o showmon 17 1 Status: 
  ;Check the notification checkboxes
  did $iif($readini(%sm.settingsfile,Notification,Flash) == 1,-c,-u) showmon 34
  did $iif($readini(%sm.settingsfile,Notification,Sound) == 1,-c,-u) showmon 35
  did $iif($readini(%sm.settingsfile,Notification,Balloon) == 1,-c,-u) showmon 36
  ;Populate notification window name
  did -o showmon 33 1 $readini(%sm.settingsfile,Notification,Window)
  ;Populate monitored prebots
  var %i3 1
  while (%i3 <= $ini(%sm.premonitorfile, 0)) {
    did -a showmon 48 $ini(%sm.premonitorfile, %i3)
    inc %i3
  }
  sm.parser
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; POPULATE INFORMATION ON DIALOG OPEN ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on 1:dialog:showmon:init:*:{
  set %sm.showfile $scriptdir $+ showmonitor_files\showmonitor_shows.ini
  set %sm.settingsfile $scriptdir $+ showmonitor_files\showmonitor_settings.ini
  set %sm.premonitorfile $scriptdir $+ showmonitor_files\showmonitor_premonitor.ini
  set %sm.skiplistfile $scriptdir $+ showmonitor_files\showmonitor_skiplist.txt
  sm.refresh
  did -h showmon 38
}

;;;;;;;;;;;;;;;;;;
; PARSER UPDATER ;
;;;;;;;;;;;;;;;;;;

on 1:dialog:showmon:edit:45,55:{ sm.parser }

alias sm.parser {
  did -o showmon 56 1 $gettok($$did(showmon,45).text,$$did(showmon,55).text,32) for Example.Show.Pre.S01E01.720p.HDTV.x264-iND
  did -ra showmon 52 Max: $numtok($did(showmon,45).text,32)
}

;;;;;;;;;;;;;;;;;;;;;;;
;      SHOW ITEMS     ;
;;;;;;;;;;;;;;;;;;;;;;;

alias showmonshow {
  did -h showmon 38
  did -o showmon 5 1 $did(showmon,2).seltext
  var %showsection $ini(%sm.showfile,$did(showmon,2).seltext)
  did -o showmon 7 1 $readini(%sm.showfile,n,$ini(%sm.showfile,%showsection),ShowPre)
  did -c showmon 1 $readini(%sm.showfile,n,$ini(%sm.showfile,%showsection),ShowSource)
  if ($readini(%sm.showfile,n,$ini(%sm.showfile,%showsection),ShowIMDB) != Blank) { did -o showmon 14 1 $readini(%sm.showfile,n,$ini(%sm.showfile,%showsection),ShowIMDB) }
  did -o showmon 42 1 $readini(%sm.showfile,n,$ini(%sm.showfile,%showsection),ShowMaze)
  showmontvmaze
}

alias showmonpres {
  var %showprebot $ini(%sm.premonitorfile,$did(showmon,48).seltext)
  did -o showmon 45 1 $readini(%sm.premonitorfile,n,$ini(%sm.premonitorfile,%showprebot),Example)
  did -o showmon 55 1 $readini(%sm.premonitorfile,n,$ini(%sm.premonitorfile,%showprebot),Token)
  did -o showmon 25 1 $readini(%sm.premonitorfile,n,$ini(%sm.premonitorfile,%showprebot),Network)
  did -o showmon 28 1 $readini(%sm.premonitorfile,n,$ini(%sm.premonitorfile,%showprebot),Channel)
  did -o showmon 29 1 $readini(%sm.premonitorfile,n,$ini(%sm.premonitorfile,%showprebot),Nick)
  sm.parser
}

on 1:dialog:showmon:sclick:4:{
  showmonshow
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DOUBLE CLICK LIST ITEMS ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

on 1:dialog:showmon:dclick:2,48:{
  if ($did == 2) { showmonshow }
  if ($did == 48) { showmonpres }
}

;;;;;;;;;;;;;;;;;;;;;;;;;
;     REMOVE BUTTONS    ;
;;;;;;;;;;;;;;;;;;;;;;;;;

on 1:dialog:showmon:sclick:3:{
  if ($did == 3) {
    remini %sm.showfile " $+ $did(showmon,2).seltext $+ "
    did -r showmon 2,5,7,1
    sm.refresh
  }
  if ($did == 37) {
    remini %sm.premonitorfile $qt($did(showmon,48).seltext)
    sm.refresh
  }
}

;;;;;;;;;;;;;;;;;;
; ADD NEW BUTTON ;
;;;;;;;;;;;;;;;;;;

on 1:dialog:showmon:sclick:6:{
  var %newshow $qt($?="Name of the TV show you want to monitor?")
  if (%newshow == $null) { 
    goto cancel 
  }
  writeini -n %sm.showfile %newshow ShowPre $replace(%newshow,$chr(32),$chr(46))
  writeini -n %sm.showfile %newshow ShowSource 1
  var %secretcolor $rands(16,87)
  writeini -n %sm.showfile %newshow SecretColor %secretcolor
  :cancel
  sm.refresh
  if (%newshow != $null) {
    var %i 1
    while (%i <= $did(showmon,2).lines) {
      if ($did(showmon,2,%i) == $noqt(%newshow)) {
        did -c showmon 2 %i
        did -o showmon 5 1 $did(showmon,2).seltext
        var %showsection $ini(%sm.showfile,$did(showmon,2).seltext)
        did -o showmon 7 1 $readini(%sm.showfile,n,$ini(%sm.showfile,%showsection),ShowPre)
        did -c showmon 1 $readini(%sm.showfile,n,$ini(%sm.showfile,%showsection),ShowSource)
      }
      inc %i
    }
  }
}

;;;;;;;;;;;;;;;;;;;;;;;
;;;;; SAVE BUTTON ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;

on 1:dialog:showmon:sclick:11:{
  writeini -n %sm.showfile " $+ $did(showmon,5).text $+ " ShowPre $did(showmon,7).text
  writeini -n %sm.showfile " $+ $did(showmon,5).text $+ " ShowSource $did(showmon,1).sel
  writeini -n %sm.showfile " $+ $did(showmon,5).text $+ " ShowIMDB $iif($did(showmon,14).text == $null,Blank,$did(showmon,14).text)
  writeini -n %sm.showfile " $+ $did(showmon,5).text $+ " ShowMaze $did(showmon,42).text
  sm.refresh
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;         ADD BUTTONS         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias makeprechan {
  unset %sm.prechan
  var %i 1
  while (%i <= $ini(%sm.premonitorfile,0)) {
    if ($ini(%sm.premonitorfile,0) == 1) { 
      set %sm.prechan $readini(%sm.premonitorfile,$ini(%sm.premonitorfile,%i),Channel) 
    }
    if ($ini(%sm.premonitorfile,0) > 1) { 
      if ($readini(%sm.premonitorfile,$ini(%sm.premonitorfile,%i),Channel) !isin %sm.prechan) {
        set %sm.prechan $+(%sm.prechan,$chr(44),$readini(%sm.premonitorfile,$ini(%sm.premonitorfile,%i),Channel))
      }
    }
    inc %i
  }
  if ($left(%sm.prechan,1) == $chr(44)) { set %sm.prechan $right(%sm.prechan,-1) }
}

on 1:dialog:showmon:sclick:21,46:{
  if ($did == 21) {
    var %i 1
    while (%i <= $lines(%sm.skiplistfile)) {
      if ($did(showmon,20,0).text isin $read(%sm.skiplistfile,%i)) {
        goto exists
      }
      inc %i
    }
    write -a %sm.skiplistfile $did(showmon,20,0).text
    did -r showmon 20 0
    sm.refresh
    :exists
  }
  if ($did == 46) {
    ;Let's combine some things in a var to make the list look like it should
    var %addpre $+($did(showmon,25).text,$chr(46),$did(showmon,28).text) $+($chr(47),$chr(47)) $did(showmon,29).text
    ;Write inifile
    writeini -n %sm.premonitorfile $qt(%addpre) Network $did(showmon,25).text
    writeini -n %sm.premonitorfile $qt(%addpre) Channel $did(showmon,28).text
    writeini -n %sm.premonitorfile $qt(%addpre) Nick $did(showmon,29).text
    writeini -n %sm.premonitorfile $qt(%addpre) Example $qt($did(showmon,45).text)
    ;if ($did(showmon,47).text != $null) { writeini -n %sm.premonitorfile $qt(%addpre) Delimiter $iif($did(showmon,47).text == $chr(32),32,$asc($did(showmon,47).text)) }
    if ($did(showmon,55).text isnum) { writeini -n %sm.premonitorfile $qt(%addpre) Token $did(showmon,55).text }
    makeprechan
    sm.refresh
  }
}

;;;;;;;;;;;;;;;;;;
; REMOVE BUTTONS ;
;;;;;;;;;;;;;;;;;;

on 1:dialog:showmon:sclick:22,37:{
  if ($did == 22) {
    write -ds $+ $did(showmon,20).seltext %sm.skiplistfile
    sm.refresh
  }
  if ($did == 37) {
    if ($did(showmon,48).seltext == $null) { halt }
    remini %sm.premonitorfile $qt($did(showmon,48).seltext)
    makeprechan
    sm.refresh
  }
}

;;;;;;;;;;;;;;;;
; CLOSE BUTTON ;
;;;;;;;;;;;;;;;;

on 1:dialog:showmon:sclick:8:{
  ;Save prebot settings
  if ($did(showmon,33).text != $null) { writeini -n %sm.settingsfile Notification Window $replace($did(showmon,33).text,$chr(32),$chr(46)) }
  if ($did(showmon,33).text == $null) { remini %sm.settingsfile Notification Window }
  writeini -n %sm.settingsfile Notification Flash $did(showmon,34).state
  writeini -n %sm.settingsfile Notification Sound $did(showmon,35).state
  writeini -n %sm.settingsfile Notification Balloon $did(showmon,36).state
  ;set %sm.prechan $readini(%sm.settingsfile,Pre,PreChan)
  var %closeerror 0
  if ($readini(%sm.settingsfile,Notification,Window) == $null) {
    echo -a 40,88[94,88 Show Monitor 40,88]60,88-40,88[11,1 Warning 40,88]60,88-40,88[94,88 Monitor window name field is empty 40,88]
    inc %closeerror
  }
  if (%closeerror >= 1) {
    set %sm.closeerror %closeerror
    if ($?!="There are %sm.closeerror unhandled errors or warnings. $crlf $crlf $+ $&
      Close dialog anyway?" == $true) {
      dialog -x showmon
    }
    goto cancelclose
  }
  if (%closeerror == 0) { set %sm.closeerror %closeerror }
  dialog -x showmon
  :cancelclose
}

;;;;;;;;;;;;
; ON CLOSE ;
;;;;;;;;;;;;

on 1:dialog:showmon:close:*:{
  if (%sm.closeerror >= 1) {
    echo -a 40,88[94,88 Show Monitor 40,88]60,88-40,88[94,88 Exited settings with %sm.closeerror unhandled errors or warnings. 40,88]
  }
  if (%sm.closeerror = 0) { unset %sm.closeerror }
  unset %sm.did
}

;;;;;;;;;;;;;;
; HELP TEXTS ;
;;;;;;;;;;;;;;
on 1:dialog:showmon:mouse:*:{
  if ($did == %sm.did) { halt }
  else { 

    if (($did == 19) || ($did == 24) || ($did == 31) || ($did == 0)) { did -r showmon 40 }

    if ($did == 43) { did -ra showmon 40 $&
        Uninstall script button $crlf $+ $&
        Uninstalls the entire script, removes all settings files and unloads the script file from your mIRC installation. $crlf $+ $&
        Caution: Cannot be undone once confirmed. Only the original script file will remain after an uninstallation.
    }
    if ($did == 8) { did -ra showmon 40 $&
        Save and Close button $crlf $+ $&
        Saves the current configurations and closes the dialog window. 
    }
    if ($did == 13) { did -ra showmon 40 $&
        PogDesign TV Calendar $crlf $+ $&
        Opens a new tab in your browser with a TV show calendar.
    }
    if ($did == 17) { did -ra showmon 40 $&
        Status $crlf $+ $&
        Displays the current status of the selected TV show.
    }
    if (($did == 16) || ($did == 42)) { did -ra showmon 40 $&
        TVMaze info $crlf $+ $&
        The text field will fill in automatically with the TVMaze ID if empty. $crlf $+ $&
        The link will open a new tab in your browser with the show page on TVMaze based on the ID in the text field.
    }
    if (($did == 14) || ($did == 15)) { did -ra showmon 40 $&
        IMDB info $crlf $+ $&
        The text field will fill in automatically with the IMDB tt-ID if empty. $crlf $+ $&
        The link will open a new tab in your browser with the show page on IMDB based on the tt-ID in the text field.
    }
    if (($did == 9) || ($did == 1)) { did -ra showmon 40 $&
        Source $crlf $+ $&
        Choose your preferred source for the TV show. $crlf $+ $&
        Matching the preferred source will add full match indicator in the notification window.
    }
    if (($did == 10) || ($did == 7)) { did -ra showmon 40 $&
        Pre text to match $crlf $+ $&
        Enter the the show name as it is written when pre'd. $crlf $+ $&
        This is the most vital parameter that will decide whether or not the monitor will catch releases for the show.
    }
    if (($did == 12) || ($did == 5)) { did -ra showmon 40 $&
        Show name $crlf $+ $&
        Displays the name of the show you are currently editing the parameters for.
    }
    if ($did == 3) { did -ra showmon 40 $&
        Remove button $crlf $+ $&
        Removes the highlighted TV show monitoring. $crlf $+ $&
        Cannot be undone, if mistakenly pressed you will have to enter the TV show to monitor again.
    }
    if ($did == 4) { did -ra showmon 40 $&
        Show button $crlf $+ $&
        Displays the parameters for the highlighted TV show.
    }
    if ($did == 6) { did -ra showmon 40 $&
        Add New button $crlf $+ $&
        Adds a new TV show to be monitored. $crlf $+ $&
        Automatically enters a presumed pre text to match.
    }
    if ($did == 11) { did -ra showmon 40 $&
        Save button $crlf $+ $&
        Saves the parameters for the currently viewed TV show.
    }
    if ($did == 2) { did -ra showmon 40 $&
        List of monitored TV shows $crlf $+ $&
        Lists all of the currently monitored TV shows. $crlf $+ $&
        To display the TV show parameters, highlight an entry and click Show button or double-click the entry in the list.
    }
    if ($did == 44) { did -ra showmon 40 $&
        TV Show Poster $crlf $+ $&
        Shows the poster for the currently viewed TV show. $crlf $+ $&
        Updates automatically when displaying a monitored TV show.
    }
    if ($did == 22) { did -ra showmon 40 $&
        Skiplist Remove button $crlf $+ $&
        Removes the highlighted skiplist keyword from the skiplist. $crlf $+ $&
        Cannot be undone, if mistakenly pressed you will have to add the keyword again.
    }
    if ($did == 21) { did -ra showmon 40 $&
        Skiplist Add button $crlf $+ $&
        Adds entered value to the skiplist. $crlf $+ $&
        Suggested entries: dubbed, subbed, and any language you may not want to get release notifications of.
    }
    if ($did == 20) { did -ra showmon 40 $&
        Skiplist $crlf $+ $&
        Lists all saved keywords that if present in the pre release name will not appear in the monitor window. $crlf $+ $&
        Intended to sort out particular releases that may not be of interest to the user.
    }
    if ($did == 37) { did -ra showmon 40 $&
        Pre monitor Remove button $crlf $+ $&
        Removes the highlighted pre monitor line so it will no longer be monitored. $crlf $+ $&
        Cannot be undone, if mistakenly pressed you will have to add the monitor again.
    }
    if ($did == 46) { did -ra showmon 40 $&
        Pre monitor Add button $crlf $+ $&
        Adds the current fields to a new prebot to monitor with all entered parameters. $crlf $+ $&
        Fill in all the available text fields or the monitor will not work.
    }
    if ($did == 41) { did -ra showmon 40 $&
        Get active window $crlf $+ $&
        This button fills in the active channel and network parameters needed for the pre monitor. $crlf $+ $&
        Make sure the correct channel is active behind this window when clicking button.
    }
    if ($did == 48) { did -ra showmon 40 $&
        Pre monitor list $crlf $+ $&
        This box shows a list of the prebots you have chosen to monitor. $crlf $+ $&
        Double-click an item in the list to review its properties.
    }
    if (($did == 25) || ($did == 26)) { did -ra showmon 40 $&
        Network $crlf $+ $&
        Enter the network of the prebot you want to monitor. You can find out the network with //echo -a $+($,network,.) $crlf $+ $&
        Must be exact match. This field can be filled out automatically with the $+($did(showmon,41).text,-,button) below.
    }
    if (($did == 27) || ($did == 28)) { did -ra showmon 40 $&
        Pre channel $crlf $+ $&
        Enter the channel of the prebot you want to monitor. $crlf $+ $&
        Must be entered with a leading hash sign, e.g. #channel for it to work. Can be filled out with the $+($did(showmon,41).text,-,button) below.
    }
    if (($did == 29) || ($did == 30)) { did -ra showmon 40 $&
        Prebot nick $crlf $+ $&
        Enter the nick of the prebot want to monitor. $crlf $+ $&
        If there are several prebots in the same channel, make a separate monitor for them respectively.
    }
    if (($did == 49) || ($did == 45)) { did -ra showmon 40 $& 
        Example line $crlf $+ $&
        Fill out an example pre line to help determine the definition token below. $crlf $+ $&
        Enter the example pre without timestamp or nick, only enter the pre message itself.
    }
    if (($did == 54) || ($did == 55)) { did -ra showmon 40 $&
        Definition token $crlf $+ $&
        Enter the space-delimited token where the pre message says "pre" or "nuke" or "unnuke" etc. $crlf $+ $&
        Requires the example pre field to be filled in properly.
    }
    if (($did == 51) || ($did == 56)) { did -ra showmon 40 $&
        Result line $crlf $+ $&
        The result of the example pre and token fields are displayed here to assist with identifying the correct definition token. $crlf $+ $&
        Desired result: "Pre (any formatting is fine) for Example.Show.Pre.S01E01.720p.HDTV.x264-iND"
    }
    if (($did == 32) || ($did == 33)) { did -ra showmon 40 $&
        Monitor window name $crlf $+ $&
        Enter the desired name for the window where monitor matches will be outputted. $crlf $+ $&
        Spaces are not allowed in such names and will be replaced with periods.
    }
    if ($did == 34) { did -ra showmon 40 $&
        Flash on match $crlf $+ $&
        Flash the mIRC window in the Windows taskbar when there is a match. $crlf $+ $&
        Flashes indefinitely until notification is checked.
    }
    if ($did == 35) { did -ra showmon 40 $&
        Play sound on match $crlf $+ $&
        Play a notification sound when there is a match. Sound is played until notification is checked. $crlf $+ $&
        Requires mIRC sounds (Options > Sounds) to be enabled and set up.
    }
    if ($did == 36) { did -ra showmon 40 $&
        Balloon on match $crlf $+ $&
        Displays a notification balloon when there is a match. $crlf $+ $&
        Balloon is displayed for 5 seconds.
    }
    if ($did == 39) { did -ra showmon 40 $&
        Filters $crlf $+ $&
        Choose additional filters for the selected TV show. $crlf $+ $&
        Filter on season, resolution, release group, exclusive source, etc.
    }
    set %sm.did $did
  }
}

;;;;;;;;;;;;;;;;;;;;;
; GET ACTIVE BUTTON ;
;;;;;;;;;;;;;;;;;;;;;
on 1:dialog:showmon:sclick:41:{
  did -o showmon 25 1 $scid($activecid).network
  did -o showmon 28 1 $scid($activecid).active
}

;;;;;;;;;;;;;;;;;;;;
; UNINSTALL BUTTON ;
;;;;;;;;;;;;;;;;;;;;
on 1:dialog:showmon:sclick:43:{
  if ($?!="Are you sure you want to uninstall the script? $crlf $crlf $+ $&
    Doing this will perform the following: $crlf $+ $&
    * Remove your settings file $crlf $+ $&
    * Remove your skiplist settings $crlf $+ $&
    * Remove your monitored TV shows $crlf $+ $&
    * Remove the entire showmonitor_files directory $crlf $+ $&
    * Unload the script file from mIRC $crlf $+ $& 
    * Unset all variables the script utilizes" == $true) {
    var %sm.remove $findfile(%sm.datadir,*,0,remove $qt($1-))
    rmdir $qt(%sm.datadir)
    dialog -x showmon
    unset %sm.*
    unload -rs $script
  }
}

;;;;;;;;;;;;;;;;;
;;;;; LINKS ;;;;;
;;;;;;;;;;;;;;;;;
; Pogdesign link
on 1:dialog:showmon:sclick:13:{
  url -an https://www.pogdesign.co.uk/cat
}

;IMDB link
on 1:dialog:showmon:sclick:15:{
  url -an https://www.imdb.com/ $+ $iif($did(showmon,14).text != $null,$+(title/,$did(showmon,14).text))
}

;TVMaze link
on 1:dialog:showmon:sclick:16:{
  url -an https://www.tvmaze.com/shows/ $+ $readini(%sm.showfile, " $+ $did(showmon,5).text $+ " ,ShowMaze)
}

;;;;;;;;;;;;;;;;;;;;;;
; TVMAZE INFORMATION ;
;;;;;;;;;;;;;;;;;;;;;;


alias showmontvmaze {
  if ($did(showmon,42).text == $null) {
    var %sm.mazeshow $replace($did(showmon,5).text,$chr(32),$chr(43))
    var %sm.fulllink http://api.tvmaze.com/singlesearch/shows?q= $+ %sm.mazeshow
  }
  if (($did(showmon,42).text != $null) && ($did(showmon,42).text isnum)) {
    var %sm.mazeid $did(showmon,42).text
    var %sm.fulllink http://api.tvmaze.com/shows/ $+ %sm.mazeid
  }
  var %tempget $urlget(%sm.fulllink,gf,$+(%sm.datadir,\,showmonitor_tvmaze.txt),sm.tvmazeparse)
}  

alias sm.tvmazeparse {
  var %id $1
  var %sm.tvmazeout $read($urlget(%id).target,1)
  ;TV Show Status
  var %tvmazestatus = $left($right(%sm.tvmazeout, $+(-,$calc($pos(%sm.tvmazeout,status,1)+8))),$calc($pos($right(%sm.tvmazeout, $+(-,$calc($pos(%sm.tvmazeout,status,1)+8))),",1)-1))
  did -o showmon 17 1 Status: %tvmazestatus
  ;If IMDB field is empty, fill it and write to ini file
  if ($did(showmon, 14).text == $null) {
    set %sm.imdb $left($right(%sm.tvmazeout, $+(-,$calc($pos(%sm.tvmazeout,"imdb":,1)+7))),9)
    if ($left(%sm.imdb,3) != ull) {
      did -o showmon 14 1 $left($right(%sm.tvmazeout, $+(-,$calc($pos(%sm.tvmazeout,"imdb":,1)+7))),9)
      writeini -n %sm.showfile " $+ $did(showmon,5).text $+ " ShowIMDB $left($right(%sm.tvmazeout, $+(-,$calc($pos(%sm.tvmazeout,"imdb":,1)+7))),9)
    }
  }
  ;If TVMaze field is empty, fill it and write to ini file
  if ($did(showmon, 42).text == $null) {
    writeini -n %sm.showfile " $+ $did(showmon,5).text $+ " ShowMaze $left($right(%sm.tvmazeout,-6),$calc($pos($right(%sm.tvmazeout,-6),$chr(44),1)-1))
    did -o showmon 42 1 $left($right(%sm.tvmazeout,-6),$calc($pos($right(%sm.tvmazeout,-6),$chr(44),1)-1))
  }
  ;Fetch next episode information, if available
  if (nextepisode isin %sm.tvmazeout) {
    var %sm.nextep $left($right(%sm.tvmazeout, $+(-,$calc($pos(%sm.tvmazeout,nextepisode,1)+21))),$calc($pos($right(%sm.tvmazeout, $+(-,$calc($pos(%sm.tvmazeout,nextepisode,1)+21))),",1)-1))
    var %sm.nextepget $urlget(%sm.nextep,gf,$+(%sm.datadir,\,showmonitor_nextep.txt),sm.nextep)
  }
  ;Set poster URL in vars and to ini file
  set %sm.mazeposter $left($right(%sm.tvmazeout,- $+ $calc($pos(%sm.tvmazeout,"original":,1)+11)),$calc($pos($right(%sm.tvmazeout,- $+ $calc($pos(%sm.tvmazeout,"original":,1)+11)),$chr(34),1)-1))
  writeini -n %sm.showfile " $+ $did(showmon,5).text $+ " ShowPoster [ %sm.mazeposter ]
  ;Do the poster things 
  sm.poster %sm.mazeposter
  .timerunset 1 3 unset %sm.*maze*
  .timerremove 1 3 .remove $urlget(%id).target
}

alias sm.nextep {
  var %sm.nextep.id $1
  var %sm.nextep.out $read($urlget(%sm.nextep.id).target,1)
  var %sm.nextep.date $left($right(%sm.nextep.out, $+(-,$calc($pos(%sm.nextep.out,airdate,1)+9))),$calc($pos($right(%sm.nextep.out, $+(-,$calc($pos(%sm.nextep.out,airdate,1)+9))),",1)-1))
  var %sm.nextep.time $left($right(%sm.nextep.out, $+(-,$calc($pos(%sm.nextep.out,airtime,1)+9))),$calc($pos($right(%sm.nextep.out, $+(-,$calc($pos(%sm.nextep.out,airtime,1)+9))),",1)-1))
  var %sm.nextep.season $left($right(%sm.nextep.out, $+(-,$calc($pos(%sm.nextep.out,season,1)+7))),$calc($pos($right(%sm.nextep.out, $+(-,$calc($pos(%sm.nextep.out,season,1)+8))),",1)-1))
  var %sm.nextep.season S $+ $iif($len(%sm.nextep.season) == 1,0 $+ %sm.nextep.season,%sm.nextep.season)
  var %sm.nextep.epno $left($right(%sm.nextep.out, $+(-,$calc($pos(%sm.nextep.out,number,1)+7))),$calc($pos($right(%sm.nextep.out, $+(-,$calc($pos(%sm.nextep.out,number,1)+8))),",1)-1))
  var %sm.nextep.epno E $+ $iif($len(%sm.nextep.epno) == 1,0 $+ %sm.nextep.epno,%sm.nextep.epno)
  var %sm.nextep.name $left($right(%sm.nextep.out, $+(-,$calc($pos(%sm.nextep.out,name,1)+6))),$calc($pos($right(%sm.nextep.out, $+(-,$calc($pos(%sm.nextep.out,name,1)+6))),",1)-1))
  did -ra showmon 38 Next episode: %sm.nextep.season $+ %sm.nextep.epno $crlf $+ $&
    %sm.nextep.name $crlf $+ $& 
    %sm.nextep.date %sm.nextep.time $iif(%sm.nextep.time != $null,EST)
  did -v showmon 38
  .timerremovenext 1 3 .remove $urlget(%sm.nextep.id).target
}

alias sm.poster {
  var %sm.target $+(%sm.datadir,\,$right($1,$+(-,$pos($1,$chr(47),$count($1,$chr(47))))))
  var %sm.ext $right(%sm.target,$+(-,$calc($pos(%sm.target,$chr(46),1)-1)))
  set %sm.posterfile $+(%sm.datadir,\,showmonitor_poster,%sm.ext)
  var %sm.posterget $urlget($1,gf,%sm.posterfile,sm.posterput)
}
alias sm.posterput {
  did -g showmon 44 $qt($urlget($1).target)
  did -v showmon 44
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; MONITORING EVENT ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias sm.notif {
  if (($readini(%sm.settingsfile,Notification,Sound) == 1) || ($readini(%sm.settingsfile,Notification,Flash) == 1)) {
    flash $+(-,$iif($readini(%sm.settingsfile,Notification,Sound) == 1,w),$iif($readini(%sm.settingsfile,Notification,Flash) == 1,r)) %sm.window
  }
  if ($readini(%sm.settingsfile,Notification,Balloon) == 1) {
    var %prebloon $tip(showmonbloonpre,$1 for $ini(%sm.showfile,%i),$wildtok($1-,$+(*,$readini(%sm.showfile,$ini(%sm.showfile,%i),ShowPre),*),1,32))
  }
}

on *:TEXT:*:%sm.prechan:{
  var %chancheck 1
  while %chancheck <= $ini(%sm.premonitorfile,0) { 
    if (($network == $readini(%sm.premonitorfile,$ini(%sm.premonitorfile,%chancheck),Network)) && ($chan == $readini(%sm.premonitorfile,$ini(%sm.premonitorfile,%chancheck),Channel)) && ($nick == $readini(%sm.premonitorfile,$ini(%sm.premonitorfile,%chancheck),Nick))) {
      var %i 1
      while (%i <= $ini(%sm.showfile, 0)) {
        if ($readini(%sm.showfile,$ini(%sm.showfile,%i),ShowPre) isin $1-) {
          var %findpre $wildtok($1-,$+(*,$v1,*),1,32)
          if ($v1 == $left(%findpre,$len($v1))) {
            var %i2 1
            while (%i2 <= $lines(%sm.skiplistfile)) {
              if ($read(%sm.skiplistfile,%i2) isin $1-) {
                goto skip
              }
              inc %i2
            }
            var %sm.window $+(@,$readini(%sm.settingsfile,Notification,Window))
            $iif(!$window(%sm.window),window -es %sm.window)
            set -u5 %sm.wholeline $1- 
            set -u5 %sm.i %i
            if (($readini(%sm.showfile,$ini(%sm.showfile,%i),Filter.Season.Check) == 1) || ($readini(%sm.showfile,$ini(%sm.showfile,%i),Filter.Group.Check) == 1) || ($readini(%sm.showfile,$ini(%sm.showfile,%i),Filter.Source.Check) == 1) || ($readini(%sm.showfile,$ini(%sm.showfile,%i),Filter.Resolution.Check) == 1)) { 
              sm.filtercheck 
              if (%filterfail >= 1) { 
                goto done 
              }
            }
            if (Pre isin $gettok($1-,$readini(%sm.premonitorfile,$ini(%sm.premonitorfile,%chancheck),Token),32)) {
              .timernotify 1 3 aline -hp %sm.window $timestamp $sm.output(Pre,$ini(%sm.showfile,%i))
              sm.notif Pre
              goto done
            }
            if (Modnuke isin $gettok($1-,$readini(%sm.premonitorfile,$ini(%sm.premonitorfile,%chancheck),Token),32)) {
              .timernotify 1 3 aline -hp %sm.window $timestamp $sm.output(Modnuke,$ini(%sm.showfile,%i))
              sm.notif Modnuke
              goto done
            }
            if (Unnuke isin $gettok($1-,$readini(%sm.premonitorfile,$ini(%sm.premonitorfile,%chancheck),Token),32)) {
              .timernotify 1 3 aline -hp %sm.window $timestamp $sm.output(Unnuke,$ini(%sm.showfile,%i))
              sm.notif Unnuke
              goto done
            }
            if (Nuke isin $gettok($1-,$readini(%sm.premonitorfile,$ini(%sm.premonitorfile,%chancheck),Token),32)) {
              .timernotify 1 3 aline -hp %sm.window $timestamp $sm.output(Nuke,$ini(%sm.showfile,%i))
              sm.notif Nuke
              goto done
            }
          }
        }
        inc %i
      }
    }
    :skip
    inc %chancheck
  }
  :done
}

alias sm.filtercheck {
  var %findpre $wildtok(%sm.wholeline,$+(*,$readini(%sm.showfile,$ini(%sm.showfile,%sm.i),ShowPre),*),1,32)
  set -u3 %filterfail 0
  ;season check
  if ($readini(%sm.showfile,$ini(%sm.showfile,%sm.i),Filter.Season.Check) == 1) {
    if ($+(S,$readini(%sm.showfile,$ini(%sm.showfile,%sm.i),Filter.Season.Text)) !isin $mid(%findpre,$len($readini(%sm.showfile,$ini(%sm.showfile,%sm.i),ShowPre)),5)) { 
      inc %filterfail 
    }
  }
  ;group check
  if ($readini(%sm.showfile,$ini(%sm.showfile,%sm.i),Filter.Group.Check) == 1) {
    if ($readini(%sm.showfile,$ini(%sm.showfile,%sm.i),Filter.Group.Text) != $right(%findpre,$len($readini(%sm.showfile,$ini(%sm.showfile,%sm.i),Filter.Group.Text)))) { 
      inc %filterfail
    }
  }
  ;source check
  if ($readini(%sm.showfile,$ini(%sm.showfile,%sm.i),Filter.Source.Check) == 1) {
    if ($readini(%sm.settingsfile,SourceDef,$readini(%sm.showfile,$ini(%sm.showfile,%sm.i),ShowSource)) == Any) { goto next }
    if ($readini(%sm.settingsfile,SourceDef,$readini(%sm.showfile,$ini(%sm.showfile,%sm.i),ShowSource)) !isin $mid(%findpre,$len($readini(%sm.showfile,$ini(%sm.showfile,%sm.i),ShowPre)),$len(%findpre))) {
      inc %filterfail
    }
    :next
  }
  ;resolution check
  if ($readini(%sm.showfile,$ini(%sm.showfile,%sm.i),Filter.Resolution.Check) == 1) {
    var %resCheck $iif($readini(%sm.settingsfile,FilterResDef,$readini(%sm.showfile,$ini(%sm.showfile,%sm.i),Filter.Resolution.Choice)) == Other,$readini(%sm.showfile,$ini(%sm.showfile,%sm.i),Filter.Resolution.Text),$readini(%sm.settingsfile,FilterResDef,$readini(%sm.showfile,$ini(%sm.showfile,%sm.i),Filter.Resolution.Choice)))
    if ($readini(%sm.showfile,$ini(%sm.showfile,%sm.i),Filter.Resolution.Choice) == 1) { 
      if ((0p isin $mid(%findpre,$len($readini(%sm.showfile,$ini(%sm.showfile,%sm.i),ShowPre)),$len(%findpre))) || (UHD isin $mid(%findpre,$len($readini(%sm.showfile,$ini(%sm.showfile,%sm.i),ShowPre)),$len(%findpre)))) {
        inc %filterfail
      }
    }
    if ($readini(%sm.showfile,$ini(%sm.showfile,%sm.i),Filter.Resolution.Choice) >= 2) {
      if ($count($mid(%findpre,$len($readini(%sm.showfile,$ini(%sm.showfile,%sm.i),ShowPre)),$len(%findpre)),%resCheck) < 1) {
        inc %filterfail
      }
    }
  }  
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CUSTOM IDENTIFIER DECLARATIONS ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias brkt {
  if ($1 == text) { return 28,88[94,88 Show Monitor 28,88]60,88-28,88[94,88 $2- 28,88]94,88 }
  if ($1 == logo) { return 28,88[94,88 Show Monitor 28,88]60,88-28,88[94,88 }
  if ($1 == 1) { return 28,88[94,88 }
  if ($1 == x) { return 28,88]60,88-28,88[94,88 }
  if ($1 == 2) { return 28,88]94,88 }
}

alias reason {
  var %findpre $wildtok($1-,$+(*,$readini(%sm.showfile,$ini(%sm.showfile,%sm.i),ShowPre),*),1,32)
  var %findpre $findtok($1-,%findpre,1,32)
  var %i $calc(%findpre + 1)
  while (%i <= $numtok($1-,32)) {
    smecho $gettok($1-,%i,32)
    if (($replace($gettok($1-,%i,32),[,$null,],$null) isalnum) || ($chr(46) isin $replace($gettok($1-,%i,32),[,$null,],$null))) { 
      var %findnuke $replace($gettok($1-,%i,32),[,$null,],$null)
    }
    inc %i
  }
  return %findnuke
}

alias sm.output {
  var %findpre $wildtok(%sm.wholeline,$+(*,$readini(%sm.showfile,$ini(%sm.showfile,%sm.i),ShowPre),*),1,32)
  if ($1 == Pre) { return $+($brkt(1),54,PRE,$brkt(x),,$readini(%sm.showfile,$2,SecretColor),$2,$brkt(x)) %findpre $iif($readini(%sm.settingsfile,SourceDef,$readini(%sm.showfile,$ini(%sm.showfile,%sm.i),ShowSource)) == Any,$brkt(2),$iif($readini(%sm.settingsfile,SourceDef,$readini(%sm.showfile,$ini(%sm.showfile,%sm.i),ShowSource)) isin %findpre,$+($brkt(x),68,Source match,$brkt(2)),$brkt(2))) }
  if ($1 == Nuke) { return $+($brkt(1),52,NUKE,$brkt(x),,$readini(%sm.showfile,$2,SecretColor),$2,$brkt(x)) %findpre $+($brkt(x),$reason(%sm.wholeline),$brkt(2)) }
  if ($1 == Modnuke) { return $+($brkt(1),40,MODNUKE,$brkt(x),,$readini(%sm.showfile,$2,SecretColor),$2,$brkt(x)) %findpre $+($brkt(x),$reason(%sm.wholeline),$brkt(2)) }
  if ($1 == Unnuke) { return $+($brkt(1),56,UNNUKE,$brkt(x),,$readini(%sm.showfile,$2,SecretColor),$2,$brkt(x)) %findpre $+($brkt(x),$reason(%sm.wholeline),$brkt(2)) }
}
