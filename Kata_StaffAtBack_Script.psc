Scriptname Kata_StaffAtBack_Script extends activemagiceffect  

Armor[] Property ArmorTypeLeft  Auto  
Armor[] Property ArmorTypeRight  Auto  
{
ArmorType Arrays:
	0: Aetherial
	1: Destruction
	2: DwemerGem
	3: Falmer
	4: Forsw
	5: Magnus
	6: Miraak
	7: Sanguine
	8: Skull
	9: Staff01
	10: Staff02
	11: Staff03
	12: Staff04
	13: Wabba
	14: Dragon
	15: Dark Staff
}
Armor[] Property ArmorTypeLeft_Slot44  Auto  
Armor[] Property ArmorTypeRight_Slot43  Auto  

WEAPON[] Property StavesArray  Auto  

{
Staves Array
	0: AetherialStaff
	1-9: Falmer Staves
	10-20: Miraak Staves
	21-40: DragonpriestStaff (destruction template)
	41-42: Dwarven Gem Staff
	43-46: Forsworn Staves
	47: Dragonpriest Staff (mainquest)
	48-56: restoration staves (Staff01)
	57-69: Illusion (Staff02)
	70-72: Alteration (Staff03)
	73-86: Conjuration (Staff04)
	87: Magnus
	88: Wabba
	89: Sanguine
	90: SkullOfCorrupt
	91-93: Dark staves
	94: wirlwind
	95: Dwarven
	96: Aetherial breath
}

GlobalVariable Property SlotR Auto
GlobalVariable Property SlotL Auto
GlobalVariable Property DisplayR Auto
GlobalVariable Property DisplayL Auto
GlobalVariable Property DisplayEven Auto

;Spell Property SelfSpell Auto
;Keyword Property SpellFollowerkw Auto

Event OnEffectStart(Actor akCaster, Actor akTarget)
	;Now let's registerTheAnimationEvents

	RegisterEvents(akTarget, "weaponDraw", 0)
	RegisterEvents(akTarget, "weaponSheathe", 0)


	;If !akTarget.HasMagicEffectWithKeyWord(SpellFollowerKw)
	;	Debug.Messagebox("No Me detected")
	;Else
	;	Debug.MessageBox("Me detected dispeling")
	;	akTarget.DispelSpell(SelfSpell)
	;	self.dispel()
	;EndIf
EndEvent

Event OnAnimationEvent(ObjectReference src, string anim)
	;If src == Game.GetPlayer()
	Actor A = src as Actor
		If A.GetEquippedItemType(0) == 8 && A.GetEquippedItemType(1) !=8 && DisplayL.GetValue() == 0 ;LeftHand
			If anim == "weaponDraw"
				UnEquipTheArmor(A, true)
			ElseIf anim == "weaponSheathe"
				EquipTheArmor(A, true)
			EndIf
		ElseIF A.GetEquippedItemType(1) == 8 && A.GetEquippedItemType(0) != 8  && DisplayR.GetValue() == 0 ;RightHand
			If anim == "weaponDraw"
				UnEquipTheArmor(A, False)
			ElseIf anim == "weaponSheathe"
				EquipTheArmor(A, False)
			EndIf
		ElseIF A.GetEquippedItemType(1) == 8 && A.GetEquippedItemType(0) == 8 ;Dual
			If anim == "weaponDraw"
				UnEquipTheArmor(A, true)
				UnEquipTheArmor(A, False)
			ElseIf anim == "weaponSheathe"
				if DisplayL.GetValue() == 0
					EquipTheArmor(A, true)
				endif
				if DisplayR.GetValue() == 0
					EquipTheArmor(A, False)
				endif
			EndIf
		ElseIf  DisplayEven.GetValue()==0  ;NoStavesEquiped
			UnEquipTheArmor(A,True)
			UnEquipTheArmor(A,False)
		EndIF
	;EndIF
EndEvent

Function RegisterEvents(Actor T, String eve, Int c)
	If !RegisterForAnimationEvent(T, eve)
		Debug.Notification("Something went wrong reseting")
		UnregisterForAnimationEvent(T, eve)
		c+=1
		If c<5
			RegisterEvents(T,eve,c)
		Else
			Debug.MessageBox("Error 001: Attempts to reset went wrong")
		EndIF
	Else
	EndIf
EndFunction

Int Function GetTheCorrectArmorStaff(Weapon find, Actor act)
	int k = 0
	If find != none
		while k<= StavesArray.Length+1
			if StavesArray[k] == find
				return k
			elseif k>StavesArray.Length
				return StavesArray.Length+1
			EndIF
			k+=1
		endWhile
	Else
		Debug.MessageBox("Error 002: No staff found")
		return StavesArray.Length+1
	EndIF
EndFunction

Function EquipTheArmor(Actor act, Bool Hand); if hand is true left, if false right
	Weapon find = act.GetEquippedWeapon(hand)
	int Type = GetTheCorrectArmorStaff(find, act)
	int TypeStaf = 0
	
	;Here comes the big if...
	If Type == 0 ;Aetherial
		TypeStaf=0
	ElseIf Type>=1 && Type <=9 ;Falmer
		TypeStaf=3
	ElseIf Type>=10 && Type <=20 ;Miraak
		TypeStaf=6
	ElseIf Type>=21 && Type <=40 ;Destruct
		TypeStaf=1
	ElseIf Type>=41 && Type <=42 ;Dwarven
		TypeStaf=2
	ElseIf Type>=43 && Type <=46 ;Fors
		TypeStaf=4
	ElseIf Type==47 ;Drag
		TypeStaf=14
	ElseIf Type>=48 && Type <=56 ;Staff01
		TypeStaf=9
	ElseIf Type>=57 && Type <=69 ;Staff02
		TypeStaf=10
	ElseIf Type>=70 && Type <=72 ;Staff03
		TypeStaf=11
	ElseIf Type>=73 && Type <=86 ;Staff04
		TypeStaf=12
	ElseIf Type==87 ;Magnus
		TypeStaf=5
	ElseIf Type==88 ;Wavva
		TypeStaf=13
	ElseIf Type==89 ;Sangui
		TypeStaf=7
	ElseIf Type==90 ;Skull
		TypeStaf=8
	ElseIf Type>= 91 && Type <=93 ;Dark Staves
		TypeStaf=15
		Debug.Notification("Type vale: "+type)
	ElseIf Type== 94 ;wirlwind
		TypeStaf=14
	ElseIf Type== 95 ;steam
		TypeStaf=2
	ElseIf Type == 96 ;Aetherial 2
		TypeStaf=0
	ElseIf Type==97 || Type==98 ;Drag
		TypeStaf=14
	Else ;Staff don't found
		Debug.Notification("Staff not found")
		TypeStaf=14
	EndIf
	
	;4 testing pourposes
	;Debug.MessageBox("TypeStaff = "+TypeStaf+" and Type= "+Type)
	
	If Hand
		;Debug.MessageBox("Left hand")
		if SlotL.GetValue() == 0
			act.EquipItem(ArmorTypeLeft[TypeStaf], true, true)
		else
			act.EquipItem(ArmorTypeLeft_Slot44[TypeStaf], true, true)
		endif
	Else
		;Debug.MessageBox("Right Hand")
		if SlotR.GetValue() == 0
			act.EquipItem(ArmorTypeRight[TypeStaf], true, true)
		else
			act.EquipItem(ArmorTypeRight_Slot43[TypeStaf], true, true)
		endif
	EndIf
EndFunction

Function UnEquipTheArmor (Actor act, Bool Hand); if hand is true left, if false right
	If hand
		if SlotL.GetValue() == 0
			RemoveArmor(ArmorTypeLeft, act)
		else
			RemoveArmor(ArmorTypeLeft_Slot44, act)
		endif
	Else
		if SlotR.GetValue() == 0
			RemoveArmor(ArmorTypeRight, act)
		else
			RemoveArmor(ArmorTypeRight_Slot43, act)
		endif
	EndIF
EndFunction

Function RemoveArmor (Armor[] ArmorType, Actor act)
	int k =0
	While k<ArmorType.Length
		IF act.IsEquipped(ArmorType[k])
			act.removeItem(ArmorType[k], 1, true)
		ENDIF
		k+=1
	EndWhile
EndFunction