include("shared.lua")

function ENT:Draw()
    self:DrawModel()
end

local craftMenuFrame
local autoRefreshTimerName = "CraftAutoRefreshTimer"

net.Receive("CraftUpdate", function()
    if not IsValid(craftMenuFrame) then return end

    local craftEnt = net.ReadEntity()
    local newStoredItems = net.ReadTable()

    if IsValid(craftEnt) and craftMenuFrame.CraftEnt == craftEnt then
        craftMenuFrame.StoredItems = newStoredItems
        if craftMenuFrame.SelectedRecipeKey then
            craftMenuFrame:UpdateRecipeDetails(craftMenuFrame.SelectedRecipeKey)
        end
    end
end)

net.Receive("CraftMenu", function()
    if IsValid(craftMenuFrame) then return end

    local craftEnt    = net.ReadEntity()
    local storedItems = net.ReadTable()
    if not IsValid(craftEnt) then return end

    local recipes = craftEnt.Recipes or {}

    craftMenuFrame = vgui.Create("DFrame")
    craftMenuFrame:SetSize(600, 400)
    craftMenuFrame:Center()
    craftMenuFrame:SetTitle("")
    craftMenuFrame:SetDraggable(true)
    craftMenuFrame:ShowCloseButton(false)
    craftMenuFrame:SetAlpha(0)
    craftMenuFrame:MakePopup()
    craftMenuFrame:AlphaTo(255, 1, 0)

    craftMenuFrame.CraftEnt = craftEnt
    craftMenuFrame.StoredItems = storedItems
    craftMenuFrame.Recipes = recipes
    craftMenuFrame.SelectedRecipeKey = nil

    craftMenuFrame.OnClose = function(self)
        timer.Remove(autoRefreshTimerName)
    end

    craftMenuFrame.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(40, 40, 40, 230))
        local headerHeight = 35
        draw.RoundedBoxEx(8, 0, 0, w, headerHeight, Color(70, 70, 70, 255), true, true, false, false)
        draw.SimpleText("Crafting Table", "Trebuchet24", 15, headerHeight/2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local closeBtn = vgui.Create("DButton", craftMenuFrame)
    closeBtn:SetText("X")
    closeBtn:SetFont("Trebuchet24")
    closeBtn:SetTextColor(Color(200,200,200))
    closeBtn:SetSize(40, 35)
    closeBtn:SetPos(craftMenuFrame:GetWide()-40, 0)
    closeBtn.DoClick = function() craftMenuFrame:Close() end
    closeBtn.Paint = function(self, w, h)
        if self:IsHovered() then
            draw.RoundedBoxEx(8, 0, 0, w, h, Color(200, 50, 50, 180), false, true, false, false)
        else
            draw.RoundedBoxEx(8, 0, 0, w, h, Color(0,0,0,0), false, true, false, false)
        end
    end

    local contentPanel = vgui.Create("DPanel", craftMenuFrame)
    contentPanel:SetPos(0, 35)
    contentPanel:SetSize(600, 365)
    contentPanel.Paint = function() end

    local recipeList = vgui.Create("DListView", contentPanel)
    recipeList:Dock(LEFT)
    recipeList:SetWidth(180)
    recipeList:AddColumn("Recipes")
    for key, data in pairs(recipes) do
        recipeList:AddLine(data.name or key)
    end

    local detailPanel = vgui.Create("DPanel", contentPanel)
    detailPanel:Dock(FILL)
    detailPanel.Paint = function() end

    local itemTitle = vgui.Create("DLabel", detailPanel)
    itemTitle:Dock(TOP)
    itemTitle:DockMargin(10, 10, 10, 0)
    itemTitle:SetFont("Trebuchet24")
    itemTitle:SetTextColor(Color(255,255,255))
    itemTitle:SetText("")

    local descLabel = vgui.Create("DLabel", detailPanel)
    descLabel:Dock(TOP)
    descLabel:DockMargin(10, 5, 10, 0)
    descLabel:SetFont("Trebuchet18")
    descLabel:SetTextColor(Color(200,200,200))
    descLabel:SetWrap(true)
    descLabel:SetAutoStretchVertical(true)
    descLabel:SetText("")

    local craftProgress = vgui.Create("DProgress", detailPanel)
    craftProgress:Dock(BOTTOM)
    craftProgress:DockMargin(10, 5, 10, 5)
    craftProgress:SetTall(20)
    craftProgress:SetFraction(0)
    craftProgress:SetVisible(false)

    local buttonPanel = vgui.Create("DPanel", detailPanel)
    buttonPanel:Dock(BOTTOM)
    buttonPanel:SetTall(50)
    buttonPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60,60,60,200))
    end

    local matScroll = vgui.Create("DScrollPanel", detailPanel)
    matScroll:Dock(FILL)
    matScroll:DockMargin(10, 5, 10, 5)

    local craftButton = vgui.Create("DButton", buttonPanel)
    craftButton:SetText("Craft")
    craftButton:SetFont("Trebuchet18")
    craftButton:SetTextColor(Color(255,255,255))
    craftButton:SetSize(195, 30)
    craftButton:Dock(LEFT)
    craftButton:DockMargin(10, 10, 0, 10)
    craftButton.Paint = function(self, w, h)
        local col = self:IsHovered() and Color(70,120,70,200) or Color(70,100,70,200)
        draw.RoundedBox(4, 0, 0, w, h, col)
    end

    local closeButton = vgui.Create("DButton", buttonPanel)
    closeButton:SetText("Close")
    closeButton:SetFont("Trebuchet18")
    closeButton:SetTextColor(Color(255,255,255))
    closeButton:SetSize(195, 30)
    closeButton:Dock(LEFT)
    closeButton:DockMargin(10, 10, 0, 10)
    closeButton.Paint = function(self, w, h)
        local col = self:IsHovered() and Color(150,50,50,200) or Color(120,50,50,200)
        draw.RoundedBox(4, 0, 0, w, h, col)
    end
    closeButton.DoClick = function() craftMenuFrame:Close() end

    function craftMenuFrame:CanCraftRecipe(key)
        local recipeData = self.Recipes[key]
        if not recipeData then return false end

        for _, matInfo in ipairs(recipeData.materials) do
            local haveCount = self.StoredItems[matInfo.class] or 0
            if haveCount < matInfo.required then
                return false
            end
        end
        return true
    end

    function craftMenuFrame:UpdateRecipeDetails(key)
        local recipeData = self.Recipes[key]
        if not recipeData then return end

        self.SelectedRecipeKey = key
        itemTitle:SetText(recipeData.name or key)
        itemTitle:SizeToContents()
        descLabel:SetText(recipeData.desc or "No description.")
        descLabel:SizeToContentsY()

        matScroll:Clear()
        for _, matInfo in ipairs(recipeData.materials) do
            local haveCount = self.StoredItems[matInfo.class] or 0
            local enough = haveCount >= matInfo.required
            local lineText = string.format("%s: %d/%d", matInfo.name, haveCount, matInfo.required)
            local matLabel = vgui.Create("DLabel", matScroll)
            matLabel:SetText(lineText)
            matLabel:SetFont("Trebuchet18")
            matLabel:Dock(TOP)
            matLabel:DockMargin(0, 0, 0, 0)
            matLabel:SizeToContents()
            matLabel:SetTextColor(enough and Color(30,200,0) or Color(200,80,80))
        end

        craftButton:SetEnabled(self:CanCraftRecipe(key))
    end

    craftButton.DoClick = function(ply )
        if not craftMenuFrame.SelectedRecipeKey then return end
        if not craftMenuFrame:CanCraftRecipe(craftMenuFrame.SelectedRecipeKey) then return end
    
        craftProgress:SetVisible(true)
        craftProgress:SetFraction(0)
        surface.PlaySound("items/ammocrate_open.wav")
        craftButton:SetEnabled(false)
    
        local duration = 3
        local startTime = CurTime()
    
        timer.Create("CraftingProgressTimer", 0.05, 0, function()
            if not IsValid(craftMenuFrame) then
                timer.Remove("CraftingProgressTimer")
                return
            end
    
            local elapsed = CurTime() - startTime
            local frac = math.Clamp(elapsed / duration, 0, 1)
            craftProgress:SetFraction(frac)
    
            if frac >= 1 then
                timer.Remove("CraftingProgressTimer")
                craftProgress:SetVisible(false)
                craftButton:SetEnabled(true)
    
                net.Start("CraftItem")
                    net.WriteEntity(craftMenuFrame.CraftEnt)
                    net.WriteString(craftMenuFrame.SelectedRecipeKey)
                net.SendToServer()
            end
        end)
    end    

    recipeList.OnRowSelected = function(lst, index, pnl)
        local selectedName = pnl:GetValue(1)
        for key, recipeData in pairs(recipes) do
            if recipeData.name == selectedName then
                craftMenuFrame:UpdateRecipeDetails(key)
                break
            end
        end
    end

    local lines = recipeList:GetLines()
    if #lines > 0 then
        recipeList:SelectItem(lines[1])
    end

    timer.Create(autoRefreshTimerName, 2, 0, function()
        if not IsValid(craftMenuFrame) or not IsValid(craftMenuFrame.CraftEnt) then
            timer.Remove(autoRefreshTimerName)
            return
        end

        net.Start("RequestCraft")
            net.WriteEntity(craftMenuFrame.CraftEnt)
        net.SendToServer()
    end)
end)
