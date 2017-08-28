Scriptname Kata_StaffAtback_Quest extends Quest  

SPELL Property StaveScript  Auto  
Message Property m01  Auto  
Message Property m02  Auto  
SPELL Property StaveConfigScript  Auto  

;Leveled lists
LeveledItem[] Property ListOfLIts  Auto  
Book[] Property ListBooks  Auto  

LeveledItem Property Resto75  Auto  
Book Property GreatestWard  Auto  


Event OnInit()
	Game.DisablePlayerControls() ;Disable the player to not let him to fuck off the script	
	;Debug.Notification("Stand still, staffsatback is being configured")
	m01.Show()
	Utility.Wait(2)				; wait for the cell to load properly
	StaveScript.Cast(Game.GetPlayer())
	Game.GetPlayer().AddSpell(StaveConfigScript)
	Utility.Wait(0.5)
	
	Resto75.AddForm(GreatestWard, 1, 1)	

	int k = 0
	While k<=ListOfLIts.Length
		int e = 0
		While e<=ListBooks.Length
			ListOfLIts[k].AddForm(ListBooks[e], 1, 1)
			e+=1
		EndWhile
		k+=1
	EndWhile

	Game.EnablePlayerControls()
	m02.Show()
EndEvent