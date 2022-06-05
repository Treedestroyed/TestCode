reliable server final function ModifyAllWeaponsSpareAmmoCapacity( optional bool bWeaponModified = false, optional bool bSaveItem = false )
{
	local int i;
	local float MaxSpareAmmoMod;
	local array<int> DefaultSpareAmmoCapacity;
	local KFMod Mod;	
	local KFWeapon KFW;
	local KFInventoryManager KFIM;
	
	Mod = class'KFMod.KFMod'.static.GetModInstance();
	
	KFIM = KFInventoryManager( InvManager );

	if ( KFIM != None )
	{
		foreach KFIM.InventoryActors( class'KFWeapon', KFW )
		{
			switch ( KFW.GetTraderFilter() )
			{
				case FT_Pistol:
					MaxSpareAmmoMod = Mod.WeaponMaxSpareAmmo.PistolMaxSpareAmmoMod[Clamp( KFGameReplicationInfo( WorldInfo.GRI ).WaveNum - 1, 0, 9 )];
					break;

				case FT_Shotgun:
					MaxSpareAmmoMod = Mod.WeaponMaxSpareAmmo.ShotgunMaxSpareAmmoMod[Clamp( KFGameReplicationInfo( WorldInfo.GRI ).WaveNum - 1, 0, 9 )];
					break;

				case FT_Rifle:
					MaxSpareAmmoMod = Mod.WeaponMaxSpareAmmo.RifleMaxSpareAmmoMod[Clamp( KFGameReplicationInfo( WorldInfo.GRI ).WaveNum - 1, 0, 9 )];
					break;

				case FT_Projectile:
					MaxSpareAmmoMod = Mod.WeaponMaxSpareAmmo.ProjectileMaxSpareAmmoMod[Clamp( KFGameReplicationInfo( WorldInfo.GRI ).WaveNum - 1, 0, 9 )];
					break;

				case FT_Flame:
					MaxSpareAmmoMod = Mod.WeaponMaxSpareAmmo.FlameMaxSpareAmmoMod[Clamp( KFGameReplicationInfo( WorldInfo.GRI ).WaveNum - 1, 0, 9 )];		
					break;

				case FT_Electric:
					MaxSpareAmmoMod = Mod.WeaponMaxSpareAmmo.ElectricMaxSpareAmmoMod[Clamp( KFGameReplicationInfo( WorldInfo.GRI ).WaveNum - 1, 0, 9 )];
					break;

				case FT_Explosive:
					MaxSpareAmmoMod = Mod.WeaponMaxSpareAmmo.ExplosiveMaxSpareAmmoMod[Clamp( KFGameReplicationInfo( WorldInfo.GRI ).WaveNum - 1, 0, 9 )];
					break;

				case FT_Assault:
					MaxSpareAmmoMod = Mod.WeaponMaxSpareAmmo.AssaultMaxSpareAmmoMod[Clamp( KFGameReplicationInfo( WorldInfo.GRI ).WaveNum - 1, 0, 9 )];
					break;

				case FT_SMG:
					MaxSpareAmmoMod = Mod.WeaponMaxSpareAmmo.SMGMaxSpareAmmoMod[Clamp( KFGameReplicationInfo( WorldInfo.GRI ).WaveNum - 1, 0, 9 )];	
					break;						
			}

			if ( Mod.bIsFireteamMode && KFW.UsesAmmo() )	
			{
				DefaultSpareAmmoCapacity[0] = KFW.default.SpareAmmoCapacity[0];
				DefaultSpareAmmoCapacity[1] = KFW.default.SpareAmmoCapacity[1];
				
				KFW.ModifySpareAmmoCapacity( DefaultSpareAmmoCapacity[0], class'KFWeapon'.const.DEFAULT_FIREMODE );
				KFW.ModifySpareAmmoCapacity( DefaultSpareAmmoCapacity[1], class'KFWeapon'.const.ALTFIRE_FIREMODE );	

				if ( KFW.SpareAmmoCapacity[0] != DefaultSpareAmmoCapacity[0] * MaxSpareAmmoMod )	
				{
					KFW.SpareAmmoCapacity[0] = DefaultSpareAmmoCapacity[0] * MaxSpareAmmoMod;
					
					if ( KFW.GetWeaponPerkClass( GetPerk().Class ) == GetPerk().Class && KFW.SpareAmmoCapacity[0] < DefaultSpareAmmoCapacity[0] * MaxSpareAmmoMod )	
						KFW.AddAmmo( 0 );
				}
				
				if ( KFW.UsesSecondaryAmmo() && KFW.SpareAmmoCapacity[1] != DefaultSpareAmmoCapacity[1] * MaxSpareAmmoMod )		
				{
					KFW.SpareAmmoCapacity[1] = DefaultSpareAmmoCapacity[1] * MaxSpareAmmoMod;
					
					if ( KFW.GetWeaponPerkClass( GetPerk().Class ) == GetPerk().Class && KFW.SpareAmmoCapacity[1] < DefaultSpareAmmoCapacity[1] * MaxSpareAmmoMod )	
						KFW.AddSecondaryAmmo( 0 );
				}
				
				if ( bSaveItem )
				{
					WeaponInfo.Length = WeaponInfo.Length + 1;
					WeaponInfo[WeaponInfo.Length - 1].ClassName = KFW.Class.Name;
					WeaponInfo[WeaponInfo.Length - 1].SpareAmmoCount = KFW.SpareAmmoCount[0];
				}
				
				if ( bWeaponModified )
				{	
					for ( i = 0; i < WeaponInfo.Length; ++i )
					{
						if ( KFW.Class.Name == WeaponInfo[i].ClassName )
						{
							KFW.SpareAmmoCount[0] = WeaponInfo[i].SpareAmmoCount;
							KFW.AddAmmo( 0 );
						}
					}
				}
			}
		}
	}
}
