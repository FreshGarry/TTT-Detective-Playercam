-- Please ask me if you want to use parts of this code!
-- Variables
local CamFrame = nil
local CamFrameOffen = false
-- CamWindow function
local function CamActive(target)
	-- create window
	CamFrameOffen = true
	CamFrame = vgui.Create( 'DFrame' )
	CamFrame:SetSize( ScrW() /5, ScrH() /5 )
	CamFrame:SetPos( 0, 0 )
	CamFrame:SetTitle( "View of ".. target:GetName() )
	CamFrame:SetDraggable( true )
	CamFrame:SetSizable( true )
	-- Set View
	function CamFrame:Paint( w, h )
	x, y, w, h = CamFrame:GetBounds()
		render.RenderView( {
			origin = target:GetPos() + Vector(0, 0, 100),
			angles = Angle( target:EyeAngles().xaw, target:EyeAngles().yaw, 0 ),
			self.entity:DrawModel() ???
			x = x,
			y = y,
			w = w,
			h = h,
		 } )

	end
	-- check if it is closed
	hook.Add("Think", "Think4TTTDetePlayerCam", function()
		local function Geschlossen()
			CamFrameOffen = false
			net.Start( "CamSchliessenDetePlyCam" )
			net.WriteEntity(LocalPlayer())
			net.SendToServer()
		end
		if CamFrameOffen then
			CamFrame.OnClose = Geschlossen
		end
	end)
end
-- reset every round
hook.Add("TTTPrepareRound", "TTTPrepareRound4TTTPlayerCam", function()
	if CamFrameOffen then
		CamFrame:Remove()
		CamFrameOffen = false
	end
end)
-- Open CamWindow
net.Receive("CamFensterDetePlyCam", function()
	ply = net.ReadEntity()
	CamActive(ply)
end)
-- check if player dies
hook.Add("Think", "Think4TTTDetePlayerCam2", function()
	if CamFrameOffen then
		if (not LocalPlayer():Alive()) or (not ply:Alive()) then
			CamFrame:Remove()
			CamFrameOffen = false
			net.Start( "CamSchliessenDetePlyCam" )
			net.WriteEntity(LocalPlayer())
			net.SendToServer()
		end
	end
end)
