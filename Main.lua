local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local ContextActionService = game:GetService("ContextActionService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local TextChatService = game:GetService("TextChatService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local PhysicsService = game:GetService("PhysicsService")
local MaterialService = game:GetService("MaterialService")
local SoundService = game:GetService("SoundService")

local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/fiiremax/Scripts/refs/heads/master/Scriptnew/GitHub/Scripts/Loader.lua'))()

local SpawnedInToys = Workspace[LocalPlayer.Name .. "SpawnedInToys"]
local MenuToys = ReplicatedStorage:WaitForChild("MenuToys")
local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
local CharacterEvents = ReplicatedStorage:WaitForChild("CharacterEvents")
local BombEvents = ReplicatedStorage:WaitForChild("BombEvents")
local DataEvents = ReplicatedStorage:WaitForChild("DataEvents")
local PlayerEvents = ReplicatedStorage:WaitForChild("PlayerEvents")
local HoldEvents = ReplicatedStorage:WaitForChild("HoldEvents")

local SpawnToyRF = MenuToys:WaitForChild("SpawnToyRemoteFunction")
local DestroyToy = MenuToys:WaitForChild("DestroyToy")
local BuyToy = MenuToys:WaitForChild("BuyToyRemoteFunction")
local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")
local CreateGrabLine = GrabEvents:WaitForChild("CreateGrabLine")
local DestroyGrabLine = GrabEvents:WaitForChild("DestroyGrabLine")
local ExtendGrabLine = GrabEvents:WaitForChild("ExtendGrabLine")
local RagdollRemote = CharacterEvents:WaitForChild("RagdollRemote")
local Struggle = CharacterEvents:WaitForChild("Struggle")
local StickyPartEvent = PlayerEvents:WaitForChild("StickyPartEvent")
local BombExplode = BombEvents:WaitForChild("BombExplode")
local UpdateLineColors = DataEvents:WaitForChild("UpdateLineColorsEvent")
local UseEvent = HoldEvents:WaitForChild("Use")

local PoisonContainer = Workspace.Map.FactoryIsland.PoisonContainer.PoisonHurtPart
local PoisonBigHole = Workspace.Map.Hole.PoisonBigHole.PoisonHurtPart
local PoisonSmallHole = Workspace.Map.Hole.PoisonSmallHole.PoisonHurtPart
local ExtinguishPart = Workspace.Map.Hole.PoisonBigHole.ExtinguishPart
local UFO = Workspace.Map.AlwaysHereTweenedObjects:FindFirstChild("OuterUFO")
if UFO and UFO:FindFirstChild("Object") and UFO.Object:FindFirstChild("ObjectModel") then
    UFO = UFO.Object.ObjectModel.PaintPlayerPart
else
    UFO = Instance.new("Part")
    UFO.Size = Vector3.new(0.5, 0.5, 0.5)
    UFO.Transparency = 1
    UFO.Anchored = true
    UFO.Parent = Workspace
end

local RigidConstraint = Instance.new("RigidConstraint")
local PoisonSize = Vector3.new(2, 2, 2)
PoisonContainer.Size = PoisonSize
PoisonBigHole.Size = PoisonSize
PoisonSmallHole.Size = PoisonSize
PoisonContainer.Position = Vector3.new(0, -500, 0)
PoisonBigHole.Position = Vector3.new(0, -500, 0)
PoisonSmallHole.Position = Vector3.new(0, -500, 0)

local RigidConstraint = Instance.new("RigidConstraint")

local Window = OrionLib:MakeWindow({
    Name = "NyPlus Hub",
    IntroEnabled = false,
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "NyPlusHub",
    Icon = "rbxassetid://114143041236784"
})

local PlayerTab = Window:MakeTab({Name = "Player", Icon = "rbxassetid://7743871002"})
local CombatTab = Window:MakeTab({Name = "Combat", Icon = "rbxassetid://7485051715"})
local GrabTab = Window:MakeTab({Name = "Grab", Icon = "rbxassetid://7733955740"})
local AuraTab = Window:MakeTab({Name = "Auras", Icon = "rbxassetid://7733666258"})
local BlobTab = Window:MakeTab({Name = "Blobman", Icon = "rbxassetid://10152135063"})
local VisualTab = Window:MakeTab({Name = "Visual", Icon = "rbxassetid://7733774602"})
local AntiTab = Window:MakeTab({Name = "Anti", Icon = "rbxassetid://8932822968"})
local KeybindTab = Window:MakeTab({Name = "Keybinds", Icon = "rbxassetid://11710306232"})
local LoopTab = Window:MakeTab({Name = "Loop", Icon = "rbxassetid://7734058599"})
local ExplosionTab = Window:MakeTab({Name = "Explosions", Icon = "rbxassetid://17837704089"})
local TeleportTab = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://7733992829"})
local MiscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://7733916988"})
local ConfigTab = Window:MakeTab({Name = "Config", Icon = "rbxassetid://7734053495"})
local WhitelistTab = Window:MakeTab({Name = "Whitelist", Icon = "rbxassetid://10723433811"})

local function getRoot()
    if LocalPlayer.Character then
        return LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local function getHumanoid()
    if LocalPlayer.Character then
        return LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

local function getHead()
    if LocalPlayer.Character then
        return LocalPlayer.Character:FindFirstChild("Head")
    end
    return nil
end

local function getTorso()
    if LocalPlayer.Character then
        return LocalPlayer.Character:FindFirstChild("Torso") or LocalPlayer.Character:FindFirstChild("UpperTorso")
    end
    return nil
end

local function isInRange(part, range)
    local root = getRoot()
    if root and part then
        return (root.Position - part.Position).Magnitude <= (range or 30)
    end
    return false
end

local function isOwner(part)
    if part and part:FindFirstChild("PartOwner") then
        return part.PartOwner.Value == LocalPlayer.Name
    end
    return false
end

local function getOwner(part)
    if part and part:FindFirstChild("PartOwner") then
        return part.PartOwner.Value
    end
    return nil
end

local function grabPart(part, safe)
    if not part then return end
    if safe and not isInRange(part, 30) then
        local root = getRoot()
        local pos = root and root.CFrame or CFrame.new()
        for i = 1, 15 do
            if root then root.CFrame = CFrame.new(part.Position) + Vector3.new(0, 5, 0) end
            SetNetworkOwner:FireServer(part, part.CFrame)
            task.wait(0.02)
        end
        if root then root.CFrame = pos end
    else
        SetNetworkOwner:FireServer(part, part.CFrame)
    end
end

local function ungrabPart(part)
    if part then
        DestroyGrabLine:FireServer(part)
    end
end

local function getGrabPart(toy)
    if toy:FindFirstChild("SoundPart") then
        return toy.SoundPart
    elseif toy:FindFirstChild("HoldPart") then
        return toy.HoldPart
    elseif toy:FindFirstChild("Part") then
        return toy.Part
    elseif toy:FindFirstChild("HitboxPart") then
        return toy.HitboxPart
    end
    for _, v in pairs(toy:GetChildren()) do
        if v:IsA("BasePart") then
            return v
        end
    end
    return nil
end

local function getHitboxPart(toy, bombType)
    if bombType == "BombMissile" then
        return toy:FindFirstChild("PartHitDetector") or toy:FindFirstChild("HitboxBodyTop")
    elseif bombType == "FireworkMissile" then
        return toy:FindFirstChild("PartHitDetector") or toy:FindFirstChild("PyramidOctagon")
    elseif bombType == "BombBalloon" then
        return toy:FindFirstChild("Balloon")
    elseif bombType == "BombDarkMatter" then
        return toy:FindFirstChild("PartHitDetector") or toy:FindFirstChild("Spinner")
    elseif bombType == "BallSnowball" then
        return toy:FindFirstChild("SoundPart")
    end
    return getGrabPart(toy)
end

local function spawnToy(name, cframe)
    if not LocalPlayer.Character then return nil end
    local root = getRoot()
    if not root then return nil end
    local cf = cframe or (root.CFrame * CFrame.new(0, 5, 0))
    SpawnToyRF:InvokeServer(name, cf, Vector3.zero)
    task.wait(0.3)
    for _, v in pairs(SpawnedInToys:GetChildren()) do
        if v.Name == name then
            return v
        end
    end
    return nil
end

local function spawnToyAtHead(name)
    local head = getHead()
    if head then
        return spawnToy(name, CFrame.new(head.Position + Vector3.new(0, 1, 0), head.Position) * CFrame.Angles(math.pi, 0, 0))
    end
    return spawnToy(name)
end

local function spawnToyVoid(name)
    local toy = spawnToy(name)
    if toy then
        local gp = getGrabPart(toy)
        if gp then
            local bv = Instance.new("BodyPosition", gp)
            bv.Position = gp.Position + Vector3.new(math.random(-100, 100), 1000000, math.random(-100, 100))
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            task.delay(0.5, function()
                if bv then bv:Destroy() end
            end)
        end
    end
    return toy
end

local function deleteToy(toy)
    if toy then
        DestroyToy:FireServer(toy)
    end
end

local function explodeBomb(hitbox, positionPart, explosionPos)
    BombExplode:FireServer({{Hitbox = hitbox, PositionPart = positionPart}, explosionPos})
end

local function getAllPlayers()
    local list = {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            table.insert(list, v.Name .. " (" .. v.DisplayName .. ")")
        end
    end
    table.sort(list)
    return list
end

local function getPlayerFromName(name)
    if not name then return nil end
    local clean = name:match("^(.-)%s*%(")
    if clean then
        return Players:FindFirstChild(clean)
    end
    return Players:FindFirstChild(name)
end

local function getNearestPlayer()
    local root = getRoot()
    if not root then return nil end
    local nearest = nil
    local minDist = HOption.silentRange or 50
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local target = plr.Character:FindFirstChild("Torso") or plr.Character:FindFirstChild("UpperTorso") or plr.Character:FindFirstChild("HumanoidRootPart")
            if target then
                local dist = (root.Position - target.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = target
                end
            end
        end
    end
    return nearest
end

local function getClosestPlayerToCursor()
    local mouse = LocalPlayer:GetMouse()
    if not mouse then return nil end
    local nearest = nil
    local minDist = math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos, onScreen = Camera:WorldToScreenPoint(hrp.Position)
                if onScreen then
                    local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearest = plr
                    end
                end
            end
        end
    end
    return nearest
end

local function getCharacterFromPart(part)
    if not part then return nil end
    local current = part
    while current do
        if current:IsA("Model") and current:FindFirstChild("Humanoid") then
            return current
        end
        current = current.Parent
    end
    return nil
end

local function getPlayerFromPart(part)
    local char = getCharacterFromPart(part)
    if char then
        return Players:GetPlayerFromCharacter(char)
    end
    return nil
end

local function isInPlot()
    return LocalPlayer.InPlot.Value
end

local function isInOwnedPlot()
    return LocalPlayer.InOwnedPlot.Value
end

local function getOwnedPlot()
    for _, plot in pairs(Workspace.Plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local owners = sign:FindFirstChild("ThisPlotsOwners")
            if owners then
                for _, owner in pairs(owners:GetChildren()) do
                    if owner.Value == LocalPlayer.Name then
                        return Workspace.PlotItems:FindFirstChild(plot.Name)
                    end
                end
            end
        end
    end
    return nil
end

local function checkToyLimit()
    local used = LocalPlayer.UsedToyPoints.Value
    local limit = LocalPlayer.ToysLimitCap.Value
    return used / limit > 0.9
end

local function waitForCanSpawn()
    while not LocalPlayer.CanSpawnToy.Value do
        task.wait()
    end
end

local function waitForNotInPlot()
    while LocalPlayer.InPlot.Value and not LocalPlayer.InOwnedPlot.Value do
        task.wait()
    end
end

HOption = {
    walkSpeed = false,
    walkSpeedVal = 50,
    jumpPower = false,
    jumpPowerVal = 100,
    infJump = false,
    gravity = false,
    gravityVal = 50,
    noclip = false,
    silentAim = false,
    silentRange = 50,
    silentPart = "Torso",
    killAura = false,
    killRange = 30,
    poisonAura = false,
    flingAura = false,
    flingStrength = 1000,
    attractAura = false,
    grabAura = false,
    killGrab = false,
    poisonGrab = false,
    noclipGrab = false,
    invisGrab = false,
    superStrength = false,
    strength = 1000,
    invisLine = false,
    furtherExtend = false,
    extendDist = 100,
    antiGrab = false,
    antiRagdoll = false,
    antiExplosion = false,
    antiVoid = false,
    antiLag = false,
    antiFire = false,
    antiBlob = false,
    antiKick = false,
    antiFling = false,
    antiBanana = false,
    antiDsync = true,
    esp = false,
    chams = false,
    loopEnabled = false,
    loopType = "Kill",
    lagServer = false,
    lagIntensity = 100,
    explosionType = "BombMissile",
    explosionTarget = "Mouse",
    explosionDelay = 0,
    explosionAmmount = 5,
    grabTP = false,
    freezeGrab = false,
    masslessGrab = false,
    ragdollGrab = false,
    crazyGrab = false,
    spinGrab = false,
    ultraGrab = false,
    radioactiveGrab = false,
    infiniteZoom = false,
    godMode = false,
    safeReset = false,
    breakBarriers = false,
    autoSpin = false,
    autoSaveTime = false,
    autoClaimPlot = false,
    autoGucci = false,
    controlCreature = false,
    anchorGrab = false,
    compileParts = false,
    perspectiveGrab = false,
    tearAura = false,
    tornadoAura = false,
    blackholeAura = false,
    silentAimV2 = false,
    longReach = false,
    clickTP = false,
    clickDelete = false
}

HFPS = {
    ESP = {},
    Chams = {},
    Anchored = {},
    Compiled = {},
    Tornado = {},
    LineColors = {},
    GrabbedParts = {},
    PoisonParts = {PoisonContainer, PoisonBigHole, PoisonSmallHole}
}

HList = {
    Whitelist = {},
    KillList = {},
    BlobList = {},
    LoopList = {},
    AnchoredParts = {},
    CompiledGroups = {}
}

HConn = {}

local function addToWhitelist(plr)
    if not table.find(HList.Whitelist, plr) then
        table.insert(HList.Whitelist, plr)
    end
end

local function removeFromWhitelist(plr)
    for i, v in pairs(HList.Whitelist) do
        if v == plr then
            table.remove(HList.Whitelist, i)
            break
        end
    end
end

local function isWhitelisted(plr)
    if not plr then return false end
    if table.find(HList.Whitelist, plr.Name) then
        return true
    end
    if plr:IsFriendsWith(LocalPlayer.UserId) then
        return true
    end
    return false
end

local function addToKillList(plr)
    if not table.find(HList.KillList, plr) then
        table.insert(HList.KillList, plr)
    end
end

local function removeFromKillList(plr)
    for i, v in pairs(HList.KillList) do
        if v == plr then
            table.remove(HList.KillList, i)
            break
        end
    end
end

local function addToLoopList(plr)
    if not table.find(HList.LoopList, plr) then
        table.insert(HList.LoopList, plr)
    end
end

local function removeFromLoopList(plr)
    for i, v in pairs(HList.LoopList) do
        if v == plr then
            table.remove(HList.LoopList, i)
            break
        end
    end
end

PlayerTab:CreateSection("WalkSpeed")

local walkSpeedToggle = PlayerTab:CreateToggle({
    Name = "WalkSpeed",
    CurrentValue = false,
    Callback = function(val)
        HOption.walkSpeed = val
        if not val and LocalPlayer.Character then
            local hum = getHumanoid()
            if hum then hum.WalkSpeed = 16 end
        end
    end
})

local walkSpeedSlider = PlayerTab:CreateSlider({
    Name = "Speed Value",
    Range = {16, 350},
    Increment = 5,
    Suffix = "",
    CurrentValue = 50,
    Callback = function(val)
        HOption.walkSpeedVal = val
        if HOption.walkSpeed and LocalPlayer.Character then
            local hum = getHumanoid()
            if hum then hum.WalkSpeed = val end
        end
    end
})

PlayerTab:CreateSection("JumpPower")

local jumpPowerToggle = PlayerTab:CreateToggle({
    Name = "JumpPower",
    CurrentValue = false,
    Callback = function(val)
        HOption.jumpPower = val
        if not val and LocalPlayer.Character then
            local hum = getHumanoid()
            if hum then hum.JumpPower = 50 end
        end
    end
})

local jumpPowerSlider = PlayerTab:CreateSlider({
    Name = "Jump Value",
    Range = {50, 500},
    Increment = 10,
    Suffix = "",
    CurrentValue = 100,
    Callback = function(val)
        HOption.jumpPowerVal = val
        if HOption.jumpPower and LocalPlayer.Character then
            local hum = getHumanoid()
            if hum then hum.JumpPower = val end
        end
    end
})

PlayerTab:CreateSection("Infinite Jump")

PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(val)
        HOption.infJump = val
    end
})

PlayerTab:CreateSection("Gravity")

local gravityToggle = PlayerTab:CreateToggle({
    Name = "Custom Gravity",
    CurrentValue = false,
    Callback = function(val)
        HOption.gravity = val
        if not val then
            Workspace.Gravity = 100
        end
    end
})

local gravitySlider = PlayerTab:CreateSlider({
    Name = "Gravity Value",
    Range = {-200, 300},
    Increment = 10,
    Suffix = "",
    CurrentValue = 50,
    Callback = function(val)
        HOption.gravityVal = val
        if HOption.gravity then
            Workspace.Gravity = val
        end
    end
})

PlayerTab:CreateSection("Noclip")

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(val)
        HOption.noclip = val
    end
})

PlayerTab:CreateSection("God Mode")

PlayerTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Callback = function(val)
        HOption.godMode = val
    end
})

PlayerTab:CreateSection("Super Strength")

PlayerTab:CreateToggle({
    Name = "Super Strength",
    CurrentValue = false,
    Callback = function(val)
        HOption.superStrength = val
    end
})

local playerStrengthSlider = PlayerTab:CreateSlider({
    Name = "Strength Value",
    Range = {100, 10000},
    Increment = 100,
    Suffix = "",
    CurrentValue = 1000,
    Callback = function(val)
        HOption.strength = val
    end
})

PlayerTab:CreateSection("Safe Reset")

PlayerTab:CreateToggle({
    Name = "Safe Reset",
    CurrentValue = false,
    Callback = function(val)
        HOption.safeReset = val
        local rb = Instance.new("BindableEvent")
        rb.Event:Connect(function()
            if HOption.safeReset then
                local char = LocalPlayer.Character
                if char then
                    local hrp = getRoot()
                    local pos = hrp and hrp.CFrame
                    char:BreakJoints()
                    LocalPlayer.CharacterAdded:Wait()
                    task.wait(0.5)
                    local newHrp = getRoot()
                    if newHrp and pos then
                        newHrp.CFrame = pos
                    end
                end
            else
                if LocalPlayer.Character then
                    local hum = getHumanoid()
                    if hum then hum:ChangeState(Enum.HumanoidStateType.Dead) end
                end
            end
        end)
        StarterGui:SetCore("ResetButtonCallback", rb)
    end
})

PlayerTab:CreateSection("Break Barriers")

PlayerTab:CreateButton({
    Name = "Break House Barriers",
    Callback = function()
        HOption.breakBarriers = true
        local pos = Vector3.new(263.4, -4.79, 466.8)
        local spawnPos = CFrame.new(263.5, -4.5, 486.9)
        local conn = Workspace.ChildAdded:Connect(function(child)
            if HOption.breakBarriers and child.Name == "Part" and (child.Position - pos).Magnitude <= 2 then
                HOption.breakBarriers = false
                conn:Disconnect()
                for _, plot in pairs(Workspace.Plots:GetChildren()) do
                    local barrier = plot:FindFirstChild("Barrier")
                    if barrier then
                        for _, part in pairs(barrier:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end
                OrionLib:MakeNotification({Name = "Success", Content = "Barriers destroyed!", Time = 3})
            end
        end)
        for i = 1, 10 do
            if not HOption.breakBarriers then break end
            spawnToy("BallSnowball", spawnPos)
            task.wait(1)
        end
        if HOption.breakBarriers then
            HOption.breakBarriers = false
            conn:Disconnect()
            OrionLib:MakeNotification({Name = "Failed", Content = "Could not destroy barriers", Time = 3})
        end
    end
})

PlayerTab:CreateSection("Auto Spin (Coins)")

PlayerTab:CreateToggle({
    Name = "Auto Spin",
    CurrentValue = false,
    Callback = function(val)
        HOption.autoSpin = val
    end
})

PlayerTab:CreateSection("Auto Save House Time")

PlayerTab:CreateToggle({
    Name = "Auto Save House Time",
    CurrentValue = false,
    Callback = function(val)
        HOption.autoSaveTime = val
    end
})

PlayerTab:CreateSection("Auto Claim Plot")

PlayerTab:CreateDropdown({
    Name = "Select Plot",
    Options = {"Plot1 (Common)", "Plot2 (Lumber)", "Plot3 (Witch)", "Plot4 (American)", "Plot5 (Chinese)"},
    CurrentOption = {"Plot3 (Witch)"},
    MultipleOptions = false,
    Callback = function(val)
        HOption.selectedPlot = val[1]:match("(%w+)")
    end
})

PlayerTab:CreateButton({
    Name = "Claim Plot",
    Callback = function()
        if not HOption.selectedPlot then return end
        local plot = Workspace.Plots:FindFirstChild(HOption.selectedPlot)
        if plot then
            local sign = plot:FindFirstChild("PlotSign")
            if sign then
                local plus = sign:FindFirstChild("Plus")
                if plus then
                    local grabPart = plus:FindFirstChild("PlusGrabPart")
                    if grabPart then
                        grabPart(grabPart, true)
                        task.wait(0.5)
                        ungrabPart(grabPart)
                    end
                end
            end
        end
    end
})

RunService.RenderStepped:Connect(function()
    if HOption.noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end
    if HOption.infiniteZoom then
        if Workspace:FindFirstChild("GrabParts") then
            local grabParts = Workspace.GrabParts
            local dragPart = grabParts:FindFirstChild("DragPart")
            if dragPart then
                local dist = (dragPart.Position - Camera.CFrame.Position).Magnitude
                if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                    dist = dist - 3
                elseif UserInputService:IsKeyDown(Enum.KeyCode.E) then
                    dist = dist + 3
                end
                ExtendGrabLine:FireServer(math.clamp(dist, 5, 500))
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if HOption.walkSpeed and LocalPlayer.Character then
        local hum = getHumanoid()
        if hum then
            hum.WalkSpeed = HOption.walkSpeedVal
        end
    end
    if HOption.gravity then
        Workspace.Gravity = HOption.gravityVal
    end
    if HOption.infJump then
        local hum = getHumanoid()
        if hum and hum:GetState() == Enum.HumanoidStateType.Freefall then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
    if HOption.godMode and LocalPlayer.Character then
        local hum = getHumanoid()
        if hum then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            hum.BreakJointsOnDeath = false
        end
    end
    if HOption.autoSpin then
        local slots = Workspace.Slots
        if slots then
            local allNeon = true
            for _, slot in pairs(slots:GetChildren()) do
                local light = slot:FindFirstChild("SlotHandle")
                if light then
                    local ball = light:FindFirstChild("LightBall")
                    if ball and ball.Material ~= Enum.Material.Neon then
                        allNeon = false
                        break
                    end
                end
            end
            if allNeon then
                local handle = nil
                for _, slot in pairs(slots:GetChildren()) do
                    local slotHandle = slot:FindFirstChild("SlotHandle")
                    if slotHandle then
                        handle = slotHandle:FindFirstChild("Handle")
                        if handle then
                            break
                        end
                    end
                end
                if handle then
                    grabPart(handle, false)
                end
            end
        end
    end
    if HOption.autoSaveTime then
        local inPlot = false
        for _, plot in pairs(Workspace.Plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            if sign then
                local owners = sign:FindFirstChild("ThisPlotsOwners")
                if owners then
                    for _, owner in pairs(owners:GetChildren()) do
                        if owner.Value == LocalPlayer.Name then
                            local timeLeft = owner:FindFirstChild("TimeRemainingNum")
                            if timeLeft and timeLeft.Value < 20 then
                                local plotItem = Workspace.PlotItems:FindFirstChild(plot.Name)
                                if plotItem then
                                    local area = plotItem:FindFirstChild("PlotArea")
                                    if area then
                                        local root = getRoot()
                                        if root then
                                            root.CFrame = area.CFrame
                                            task.wait(1)
                                        end
                                    end
                                end
                            end
                            inPlot = true
                            break
                        end
                    end
                end
            end
            if inPlot then break end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if HOption.infJump and LocalPlayer.Character then
        local hum = getHumanoid()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

CombatTab:CreateSection("Silent Aim")

local silentAimToggle = CombatTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(val)
        HOption.silentAim = val
    end
})

local silentAimRange = CombatTab:CreateSlider({
    Name = "Aim Range",
    Range = {10, 100},
    Increment = 5,
    Suffix = "Studs",
    CurrentValue = 50,
    Callback = function(val)
        HOption.silentRange = val
    end
})

local targetPartDrop = CombatTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "Torso", "HumanoidRootPart"},
    CurrentOption = {"Torso"},
    MultipleOptions = false,
    Callback = function(val)
        HOption.silentPart = val[1]
    end
})

CombatTab:CreateSection("Silent Aim V2")

CombatTab:CreateToggle({
    Name = "Silent Aim V2 (Mouse)",
    CurrentValue = false,
    Callback = function(val)
        HOption.silentAimV2 = val
    end
})

CombatTab:CreateSection("Kill Aura")

local killAuraToggle = CombatTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Callback = function(val)
        HOption.killAura = val
    end
})

local killAuraRange = CombatTab:CreateSlider({
    Name = "Kill Range",
    Range = {10, 50},
    Increment = 5,
    Suffix = "Studs",
    CurrentValue = 30,
    Callback = function(val)
        HOption.killRange = val
    end
})

CombatTab:CreateSection("Tear Aura")

CombatTab:CreateToggle({
    Name = "Tear Aura",
    CurrentValue = false,
    Callback = function(val)
        HOption.tearAura = val
    end
})

CombatTab:CreateSection("Bring Player")

local bringDropdown = CombatTab:CreateDropdown({
    Name = "Select Player",
    Options = getAllPlayers(),
    CurrentOption = {""},
    MultipleOptions = false,
    Callback = function(val)
        HOption.bringTarget = getPlayerFromName(val[1])
    end
})

CombatTab:CreateButton({
    Name = "Bring Player",
    Callback = function()
        if HOption.bringTarget and HOption.bringTarget.Character then
            local hrp = HOption.bringTarget.Character:FindFirstChild("HumanoidRootPart")
            local root = getRoot()
            if hrp and root then
                grabPart(hrp, true)
                task.wait(0.3)
                hrp.CFrame = root.CFrame + Vector3.new(0, 5, 0)
                ungrabPart(hrp)
            end
        end
    end
})

CombatTab:CreateButton({
    Name = "Kill Player",
    Callback = function()
        if HOption.bringTarget and HOption.bringTarget.Character then
            local hum = HOption.bringTarget.Character:FindFirstChild("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Dead)
            end
        end
    end
})

CombatTab:CreateButton({
    Name = "Fling Player",
    Callback = function()
        if HOption.bringTarget and HOption.bringTarget.Character then
            local hrp = HOption.bringTarget.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                grabPart(hrp, true)
                local bv = Instance.new("BodyVelocity", hrp)
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Vector3.new(0, 10000, 0)
                task.delay(1, function()
                    if bv then bv:Destroy() end
                end)
            end
        end
    end
})

CombatTab:CreateSection("Ragdoll Player")

CombatTab:CreateButton({
    Name = "Ragdoll Player",
    Callback = function()
        if HOption.bringTarget and HOption.bringTarget.Character then
            local hrp = HOption.bringTarget.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                RagdollRemote:FireServer(hrp, 0)
            end
        end
    end
})

CombatTab:CreateSection("Snowball Ragdoll")

CombatTab:CreateButton({
    Name = "Snowball Ragdoll Player",
    Callback = function()
        if HOption.bringTarget and HOption.bringTarget.Character then
            local head = HOption.bringTarget.Character:FindFirstChild("Head")
            if head then
                local toy = spawnToyAtHead("BallSnowball")
                if toy then
                    local sp = toy:FindFirstChild("SoundPart")
                    if sp then
                        grabPart(sp, true)
                        firetouchinterest(sp, head, 0)
                        task.delay(2, function()
                            deleteToy(toy)
                        end)
                    end
                end
            end
        end
    end
})

CombatTab:CreateSection("Banana Ragdoll")

CombatTab:CreateButton({
    Name = "Banana Ragdoll Player",
    Callback = function()
        if HOption.bringTarget and HOption.bringTarget.Character then
            local leg = HOption.bringTarget.Character:FindFirstChild("Right Leg") or HOption.bringTarget.Character:FindFirstChild("RightLowerLeg")
            if leg then
                local toy = spawnToyAtHead("FoodBanana")
                if toy then
                    local peel = toy:FindFirstChild("BananaPeel")
                    if peel then
                        grabPart(peel, true)
                        firetouchinterest(peel, leg, 0)
                        task.delay(2, function()
                            deleteToy(toy)
                        end)
                    end
                end
            end
        end
    end
})

CombatTab:CreateSection("Fire Player")

CombatTab:CreateButton({
    Name = "Fire Player",
    Callback = function()
        if HOption.bringTarget and HOption.bringTarget.Character then
            local hrp = HOption.bringTarget.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local toy = spawnToyAtHead("Campfire")
                if toy then
                    local firePart = toy:FindFirstChild("FirePlayerPart")
                    if firePart then
                        grabPart(firePart, true)
                        firePart.Position = hrp.Position
                        task.delay(3, function()
                            deleteToy(toy)
                        end)
                    end
                end
            end
        end
    end
})

CombatTab:CreateSection("Anti Kunai")

CombatTab:CreateButton({
    Name = "Anti Kunai Player",
    Callback = function()
        if HOption.bringTarget and HOption.bringTarget.Character then
            local leg = HOption.bringTarget.Character:FindFirstChild("Left Leg") or HOption.bringTarget.Character:FindFirstChild("LeftLowerLeg")
            if leg then
                local toy = spawnToyAtHead("SprayCanWD")
                if toy then
                    local remover = toy:FindFirstChild("StickyRemoverPart")
                    if remover then
                        grabPart(remover, true)
                        firetouchinterest(remover, leg, 0)
                        task.delay(2, function()
                            deleteToy(toy)
                        end)
                    end
                end
            end
        end
    end
})

local oldNamecall = nil
if hookmetamethod then
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if not checkcaller() and HOption.silentAim and self == Workspace then
            local method = getnamecallmethod()
            if method == "Raycast" then
                local nearest = nil
                local root = getRoot()
                if root then
                    local minDist = HOption.silentRange or 50
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr ~= LocalPlayer and plr.Character then
                            local target = plr.Character:FindFirstChild(HOption.silentPart)
                            if target then
                                local dist = (root.Position - target.Position).Magnitude
                                if dist < minDist then
                                    minDist = dist
                                    nearest = target
                                end
                            end
                        end
                    end
                end
                if nearest then
                    local args = {...}
                    if #args >= 2 then
                        local dir = (nearest.Position - args[1]).Unit * 1000
                        args[2] = dir
                        return oldNamecall(self, unpack(args))
                    end
                end
            end
        end
        return oldNamecall(self, ...)
    end)
end

RunService.Heartbeat:Connect(function()
    if HOption.killAura then
        local root = getRoot()
        if root then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and (root.Position - hrp.Position).Magnitude <= (HOption.killRange or 30) then
                        for _, poison in pairs(HFPS.PoisonParts) do
                            poison.CFrame = hrp.CFrame
                        end
                        task.wait()
                        for _, poison in pairs(HFPS.PoisonParts) do
                            poison.Position = Vector3.new(0, -500, 0)
                        end
                    end
                end
            end
        end
    end
    if HOption.tearAura then
        local root = getRoot()
        if root then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and (root.Position - hrp.Position).Magnitude <= 30 then
                        RagdollRemote:FireServer(hrp, 0)
                    end
                end
            end
        end
    end
    if HOption.silentAimV2 then
        local target = getClosestPlayerToCursor()
        if target and target.Character then
            local part = target.Character:FindFirstChild(HOption.silentPart) or target.Character:FindFirstChild("HumanoidRootPart")
            if part then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
            end
        end
    end
end)

GrabTab:CreateSection("Grab Mods")

GrabTab:CreateToggle({
    Name = "Kill Grab",
    CurrentValue = false,
    Callback = function(val)
        HOption.killGrab = val
    end
})

GrabTab:CreateToggle({
    Name = "Poison Grab",
    CurrentValue = false,
    Callback = function(val)
        HOption.poisonGrab = val
    end
})

GrabTab:CreateToggle({
    Name = "Radioactive Grab",
    CurrentValue = false,
    Callback = function(val)
        HOption.radioactiveGrab = val
    end
})

GrabTab:CreateToggle({
    Name = "Noclip Grab",
    CurrentValue = false,
    Callback = function(val)
        HOption.noclipGrab = val
    end
})

GrabTab:CreateToggle({
    Name = "Invisible Grab",
    CurrentValue = false,
    Callback = function(val)
        HOption.invisGrab = val
    end
})

GrabTab:CreateToggle({
    Name = "Super Strength Grab",
    CurrentValue = false,
    Callback = function(val)
        HOption.superStrength = val
    end
})

local grabStrengthSlider = GrabTab:CreateSlider({
    Name = "Strength Value",
    Range = {100, 10000},
    Increment = 100,
    Suffix = "",
    CurrentValue = 1000,
    Callback = function(val)
        HOption.strength = val
    end
})

GrabTab:CreateToggle({
    Name = "Massless Grab",
    CurrentValue = false,
    Callback = function(val)
        HOption.masslessGrab = val
    end
})

GrabTab:CreateToggle({
    Name = "Ragdoll Grab",
    CurrentValue = false,
    Callback = function(val)
        HOption.ragdollGrab = val
    end
})

GrabTab:CreateToggle({
    Name = "Crazy Grab",
    CurrentValue = false,
    Callback = function(val)
        HOption.crazyGrab = val
    end
})

GrabTab:CreateToggle({
    Name = "Spin Grab",
    CurrentValue = false,
    Callback = function(val)
        HOption.spinGrab = val
    end
})

GrabTab:CreateToggle({
    Name = "Ultra Grab",
    CurrentValue = false,
    Callback = function(val)
        HOption.ultraGrab = val
    end
})

GrabTab:CreateToggle({
    Name = "Infinite Zoom (Q/E)",
    CurrentValue = false,
    Callback = function(val)
        HOption.infiniteZoom = val
    end
})

GrabTab:CreateSection("Line Mods")

GrabTab:CreateToggle({
    Name = "Invisible Line",
    CurrentValue = false,
    Callback = function(val)
        HOption.invisLine = val
        if val then
            CreateGrabLine:FireServer()
        end
    end
})

GrabTab:CreateToggle({
    Name = "Further Extend",
    CurrentValue = false,
    Callback = function(val)
        HOption.furtherExtend = val
        if val then
            ExtendGrabLine:FireServer(HOption.extendDist)
        end
    end
})

local extendSlider = GrabTab:CreateSlider({
    Name = "Extend Distance",
    Range = {10, 500},
    Increment = 10,
    Suffix = "Studs",
    CurrentValue = 100,
    Callback = function(val)
        HOption.extendDist = val
        if HOption.furtherExtend then
            ExtendGrabLine:FireServer(val)
        end
    end
})

GrabTab:CreateToggle({
    Name = "Crazy Line",
    CurrentValue = false,
    Callback = function(val)
        HOption.crazyLine = val
    end
})

GrabTab:CreateSection("Anchor Grab")

GrabTab:CreateToggle({
    Name = "Anchor Grab",
    CurrentValue = false,
    Callback = function(val)
        HOption.anchorGrab = val
    end
})

GrabTab:CreateToggle({
    Name = "Compile Parts",
    CurrentValue = false,
    Callback = function(val)
        HOption.compileParts = val
    end
})

GrabTab:CreateButton({
    Name = "Unanchor All",
    Callback = function()
        for _, data in pairs(HFPS.Anchored) do
            if data and data.BodyPosition then
                data.BodyPosition:Destroy()
            end
            if data and data.BodyGyro then
                data.BodyGyro:Destroy()
            end
            if data and data.Model then
                data.Model:SetAttribute("IsAnchored", false)
            end
        end
        HFPS.Anchored = {}
        HList.AnchoredParts = {}
    end
})

GrabTab:CreateButton({
    Name = "Disassemble All",
    Callback = function()
        for _, group in pairs(HList.CompiledGroups) do
            for _, data in pairs(group) do
                if data.BodyPosition then
                    data.BodyPosition:Destroy()
                end
                if data.BodyGyro then
                    data.BodyGyro:Destroy()
                end
                if data.Model then
                    data.Model:SetAttribute("Glue", false)
                    data.Model:SetAttribute("GluePrimary", false)
                end
            end
        end
        HList.CompiledGroups = {}
        HFPS.Compiled = {}
    end
})

GrabTab:CreateSection("Perspective Grab")

GrabTab:CreateToggle({
    Name = "Perspective Grab",
    CurrentValue = false,
    Callback = function(val)
        HOption.perspectiveGrab = val
    end
})

local perspectiveSpeed = GrabTab:CreateSlider({
    Name = "Perspective Speed",
    Range = {50, 150},
    Increment = 5,
    Suffix = "",
    CurrentValue = 50,
    Callback = function(val)
        HOption.perspectiveSpeed = val
    end
})

local anchorConnection = nil
local compileConnection = nil
local anchorParts = {}

local function anchorPart(part)
    if not part or not part.Parent then return end
    local model = part.Parent
    if model:IsA("Model") and not model:GetAttribute("IsAnchored") then
        local bp = Instance.new("BodyPosition", part)
        local bg = Instance.new("BodyGyro", part)
        bp.Name = "AnchorBP"
        bg.Name = "AnchorBG"
        bp.P = 40000
        bp.D = 950
        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bp.Position = part.Position
        bg.P = 40000
        bg.D = 950
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.CFrame = part.CFrame
        model:SetAttribute("IsAnchored", true)
        table.insert(HFPS.Anchored, {Model = model, BodyPosition = bp, BodyGyro = bg, Part = part})
        table.insert(HList.AnchoredParts, model)
        local sb = Instance.new("SelectionBox", model)
        sb.Adornee = model
        sb.Color3 = Color3.fromRGB(0, 255, 0)
        sb.SurfaceColor3 = Color3.fromRGB(0, 100, 0)
        sb.LineThickness = 0.03
        sb.Transparency = 0.5
        table.insert(HFPS.Anchored, {SelectionBox = sb})
    end
end

local function unanchorPart(model)
    for i, data in pairs(HFPS.Anchored) do
        if data.Model == model then
            if data.BodyPosition then data.BodyPosition:Destroy() end
            if data.BodyGyro then data.BodyGyro:Destroy() end
            if data.SelectionBox then data.SelectionBox:Destroy() end
            table.remove(HFPS.Anchored, i)
            break
        end
    end
    for i, m in pairs(HList.AnchoredParts) do
        if m == model then
            table.remove(HList.AnchoredParts, i)
            break
        end
    end
    model:SetAttribute("IsAnchored", false)
end

local function compileGroup(primaryPart)
    local group = {}
    local primaryModel = primaryPart.Parent
    local primaryPartInst = primaryPart
    for _, data in pairs(HFPS.Anchored) do
        if data.Model ~= primaryModel and data.Model:GetAttribute("IsAnchored") then
            local offset = primaryPartInst.CFrame:ToObjectSpace(data.Part.CFrame)
            table.insert(group, {
                Model = data.Model,
                Part = data.Part,
                Offset = offset,
                BodyPosition = data.BodyPosition,
                BodyGyro = data.BodyGyro
            })
            data.Model:SetAttribute("Glue", true)
        end
    end
    primaryModel:SetAttribute("GluePrimary", true)
    table.insert(HList.CompiledGroups, {Primary = primaryModel, Group = group})
    table.insert(HFPS.Compiled, {Primary = primaryModel, Group = group})
    for _, data in pairs(group) do
        if data.BodyPosition and data.BodyGyro then
            data.BodyPosition.P = 40000
            data.BodyPosition.D = 200
            data.BodyGyro.P = 40000
            data.BodyGyro.D = 200
        end
    end
    local sb = Instance.new("SelectionBox", primaryModel)
    sb.Adornee = primaryModel
    sb.Color3 = Color3.fromRGB(255, 255, 0)
    sb.SurfaceColor3 = Color3.fromRGB(100, 100, 0)
    sb.LineThickness = 0.03
    sb.Transparency = 0.5
    table.insert(HFPS.Compiled, {SelectionBox = sb})
end

local function updateCompiledGroups()
    for _, group in pairs(HList.CompiledGroups) do
        if group.Primary and group.Primary.Parent then
            local primaryPart = group.Primary:FindFirstChild("HumanoidRootPart") or group.Primary:FindFirstChild("Head") or group.Primary:FindFirstChildOfClass("BasePart")
            if primaryPart then
                for _, data in pairs(group.Group) do
                    if data.BodyPosition and data.BodyGyro and data.Offset then
                        data.BodyPosition.Position = (primaryPart.CFrame * data.Offset).Position
                        data.BodyGyro.CFrame = primaryPart.CFrame * data.Offset
                    end
                end
            end
        end
    end
end

Workspace.ChildAdded:Connect(function(child)
    if HOption.killGrab and child.Name == "GrabParts" then
        local gp = child:FindFirstChild("GrabPart")
        if gp and gp:FindFirstChild("WeldConstraint") then
            local part = gp.WeldConstraint.Part1
            if part and part.Parent and part.Parent:FindFirstChild("Humanoid") then
                task.spawn(function()
                    part.Parent.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                end)
            end
        end
    end
    if HOption.noclipGrab and child.Name == "GrabParts" then
        local gp = child:FindFirstChild("GrabPart")
        if gp and gp:FindFirstChild("WeldConstraint") then
            local part = gp.WeldConstraint.Part1
            if part and part.Parent then
                for _, v in pairs(part.Parent:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
                part.AncestryChanged:Connect(function()
                    for _, v in pairs(part.Parent:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = true
                        end
                    end
                end)
            end
        end
    end
    if HOption.invisGrab and child.Name == "GrabParts" then
        local beam = child:FindFirstChild("BeamPart")
        local drag = child:FindFirstChild("DragPart")
        local grab = child:FindFirstChild("GrabPart")
        if beam then beam:Destroy() end
        if drag then drag.Transparency = 1 end
        if grab then grab.Transparency = 1 end
        CreateGrabLine:FireServer()
        LocalPlayer.PlayerScripts.CharacterAndBeamMove.GrabNotifyEvent:Fire(false)
    end
    if HOption.superStrength and child.Name == "GrabParts" then
        local gp = child:FindFirstChild("GrabPart")
        if gp and gp:FindFirstChild("WeldConstraint") then
            local part = gp.WeldConstraint.Part1
            if part then
                local bv = Instance.new("BodyVelocity", part)
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Vector3.zero
                child:GetPropertyChangedSignal("Parent"):Connect(function()
                    if not child.Parent then
                        if UserInputService:GetLastInputType() == Enum.UserInputType.MouseButton2 then
                            bv.Velocity = Camera.CFrame.LookVector * HOption.strength
                        end
                        task.delay(2, function()
                            if bv then bv:Destroy() end
                        end)
                    end
                end)
            end
        end
    end
    if HOption.masslessGrab and child.Name == "GrabParts" then
        local dragPart = child:FindFirstChild("DragPart")
        if dragPart then
            local ao = dragPart:FindFirstChild("AlignOrientation")
            local ap = dragPart:FindFirstChild("AlignPosition")
            if ao then
                ao.MaxTorque = math.huge
                ao.Responsiveness = 200
            end
            if ap then
                ap.MaxForce = math.huge
                ap.Responsiveness = 200
            end
        end
    end
    if HOption.ragdollGrab and child.Name == "GrabParts" then
        local gp = child:FindFirstChild("GrabPart")
        if gp and gp:FindFirstChild("WeldConstraint") then
            local part = gp.WeldConstraint.Part1
            if part and part.Parent and part.Parent:FindFirstChild("Humanoid") then
                RagdollRemote:FireServer(part, 0)
            end
        end
    end
    if HOption.poisonGrab and child.Name == "GrabParts" then
        local gp = child:FindFirstChild("GrabPart")
        if gp and gp:FindFirstChild("WeldConstraint") then
            local part = gp.WeldConstraint.Part1
            if part then
                task.spawn(function()
                    while child.Parent and HOption.poisonGrab do
                        for _, poison in pairs(HFPS.PoisonParts) do
                            poison.CFrame = part.CFrame
                        end
                        task.wait()
                        for _, poison in pairs(HFPS.PoisonParts) do
                            poison.Position = Vector3.new(0, -500, 0)
                        end
                    end
                end)
            end
        end
    end
    if HOption.radioactiveGrab and child.Name == "GrabParts" then
        local gp = child:FindFirstChild("GrabPart")
        if gp and gp:FindFirstChild("WeldConstraint") then
            local part = gp.WeldConstraint.Part1
            if part then
                task.spawn(function()
                    while child.Parent and HOption.radioactiveGrab do
                        UFO.Position = part.Position
                        task.wait()
                        UFO.Position = Vector3.new(0, -500, 0)
                    end
                end)
            end
        end
    end
    if HOption.anchorGrab and child.Name == "GrabParts" then
        local gp = child:FindFirstChild("GrabPart")
        if gp and gp:FindFirstChild("WeldConstraint") then
            local part = gp.WeldConstraint.Part1
            if part then
                anchorPart(part)
            end
        end
    end
    if HOption.crazyGrab and child.Name == "GrabParts" then
        local gp = child:FindFirstChild("GrabPart")
        if gp and gp:FindFirstChild("WeldConstraint") then
            local part = gp.WeldConstraint.Part1
            if part then
                local bav = Instance.new("BodyAngularVelocity", part)
                bav.AngularVelocity = Vector3.new(0, 1000, 0)
                bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                task.delay(5, function()
                    if bav then bav:Destroy() end
                end)
            end
        end
    end
    if HOption.spinGrab and child.Name == "GrabParts" then
        local gp = child:FindFirstChild("GrabPart")
        if gp and gp:FindFirstChild("WeldConstraint") then
            local part = gp.WeldConstraint.Part1
            if part then
                local bav = Instance.new("BodyAngularVelocity", part)
                bav.AngularVelocity = Vector3.new(0, 100, 0)
                bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            end
        end
    end
    if HOption.ultraGrab and child.Name == "GrabParts" then
        local dragPart = child:FindFirstChild("DragPart")
        if dragPart then
            local ao = dragPart:FindFirstChild("AlignOrientation")
            local ap = dragPart:FindFirstChild("AlignPosition")
            if ao then
                ao.Responsiveness = 200
                ao.MaxTorque = math.huge
            end
            if ap then
                ap.Responsiveness = 200
                ap.MaxForce = math.huge
            end
        end
    end
    if HOption.perspectiveGrab and child.Name == "GrabParts" then
        local gp = child:FindFirstChild("GrabPart")
        if gp and gp:FindFirstChild("WeldConstraint") then
            local part = gp.WeldConstraint.Part1
            if part then
                task.spawn(function()
                    local root = getRoot()
                    if not root then return end
                    local origPos = root.CFrame
                    local speed = HOption.perspectiveSpeed or 50
                    local perspConn = RunService.Heartbeat:Connect(function(dt)
                        if not child.Parent or not HOption.perspectiveGrab then
                            perspConn:Disconnect()
                            return
                        end
                        local moveDir = getHumanoid() and getHumanoid().MoveDirection or Vector3.zero
                        root.CFrame = root.CFrame + moveDir * speed * dt
                        root.CFrame = CFrame.new(root.Position, part.Position)
                    end)
                    child.AncestryChanged:Connect(function()
                        if not child.Parent then
                            perspConn:Disconnect()
                            root.CFrame = origPos
                        end
                    end)
                end)
            end
        end
    end
    if HOption.crazyLine and child.Name == "GrabParts" then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local torso = getTorso()
                if torso then
                    CreateGrabLine:FireServer(torso, torso.CFrame)
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if HOption.compileParts then
        updateCompiledGroups()
    end
    if HOption.crazyLine then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local torso = plr.Character:FindFirstChild("Torso") or plr.Character:FindFirstChild("UpperTorso")
                if torso then
                    CreateGrabLine:FireServer(torso, torso.CFrame)
                end
            end
        end
    end
end)

AuraTab:CreateSection("Combat Auras")

AuraTab:CreateToggle({
    Name = "Poison Aura",
    CurrentValue = false,
    Callback = function(val)
        HOption.poisonAura = val
    end
})

AuraTab:CreateToggle({
    Name = "Fling Aura",
    CurrentValue = false,
    Callback = function(val)
        HOption.flingAura = val
    end
})

local flingStrengthSlider = AuraTab:CreateSlider({
    Name = "Fling Strength",
    Range = {400, 5000},
    Increment = 100,
    Suffix = "",
    CurrentValue = 1000,
    Callback = function(val)
        HOption.flingStrength = val
    end
})

AuraTab:CreateToggle({
    Name = "Attraction Aura",
    CurrentValue = false,
    Callback = function(val)
        HOption.attractAura = val
    end
})

AuraTab:CreateToggle({
    Name = "Grab Aura",
    CurrentValue = false,
    Callback = function(val)
        HOption.grabAura = val
    end
})

AuraTab:CreateToggle({
    Name = "Tornado Aura",
    CurrentValue = false,
    Callback = function(val)
        HOption.tornadoAura = val
    end
})

local tornadoSpeedSlider = AuraTab:CreateSlider({
    Name = "Tornado Speed",
    Range = {1, 20},
    Increment = 1,
    Suffix = "",
    CurrentValue = 5,
    Callback = function(val)
        HOption.tornadoSpeed = val
    end
})

local tornadoRangeSlider = AuraTab:CreateSlider({
    Name = "Tornado Range",
    Range = {10, 50},
    Increment = 5,
    Suffix = "Studs",
    CurrentValue = 25,
    Callback = function(val)
        HOption.tornadoRange = val
    end
})

AuraTab:CreateToggle({
    Name = "Blackhole Aura",
    CurrentValue = false,
    Callback = function(val)
        HOption.blackholeAura = val
    end
})

local blackholeStrengthSlider = AuraTab:CreateSlider({
    Name = "Blackhole Strength",
    Range = {500, 5000},
    Increment = 100,
    Suffix = "",
    CurrentValue = 1500,
    Callback = function(val)
        HOption.blackholeStrength = val
    end
})

local tornadoObjects = {}

RunService.Heartbeat:Connect(function()
    if HOption.poisonAura then
        local root = getRoot()
        if root then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and (root.Position - hrp.Position).Magnitude <= 30 then
                        for _, poison in pairs(HFPS.PoisonParts) do
                            poison.CFrame = hrp.CFrame
                        end
                        task.wait()
                        for _, poison in pairs(HFPS.PoisonParts) do
                            poison.Position = Vector3.new(0, -500, 0)
                        end
                    end
                end
            end
        end
    end
    if HOption.flingAura then
        local root = getRoot()
        if root then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and (root.Position - hrp.Position).Magnitude <= 25 then
                        if not hrp:FindFirstChild("FlingAuraBV") then
                            local bv = Instance.new("BodyVelocity", hrp)
                            bv.Name = "FlingAuraBV"
                            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            bv.Velocity = (hrp.Position - root.Position).Unit * HOption.flingStrength + Vector3.new(0, 500, 0)
                            task.delay(0.5, function()
                                if bv then bv:Destroy() end
                            end)
                        end
                    end
                end
            end
        end
    end
    if HOption.attractAura then
        local root = getRoot()
        if root then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and (root.Position - hrp.Position).Magnitude <= 35 then
                        local hum = plr.Character:FindFirstChild("Humanoid")
                        if hum then
                            hum.Sit = false
                            hum:MoveTo(root.Position)
                        end
                    end
                end
            end
        end
    end
    if HOption.grabAura then
        local root = getRoot()
        if root then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local head = plr.Character:FindFirstChild("Head")
                    if head and (root.Position - head.Position).Magnitude <= 25 then
                        if not isOwner(head) then
                            grabPart(head, false)
                        end
                    end
                end
            end
        end
    end
    if HOption.tornadoAura then
        local root = getRoot()
        if root then
            local angle = 0
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and (root.Position - hrp.Position).Magnitude <= HOption.tornadoRange then
                        if not hrp:FindFirstChild("TornadoBV") then
                            local bv = Instance.new("BodyVelocity", hrp)
                            bv.Name = "TornadoBV"
                            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            table.insert(tornadoObjects, {Part = hrp, BV = bv, Angle = angle})
                            angle = angle + math.pi * 2 / 8
                        end
                    end
                end
            end
            for _, obj in pairs(tornadoObjects) do
                if obj.Part and obj.Part.Parent then
                    obj.Angle = obj.Angle + (HOption.tornadoSpeed or 5) * 0.01
                    local x = math.cos(obj.Angle) * 15
                    local z = math.sin(obj.Angle) * 15
                    obj.BV.Velocity = Vector3.new(x, 50, z)
                else
                    if obj.BV then obj.BV:Destroy() end
                end
            end
            tornadoObjects = {}
        end
    end
    if HOption.blackholeAura then
        local root = getRoot()
        if root then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and (root.Position - hrp.Position).Magnitude <= 40 then
                        if not hrp:FindFirstChild("BlackholeBV") then
                            local bv = Instance.new("BodyVelocity", hrp)
                            bv.Name = "BlackholeBV"
                            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            bv.Velocity = (root.Position - hrp.Position).Unit * HOption.blackholeStrength
                            task.delay(1, function()
                                if bv then bv:Destroy() end
                            end)
                        end
                    end
                end
            end
        end
    end
end)

BlobTab:CreateSection("Blobman Functions")

local blobPlayerDropdown = BlobTab:CreateDropdown({
    Name = "Select Player",
    Options = getAllPlayers(),
    CurrentOption = {""},
    MultipleOptions = false,
    Callback = function(val)
        HOption.blobTarget = getPlayerFromName(val[1])
    end
})

BlobTab:CreateButton({
    Name = "Get Blobman",
    Callback = function()
        if not HOption.blobTarget then return end
        local root = getRoot()
        if not root then return end
        local blob = spawnToy("CreatureBlobman")
        if blob then
            local seat = blob:FindFirstChild("VehicleSeat")
            if seat then
                seat:Sit(getHumanoid())
                task.wait(0.5)
                local hrp = HOption.blobTarget.Character and HOption.blobTarget.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local leftDetector = blob:FindFirstChild("LeftDetector")
                    local rightDetector = blob:FindFirstChild("RightDetector")
                    local script = blob:FindFirstChild("BlobmanSeatAndOwnerScript")
                    if leftDetector and rightDetector and script then
                        local leftWeld = leftDetector:FindFirstChild("LeftWeld")
                        local rightWeld = rightDetector:FindFirstChild("RightWeld")
                        local creatureGrab = script:FindFirstChild("CreatureGrab")
                        if creatureGrab and leftWeld then
                            creatureGrab:FireServer(leftDetector, hrp, leftWeld)
                        end
                        if creatureGrab and rightWeld then
                            creatureGrab:FireServer(rightDetector, hrp, rightWeld)
                        end
                    end
                end
            end
        end
    end
})

BlobTab:CreateButton({
    Name = "Kick Player",
    Callback = function()
        if HOption.blobTarget and HOption.blobTarget.Character then
            local hrp = HOption.blobTarget.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bv = Instance.new("BodyPosition", hrp)
                bv.Position = hrp.Position + Vector3.new(0, 5000, 0)
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.D = 1000
                bv.P = 50000
                task.delay(1, function()
                    if bv then bv:Destroy() end
                end)
            end
        end
    end
})

BlobTab:CreateButton({
    Name = "Kill Player",
    Callback = function()
        if HOption.blobTarget and HOption.blobTarget.Character then
            local hum = HOption.blobTarget.Character:FindFirstChild("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Dead)
            end
        end
    end
})

BlobTab:CreateButton({
    Name = "Lock Player",
    Callback = function()
        if HOption.blobTarget and HOption.blobTarget.Character then
            local hrp = HOption.blobTarget.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Anchored = true
                task.delay(5, function()
                    if hrp then hrp.Anchored = false end
                end)
            end
        end
    end
})

BlobTab:CreateButton({
    Name = "Bring Player",
    Callback = function()
        if HOption.blobTarget and HOption.blobTarget.Character then
            local hrp = HOption.blobTarget.Character:FindFirstChild("HumanoidRootPart")
            local root = getRoot()
            if hrp and root then
                grabPart(hrp, true)
                hrp.CFrame = root.CFrame + Vector3.new(0, 5, 0)
                ungrabPart(hrp)
            end
        end
    end
})

BlobTab:CreateSection("Auto Gucci")

BlobTab:CreateToggle({
    Name = "Auto Gucci (Blobman)",
    CurrentValue = false,
    Callback = function(val)
        HOption.autoGucci = val
    end
})

BlobTab:CreateToggle({
    Name = "Auto Gucci (Tractor)",
    CurrentValue = false,
    Callback = function(val)
        HOption.autoGucciTractor = val
    end
})

BlobTab:CreateToggle({
    Name = "Auto Gucci (Train)",
    CurrentValue = false,
    Callback = function(val)
        HOption.autoGucciTrain = val
    end
})

local function autoGucciBlobman()
    if not HOption.autoGucci then return end
    local root = getRoot()
    if not root then return end
    local blob = SpawnedInToys:FindFirstChild("CreatureBlobman")
    if not blob then
        blob = spawnToy("CreatureBlobman")
        if not blob then return end
    end
    local seat = blob:FindFirstChild("VehicleSeat")
    if seat then
        seat:Sit(getHumanoid())
        task.wait(0.5)
        local rootPos = root.Position
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 1000, 0)
        task.delay(0.5, function()
            if bv then bv:Destroy() end
            root.CFrame = CFrame.new(rootPos)
        end)
    end
end

local function autoGucciTractor()
    if not HOption.autoGucciTractor then return end
    local tractor = SpawnedInToys:FindFirstChild("TractorOrange")
    if not tractor then
        tractor = spawnToy("TractorOrange")
        if not tractor then return end
    end
    local seat = tractor:FindFirstChildOfClass("VehicleSeat")
    if seat then
        seat:Sit(getHumanoid())
        task.wait(0.5)
        local root = getRoot()
        if root then
            local bv = Instance.new("BodyVelocity", root)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, 10000, 0)
        end
    end
end

local function autoGucciTrain()
    if not HOption.autoGucciTrain then return end
    local train = Workspace.Map.AlwaysHereTweenedObjects:FindFirstChild("Train")
    if train then
        local seat = nil
        for _, v in pairs(train:GetDescendants()) do
            if v:IsA("Seat") or v:IsA("VehicleSeat") then
                seat = v
                break
            end
        end
        if seat then
            seat:Sit(getHumanoid())
        end
    end
end

RunService.Heartbeat:Connect(function()
    if HOption.autoGucci then
        autoGucciBlobman()
    end
    if HOption.autoGucciTractor then
        autoGucciTractor()
    end
    if HOption.autoGucciTrain then
        autoGucciTrain()
    end
end)

VisualTab:CreateSection("ESP")

local espFillColor = Color3.fromRGB(255, 0, 0)
local espOutlineColor = Color3.fromRGB(0, 0, 0)
local espFillTrans = 0.5
local espOutlineTrans = 0

local espFillPicker = VisualTab:CreateColorPicker({
    Name = "Fill Color",
    Color = espFillColor,
    Callback = function(val)
        espFillColor = val
        for _, h in pairs(HFPS.ESP) do
            if h then h.FillColor = val end
        end
    end
})

local espFillSlider = VisualTab:CreateSlider({
    Name = "Fill Transparency",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = 0.5,
    Callback = function(val)
        espFillTrans = val
        for _, h in pairs(HFPS.ESP) do
            if h then h.FillTransparency = val end
        end
    end
})

local espOutlinePicker = VisualTab:CreateColorPicker({
    Name = "Outline Color",
    Color = espOutlineColor,
    Callback = function(val)
        espOutlineColor = val
        for _, h in pairs(HFPS.ESP) do
            if h then h.OutlineColor = val end
        end
    end
})

local espOutlineSlider = VisualTab:CreateSlider({
    Name = "Outline Transparency",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = 0,
    Callback = function(val)
        espOutlineTrans = val
        for _, h in pairs(HFPS.ESP) do
            if h then h.OutlineTransparency = val end
        end
    end
})

local espToggle = VisualTab:CreateToggle({
    Name = "ESP Players",
    CurrentValue = false,
    Callback = function(val)
        HOption.esp = val
        if val then
            HFPS.ESP = {}
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local hl = Instance.new("Highlight", plr.Character)
                    hl.FillColor = espFillColor
                    hl.OutlineColor = espOutlineColor
                    hl.FillTransparency = espFillTrans
                    hl.OutlineTransparency = espOutlineTrans
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    table.insert(HFPS.ESP, hl)
                end
            end
        else
            for _, h in pairs(HFPS.ESP) do
                if h then h:Destroy() end
            end
            HFPS.ESP = {}
        end
    end
})

VisualTab:CreateSection("Chams")

local chamsFillColor = Color3.fromRGB(0, 255, 0)
local chamsOutlineColor = Color3.fromRGB(0, 0, 0)
local chamsFillTrans = 0.3
local chamsOutlineTrans = 0

local chamsFillPicker = VisualTab:CreateColorPicker({
    Name = "Chams Fill",
    Color = chamsFillColor,
    Callback = function(val)
        chamsFillColor = val
        for _, h in pairs(HFPS.Chams) do
            if h then h.FillColor = val end
        end
    end
})

local chamsOutlinePicker = VisualTab:CreateColorPicker({
    Name = "Chams Outline",
    Color = chamsOutlineColor,
    Callback = function(val)
        chamsOutlineColor = val
        for _, h in pairs(HFPS.Chams) do
            if h then h.OutlineColor = val end
        end
    end
})

local chamsToggle = VisualTab:CreateToggle({
    Name = "Chams",
    CurrentValue = false,
    Callback = function(val)
        HOption.chams = val
        if val then
            HFPS.Chams = {}
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local hl = Instance.new("Highlight", plr.Character)
                    hl.FillColor = chamsFillColor
                    hl.OutlineColor = chamsOutlineColor
                    hl.FillTransparency = chamsFillTrans
                    hl.OutlineTransparency = chamsOutlineTrans
                    hl.DepthMode = Enum.HighlightDepthMode.Occluded
                    table.insert(HFPS.Chams, hl)
                end
            end
        else
            for _, h in pairs(HFPS.Chams) do
                if h then h:Destroy() end
            end
            HFPS.Chams = {}
        end
    end
})

VisualTab:CreateSection("Line Colors")

local lineColors = {}
for i = 1, 20 do
    lineColors[i] = Color3.fromRGB(255, 0, 0)
end

for i = 1, 10 do
    local colorPicker = VisualTab:CreateColorPicker({
        Name = "Color " .. i,
        Color = lineColors[i],
        Callback = function(val)
            lineColors[i] = val
            local cs = {}
            for j = 1, 20 do
                if j == 1 then
                    cs[j] = ColorSequenceKeypoint.new(0, lineColors[j])
                else
                    cs[j] = ColorSequenceKeypoint.new((j - 1) / 19, lineColors[j])
                end
            end
            UpdateLineColors:FireServer(ColorSequence.new(cs))
        end
    })
end

VisualTab:CreateToggle({
    Name = "RGB Line",
    CurrentValue = false,
    Callback = function(val)
        HOption.rgbLine = val
    end
})

RunService.Heartbeat:Connect(function()
    if HOption.rgbLine then
        local cs = {}
        for i = 1, 20 do
            local color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
            if i == 1 then
                cs[i] = ColorSequenceKeypoint.new(0, color)
            else
                cs[i] = ColorSequenceKeypoint.new((i - 1) / 19, color)
            end
        end
        UpdateLineColors:FireServer(ColorSequence.new(cs))
    end
end)

Players.PlayerAdded:Connect(function(plr)
    if HOption.esp and plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            local hl = Instance.new("Highlight", char)
            hl.FillColor = espFillColor
            hl.OutlineColor = espOutlineColor
            hl.FillTransparency = espFillTrans
            hl.OutlineTransparency = espOutlineTrans
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            table.insert(HFPS.ESP, hl)
        end)
    end
    if HOption.chams and plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            local hl = Instance.new("Highlight", char)
            hl.FillColor = chamsFillColor
            hl.OutlineColor = chamsOutlineColor
            hl.FillTransparency = chamsFillTrans
            hl.OutlineTransparency = chamsOutlineTrans
            hl.DepthMode = Enum.HighlightDepthMode.Occluded
            table.insert(HFPS.Chams, hl)
        end)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if HFPS.ESP then
        for i, h in pairs(HFPS.ESP) do
            if h and h.Parent and h.Parent:FindFirstChild(plr.Name) then
                h:Destroy()
                HFPS.ESP[i] = nil
            end
        end
    end
    if HFPS.Chams then
        for i, h in pairs(HFPS.Chams) do
            if h and h.Parent and h.Parent:FindFirstChild(plr.Name) then
                h:Destroy()
                HFPS.Chams[i] = nil
            end
        end
    end
end)

AntiTab:CreateSection("Protections")

AntiTab:CreateToggle({
    Name = "Anti Grab",
    CurrentValue = false,
    Callback = function(val)
        HOption.antiGrab = val
    end
})

AntiTab:CreateToggle({
    Name = "Anti Ragdoll",
    CurrentValue = false,
    Callback = function(val)
        HOption.antiRagdoll = val
    end
})

AntiTab:CreateToggle({
    Name = "Anti Explosion",
    CurrentValue = false,
    Callback = function(val)
        HOption.antiExplosion = val
    end
})

AntiTab:CreateToggle({
    Name = "Anti Void",
    CurrentValue = false,
    Callback = function(val)
        HOption.antiVoid = val
        if val then
            Workspace.FallenPartsDestroyHeight = -50000
        else
            Workspace.FallenPartsDestroyHeight = -100
        end
    end
})

AntiTab:CreateToggle({
    Name = "Anti Lag",
    CurrentValue = false,
    Callback = function(val)
        HOption.antiLag = val
        local script = LocalPlayer.PlayerScripts:FindFirstChild("CharacterAndBeamMove")
        if script then
            script.Disabled = val
        end
    end
})

AntiTab:CreateToggle({
    Name = "Anti Fire",
    CurrentValue = false,
    Callback = function(val)
        HOption.antiFire = val
    end
})

AntiTab:CreateToggle({
    Name = "Anti Blobman",
    CurrentValue = false,
    Callback = function(val)
        HOption.antiBlob = val
    end
})

AntiTab:CreateToggle({
    Name = "Anti Kick",
    CurrentValue = false,
    Callback = function(val)
        HOption.antiKick = val
    end
})

AntiTab:CreateToggle({
    Name = "Anti Fling",
    CurrentValue = false,
    Callback = function(val)
        HOption.antiFling = val
    end
})

AntiTab:CreateToggle({
    Name = "Anti Banana",
    CurrentValue = false,
    Callback = function(val)
        HOption.antiBanana = val
    end
})

AntiTab:CreateToggle({
    Name = "Anti Dsync",
    CurrentValue = true,
    Callback = function(val)
        HOption.antiDsync = val
    end
})

AntiTab:CreateSection("Anti Input Lag")

AntiTab:CreateToggle({
    Name = "Anti Input Lag",
    CurrentValue = false,
    Callback = function(val)
        HOption.antiInputLag = val
    end
})

local antiInputToy = AntiTab:CreateDropdown({
    Name = "Anti Input Toy",
    Options = {"FoodDonut", "FoodApple", "FoodBanana", "FoodOrange"},
    CurrentOption = {"FoodDonut"},
    MultipleOptions = false,
    Callback = function(val)
        HOption.antiInputToy = val[1]
    end
})

RunService.Heartbeat:Connect(function()
    if HOption.antiGrab and LocalPlayer.Character then
        local root = getRoot()
        if root then
            if LocalPlayer.IsHeld.Value then
                root.Anchored = true
                Struggle:FireServer()
                RagdollRemote:FireServer(root, 0)
            else
                root.Anchored = false
            end
        end
    end
    if HOption.antiRagdoll and LocalPlayer.Character then
        local hum = getHumanoid()
        if hum and hum.Ragdolled and hum.Ragdolled.Value then
            hum.Ragdolled.Value = false
            RagdollRemote:FireServer(getRoot(), 0)
        end
    end
    if HOption.antiVoid and LocalPlayer.Character then
        local root = getRoot()
        if root and root.Position.Y < -300 then
            root.CFrame = CFrame.new(0, 10, 0)
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end
    if HOption.antiFire and LocalPlayer.Character then
        local root = getRoot()
        if root then
            local firePart = root:FindFirstChild("FirePlayerPart")
            if firePart and firePart:FindFirstChild("CanBurn") and firePart.CanBurn.Value then
                firetouchinterest(firePart, ExtinguishPart, 0)
            end
        end
    end
    if HOption.antiBlob and LocalPlayer.Character then
        local hum = getHumanoid()
        if hum and hum.SeatPart and hum.SeatPart.Parent and hum.SeatPart.Parent.Name == "CreatureBlobman" then
            local blob = hum.SeatPart.Parent
            local leftDetector = blob:FindFirstChild("LeftDetector")
            local rightDetector = blob:FindFirstChild("RightDetector")
            if leftDetector and rightDetector then
                local leftWeld = leftDetector:FindFirstChild("LeftWeld")
                local rightWeld = rightDetector:FindFirstChild("RightWeld")
                if leftWeld then leftWeld.Enabled = false end
                if rightWeld then rightWeld.Enabled = false end
                hum.Sit = false
            end
        end
    end
    if HOption.antiKick and LocalPlayer.Character then
        local kunai = SpawnedInToys:FindFirstChild("NinjaKunai")
        if not kunai then
            kunai = spawnToyAtHead("NinjaKunai")
        end
        if kunai then
            local stickyPart = kunai:FindFirstChild("StickyPart")
            if stickyPart then
                if not isOwner(stickyPart) then
                    grabPart(stickyPart, true)
                end
                local leg = LocalPlayer.Character:FindFirstChild("Left Leg") or LocalPlayer.Character:FindFirstChild("LeftLowerLeg")
                if leg and not stickyPart:FindFirstChild("StickyWeld") then
                    StickyPartEvent:FireServer(stickyPart, leg, CFrame.new(0, -0.5, 0) * CFrame.Angles(0, 0, math.rad(90)))
                end
            end
        end
    end
    if HOption.antiFling and LocalPlayer.Character then
        local root = getRoot()
        if root then
            PhysicsService:SetPartCollisionGroup(root, "PlotPlayers")
        end
    else
        local root = getRoot()
        if root then
            PhysicsService:SetPartCollisionGroup(root, "Players")
        end
    end
    if HOption.antiBanana then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                for _, v in pairs(plr.Character:GetDescendants()) do
                    if v.Name == "BananaPeel" and v:IsA("BasePart") then
                        v.CanTouch = false
                    end
                end
            end
        end
        for _, toy in pairs(SpawnedInToys:GetChildren()) do
            if toy.Name == "FoodBanana" then
                local holdPart = toy:FindFirstChild("HoldPart")
                if holdPart then
                    local rigidConstraint = holdPart:FindFirstChild("RigidConstraint")
                    if rigidConstraint then
                        rigidConstraint.Enabled = false
                    end
                end
            end
        end
    end
    if HOption.antiDsync then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp and hrp.Massless then
                    hrp.Massless = false
                end
            end
        end
    end
    if HOption.antiInputLag then
        if not HOption.antiInputToy then
            HOption.antiInputToy = "FoodDonut"
        end
        local toy = SpawnedInToys:FindFirstChild(HOption.antiInputToy)
        if not toy then
            toy = spawnToyAtHead(HOption.antiInputToy)
        end
        if toy then
            local holdPart = toy:FindFirstChild("HoldPart")
            if holdPart then
                local holdFunc = holdPart:FindFirstChild("HoldItemRemoteFunction")
                if holdFunc then
                    holdFunc:InvokeServer(toy, LocalPlayer.Character)
                end
            end
        end
    end
end)

Workspace.ChildAdded:Connect(function(child)
    if HOption.antiExplosion and child.Name == "Part" then
        local root = getRoot()
        if root and (root.Position - child.Position).Magnitude <= 18 then
            root.Anchored = true
            task.wait(0.1)
            root.Anchored = false
        end
    end
end)

if HOption.antiGrab then
    local head = getHead()
    if head then
        head.ChildAdded:Connect(function(child)
            if child.Name == "PartOwner" and HOption.antiGrab then
                Struggle:FireServer()
                RagdollRemote:FireServer(getRoot(), 0)
            end
        end)
    end
end

KeybindTab:CreateSection("Teleport")

KeybindTab:CreateKeybind({
    Name = "Teleport to Mouse",
    CurrentKeybind = "Z",
    HoldToInteract = false,
    Callback = function()
        local root = getRoot()
        if not root then return end
        local mouse = LocalPlayer:GetMouse()
        local hit = mouse.Hit
        if hit then
            root.CFrame = CFrame.new(hit.Position) + Vector3.new(0, 5, 0)
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end
})

KeybindTab:CreateKeybind({
    Name = "Click TP (Hold)",
    CurrentKeybind = "LeftAlt",
    HoldToInteract = true,
    Callback = function(hold)
        if hold then
            local root = getRoot()
            if not root then return end
            local mouse = LocalPlayer:GetMouse()
            local hit = mouse.Hit
            if hit then
                root.CFrame = CFrame.new(hit.Position) + Vector3.new(0, 5, 0)
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end
})

KeybindTab:CreateSection("Grab")

KeybindTab:CreateKeybind({
    Name = "Invisible Grab",
    CurrentKeybind = "X",
    HoldToInteract = false,
    Callback = function()
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Target
        if target then
            grabPart(target, true)
        end
    end
})

KeybindTab:CreateKeybind({
    Name = "Safe Grab",
    CurrentKeybind = "C",
    HoldToInteract = false,
    Callback = function()
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Target
        if target then
            local root = getRoot()
            if root then
                for i = 1, 10 do
                    root.CFrame = CFrame.new(target.Position) + Vector3.new(0, 5, 0)
                    SetNetworkOwner:FireServer(target, target.CFrame)
                    task.wait(0.05)
                end
            end
        end
    end
})

KeybindTab:CreateKeybind({
    Name = "Ungrab All",
    CurrentKeybind = "V",
    HoldToInteract = false,
    Callback = function()
        local grabParts = Workspace:FindFirstChild("GrabParts")
        if grabParts then
            local gp = grabParts:FindFirstChild("GrabPart")
            if gp and gp:FindFirstChild("WeldConstraint") then
                DestroyGrabLine:FireServer(gp.WeldConstraint.Part1)
            end
        end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local head = plr.Character:FindFirstChild("Head")
                if head then
                    DestroyGrabLine:FireServer(head)
                end
            end
        end
    end
})

KeybindTab:CreateSection("Combat")

KeybindTab:CreateKeybind({
    Name = "Kill Nearest",
    CurrentKeybind = "T",
    HoldToInteract = false,
    Callback = function()
        local nearest = getNearestPlayer()
        if nearest and nearest.Parent then
            local hum = nearest.Parent:FindFirstChild("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Dead)
            end
        end
    end
})

KeybindTab:CreateKeybind({
    Name = "Bring Nearest",
    CurrentKeybind = "B",
    HoldToInteract = false,
    Callback = function()
        local nearest = getNearestPlayer()
        if nearest and nearest.Parent then
            local hrp = nearest.Parent:FindFirstChild("HumanoidRootPart")
            local root = getRoot()
            if hrp and root then
                grabPart(hrp, true)
                hrp.CFrame = root.CFrame + Vector3.new(0, 5, 0)
                ungrabPart(hrp)
            end
        end
    end
})

KeybindTab:CreateKeybind({
    Name = "Fling Nearest",
    CurrentKeybind = "F",
    HoldToInteract = false,
    Callback = function()
        local nearest = getNearestPlayer()
        if nearest and nearest.Parent then
            local hrp = nearest.Parent:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bv = Instance.new("BodyVelocity", hrp)
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Vector3.new(0, 10000, 0)
                task.delay(1, function()
                    if bv then bv:Destroy() end
                end)
            end
        end
    end
})

KeybindTab:CreateSection("Animations")

KeybindTab:CreateKeybind({
    Name = "Jerk Off",
    CurrentKeybind = "J",
    HoldToInteract = true,
    Callback = function(hold)
        if LocalPlayer.Character then
            local hum = getHumanoid()
            if hum then
                local animator = hum:FindFirstChild("Animator")
                if animator then
                    local anim = Instance.new("Animation")
                    anim.AnimationId = "rbxassetid://168268306"
                    local track = animator:LoadAnimation(anim)
                    if hold then
                        track:Play()
                        while hold do
                            track.TimePosition = 0.3
                            task.wait(0.1)
                        end
                        track:Stop()
                    end
                end
            end
        end
    end
})

KeybindTab:CreateKeybind({
    Name = "Typing Animation",
    CurrentKeybind = "Y",
    HoldToInteract = true,
    Callback = function(hold)
        if LocalPlayer.Character then
            local hum = getHumanoid()
            if hum then
                local animator = hum:FindFirstChild("Animator")
                if animator then
                    local anim = Instance.new("Animation")
                    anim.AnimationId = "rbxassetid://18353618958"
                    local track = animator:LoadAnimation(anim)
                    if hold then
                        track:Play()
                    else
                        track:Stop()
                    end
                end
            end
        end
    end
})

KeybindTab:CreateKeybind({
    Name = "Crouch Animation",
    CurrentKeybind = "LeftControl",
    HoldToInteract = true,
    Callback = function(hold)
        if LocalPlayer.Character then
            local hum = getHumanoid()
            if hum then
                local animator = hum:FindFirstChild("Animator")
                if animator then
                    local anim = Instance.new("Animation")
                    anim.AnimationId = "rbxassetid://6980229055"
                    local track = animator:LoadAnimation(anim)
                    if hold then
                        track:Play()
                    else
                        track:Stop()
                    end
                end
            end
        end
    end
})

KeybindTab:CreateKeybind({
    Name = "Throwed Animation",
    CurrentKeybind = "R",
    HoldToInteract = false,
    Callback = function()
        if LocalPlayer.Character then
            local hum = getHumanoid()
            if hum then
                local animator = hum:FindFirstChild("Animator")
                if animator then
                    local anim = Instance.new("Animation")
                    anim.AnimationId = "rbxassetid://7047322890"
                    local track = animator:LoadAnimation(anim)
                    track:Play()
                end
            end
        end
    end
})

KeybindTab:CreateSection("Anchor")

KeybindTab:CreateKeybind({
    Name = "Anchor Object",
    CurrentKeybind = "K",
    HoldToInteract = false,
    Callback = function()
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Target
        if target then
            anchorPart(target)
        end
    end
})

KeybindTab:CreateKeybind({
    Name = "Unanchor Object",
    CurrentKeybind = "U",
    HoldToInteract = false,
    Callback = function()
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Target
        if target and target.Parent then
            unanchorPart(target.Parent)
        end
    end
})

KeybindTab:CreateKeybind({
    Name = "Compile Group",
    CurrentKeybind = "L",
    HoldToInteract = false,
    Callback = function()
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Target
        if target then
            compileGroup(target)
        end
    end
})

KeybindTab:CreateSection("Control")

KeybindTab:CreateKeybind({
    Name = "Control Creature",
    CurrentKeybind = "C",
    HoldToInteract = false,
    Callback = function()
        if HOption.controlCreature then
            HOption.controlCreature = false
            if HOption.controlCreatureConn then
                HOption.controlCreatureConn:Disconnect()
            end
            return
        end
        HOption.controlCreature = true
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Target
        if target then
            local char = getCharacterFromPart(target)
            if char and char:FindFirstChild("Humanoid") then
                local origChar = LocalPlayer.Character
                local origHum = getHumanoid()
                local origRoot = getRoot()
                HOption.controlCreatureConn = RunService.Heartbeat:Connect(function()
                    if not HOption.controlCreature or not char.Parent then
                        HOption.controlCreature = false
                        HOption.controlCreatureConn:Disconnect()
                        if origChar then
                            LocalPlayer.Character = origChar
                            Camera.CameraSubject = origHum
                        end
                        return
                    end
                    LocalPlayer.Character = char
                    Camera.CameraSubject = char:FindFirstChild("Humanoid")
                    if origRoot then
                        origRoot.CFrame = char:FindFirstChild("HumanoidRootPart").CFrame
                    end
                end)
            end
        end
    end
})

LoopTab:CreateSection("Player Loops")

local loopPlayers = {}

local loopPlayerDropdown = LoopTab:CreateDropdown({
    Name = "Select Player",
    Options = getAllPlayers(),
    CurrentOption = {""},
    MultipleOptions = false,
    Callback = function(val)
        local plr = getPlayerFromName(val[1])
        if plr and not table.find(loopPlayers, plr) then
            table.insert(loopPlayers, plr)
            addToLoopList(plr.Name)
        end
    end
})

LoopTab:CreateButton({
    Name = "Clear Loop List",
    Callback = function()
        loopPlayers = {}
        HList.LoopList = {}
    end
})

local loopTypeDropdown = LoopTab:CreateDropdown({
    Name = "Loop Type",
    Options = {"Kill", "Bring", "Fling", "Ragdoll", "Poison", "Fire", "Banana"},
    CurrentOption = {"Kill"},
    MultipleOptions = false,
    Callback = function(val)
        HOption.loopType = val[1]
    end
})

local loopToggle = LoopTab:CreateToggle({
    Name = "Enable Loop",
    CurrentValue = false,
    Callback = function(val)
        HOption.loopEnabled = val
    end
})

LoopTab:CreateSection("Kick Loop")

local kickLoopTarget = LoopTab:CreateDropdown({
    Name = "Kick Target",
    Options = getAllPlayers(),
    CurrentOption = {""},
    MultipleOptions = false,
    Callback = function(val)
        HOption.kickTarget = getPlayerFromName(val[1])
    end
})

local kickLoopToggle = LoopTab:CreateToggle({
    Name = "Loop Kick",
    CurrentValue = false,
    Callback = function(val)
        HOption.kickLoop = val
    end
})

LoopTab:CreateSection("Bring Loop")

local bringLoopTarget = LoopTab:CreateDropdown({
    Name = "Bring Target",
    Options = getAllPlayers(),
    CurrentOption = {""},
    MultipleOptions = false,
    Callback = function(val)
        HOption.bringLoopTarget = getPlayerFromName(val[1])
    end
})

local bringLoopToggle = LoopTab:CreateToggle({
    Name = "Loop Bring",
    CurrentValue = false,
    Callback = function(val)
        HOption.bringLoop = val
    end
})

LoopTab:CreateSection("Server Lag")

local lagToggle = LoopTab:CreateToggle({
    Name = "Lag Server",
    CurrentValue = false,
    Callback = function(val)
        HOption.lagServer = val
    end
})

local lagIntensitySlider = LoopTab:CreateSlider({
    Name = "Lag Intensity",
    Range = {10, 500},
    Increment = 10,
    Suffix = "",
    CurrentValue = 100,
    Callback = function(val)
        HOption.lagIntensity = val
    end
})

LoopTab:CreateSection("Packet Send")

local packetToggle = LoopTab:CreateToggle({
    Name = "Packet Send",
    CurrentValue = false,
    Callback = function(val)
        HOption.packetSend = val
    end
})

local packetValue = LoopTab:CreateTextbox({
    Name = "Packet Strings",
    Default = "1000",
    Callback = function(val)
        HOption.packetValue = tonumber(val) or 1000
    end
})

RunService.Heartbeat:Connect(function()
    if HOption.loopEnabled then
        for _, plr in pairs(loopPlayers) do
            if plr and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local hum = plr.Character:FindFirstChild("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    if HOption.loopType == "Kill" then
                        hum:ChangeState(Enum.HumanoidStateType.Dead)
                    elseif HOption.loopType == "Bring" then
                        local root = getRoot()
                        if root then
                            grabPart(hrp, true)
                            hrp.CFrame = root.CFrame + Vector3.new(0, 5, 0)
                            ungrabPart(hrp)
                        end
                    elseif HOption.loopType == "Fling" then
                        if not hrp:FindFirstChild("LoopFlingBV") then
                            local bv = Instance.new("BodyVelocity", hrp)
                            bv.Name = "LoopFlingBV"
                            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            bv.Velocity = Vector3.new(0, 10000, 0)
                            task.delay(0.5, function()
                                if bv then bv:Destroy() end
                            end)
                        end
                    elseif HOption.loopType == "Ragdoll" then
                        RagdollRemote:FireServer(hrp, 0)
                    elseif HOption.loopType == "Poison" then
                        for _, poison in pairs(HFPS.PoisonParts) do
                            poison.CFrame = hrp.CFrame
                        end
                        task.wait()
                        for _, poison in pairs(HFPS.PoisonParts) do
                            poison.Position = Vector3.new(0, -500, 0)
                        end
                    elseif HOption.loopType == "Fire" then
                        local toy = spawnToyAtHead("Campfire")
                        if toy then
                            local firePart = toy:FindFirstChild("FirePlayerPart")
                            if firePart then
                                firePart.Position = hrp.Position
                                task.delay(2, function()
                                    deleteToy(toy)
                                end)
                            end
                        end
                    elseif HOption.loopType == "Banana" then
                        local leg = plr.Character:FindFirstChild("Right Leg") or plr.Character:FindFirstChild("RightLowerLeg")
                        if leg then
                            local toy = spawnToyAtHead("FoodBanana")
                            if toy then
                                local peel = toy:FindFirstChild("BananaPeel")
                                if peel then
                                    firetouchinterest(peel, leg, 0)
                                    task.delay(2, function()
                                        deleteToy(toy)
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if HOption.kickLoop and HOption.kickTarget and HOption.kickTarget.Character then
        local hrp = HOption.kickTarget.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = Instance.new("BodyPosition", hrp)
            bv.Position = hrp.Position + Vector3.new(0, 5000, 0)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.D = 1000
            bv.P = 50000
        end
    end
    if HOption.bringLoop and HOption.bringLoopTarget and HOption.bringLoopTarget.Character then
        local hrp = HOption.bringLoopTarget.Character:FindFirstChild("HumanoidRootPart")
        local root = getRoot()
        if hrp and root then
            grabPart(hrp, true)
            hrp.CFrame = root.CFrame + Vector3.new(0, 5, 0)
            ungrabPart(hrp)
        end
    end
    if HOption.lagServer then
        for i = 1, (HOption.lagIntensity or 100) do
            CreateGrabLine:FireServer(Workspace.SpawnLocation, Workspace.SpawnLocation.CFrame)
        end
    end
    if HOption.packetSend then
        local amount = HOption.packetValue or 1000
        for i = 1, amount do
            CreateGrabLine:FireServer(Workspace.SpawnLocation, Workspace.SpawnLocation.CFrame)
        end
    end
end)

ExplosionTab:CreateSection("Explosions")

local explosionTypeDropdown = ExplosionTab:CreateDropdown({
    Name = "Explosion Type",
    Options = {"BombMissile", "FireworkMissile", "BombBalloon", "BombDarkMatter", "BallSnowball"},
    CurrentOption = {"BombMissile"},
    MultipleOptions = false,
    Callback = function(val)
        HOption.explosionType = val[1]
    end
})

local explosionTargetDropdown = ExplosionTab:CreateDropdown({
    Name = "Target",
    Options = {"Mouse", "Nearest Player", "All Players"},
    CurrentOption = {"Mouse"},
    MultipleOptions = false,
    Callback = function(val)
        HOption.explosionTarget = val[1]
    end
})

local explosionDelaySlider = ExplosionTab:CreateSlider({
    Name = "Explosion Delay",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "Seconds",
    CurrentValue = 0,
    Callback = function(val)
        HOption.explosionDelay = val
    end
})

local explosionAmmountSlider = ExplosionTab:CreateSlider({
    Name = "Explosion Ammount",
    Range = {1, 20},
    Increment = 1,
    Suffix = "",
    CurrentValue = 5,
    Callback = function(val)
        HOption.explosionAmmount = val
    end
})

ExplosionTab:CreateButton({
    Name = "Explode Once",
    Callback = function()
        local root = getRoot()
        if not root then return end
        local pos = nil
        if HOption.explosionTarget == "Mouse" then
            local mousePos = UserInputService:GetMouseLocation()
            local ray = Camera:ScreenPointToRay(mousePos.X, mousePos.Y)
            local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000)
            if result then
                pos = result.Position
            else
                pos = ray.Origin + ray.Direction * 1000
            end
        elseif HOption.explosionTarget == "Nearest Player" then
            local nearest = getNearestPlayer()
            if nearest then
                pos = nearest.Position
            end
        end
        if pos then
            local toy = spawnToy(HOption.explosionType)
            if toy then
                local hitbox = getHitboxPart(toy, HOption.explosionType)
                if hitbox then
                    explodeBomb(hitbox, hitbox, pos)
                end
                deleteToy(toy)
            end
        end
    end
})

ExplosionTab:CreateToggle({
    Name = "Auto Explode",
    CurrentValue = false,
    Callback = function(val)
        HOption.autoExplode = val
    end
})

RunService.Heartbeat:Connect(function()
    if HOption.autoExplode then
        local root = getRoot()
        if not root then return end
        local targets = {}
        if HOption.explosionTarget == "Mouse" then
            local mousePos = UserInputService:GetMouseLocation()
            local ray = Camera:ScreenPointToRay(mousePos.X, mousePos.Y)
            local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000)
            if result then
                targets = {result.Position}
            end
        elseif HOption.explosionTarget == "Nearest Player" then
            local nearest = getNearestPlayer()
            if nearest then
                targets = {nearest.Position}
            end
        elseif HOption.explosionTarget == "All Players" then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        table.insert(targets, hrp.Position)
                    end
                end
            end
        end
        for _, pos in pairs(targets) do
            for i = 1, HOption.explosionAmmount or 1 do
                local toy = spawnToy(HOption.explosionType)
                if toy then
                    local hitbox = getHitboxPart(toy, HOption.explosionType)
                    if hitbox then
                        explodeBomb(hitbox, hitbox, pos)
                    end
                    deleteToy(toy)
                end
                if HOption.explosionDelay > 0 then
                    task.wait(HOption.explosionDelay)
                end
            end
        end
    end
end)

TeleportTab:CreateSection("Location Teleports")

local locations = {
    ["Spawn"] = CFrame.new(0, 5, 0),
    ["Green House"] = CFrame.new(-520.812, -7.374, 69.908),
    ["Red House"] = CFrame.new(-453.869, -7.374, -140.031),
    ["Blue House"] = CFrame.new(479.196, 83.313, -274.814),
    ["Chinese House"] = CFrame.new(499.552, 123.313, -92.731),
    ["Purple House"] = CFrame.new(256.983, -7.374, 420.039),
    ["Farm"] = CFrame.new(-148.779, 59.755, -240.749),
    ["Ice Mountain"] = CFrame.new(-415.797, 230.622, 485.994),
    ["Secret Cave"] = CFrame.new(123.519, -7.374, 630.845),
    ["Sky Island"] = CFrame.new(57.608, 346.170, 348.660),
    ["Broken Bridge"] = CFrame.new(451.626, 163.315, 207.368),
    ["Void"] = CFrame.new(0, -49980, 0),
    ["Sky"] = CFrame.new(10000, 10000, 10000)
}

local locationDropdown = TeleportTab:CreateDropdown({
    Name = "Select Location",
    Options = {"Spawn", "Green House", "Red House", "Blue House", "Chinese House", "Purple House", "Farm", "Ice Mountain", "Secret Cave", "Sky Island", "Broken Bridge", "Void", "Sky"},
    CurrentOption = {"Spawn"},
    MultipleOptions = false,
    Callback = function(val)
        HOption.teleportLocation = val[1]
    end
})

TeleportTab:CreateButton({
    Name = "Teleport",
    Callback = function()
        local root = getRoot()
        if root and HOption.teleportLocation then
            local cf = locations[HOption.teleportLocation]
            if cf then
                root.CFrame = cf
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end
})

TeleportTab:CreateSection("Player Teleports")

local teleportPlayerDropdown = TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = getAllPlayers(),
    CurrentOption = {""},
    MultipleOptions = false,
    Callback = function(val)
        HOption.teleportPlayer = getPlayerFromName(val[1])
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to Player",
    Callback = function()
        if HOption.teleportPlayer and HOption.teleportPlayer.Character then
            local root = getRoot()
            local targetRoot = HOption.teleportPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root and targetRoot then
                root.CFrame = targetRoot.CFrame + Vector3.new(0, 5, 0)
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end
})

TeleportTab:CreateButton({
    Name = "Bring Player to You",
    Callback = function()
        if HOption.teleportPlayer and HOption.teleportPlayer.Character then
            local root = getRoot()
            local targetRoot = HOption.teleportPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root and targetRoot then
                grabPart(targetRoot, true)
                targetRoot.CFrame = root.CFrame + Vector3.new(0, 5, 0)
                ungrabPart(targetRoot)
            end
        end
    end
})

TeleportTab:CreateSection("Part Teleports")

TeleportTab:CreateButton({
    Name = "Select Part",
    Callback = function()
        HOption.selectingPart = true
        OrionLib:MakeNotification({Name = "Selecting", Content = "Click on a part to teleport to it", Time = 3})
        local conn
        conn = UserInputService.InputBegan:Connect(function(input)
            if HOption.selectingPart and input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mouse = LocalPlayer:GetMouse()
                local target = mouse.Target
                if target then
                    HOption.selectedPart = target
                    HOption.selectingPart = false
                    conn:Disconnect()
                    OrionLib:MakeNotification({Name = "Selected", Content = "Part selected: " .. target.Name, Time = 2})
                end
            end
        end)
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to Selected Part",
    Callback = function()
        if HOption.selectedPart then
            local root = getRoot()
            if root then
                root.CFrame = HOption.selectedPart.CFrame + Vector3.new(0, 3, 0)
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end
})

TeleportTab:CreateButton({
    Name = "Copy Part Path",
    Callback = function()
        if HOption.selectedPart then
            local path = ""
            local current = HOption.selectedPart
            while current do
                if path == "" then
                    path = current.Name
                else
                    path = current.Name .. "." .. path
                end
                current = current.Parent
            end
            setclipboard(path)
            OrionLib:MakeNotification({Name = "Copied", Content = "Part path copied to clipboard", Time = 2})
        end
    end
})

MiscTab:CreateSection("FOV")

local fovToggle = MiscTab:CreateToggle({
    Name = "Custom FOV",
    CurrentValue = false,
    Callback = function(val)
        HOption.customFOV = val
        if not val then
            Camera.FieldOfView = 70
        end
    end
})

local fovSlider = MiscTab:CreateSlider({
    Name = "FOV Value",
    Range = {1, 120},
    Increment = 1,
    Suffix = "",
    CurrentValue = 70,
    Callback = function(val)
        HOption.fovValue = val
        if HOption.customFOV then
            Camera.FieldOfView = val
        end
    end
})

MiscTab:CreateSection("Time")

local timeSlider = MiscTab:CreateSlider({
    Name = "Time of Day",
    Range = {0, 24},
    Increment = 0.1,
    Suffix = "Hours",
    CurrentValue = 14,
    Callback = function(val)
        Lighting.ClockTime = val
    end
})

MiscTab:CreateToggle({
    Name = "Sync Time",
    CurrentValue = false,
    Callback = function(val)
        HOption.syncTime = val
    end
})

MiscTab:CreateSection("Graphics")

local graphicsDropdown = MiscTab:CreateDropdown({
    Name = "Graphics Quality",
    Options = {"Low", "Medium", "High", "Ultra"},
    CurrentOption = {"Medium"},
    MultipleOptions = false,
    Callback = function(val)
        HOption.graphics = val[1]
        if val[1] == "Low" then
            settings().Rendering.QualityLevel = 1
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
        elseif val[1] == "Medium" then
            settings().Rendering.QualityLevel = 3
            Lighting.GlobalShadows = true
        elseif val[1] == "High" then
            settings().Rendering.QualityLevel = 6
            Lighting.GlobalShadows = true
        elseif val[1] == "Ultra" then
            settings().Rendering.QualityLevel = 10
            Lighting.GlobalShadows = true
        end
    end
})

MiscTab:CreateToggle({
    Name = "Full Bright",
    CurrentValue = false,
    Callback = function(val)
        HOption.fullBright = val
        if val then
            Lighting.Brightness = 2
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        else
            Lighting.Brightness = 1
            Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
            Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        end
    end
})

MiscTab:CreateSection("Sounds")

MiscTab:CreateToggle({
    Name = "Mute Boombox",
    CurrentValue = false,
    Callback = function(val)
        HOption.muteBoombox = val
    end
})

MiscTab:CreateToggle({
    Name = "Mute Jukebox",
    CurrentValue = false,
    Callback = function(val)
        HOption.muteJukebox = val
    end
})

MiscTab:CreateSection("Camera")

MiscTab:CreateToggle({
    Name = "First Person",
    CurrentValue = false,
    Callback = function(val)
        if val then
            LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
        else
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
        end
    end
})

MiscTab:CreateToggle({
    Name = "Shift Lock",
    CurrentValue = false,
    Callback = function(val)
        LocalPlayer.DevEnableMouseLock = val
    end
})

MiscTab:CreateSection("Break Loops")

MiscTab:CreateButton({
    Name = "Break All Loops",
    Callback = function()
        HOption.loopEnabled = false
        HOption.kickLoop = false
        HOption.bringLoop = false
        HOption.autoExplode = false
        HOption.lagServer = false
        HOption.packetSend = false
        if loopToggle then loopToggle:Set(false) end
        if kickLoopToggle then kickLoopToggle:Set(false) end
        if bringLoopToggle then bringLoopToggle:Set(false) end
        OrionLib:MakeNotification({Name = "Loops Broken", Content = "All loops have been stopped", Time = 2})
    end
})

Workspace.DescendantAdded:Connect(function(child)
    if HOption.muteBoombox and child.Name == "Boombox" then
        local speaker = child:FindFirstChild("Speaker")
        if speaker then speaker:Destroy() end
    end
    if HOption.muteJukebox and (child.Name == "JukeboxOrange" or child.Name == "JukeboxBlue" or child.Name == "Jukebox") then
        local speakerPart = child:FindFirstChild("SpeakerPart")
        if speakerPart then speakerPart:Destroy() end
    end
end)

if HOption.syncTime then
    task.spawn(function()
        while HOption.syncTime do
            local success, data = pcall(function()
                return game:HttpGet("https://timeapi.io/api/time/current/zone?timeZone=UTC")
            end)
            if success and data then
                local decoded = HttpService:JSONDecode(data)
                if decoded and decoded.hour then
                    Lighting.TimeOfDay = string.format("%02d:%02d:%02d", decoded.hour, decoded.minute, decoded.seconds)
                end
            end
            task.wait(60)
        end
    end)
end

ConfigTab:CreateSection("UI Settings")

ConfigTab:CreateInput({
    Name = "Window Name",
    PlaceholderText = "NyPlus Hub",
    Callback = function(val)
        if val and val ~= "" then
            Window:SetName({val, "#FFFFFF"})
        end
    end
})

ConfigTab:CreateInput({
    Name = "Window Icon",
    PlaceholderText = "rbxassetid://...",
    Callback = function(val)
        if val and val ~= "" then
            Window:ChangeIcon(val)
        end
    end
})

ConfigTab:CreateSection("Discord")

ConfigTab:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/nyplushub")
        OrionLib:MakeNotification({Name = "Copied", Content = "Discord link copied to clipboard", Time = 2})
    end
})

ConfigTab:CreateSection("Credits")

ConfigTab:CreateParagraph("NyPlus Hub", "Made by NyPlus Team\nVersion: 2.0.0\n\nThanks to all contributors!")

WhitelistTab:CreateSection("Whitelist Management")

local whitelistDropdown = WhitelistTab:CreateDropdown({
    Name = "Select Player",
    Options = getAllPlayers(),
    CurrentOption = {""},
    MultipleOptions = false,
    Callback = function(val)
        HOption.whitelistPlayer = getPlayerFromName(val[1])
    end
})

WhitelistTab:CreateButton({
    Name = "Add to Whitelist",
    Callback = function()
        if HOption.whitelistPlayer then
            addToWhitelist(HOption.whitelistPlayer.Name)
            OrionLib:MakeNotification({Name = "Added", Content = HOption.whitelistPlayer.Name .. " added to whitelist", Time = 2})
        end
    end
})

WhitelistTab:CreateButton({
    Name = "Remove from Whitelist",
    Callback = function()
        if HOption.whitelistPlayer then
            removeFromWhitelist(HOption.whitelistPlayer.Name)
            OrionLib:MakeNotification({Name = "Removed", Content = HOption.whitelistPlayer.Name .. " removed from whitelist", Time = 2})
        end
    end
})

WhitelistTab:CreateButton({
    Name = "Clear Whitelist",
    Callback = function()
        HList.Whitelist = {}
        OrionLib:MakeNotification({Name = "Cleared", Content = "Whitelist cleared", Time = 2})
    end
})

WhitelistTab:CreateSection("Kill List")

local killListDropdown = WhitelistTab:CreateDropdown({
    Name = "Select Player",
    Options = getAllPlayers(),
    CurrentOption = {""},
    MultipleOptions = false,
    Callback = function(val)
        HOption.killListPlayer = getPlayerFromName(val[1])
    end
})

WhitelistTab:CreateButton({
    Name = "Add to Kill List",
    Callback = function()
        if HOption.killListPlayer then
            addToKillList(HOption.killListPlayer.Name)
            OrionLib:MakeNotification({Name = "Added", Content = HOption.killListPlayer.Name .. " added to kill list", Time = 2})
        end
    end
})

WhitelistTab:CreateButton({
    Name = "Remove from Kill List",
    Callback = function()
        if HOption.killListPlayer then
            removeFromKillList(HOption.killListPlayer.Name)
            OrionLib:MakeNotification({Name = "Removed", Content = HOption.killListPlayer.Name .. " removed from kill list", Time = 2})
        end
    end
})

WhitelistTab:CreateButton({
    Name = "Clear Kill List",
    Callback = function()
        HList.KillList = {}
        OrionLib:MakeNotification({Name = "Cleared", Content = "Kill list cleared", Time = 2})
    end
})

OrionLib:Init()

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    HOption.walkSpeed = false
    HOption.jumpPower = false
    HOption.gravity = false
    HOption.noclip = false
    HOption.godMode = false
    if walkSpeedToggle then walkSpeedToggle:Set(false) end
    if jumpPowerToggle then jumpPowerToggle:Set(false) end
    if gravityToggle then gravityToggle:Set(false) end
end)

for _, v in pairs(Workspace.Plots:GetDescendants()) do
    if v.Name == "PlotBarrier" or v.Name == "PlotArea" then
        v.CanQuery = false
        v.CanCollide = false
    end
end

local lineColorsSequence = {}
for i = 1, 20 do
    lineColorsSequence[i] = ColorSequenceKeypoint.new((i - 1) / 19, lineColors[i])
end
UpdateLineColors:FireServer(ColorSequence.new(lineColorsSequence))
