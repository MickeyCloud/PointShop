


local PANEL = {}

AccessorFunc(PANEL, "InfoHeight", "InfoHeight")

local icon = Material( "icon16/shield.png" )

function PANEL:Init()
	self:SetCamPos(Vector(0, 30, 0))
	self:SetLookAt(Vector(0, 0, 0))
	
	self.Info = ""
	self.InfoHeight = 14
end

function PANEL:SetSkin(id)
	self.Entity:SetSkin(id)
end

function PANEL:SetData(data)
	self.Data = data
	self.Info = data.Name
	self:SetModel(data.Model)
	
	if data.Skin then
		self:SetSkin(data.Skin)
	end
	
	if self.Description then
		self:SetTooltip(data.Description)
	end
	
	self.dir = 200
	if math.random(0, 10) > 5 then self.dir = -self.dir end
	
	if LocalPlayer():PS_CanAfford(self.Data.Cost) then
		self.BarColor = Color(0, 50, 0, 125)
	else
		self.BarColor = Color(50, 0, 0, 125)
	end
	
	local PrevMins, PrevMaxs = self.Entity:GetRenderBounds()
    self:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.75, 0.75, 0.5))
    self:SetLookAt((PrevMaxs + PrevMins) / 2)
end

function PANEL:LayoutEntity(ent)
	if self.Hovered then
		ent:SetAngles(Angle(0, RealTime() * self.dir, 0))
	end
end

function PANEL:PaintOver()
	if self.Data.AdminOnly then
		surface.SetMaterial(icon)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(0, 0, 16, 16)
	end
	
	surface.SetDrawColor(self.BarColor.r, self.BarColor.g, self.BarColor.b, self.BarColor.a)
	surface.DrawRect(0, self:GetTall() - self.InfoHeight, self:GetWide(), self.InfoHeight)
	draw.SimpleText(self.Info, "DefaultSmall", self:GetWide() / 2, self:GetTall() - (self.InfoHeight / 2) - 1, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:OnCursorEntered()
	self.Hovered = true
	if self.Sell then
		self.Info = "Sell: " .. POINTSHOP.Config.SellCost(self.Data.Cost)
	else
		self.Info = "Buy: " .. self.Data.Cost
	end
end

function PANEL:OnCursorExited()
	self.Hovered = false
	self.Info = self.Data.Name
end


function PANEL:Paint()
    local x, y = self:LocalToScreen( 0, 0 )
    local w, h = self:GetSize()
     
    local sl, st, sr, sb = x, y, x + w, y + h
     
    local p = self
    while p:GetParent() do
        p = p:GetParent()
        local pl, pt = p:LocalToScreen( 0, 0 )
        local pr, pb = pl + p:GetWide(), pt + p:GetTall()
        sl = sl < pl and pl or sl
        st = st < pt and pt or st
        sr = sr > pr and pr or sr
        sb = sb > pb and pb or sb
    end
     
    render.SetScissorRect( sl, st, sr, sb, true )
        self.BaseClass.Paint( self )
    render.SetScissorRect( 0, 0, 0, 0, false )
end

vgui.Register("DShopModel", PANEL, "DModelPanel")