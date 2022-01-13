class KFItemLocalization extends Object;

struct StructItemLocalization
{
	var name ItemKey;
	var() array<string> ItemName;
	var() array<string> ItemDescription;
};

var Ext_TraitAcidicCompound TraitAcidicCompound;
var Ext_TraitAcidicCompound TraitAutoFire;

var array<StructItemLocalization> ItemLocalization;

function byte GetLanguageIndexByName()
{
	if ( class'Engine'.static.GetEngine().GetLanguage() ~= "ENG" )
	{
		return 0;
	}
	else if ( class'Engine'.static.GetEngine().GetLanguage() ~= "RUS" )
	{
		return 1;
	}
}

function SetItemLocalization()
{
	TraitAcidicCompound.ItemName = ItemLocalization[ItemLocalization.Find( 'ItemKey', TraitAcidicCompound.Class.Name )].ItemName[GetLanguageIndexByName()];
	TraitAcidicCompound.ItemDescription = ItemLocalization[ItemLocalization.Find( 'ItemKey', TraitAcidicCompound.Class.Name )].ItemDescription[GetLanguageIndexByName()];
	
	TraitAutoFire.ItemName = ItemLocalization[ItemLocalization.Find( 'ItemKey', TraitAutoFire.Class.Name )].ItemName[GetLanguageIndexByName()];
	TraitAutoFire.ItemDescription = ItemLocalization[ItemLocalization.Find( 'ItemKey', TraitAutoFire.Class.Name )].ItemDescription[GetLanguageIndexByName()];
}

defaultproperties
{
    ItemLocalization[0]={( ItemKey=Ext_TraitAcidicCompound,
						   ItemName=("Acidic Compound", "Кислотные боеприпасы"),
						   ItemDescription=("When activated medic weapons have a chance to poison zeds.", "Медицинское оружие получает шанс отравить зедов.") )}
						   
    ItemLocalization[1]={( ItemKey=Ext_TraitAutoFire,
						   ItemName=("Auto-Fire weapons", "Авто режим оружия"),
						   ItemDescription=("Make all perked weapons fully automatic.", "Делает все ваше оружие полностью автоматическим.") )}
}
