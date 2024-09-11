;
; AutoIt Version: 3.3.14.2
; Language:       English
; Platform:       Win9x/NT
; Author:         Nathan Larsen
; Finalized:      08.18.2018 at 1730
;
; Script Function:
;	Script to map network drives.
;

AutoItSetOption("MustDeclareVars", 1)

; Array that contains drive letters and network share names. The array uses the following format: (drive letter with colon, share name).
; All values need to be separated by commas.
Global $DriveArray = StringSplit("S:,Shared,U:,Nathan", ",")

; Name or IP address of file server. This can be one of the following: fully qualified domain name, hostname or IP address.
Global $ServerName = "family-server"

;********************************************************
; Check if network is available
;********************************************************

; Ping server to see if network is available
While 1
	Ping($ServerName)
	If not @error Then ExitLoop
	Sleep(1000)
WEnd

;********************************************************
; Map network drives
;********************************************************

; Disconnect incorrect drive mappings and map drive letters to the correct network shares
Global $MappedSuccessful = True
For $i = 1 to $DriveArray[0] - 1 Step 2
  If Not ((DriveMapGet($DriveArray[$i])) = ( "\\" & $ServerName & "\" & $DriveArray[$i + 1] )) Then
    If (DriveMapGet($DriveArray[$i])) Then
      DriveMapDel($DriveArray[$i])
    EndIf
    DriveMapAdd( $DriveArray[$i], "\\" & $ServerName & "\" & $DriveArray[$i + 1] , 8 )
    If ( @error <> 0 ) Then
      $MappedSuccessful = False
    EndIf
  EndIf
Next

; Invoke MsgBox to report if drive letters were not successfully mapped to the correct network shares
If Not ( $MappedSuccessful ) Then
  MsgBox(48, "", "All drives did not map successfully.")
  Exit
EndIf
