-- Please ask me if you want to use parts of this code!
-- Add recources
if SERVER then
   AddCSLuaFile( "shared.lua" )
   resource.AddWorkshop("942402787")
end

-- swep settings
SWEP.HoldType              = "pistol"
if CLIENT then
	SWEP.PrintName          = "Dete Playercam"
	SWEP.Slot               = 6

	SWEP.ViewModelFlip      = false
	SWEP.ViewModelFOV       = 54
   
	SWEP.EquipMenuData = {
		type = "item_weapon",
		desc = "1 Shot with autoaim.\nShows the vision of the target wich was shot.\nTarget changeable by closing the window. \nand shooting again (only works if you still carry the \nwepon)."
	};

	SWEP.Icon = "vgui/ttt/icon_dete_playercam.png"
end
game.AddAmmoType( {
	name = "dete_playercam",
	dmgtype = DMG_GENERIC,
	tracer = 0,
	plydmg = 0,
	npcdmg = 0,
	force = 0,
	minsplash = 0,
	maxsplash = 0
} )
SWEP.Base                  = "weapon_tttbase"
SWEP.Kind                  = WEAPON_PISTOL
SWEP.WeaponID              = AMMO_PISTOL
SWEP.Primary.Recoil        = 3
SWEP.Primary.Damage        = 0
SWEP.Primary.Delay         = 1
SWEP.Primary.Cone          = 0.01
SWEP.Primary.ClipSize      = 1
SWEP.Primary.Automatic     = false
SWEP.Primary.DefaultClip   = 1
SWEP.Primary.ClipMax       = 1
SWEP.Primary.Ammo          = "dete_playercam"
SWEP.AmmoEnt               = "none"
SWEP.UseHands              = true
SWEP.ViewModel             = "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_fiveseven.mdl"
SWEP.Kind = WEAPON_EQUIP1
SWEP.CanBuy = {ROLE_DETECTIVE}
SWEP.LimitedStock = true
SWEP.IronSightsPos         = Vector(-5.95, -1, 4.799)
SWEP.IronSightsAng         = Vector(0, 0, 0)

function SWEP:PrimaryAttack()
	if self:Clip1() <= 0 then 
	return 
	end
	local Kugel = {}
	Kugel.Dmgtype = "DMG_GENERIC"
	Kugel.Num = num
	Kugel.Spread = Vector( cone, cone, 0 )
	Kugel.Tracer = 0
	Kugel.Force	= 0
	Kugel.Damage = 0
	Kugel.Src = self.Owner:GetShootPos()
	Kugel.Dir = self.Owner:GetAimVector()
	Kugel.TracerName = "TRACER_NONE"
	Kugel.Callback = function(Schuetze, Ziel)				
		if SERVER and Ziel.Entity:IsPlayer() then
			net.Start( "CamFensterDetePlyCam" )
			print("sending")
			net.WriteEntity(Ziel.Entity)
			net.Send(Schuetze)
			self:TakePrimaryAmmo( 1 )
			
		end
	end
	self.Owner:FireBullets( Kugel )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end
net.Receive("CamSchliessenDetePlyCam", function()
	if SERVER then
		ply = net.ReadEntity()
		ply:GiveAmmo( 1, "dete_playercam", false )
	end
end)
