--[[
    MODERN REAL-TIME STATS VIEWER (FLOATING MINIMIZE)
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local DAMAGE_MULTIPLIER = 0.39 

local OldGui = PlayerGui:FindFirstChild("ModernStatsGui")
if OldGui then OldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernStatsGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local function Tween(Object, Time, Properties, Style, Direction)
    local TweenInfo = TweenInfo.new(Time, Style or Enum.EasingStyle.Quint, Direction or Enum.EasingDirection.Out)
    local TweenAnim = TweenService:Create(Object, TweenInfo, Properties)
    TweenAnim:Play()
    return TweenAnim
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 260)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(80, 80, 255)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.3
UIStroke.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
})
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

-- FLOATING BUTTON (MINIMIZE STATE)
local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Name = "FloatingBtn"
FloatingBtn.Size = UDim2.new(0, 0, 0, 0) -- Awalnya kecil (animasi)
FloatingBtn.Position = UDim2.new(0, 15, 0.5, -25) -- Posisi di tengah kiri
FloatingBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
FloatingBtn.Text = "S"
FloatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.TextSize = 22
FloatingBtn.Visible = false
FloatingBtn.Parent = ScreenGui
Instance.new("UICorner", FloatingBtn).CornerRadius = UDim.new(1, 0) -- Biar bulat

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Color3.fromRGB(150, 150, 255)
FloatStroke.Thickness = 2
FloatStroke.Parent = FloatingBtn

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "STATS VIEWER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 24, 0, 24)
MinBtn.Position = UDim2.new(1, -60, 0.5, -12)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.Parent = Header
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -30, 0.5, -12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Dropdown Container
local DropdownContainer = Instance.new("Frame")
DropdownContainer.Size = UDim2.new(1, -30, 0, 35)
DropdownContainer.Position = UDim2.new(0, 15, 0, 45)
DropdownContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
DropdownContainer.ClipsDescendants = true
DropdownContainer.ZIndex = 5
DropdownContainer.Parent = MainFrame
Instance.new("UICorner", DropdownContainer).CornerRadius = UDim.new(0, 6)

local DropdownBtn = Instance.new("TextButton")
DropdownBtn.Size = UDim2.new(1, 0, 0, 35)
DropdownBtn.BackgroundTransparency = 1
DropdownBtn.Text = "  Pilih Pemain..."
DropdownBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
DropdownBtn.Font = Enum.Font.Gotham
DropdownBtn.TextSize = 13
DropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
DropdownBtn.ZIndex = 6
DropdownBtn.Parent = DropdownContainer

-- Search TextBox
local SearchBar = Instance.new("TextBox")
SearchBar.Size = UDim2.new(1, -10, 0, 30)
SearchBar.Position = UDim2.new(0, 5, 0, 35)
SearchBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
SearchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBar.Text = ""
SearchBar.PlaceholderText = "Cari nama / display..."
SearchBar.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
SearchBar.Font = Enum.Font.Gotham
SearchBar.TextSize = 13
SearchBar.ZIndex = 6
SearchBar.ClearTextOnFocus = true
SearchBar.Parent = DropdownContainer
Instance.new("UICorner", SearchBar).CornerRadius = UDim.new(0, 4)

local Arrow = Instance.new("TextLabel")
Arrow.Size = UDim2.new(0, 30, 0, 35)
Arrow.Position = UDim2.new(1, -35, 0, 0)
Arrow.BackgroundTransparency = 1
Arrow.Text = "v"
Arrow.TextColor3 = Color3.fromRGB(200, 200, 200)
Arrow.Font = Enum.Font.GothamBold
Arrow.TextSize = 12
Arrow.ZIndex = 6
Arrow.Parent = DropdownContainer

-- Scroll Frame for Players
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, 0, 0, 105)
PlayerList.Position = UDim2.new(0, 0, 0, 70)
PlayerList.BackgroundTransparency = 1
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 3
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.ZIndex = 5
PlayerList.Parent = DropdownContainer

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 2)
UIListLayout.Parent = PlayerList

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

-- Stats Display
local StatsFrame = Instance.new("Frame")
StatsFrame.Size = UDim2.new(1, -30, 0, 90)
StatsFrame.Position = UDim2.new(0, 15, 0, 135)
StatsFrame.BackgroundTransparency = 1
StatsFrame.Parent = MainFrame

-- Strength Label
local StrLabel = Instance.new("TextLabel")
StrLabel.Size = UDim2.new(1, 0, 0, 30)
StrLabel.BackgroundTransparency = 1
StrLabel.Text = "Strength:"
StrLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StrLabel.Font = Enum.Font.Gotham
StrLabel.TextSize = 14
StrLabel.TextXAlignment = Enum.TextXAlignment.Left
StrLabel.Parent = StatsFrame

-- Strength Value
local StrValue = Instance.new("TextLabel")
StrValue.Size = UDim2.new(1, 0, 0, 30)
StrValue.BackgroundTransparency = 1
StrValue.Text = "0"
StrValue.TextColor3 = Color3.fromRGB(100, 255, 100)
StrValue.Font = Enum.Font.GothamBold
StrValue.TextSize = 18
StrValue.TextXAlignment = Enum.TextXAlignment.Right
StrValue.Parent = StatsFrame

-- Damage Label
local DmgLabel = Instance.new("TextLabel")
DmgLabel.Size = UDim2.new(1, 0, 0, 30)
DmgLabel.Position = UDim2.new(0, 0, 0, 45)
DmgLabel.BackgroundTransparency = 1
DmgLabel.Text = "Damage Dealt:"
DmgLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
DmgLabel.Font = Enum.Font.Gotham
DmgLabel.TextSize = 14
DmgLabel.TextXAlignment = Enum.TextXAlignment.Left
DmgLabel.Parent = StatsFrame

-- Damage Value
local DmgValue = Instance.new("TextLabel")
DmgValue.Size = UDim2.new(1, 0, 0, 30)
DmgValue.Position = UDim2.new(0, 0, 0, 45)
DmgValue.BackgroundTransparency = 1
DmgValue.Text = "0"
DmgValue.TextColor3 = Color3.fromRGB(255, 100, 100)
DmgValue.Font = Enum.Font.GothamBold
DmgValue.TextSize = 18
DmgValue.TextXAlignment = Enum.TextXAlignment.Right
DmgValue.Parent = StatsFrame

-- ==========================================
-- LOGIKA SCRIPT
-- ==========================================

local SelectedPlayer = nil
local IsOpen = false

local function FormatNumber(n)
    local i, j = tostring(math.floor(n)):find('^%-?%d+()%d%d%d')
    while i do
        j = j + 1
        i, j = tostring(n):find('^%-?%d+()%d%d%d', j)
    end
    local formatted = tostring(math.floor(n))
    while true do  
        formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

local function RefreshPlayerList()
    for _, v in pairs(PlayerList:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end

    for i, p in pairs(Players:GetPlayers()) do
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 30)
        Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        Btn.BackgroundTransparency = 0.5
        Btn.Text = "  " .. p.DisplayName .. " (@" .. p.Name .. ")"
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 12
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Btn.LayoutOrder = i
        Btn.ZIndex = 5
        Btn.Parent = PlayerList
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

        Btn.MouseEnter:Connect(function()
            Tween(Btn, 0.2, {BackgroundTransparency = 0.2})
        end)
        Btn.MouseLeave:Connect(function()
            Tween(Btn, 0.2, {BackgroundTransparency = 0.5})
        end)
        
        Btn.MouseButton1Click:Connect(function()
            SelectedPlayer = p
            DropdownBtn.Text = "  " .. p.DisplayName .. " (@" .. p.Name .. ")"
            IsOpen = false
            SearchBar.Text = ""
            Tween(DropdownContainer, 0.3, {Size = UDim2.new(1, -30, 0, 35)}, Enum.EasingStyle.Quart)
            Tween(Arrow, 0.3, {Rotation = 0})
        end)
    end
end

-- LIVE FILTER
SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(SearchBar.Text)
    for _, btn in pairs(PlayerList:GetChildren()) do
        if btn:IsA("TextButton") then
            if query == "" or string.find(string.lower(btn.Text), query, 1, true) then
                btn.Visible = true
            else
                btn.Visible = false
            end
        end
    end
end)

-- ENTER SELECT
SearchBar.FocusLost:Connect(function(enterPressed)
    if enterPressed and SearchBar.Text ~= "" then
        local input = string.lower(SearchBar.Text)
        local found = nil
        
        for _, p in pairs(Players:GetPlayers()) do
            local pName = string.lower(p.Name)
            local pDisplay = string.lower(p.DisplayName)
            
            if pName == input or pDisplay == input or string.find(pName, input, 1, true) or string.find(pDisplay, input, 1, true) then
                found = p
                break
            end
        end
        
        if found then
            SelectedPlayer = found
            DropdownBtn.Text = "  " .. found.DisplayName .. " (@" .. found.Name .. ")"
            IsOpen = false
            SearchBar.Text = ""
            Tween(DropdownContainer, 0.3, {Size = UDim2.new(1, -30, 0, 35)}, Enum.EasingStyle.Quart)
            Tween(Arrow, 0.3, {Rotation = 0})
        end
    end
end)

DropdownBtn.MouseButton1Click:Connect(function()
    IsOpen = not IsOpen
    RefreshPlayerList()
    if IsOpen then
        Tween(DropdownContainer, 0.4, {Size = UDim2.new(1, -30, 0, 175)}, Enum.EasingStyle.Quart)
        Tween(Arrow, 0.4, {Rotation = 180})
    else
        Tween(DropdownContainer, 0.4, {Size = UDim2.new(1, -30, 0, 35)}, Enum.EasingStyle.Quart)
        Tween(Arrow, 0.4, {Rotation = 0})
    end
end)

-- CLOSE SCRIPT
CloseBtn.MouseButton1Click:Connect(function()
    Tween(MainFrame, 0.3, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.wait(0.3)
    ScreenGui:Destroy()
end)

-- MINIMIZE LOGIC (Ubah ke Floating Button)
local isMinimized = false
local lastPos = MainFrame.Position -- Simpan posisi terakhir sebelum di-minimize

MinBtn.MouseButton1Click:Connect(function()
    if not isMinimized then
        lastPos = MainFrame.Position
        isMinimized = true
        
        -- Animasi ngecil ke tengah kiri
        Tween(MainFrame, 0.3, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0, 15, 0.5, -25), BackgroundTransparency = 1}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.25)
        MainFrame.Visible = false
        
        -- Munculin Floating Button
        FloatingBtn.Visible = true
        Tween(FloatingBtn, 0.3, {Size = UDim2.new(0, 50, 0, 50)}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end
end)

-- KLIK FLOATING BUTTON UNTUK BALIKIN GUI
FloatingBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        -- Animasi hilangin floating button
        Tween(FloatingBtn, 0.3, {Size = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.25)
        FloatingBtn.Visible = false
        
        -- Balikin GUI ke ukuran & posisi semula
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0, 15, 0.5, -25)
        MainFrame.BackgroundTransparency = 0.1
        
        Tween(MainFrame, 0.4, {Size = UDim2.new(0, 320, 0, 260), Position = lastPos}, Enum.EasingStyle.Quart)
        isMinimized = false
    end
end)

-- DRAGGING LOGIC (Hanya buat MainFrame)
local Dragging, DragInput, DragStart, StartPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then Dragging = false end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        DragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end
end)

-- REALTIME LOOP
RunService.RenderStepped:Connect(function()
    if SelectedPlayer then
        local FoundValue = 0
        local Found = false

        local strAttr = SelectedPlayer:GetAttribute("Strength") or SelectedPlayer:GetAttribute("strength") or SelectedPlayer:GetAttribute("Str") or SelectedPlayer:GetAttribute("Power")
        if strAttr and type(strAttr) == "number" then
            FoundValue = strAttr
            Found = true
        end

        if not Found then
            local folders = {"leaderstats", "Stats", "HiddenStats", "Values", "Data", "PlayerStats"}
            for _, fName in pairs(folders) do
                local folder = SelectedPlayer:FindFirstChild(fName)
                if folder then
                    for _, v in pairs(folder:GetChildren()) do
                        if v:IsA("ValueBase") and type(v.Value) == "number" then
                            local n = v.Name:lower()
                            if n:find("str") or n:find("pow") or n:find("dmg") or n:find("damage") then
                                FoundValue = v.Value
                                Found = true
                                break
                            end
                        end
                    end
                end
                if Found then break end
            end
        end
        
        if not Found and SelectedPlayer.Character then
            for _, v in pairs(SelectedPlayer.Character:GetChildren()) do
                if v:IsA("ValueBase") and type(v.Value) == "number" then
                    local n = v.Name:lower()
                    if n:find("str") or n:find("pow") or n:find("dmg") or n:find("damage") then
                        FoundValue = v.Value
                        Found = true
                        break
                    end
                end
            end
        end

        if Found and FoundValue > 0 then
            local CurrentStr = FoundValue
            local CalculatedDmg = math.floor(CurrentStr * DAMAGE_MULTIPLIER)
            
            if StrValue.Text ~= FormatNumber(CurrentStr) then
                StrValue.Text = FormatNumber(CurrentStr)
                Tween(StrValue, 0.2, {TextColor3 = Color3.fromRGB(255, 255, 255)})
                Tween(StrValue, 0.2, {TextColor3 = Color3.fromRGB(100, 255, 100)}, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            end
            
            DmgValue.Text = FormatNumber(CalculatedDmg)
        elseif not Found then
            StrValue.Text = "No Stats Found"
            DmgValue.Text = "0"
        end
    end
end)
