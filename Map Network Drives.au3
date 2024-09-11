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
Global $DriveArray = StringSplit("S:,Shared,U:,User", ",")

; Name or IP address of file server. This can be one of the following: fully qualified domain name, hostname or IP address.
Global $ServerName = "server.domain.com"

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
; Check if network drives are already mapped
;********************************************************

; Check to see if drive letters are already mapped to the correct network shares
Global $AlreadyMapped = 0
For $i = 1 to $DriveArray[0] - 1 Step 2
  If ((DriveMapGet($DriveArray[$i])) = ( "\\" & $ServerName & "\" & $DriveArray[$i + 1] )) Then
    $AlreadyMapped += 1
  EndIf
Next

; If drive letters are already mapped to the correct network shares then invoke MsgBox and exit script
If ($AlreadyMapped = (($DriveArray[0]) / 2)) Then
  MsgBox(64, "", "The drives found are already mapped to the correct network shares.", 3)
  Exit
EndIf

;********************************************************
; Map network drives
;********************************************************

; Map drive letters to the correct network shares
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

; Invoke MsgBox to report if drive letters were successfully mapped to the correct network shares
If ( $MappedSuccessful ) Then
  MsgBox(64, "", "All drives mapped successfully.", 3)
Else
  MsgBox(48, "", "All drives did not map successfully.")
EndIf
