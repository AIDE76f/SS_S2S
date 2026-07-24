-- ========================================== -- الخدمات الأساسية -- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ========================================== -- الإعدادات والمتغيرات (Settings) -- ==========================================
local Settings = {
    Aimbot = {
        Enabled = false,
        ShowFOV = false,
        FOV_Radius = 120,
        TriggerBot = false,
        HitboxExpander = false,
        HitboxSize = 25,
        WallBang = false
    },
    ESP = {
        Enabled = false,
        ShowNames = false,
        Chams = false
    },
    Combo = {
        SpeedBoost = false,
        SpeedMultiplier = 2,
        InfiniteJump = false,
        Noclip = false,
        GodMode = false,
        InfAmmo = false,
        JumpPowerBoost = false,
        JumpPowerMultiplier = 2
    },
    Friends = {}
}

local TargetPartsPriority = {"Head", "UpperTorso", "Torso", "LowerTorso", "RightUpperArm", "RightArm", "LeftUpperArm", "LeftArm", "RightLowerArm", "LeftLowerArm"}

-- ========================================== -- دالة تأثير ألوان قوس قزح -- ==========================================
local function RainbowColor(speed)
    local hue = (tick() * (speed or 0.5)) % 1
    return Color3.fromHSV(hue, 1, 1)
end

-- ========================================== -- 1. بناء الواجهة (GUI) -- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HasanHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESP_Folder"
ESPFolder.Parent = ScreenGui

local FOVCircle = Instance.new("Frame")
FOVCircle.Size = UDim2.new(0, Settings.Aimbot.FOV_Radius * 2, 0, Settings.Aimbot.FOV_Radius * 2)
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false
FOVCircle.Parent = ScreenGui
Instance.new("UICorner", FOVCircle).CornerRadius = UDim.new(1, 0)
local FOVStroke = Instance.new("UIStroke", FOVCircle)
FOVStroke.Color = Color3.fromRGB(255, 255, 255); FOVStroke.Thickness = 1.5

-- الإطار الرئيسي
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 320)
MainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true; MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- الشريط العلوي
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35); TitleBar.BackgroundTransparency = 1; TitleBar.Parent = MainFrame
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0); Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1; Title.Text = "📱 حسن | @SS_S2S"; Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold; Title.TextSize = 13; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.Parent = TitleBar

-- تأثير قوس قزح على العنوان
RunService.RenderStepped:Connect(function()
    Title.TextColor3 = RainbowColor(0.3)
end)

-- نص حقوق إضافي في الأسفل
local CreditLabel = Instance.new("TextLabel")
CreditLabel.Size = UDim2.new(1, -20, 0, 20)
CreditLabel.Position = UDim2.new(0, 10, 1, -25)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "By حسن | telegram: @SS_S2S"
CreditLabel.Font = Enum.Font.GothamSemibold
CreditLabel.TextSize = 10
CreditLabel.TextXAlignment = Enum.TextXAlignment.Center
CreditLabel.Parent = MainFrame

-- تأثير قوس قزح على نص الحقوق
RunService.RenderStepped:Connect(function()
    CreditLabel.TextColor3 = RainbowColor(0.5)
end)

-- أزرار التصغير والإغلاق
local function CreateTitleBtn(text, color, xOffset)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 25, 0, 25); btn.Position = UDim2.new(1, xOffset, 0.5, -12.5)
    btn.BackgroundColor3 = color; btn.Text = text; btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 14; btn.AutoButtonColor = false; btn.Parent = TitleBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local CloseBtn = CreateTitleBtn("X", Color3.fromRGB(255, 65, 65), -30)
local MinBtn = CreateTitleBtn("-", Color3.fromRGB(50, 150, 255), -60)

local isMinimized = false
local smoothTween = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    TweenService:Create(MainFrame, smoothTween, {Size = isMinimized and UDim2.new(0, 260, 0, 35) or UDim2.new(0, 260, 0, 320)}):Play()
    MinBtn.Text = isMinimized and "+" or "-"
end)

CloseBtn.MouseButton1Click:Connect(function()
    Settings.Aimbot.Enabled = false; Settings.ESP.Enabled = false; Settings.Aimbot.HitboxExpander = false; Settings.Aimbot.WallBang = false
    local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
    closeTween:Play(); closeTween.Completed:Wait(); ScreenGui:Destroy()
end)

local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = gui.Position
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            if input.UserInputState == Enum.UserInputState.End then dragging = false
            else
                local delta = input.Position - dragStart
                gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
end
MakeDraggable(MainFrame)

-- ========================================== -- 2. نظام التبويبات والتمرير -- ==========================================
local TabsContainer = Instance.new("Frame")
TabsContainer.Size = UDim2.new(1, -10, 0, 30); TabsContainer.Position = UDim2.new(0, 5, 0, 40); TabsContainer.BackgroundTransparency = 1; TabsContainer.Parent = MainFrame
local TabListLayout = Instance.new("UIListLayout"); TabListLayout.FillDirection = Enum.FillDirection.Horizontal; TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; TabListLayout.Padding = UDim.new(0, 5); TabListLayout.Parent = TabsContainer

local function CreateScrollContainer(name)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -80); scroll.Position = UDim2.new(0, 5, 0, 75); scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 3; scroll.CanvasSize = UDim2.new(0, 0, 0, 0); scroll.Visible = false; scroll.Parent = MainFrame
    local layout = Instance.new("UIListLayout"); layout.Padding = UDim.new(0, 6); layout.Parent = scroll
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    return scroll
end

local AimbotScroll = CreateScrollContainer("AimbotScroll")
local ESPScroll = CreateScrollContainer("ESPScroll")
local ComboScroll = CreateScrollContainer("ComboScroll")
local FriendsScroll = CreateScrollContainer("FriendsScroll")
local TeleportScroll = CreateScrollContainer("TeleportScroll")
AimbotScroll.Visible = true

local tabButtons = {}
local function CreateTabButton(text, targetScroll)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 1, 0); btn.BackgroundColor3 = targetScroll.Visible and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(35, 35, 40)
    btn.Text = text; btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 12; btn.Parent = TabsContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6); table.insert(tabButtons, btn)
    btn.MouseButton1Click:Connect(function()
        AimbotScroll.Visible = (targetScroll == AimbotScroll); ESPScroll.Visible = (targetScroll == ESPScroll); ComboScroll.Visible = (targetScroll == ComboScroll)
        FriendsScroll.Visible = (targetScroll == FriendsScroll); TeleportScroll.Visible = (targetScroll == TeleportScroll)
        for _, otherBtn in ipairs(tabButtons) do
            TweenService:Create(otherBtn, TweenInfo.new(0.2), {BackgroundColor3 = (otherBtn == btn) and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(35, 35, 40)}):Play()
        end
    end)
end

CreateTabButton("Aimbot", AimbotScroll); CreateTabButton("ESP", ESPScroll); CreateTabButton("Combo", ComboScroll)
CreateTabButton("Friends", FriendsScroll); CreateTabButton("Teleport", TeleportScroll)

-- ========================================== -- 3. دوال إنشاء عناصر التحكم -- ==========================================
local function CreateToggleItem(parentScroll, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35); btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    btn.Text = " " .. text; btn.TextColor3 = Color3.fromRGB(200, 200, 200); btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.Parent = parentScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local indicator = Instance.new("Frame"); indicator.Size = UDim2.new(0, 15, 0, 15); indicator.Position = UDim2.new(1, -25, 0.5, -7.5)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50); indicator.Parent = btn
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(indicator, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)}):Play()
        btn.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
        callback(state)
    end)
end

local function CreateInputItem(parentScroll, text, placeholder, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 35); container.BackgroundColor3 = Color3.fromRGB(40, 40, 45); container.Parent = parentScroll
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0); label.Position = UDim2.new(0, 10, 0, 0); label.BackgroundTransparency = 1
    label.Text = text; label.TextColor3 = Color3.fromRGB(255, 255, 255); label.Font = Enum.Font.GothamSemibold; label.TextSize = 13; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = container
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.3, 0, 0.7, 0); box.Position = UDim2.new(0.65, 0, 0.15, 0); box.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    box.Text = placeholder; box.TextColor3 = Color3.fromRGB(255, 255, 255); box.Font = Enum.Font.Gotham; box.TextSize = 12; box.Parent = container
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
    box.FocusLost:Connect(function()
        local num = tonumber(box.Text); if num then callback(num) else box.Text = placeholder end
    end)
end

-- دالة إنشاء صف الصديق
local function CreateFriendRow(parentScroll, player)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 50); container.BackgroundColor3 = Color3.fromRGB(40, 40, 45); container.Parent = parentScroll
    container.Name = "FriendRow_" .. player.UserId
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)
    
    -- أيقونة رأس الشخصية
    local headIcon = Instance.new("ImageLabel")
    headIcon.Size = UDim2.new(0, 35, 0, 35); headIcon.Position = UDim2.new(0, 10, 0.5, -17.5)
    headIcon.BackgroundTransparency = 1
    headIcon.Parent = container
    
    -- تحميل صورة رأس الشخصية
    local userId = player.UserId
    local thumbType = Enum.ThumbnailType.HeadShot
    local thumbSize = Enum.ThumbnailSize.Size420x420
    local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
    headIcon.Image = content
    
    -- اسم اللاعب
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 120, 1, 0); nameLabel.Position = UDim2.new(0, 55, 0, 0)
    nameLabel.BackgroundTransparency = 1; nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255); nameLabel.Font = Enum.Font.GothamSemibold
    nameLabel.TextSize = 13; nameLabel.TextXAlignment = Enum.TextXAlignment.Left; nameLabel.Parent = container
    
    -- زر التفعيل/الإطفاء
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 25); btn.Position = UDim2.new(1, -60, 0.5, -12.5)
    btn.BackgroundColor3 = Settings.Friends[player.UserId] and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    btn.Text = Settings.Friends[player.UserId] and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Font = Enum.Font.GothamBold; btn.TextSize = 12
    btn.Parent = container
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        Settings.Friends[player.UserId] = not Settings.Friends[player.UserId]
        btn.BackgroundColor3 = Settings.Friends[player.UserId] and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
        btn.Text = Settings.Friends[player.UserId] and "ON" or "OFF"
    end)
    
    return container
end

-- دالة إنشاء صف الانتقال (Teleport Row)
local function CreateTeleportRow(parentScroll, player)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 50); container.BackgroundColor3 = Color3.fromRGB(40, 40, 45); container.Parent = parentScroll
    container.Name = "TeleportRow_" .. player.UserId
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)
    
    -- أيقونة رأس الشخصية
    local headIcon = Instance.new("ImageLabel")
    headIcon.Size = UDim2.new(0, 35, 0, 35); headIcon.Position = UDim2.new(0, 10, 0.5, -17.5)
    headIcon.BackgroundTransparency = 1
    headIcon.Parent = container
    
    -- تحميل صورة رأس الشخصية
    local userId = player.UserId
    local thumbType = Enum.ThumbnailType.HeadShot
    local thumbSize = Enum.ThumbnailSize.Size420x420
    local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
    headIcon.Image = content
    
    -- اسم اللاعب
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 110, 1, 0); nameLabel.Position = UDim2.new(0, 55, 0, 0)
    nameLabel.BackgroundTransparency = 1; nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255); nameLabel.Font = Enum.Font.GothamSemibold
    nameLabel.TextSize = 12; nameLabel.TextXAlignment = Enum.TextXAlignment.Left; nameLabel.Parent = container
    
    -- زر الانتقال (Teleport)
    local teleportBtn = Instance.new("TextButton")
    teleportBtn.Size = UDim2.new(0, 60, 0, 25); teleportBtn.Position = UDim2.new(1, -70, 0.5, -12.5)
    teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    teleportBtn.Text = "Teleport"
    teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255); teleportBtn.Font = Enum.Font.GothamBold; teleportBtn.TextSize = 12
    teleportBtn.Parent = container
    Instance.new("UICorner", teleportBtn).CornerRadius = UDim.new(0, 6)
    
    -- وظيفة زر الانتقال
    teleportBtn.MouseButton1Click:Connect(function()
        local myChar = LocalPlayer.Character
        local targetChar = player.Character
        
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                -- الانتقال إلى موقع اللاعب
                local targetPos = targetChar.HumanoidRootPart.CFrame
                myChar.HumanoidRootPart.CFrame = targetPos + Vector3.new(0, 0, 3)
                
                -- تأثير بصري للإنتقال (اختياري)
                local oldColor = teleportBtn.BackgroundColor3
                teleportBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
                teleportBtn.Text = "✓ Done"
                
                -- إعادة الزر لوضعه الطبيعي بعد ثانية
                task.wait(1)
                teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                teleportBtn.Text = "Teleport"
            else
                -- إذا كان اللاعب غير موجود في اللعبة
                teleportBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                teleportBtn.Text = "No Char"
                
                task.wait(1)
                teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                teleportBtn.Text = "Teleport"
            end
        end
    end)
    
    return container
end

-- تحديث قائمة الأصدقاء
local function UpdateFriendsList()
    -- مسح القائمة القديمة
    for _, child in ipairs(FriendsScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    -- إضافة اللاعبين الحاليين
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateFriendRow(FriendsScroll, player)
        end
    end
end

-- تحديث قائمة الانتقال
local function UpdateTeleportList()
    -- مسح القائمة القديمة
    for _, child in ipairs(TeleportScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    -- إضافة اللاعبين الحاليين
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateTeleportRow(TeleportScroll, player)
        end
    end
end

-- تحديث القوائم عند دخول/خروج لاعبين
Players.PlayerAdded:Connect(function()
    UpdateFriendsList()
    UpdateTeleportList()
end)

Players.PlayerRemoving:Connect(function()
    UpdateFriendsList()
    UpdateTeleportList()
end)

UpdateFriendsList()
UpdateTeleportList()

-- ========================================== -- 4. تعبئة القوائم بالأوامر -- ==========================================
-- Aimbot Tab
CreateToggleItem(AimbotScroll, "تفعيل Aimbot ذكي", function(s) Settings.Aimbot.Enabled = s end)
CreateToggleItem(AimbotScroll, "تكبير جسم الخصوم (بديل Silent Aim)", function(s) Settings.Aimbot.HitboxExpander = s end)
CreateInputItem(AimbotScroll, "مدى التكبير (الافتراضي 25):", "25", function(val) Settings.Aimbot.HitboxSize = val end)
CreateToggleItem(AimbotScroll, "إطلاق تلقائي (TriggerBot)", function(s) Settings.Aimbot.TriggerBot = s end)
CreateToggleItem(AimbotScroll, "طلقة مخترقة للجدران (WallBang)", function(s) Settings.Aimbot.WallBang = s end)
CreateToggleItem(AimbotScroll, "إظهار دائرة التصويب", function(s) Settings.Aimbot.ShowFOV = s; FOVCircle.Visible = s end)
CreateInputItem(AimbotScroll, "حجم الدائرة (FOV):", "120", function(val) Settings.Aimbot.FOV_Radius = val; FOVCircle.Size = UDim2.new(0, val * 2, 0, val * 2) end)

-- ESP Tab
CreateToggleItem(ESPScroll, "تفعيل ESP المربع والخطوط", function(s) Settings.ESP.Enabled = s; if not s then for _, objs in pairs(ESP_Objects) do for _, v in pairs(objs) do v.Visible = false end end end end)
CreateToggleItem(ESPScroll, "إظهار الاسم والمسافة", function(s) Settings.ESP.ShowNames = s end)
CreateToggleItem(ESPScroll, "إضاءة الخصوم خلف الجدران (Chams)", function(s) Settings.ESP.Chams = s end)

-- Combo Tab
local FloatingTpBtn = Instance.new("TextButton")
FloatingTpBtn.Size = UDim2.new(0, 130, 0, 35); FloatingTpBtn.Position = UDim2.new(0.5, -65, 0.85, 0); FloatingTpBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
FloatingTpBtn.Text = "🎯 انتقال للأقرب"; FloatingTpBtn.TextColor3 = Color3.fromRGB(255, 255, 255); FloatingTpBtn.Font = Enum.Font.GothamBold; FloatingTpBtn.Visible = false; FloatingTpBtn.Parent = ScreenGui
Instance.new("UICorner", FloatingTpBtn).CornerRadius = UDim.new(0, 8); MakeDraggable(FloatingTpBtn)

CreateToggleItem(ComboScroll, "اختراق الجدران (Noclip)", function(s) Settings.Combo.Noclip = s end)
CreateToggleItem(ComboScroll, "إظهار زر الانتقال 🎯", function(s) FloatingTpBtn.Visible = s end)
CreateToggleItem(ComboScroll, "تفعيل مضاعف السرعة", function(s) Settings.Combo.SpeedBoost = s; if not s and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = 16 end end)
CreateInputItem(ComboScroll, "مضاعف السرعة:", "2", function(val) Settings.Combo.SpeedMultiplier = val; if Settings.Combo.SpeedBoost and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = 16 * val end end)
CreateToggleItem(ComboScroll, "قفز لا نهائي (طيران)", function(s) Settings.Combo.InfiniteJump = s end)
CreateToggleItem(ComboScroll, "تفعيل قوة القفزة", function(s) Settings.Combo.JumpPowerBoost = s; if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = s and (50 * Settings.Combo.JumpPowerMultiplier) or 50 end end)
CreateInputItem(ComboScroll, "مضاعف قوة القفزة:", "2", function(val) Settings.Combo.JumpPowerMultiplier = val; if Settings.Combo.JumpPowerBoost and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = 50 * val end end)
CreateToggleItem(ComboScroll, "صحة لا نهائية (God Mode)", function(s) Settings.Combo.GodMode = s end)
CreateToggleItem(ComboScroll, "ذخيرة لا نهائية / بدون إعادة", function(s) Settings.Combo.InfAmmo = s end)

-- ========================================== -- 5. المنطق البرمجي السري (القلب النابض) -- ==========================================
-- العثور على أفضل هدف
local function GetBestVisibleTarget()
    local bestPart = nil; local shortestDist = Settings.Aimbot.FOV_Radius
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local rayParams = RaycastParams.new(); rayParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}; rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 and not Settings.Friends[p.UserId] then
            for _, partName in ipairs(TargetPartsPriority) do
                local part = p.Character:FindFirstChild(partName)
                if part then
                    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                        if dist <= shortestDist then
                            if Settings.Aimbot.WallBang then
                                shortestDist = dist; bestPart = part; break
                            else
                                if workspace:Raycast(Camera.CFrame.Position, part.Position - Camera.CFrame.Position, rayParams) then
                                    shortestDist = dist; bestPart = part; break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return bestPart
end

-- لوب الكاميرا والايم بوت والـ Hitbox
local triggerTick = 0
RunService:BindToRenderStep("HasanAimbotCore", Enum.RenderPriority.Camera.Value + 1, function()
    -- 1. Aimbot
    local targetPart = GetBestVisibleTarget()
    if Settings.Aimbot.Enabled and targetPart then
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetPart.Position)
    end
    
    -- 2. TriggerBot (إطلاق تلقائي)
    if Settings.Aimbot.TriggerBot and targetPart then
        triggerTick = triggerTick + 1
        if triggerTick % 10 == 0 then
            VirtualUser:ClickButton1(Vector2.new())
        end
    end
    
    -- 3. Hitbox Expander (تكبير الأجسام)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and not Settings.Friends[p.UserId] then
            local hrp = p.Character.HumanoidRootPart
            if Settings.Aimbot.HitboxExpander then
                hrp.Size = Vector3.new(Settings.Aimbot.HitboxSize, Settings.Aimbot.HitboxSize, Settings.Aimbot.HitboxSize)
                hrp.Transparency = 0.8
                hrp.BrickColor = BrickColor.new("Bright blue")
                hrp.Material = Enum.Material.ForceField
                hrp.CanCollide = false
            else
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
            end
        end
    end
end)

-- لوب الفيزياء (Noclip, Speed, God Mode)
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    
    -- Noclip (اختراق الجدران)
    if Settings.Combo.Noclip then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if Settings.Combo.SpeedBoost then
            hum.WalkSpeed = 16 * Settings.Combo.SpeedMultiplier
        end
        if Settings.Combo.GodMode and hum.Health > 0 and hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
        if Settings.Combo.JumpPowerBoost then
            hum.JumpPower = 50 * Settings.Combo.JumpPowerMultiplier
        end
    end
    
    -- Inf Ammo
    if Settings.Combo.InfAmmo then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            for _, v in pairs(tool:GetDescendants()) do
                if v:IsA("IntValue") or v:IsA("NumberValue") then
                    local vName = string.lower(v.Name)
                    if string.find(vName, "ammo") or string.find(vName, "clip") or string.find(vName, "mag") then
                        v.Value = 999
                    end
                    if string.find(vName, "reload") or string.find(vName, "cooldown") then
                        v.Value = 0
                    end
                end
            end
        end
    end
end)

-- القفز اللانهائي
UserInputService.JumpRequest:Connect(function()
    if Settings.Combo.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ESP المتكامل والـ Chams
local ESP_Objects = {}
RunService.RenderStepped:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and not Settings.Friends[p.UserId] then
            local char = p.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                if not ESP_Objects[p] then
                    ESP_Objects[p] = {
                        Box = Instance.new("Frame"),
                        HealthBG = Instance.new("Frame"),
                        HealthBar = Instance.new("Frame"),
                        Tracer = Instance.new("Frame"),
                        NameTag = Instance.new("TextLabel"),
                        Highlight = Instance.new("Highlight")
                    }
                    
                    -- Box
                    ESP_Objects[p].Box.BackgroundTransparency = 1
                    ESP_Objects[p].Box.BorderColor3 = Color3.fromRGB(255, 50, 50)
                    ESP_Objects[p].Box.BorderSizePixel = 2
                    ESP_Objects[p].Box.Parent = ESPFolder
                    
                    -- Health Background
                    ESP_Objects[p].HealthBG.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                    ESP_Objects[p].HealthBG.BorderSizePixel = 0
                    ESP_Objects[p].HealthBG.Parent = ESPFolder
                    
                    -- Health Bar
                    ESP_Objects[p].HealthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
                    ESP_Objects[p].HealthBar.BorderSizePixel = 0
                    ESP_Objects[p].HealthBar.Parent = ESP_Objects[p].HealthBG
                    
                    -- Tracer
                    ESP_Objects[p].Tracer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    ESP_Objects[p].Tracer.BorderSizePixel = 0
                    ESP_Objects[p].Tracer.AnchorPoint = Vector2.new(0.5, 0.5)
                    ESP_Objects[p].Tracer.Parent = ESPFolder
                    
                    -- NameTag
                    ESP_Objects[p].NameTag.BackgroundTransparency = 1
                    ESP_Objects[p].NameTag.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ESP_Objects[p].NameTag.Font = Enum.Font.GothamBold
                    ESP_Objects[p].NameTag.TextSize = 12
                    ESP_Objects[p].NameTag.Parent = ESPFolder
                    
                    -- Highlight (Chams)
                    ESP_Objects[p].Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    ESP_Objects[p].Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    ESP_Objects[p].Highlight.Parent = ESPFolder
                end
                
                local objs = ESP_Objects[p]
                local isValid = false
                
                -- نظام الـ Chams
                if Settings.ESP.Chams then
                    objs.Highlight.Adornee = char
                    objs.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                else
                    objs.Highlight.Adornee = nil
                end
                
                if Settings.ESP.Enabled then
                    local topPos = char.Head.Position + Vector3.new(0, 1, 0)
                    local bottomPos = char.HumanoidRootPart.Position - Vector3.new(0, 3, 0)
                    local top2D, onScreen1 = Camera:WorldToViewportPoint(topPos)
                    local bottom2D, onScreen2 = Camera:WorldToViewportPoint(bottomPos)
                    
                    if onScreen1 or onScreen2 then
                        isValid = true
                        local height = math.abs(bottom2D.Y - top2D.Y)
                        local width = height / 2
                        
                        objs.Box.Size = UDim2.new(0, width, 0, height)
                        objs.Box.Position = UDim2.new(0, top2D.X - width/2, 0, top2D.Y)
                        
                        local hpPct = char.Humanoid.Health / char.Humanoid.MaxHealth
                        objs.HealthBG.Size = UDim2.new(0, 3, 0, height)
                        objs.HealthBG.Position = UDim2.new(0, (top2D.X - width/2) - 6, 0, top2D.Y)
                        objs.HealthBar.Size = UDim2.new(1, 0, hpPct, 0)
                        objs.HealthBar.Position = UDim2.new(0, 0, 1 - hpPct, 0)
                        objs.HealthBar.BackgroundColor3 = Color3.fromRGB(255 - (hpPct*255), hpPct*255, 50)
                        
                        local startPos = Vector2.new(Camera.ViewportSize.X / 2, 0)
                        local endPos = Vector2.new(top2D.X, top2D.Y)
                        local dist = (endPos - startPos).Magnitude
                        objs.Tracer.Size = UDim2.new(0, dist, 0, 1)
                        objs.Tracer.Position = UDim2.new(0, (startPos.X + endPos.X)/2, 0, (startPos.Y + endPos.Y)/2)
                        objs.Tracer.Rotation = math.deg(math.atan2(endPos.Y - startPos.Y, endPos.X - startPos.X))
                        
                        if Settings.ESP.ShowNames then
                            objs.NameTag.Visible = true
                            objs.NameTag.Text = p.Name .. " [" .. math.floor((Camera.CFrame.Position - char.HumanoidRootPart.Position).Magnitude) .. "m]"
                            objs.NameTag.Position = UDim2.new(0, top2D.X - 50, 0, top2D.Y - 20)
                            objs.NameTag.Size = UDim2.new(0, 100, 0, 20)
                        else
                            objs.NameTag.Visible = false
                        end
                    end
                end
                
                objs.Box.Visible = isValid
                objs.HealthBG.Visible = isValid
                objs.Tracer.Visible = isValid
                if not isValid then
                    objs.NameTag.Visible = false
                end
            else
                if ESP_Objects[p] then
                    ESP_Objects[p].Box.Visible = false
                    ESP_Objects[p].HealthBG.Visible = false
                    ESP_Objects[p].Tracer.Visible = false
                    ESP_Objects[p].NameTag.Visible = false
                    ESP_Objects[p].Highlight.Adornee = nil
                end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if ESP_Objects[p] then
        for _, v in pairs(ESP_Objects[p]) do
            v:Destroy()
        end
        ESP_Objects[p] = nil
    end
end)

-- زر الانتقال العائم
FloatingTpBtn.MouseButton1Click:Connect(function()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local nearest, dist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
            local d = (myRoot.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist, nearest = d, p end
        end
    end
    if nearest then
        myRoot.CFrame = nearest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end)
