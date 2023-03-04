
local wait = task.wait
local spawn = task.spawn
local Players = game:GetService("Players")
local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService('VirtualInputManager')
local TeleportService = game:GetService("TeleportService")
local Distance

for i,v in pairs(getconnections(Player.Idled)) do
    v:Disable()
end 
RunService.Stepped:connect(
    function()
        sethiddenproperty(Player, "SimulationRadius", 1000)
    end
)




local Circle = Drawing.new("Circle")
Circle.Color = Color3.fromRGB(22, 13, 56)
Circle.Thickness = 1
Circle.Radius = 250
Circle.Visible = false 
Circle.NumSides = 1000
Circle.Filled = false
Circle.Transparency = 1

RunService.RenderStepped:Connect(
    function()
        local Mouse = UserInputService:GetMouseLocation()
        Circle.Position = Vector2.new(Mouse.X, Mouse.Y)
    end
)


local Shoot = false

function FreeForAll(v)
    if Settings.FreeForAll == false or Settings.T.FreeForAll == false then
        if Player.Team == v.Team then
            return false
        else
            return true
        end
    else
        return true
    end
end

function NotObstructing(i, v)
    if Settings.WallCheck then
        c = Workspace.CurrentCamera.CFrame.p
        a = Ray.new(c, i - c)
        f = Workspace:FindPartOnRayWithIgnoreList(a, v)
        return f == nil
    else
        return true
    end
end
UserInputService.InputBegan:Connect(
    function(v)
        if v.UserInputType == Enum.UserInputType.MouseButton2 then
            Shoot = true
        end
    end
)

UserInputService.InputEnded:Connect(
    function(v)
        if v.UserInputType == Enum.UserInputType.MouseButton2 then
            Shoot = false
        end
    end
)

function GetClosestToCuror()
    Closest = math.huge
    Target = nil
    for _, v in pairs(game:GetService("Workspace").Zombies:GetChildren()) do
            if v and v:FindFirstChild("HumanoidRootPart") and
                    v:FindFirstChild("Humanoid") and
                    v.Humanoid.Health ~= 0
             then
                Point, OnScreen = Workspace.CurrentCamera:WorldToViewportPoint(v.HumanoidRootPart.Position)
                if
                    OnScreen and
                        NotObstructing(
                            v.HumanoidRootPart.Position,
                            {Player.Character, v}
                        )
                 then
                    Distance =
                        (Vector2.new(Point.X, Point.Y) -
                        Vector2.new(Player:GetMouse().X, Player:GetMouse().Y)).magnitude
                    if Distance <= math.huge then
                        Closest = Distance
                        Target = v
                    end
                end
            end
        end
    return Target
end

game:GetService("RunService").RenderStepped:Connect(
    function() 
        if Settings.Enabled == false or Shoot == false then
            return
        end
        ClosestPlayer = GetClosestToCuror()
        if ClosestPlayer then
            local Mouse = game:GetService("UserInputService"):GetMouseLocation()
            local TargetPos = game.workspace.Camera:WorldToViewportPoint(ClosestPlayer.HumanoidRootPart.Position)
            mousemoverel(
                (TargetPos.X - Mouse.X) * Settings.Smoothness ,
                (TargetPos.Y - Mouse.Y) * Settings.Smoothness 
            )
        end
       
    end
)


Settings = {
    TeamCheck = false,
    Delay = 0.01,
    Enabled = false
}

local Aim = false
UserInputService.InputBegan:connect(
    function(v)
        if v.UserInputType == Enum.UserInputType.MouseButton2 and Settings.Enabled then
            Aim = true
            while Aim do
                wait()
                if
                    Player:GetMouse().Target and
                        Workspace.Zombies:FindFirstChild(
                            Player:GetMouse().Target.Parent.Name
                        )
                 then
                    local Person =
                        Workspace.Zombies:FindFirstChild(
                        Player:GetMouse().Target.Parent.Name
                    )
                    if Settings.Delay > 0 then
                            wait(0.01)
                        end
                        mouse1press()
                        wait()
                        mouse1release()
                    end
                if not Settings.Enabled then
                    break
                end
            end
        end
    end
)

UserInputService.InputEnded:connect(
    function(v)
        if v.KeyCode == Enum.UserInputType.MouseButton2 and Settings.Enabled then
            Aim = false
        end
    end
)


local function NoClip()
    if identifyexecutor and identifyexecutor() ~= "Krnl" then
        Player.Character:FindFirstChildWhichIsA("Humanoid"):ChangeState(11)
    elseif identifyexecutor and identifyexecutor() == "Krnl" then
        for i, v in pairs(Player.Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
                v.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end

if Settings.Smoothness ==  nil then
    Settings.Smoothness = 0.2 
end 
local OrionLib = loadstring(game:HttpGet("https://pastebin.com/raw/NMEHkVTb"))()

local Window = OrionLib:MakeWindow({Name = "VIP Turtle Hub V3", HidePremium = false, SaveConfig = true, ConfigFolder = "TurtleFile"})

local P1 = Window:MakeTab({
Name = "Main",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})

local P4 = Window:MakeTab({
Name = "Misc",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})

local P5 = Window:MakeTab({
Name = "Gun Config",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})

local P2 = Window:MakeTab({
Name = "Wall",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})

local P3 = Window:MakeTab({
Name = "ESP",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})

P1:AddToggle({
Name = "Aimbot",
Default = false,
Callback = function(Value)
    Settings.Enabled = Value
end
})


P1:AddDropdown({
Name = "HitPart",
Default = "None",
Options = {"HumanoidRootPart","Head","UpperTorso","LowerTorso","Random"},
Callback = function(Value)
	Settings.AimPart = Value
end
})
if Settings.AimPart == nil then
Settings.AimPart = "HumanoidRootPart"
end 

            

P1:AddToggle({
Name = "TriggerBot",
Default = false,
Callback = function(Value)
    Settings.Enabled = Value
end
})

P2:AddToggle({
Name = "WallCheck",
Default = false,
Callback = function(Value)
    Settings.WallCheck = Value
end
})

P1:AddSlider({
Name = "Aimbot Radius",
Min = 0,
Max = 10000,
Default = 1000,
Color = Color3.fromRGB(255,255,255),
Increment = 1,
ValueName = "Radius",
Callback = function(Value)
    Settings.FOV = Value
    Circle.Radius = Settings.FOV  
end
})

P1:AddToggle({
Name = "Circle Visible",
Default = false,
Callback = function(Value)
   Circle.Visible = Value
end
})

P1:AddSlider({
Name = "Aimbot Smoothness",
Min = 0,
Max = 10,
Default = 10,
Color = Color3.fromRGB(255,255,255),
Increment = 1,
ValueName = "Smoothness",
Callback = function(Value)
    Settings.Smoothness = Value
end
})

P3:AddToggle({
Name = "ESP Distance",
Default = false,
Callback = function(esp)
local thing
local latespos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    shared.toggle = esp
    print(shared.toggle)
    thing = esp
    spawn(function()
        if thing then
local BillboardGui = Instance.new("BillboardGui")    
local Text = Instance.new("TextLabel")
 
while wait() do
for i,v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("BoolValue") and v.Name == "Zombies" then
Distance = (v.Parent.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
   BillboardGui.Parent = v.Parent.Head
   BillboardGui.AlwaysOnTop = true
   BillboardGui.LightInfluence = 1
   BillboardGui.Size = UDim2.new(0, 50, 0, 50)
   BillboardGui.StudsOffset = Vector3.new(0, 2, 0)
 
   Text.Parent = BillboardGui
   Text.BackgroundColor3 = Color3.new(1, 1, 1)
   Text.BackgroundTransparency = 1
   Text.Size = UDim2.new(1.5, 0, 1, 0)
   Text.Text = "Zombie \n".. math.floor(Distance) .. ""
   Text.TextColor3 = Color3.new(255, 255, 255)
   Text.TextScaled = true
   elseif not thing then
   BillboardGui:Destroy()
end
end
end
end
end)
end
})

--[[
P3:AddToggle({
Name = "ESP Body Colors (Zombie only)",
Default = false,
Callback = function(v)
getgenv().enabled = v
getgenv().filluseteamcolor = false
getgenv().outlineuseteamcolor = false
getgenv().fillcolor = Color3.new(172, 0, 0)
getgenv().outlinecolor = Color3.new(1, 1, 1)
getgenv().filltrans = 0
getgenv().outlinetrans = 0


local holder = game.CoreGui:FindFirstChild("ESPHolder") or Instance.new("Folder")
if enabled == false then
    holder:Destroy()
end


if holder.Name == "Folder" then
    holder.Name = "ESPHolder"
    holder.Parent = game.CoreGui
end


if uselocalplayer == false and holder:FindFirstChild(game.Players.LocalPlayer.Name) then
    holder:FindFirstChild(game.Players.LocalPlayer.Name):Destroy()
end


if getgenv().enabled == true then 
    getgenv().enabled = false
    getgenv().enabled = true
end
while getgenv().enabled do
    task.wait()
    for _,v in pairs(game.Workspace:GetChildren()) do
        if v.Name == "Zombies" then
        local chr = v.Character
        if chr ~= nil then
        local esp = holder:FindFirstChild(v.Name) or Instance.new("Highlight")
        esp.Name = v.Name
        if uselocalplayer == false and esp.Name == game.Workspace:FindFirstChild("Zombies").Name then
            else
        esp.Parent = holder
        if filluseteamcolor then
            esp.FillColor = v.TeamColor.Color
        else
            esp.FillColor = fillcolor 
        end
        if outlineuseteamcolor then
            esp.OutlineColor = v.TeamColor.Color
        else
            esp.OutlineColor = outlinecolor    
        end
        esp.FillTransparency = filltrans
        esp.OutlineTransparency = outlinetrans
        esp.Adornee = chr
        esp.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        end
        end
    end
end
end
end
})
--]]
P3:AddButton({
Name = "nearby zombie notifications",
Callback = function(esp)
local MaxNotify = 0

local function NearZombieNotify()
    MaxNotify = MaxNotify + 1
OrionLib:MakeNotification({
Name = "DANGER!",
Content = "ZOMBIES ARE AROUND YOU!",
Image = "rbxassetid://4483345998",
Time = 5
})
end

if Distance < 10 then
   NearbyService = RunService.Stepped:Connect(NearZombieNotify)
   end
   
if MaxNotify > 1 then
  if NearbyService then
  MaxNotify = 0
  NearbyService:Disconnect()
  end
end
end
})

P4:AddTextbox({
Name = "FPS cap",
Default = "Only numbers",
TextDisappear = true,
Callback = function(Value)
    Settings.Fps = Value
end
})

P4:AddTextbox({
Name = "Seconds Until ServerHop",
Default = "Only numbers",
TextDisappear = true,
Callback = function(Value)
    Settings.Seconds = Value
end
})

P4:AddToggle({
Name = "Infinite Jump",
Default = false,
Callback = function(Value)
Settings.InfiniteJump = Value
UserInputService.JumpRequest:connect(
    function()
        if Settings.InfiniteJump then
            Player.Character:FindFirstChildOfClass "Humanoid":ChangeState("Jumping")
        end
    end
)
end
})

P5:AddButton({
Name = "No-Recoil",
Callback = function()
local spread1 = {
  Increase = 0,
  Decrease = 0,
  Max = 0,
  Min = 0
}
local rec = {
  Tilt = { 0, 0 },
  Side = { 0, 0 },
  Vertical = { 0, 0 },
  Back = { 0, 0 },
  Aimed = 0,
  FirstShot = 0
}
for i,v in pairs(getgc(true)) do
   if type(v) == 'table' and rawget(v, 'magsize') then
       v.magsize = math.huge
       v.storedammo = math.huge
       v.rpm = math.huge
       v.spread = spread1
       v.recoil = rec
       v.mode = "Auto"
   end
end
end
})



P4:AddToggle({
Name = "N Noclip",
Default = false,
Callback = function(Value)
noclips = false
Settings.Sex1 = Value
Player:GetMouse().KeyDown:connect(
    function(v)
        if v == "n" then
            if Settings.Sex1 then
                noclips = not noclips
                for i, v in pairs(Player.Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end
    end
)
RunService.Stepped:connect(
    function()
        if noclips then
            for i, v in pairs(Player.Character:GetChildren()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end
)
end
})

P4:AddToggle({
Name = "G Noclip",
Default = false,
Callback = function(Value)
Settings.Sex = Value
noclip = false
RunService.Stepped:connect(
    function()
        if noclip then
            Player.Character.Humanoid:ChangeState(11)
        end
    end
)
mouse = Player:GetMouse()
Player:GetMouse().KeyDown:connect(
    function(v)
        if v == "g" then
            if Settings.Sex then
                noclip = not noclip
                Player.Character.Humanoid:ChangeState(11)
            end
        end
    end
)
end
})

P4:AddToggle({
Name = "H Fly",
Default = false,
Callback = function(Value)
Settings.Sex2 = Value
local Max = 0
local Players = game.Players
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
Mouse.KeyDown:connect(
    function(k)
        if k:lower() == "h" then
            Max = Max + 1
            getgenv().Fly = false
            if Settings.Sex2 then
                local T = LP.Character.Torso
                local S = {
                    F = 0,
                    B = 0,
                    L = 0,
                    R = 0
                }
                local S2 = {
                    F = 0,
                    B = 0,
                    L = 0,
                    R = 0
                }
                local SPEED = 5
                local function FLY()
                    getgenv().Fly = true
                    local BodyGyro = Instance.new("BodyGyro", T)
                    local BodyVelocity = Instance.new("BodyVelocity", T)
                    BodyGyro.P = 9e4
                    BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                    BodyGyro.cframe = T.CFrame
                    BodyVelocity.velocity = Vector3.new(0, 0.1, 0)
                    BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
                    spawn(
                        function()
                            repeat
                                wait()
                                LP.Character.Humanoid.PlatformStand = false
                                if S.L + S.R ~= 0 or S.F + S.B ~= 0 then
                                    SPEED = 200
                                elseif not (S.L + S.R ~= 0 or S.F + S.B ~= 0) and SPEED ~= 0 then
                                    SPEED = 0
                                end
                                if (S.L + S.R) ~= 0 or (S.F + S.B) ~= 0 then
                                    BodyVelocity.velocity =
                                        ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (S.F + S.B)) +
                                        ((game.Workspace.CurrentCamera.CoordinateFrame *
                                            CFrame.new(S.L + S.R, (S.F + S.B) * 0.2, 0).p) -
                                            game.Workspace.CurrentCamera.CoordinateFrame.p)) *
                                        SPEED
                                    S2 = {
                                        F = S.F,
                                        B = S.B,
                                        L = S.L,
                                        R = S.R
                                    }
                                elseif (S.L + S.R) == 0 and (S.F + S.B) == 0 and SPEED ~= 0 then
                                    BodyVelocity.velocity =
                                        ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (S2.F + S2.B)) +
                                        ((game.Workspace.CurrentCamera.CoordinateFrame *
                                            CFrame.new(S2.L + S2.R, (S2.F + S2.B) * 0.2, 0).p) -
                                            game.Workspace.CurrentCamera.CoordinateFrame.p)) *
                                        SPEED
                                else
                                    BodyVelocity.velocity = Vector3.new(0, 0.1, 0)
                                end
                                BodyGyro.cframe = game.Workspace.CurrentCamera.CoordinateFrame
                            until not getgenv().Fly
                            S = {
                                F = 0,
                                B = 0,
                                L = 0,
                                R = 0
                            }
                            S2 = {
                                F = 0,
                                B = 0,
                                L = 0,
                                R = 0
                            }
                            SPEED = 0
                            BodyGyro:destroy()
                            BodyVelocity:destroy()
                            LP.Character.Humanoid.PlatformStand = false
                        end
                    )
                end
                Mouse.KeyDown:connect(
                    function(k)
                        if k:lower() == "w" then
                            S.F = 1
                        elseif k:lower() == "s" then
                            S.B = -1
                        elseif k:lower() == "a" then
                            S.L = -1
                        elseif k:lower() == "d" then
                            S.R = 1
                        end
                    end
                )
                Mouse.KeyUp:connect(
                    function(k)
                        if k:lower() == "w" then
                            S.F = 0
                        elseif k:lower() == "s" then
                            S.B = 0
                        elseif k:lower() == "a" then
                            S.L = 0
                        elseif k:lower() == "d" then
                            S.R = 0
                        end
                    end
                )
                FLY()
                if Max == 2 then
                    getgenv().Fly = false
                    Max = 0
                end
            end
        end
    end
)
end
})

P4:AddToggle({
Name = "Auto serverhop",
Default = false,
Callback = function(Value)
Settings.ServerHop = Value
spawn(function()
while Settings.ServerHop do wait(Settings.Seconds)
local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local File = pcall(function()
    AllIDs = HttpService:JSONDecode(readfile("NotSameServers.json"))
end)
if not File then
    table.insert(AllIDs, actualHour)
    writefile("NotSameServers.json", HttpService:JSONEncode(AllIDs))
end
function TPReturner()
    local Site;
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", HttpService:JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, Player)
                end)
                wait(4)
            end
        end
    end
end
function Teleport()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end
-- If you'd like to use a script before server hopping (Like a Automatic Chest collector you can put the Teleport() after it collected everything.
Teleport() 
end 
end)
end
})

P4:AddButton({
Name = "Anti Lag",
Callback = function()
for _, v in pairs(Workspace:GetDescendants()) do
    if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
        v.Material = Enum.Material.SmoothPlastic
        if v:IsA("Texture") then
            v:Destroy()
        end
    end
end
end
})

P4:AddButton({
Name = "Teleport to random Player",
Callback = function()
local randomPlayer = game.Players:GetPlayers()[math.random(1, #game.Players:GetPlayers())]
Player.Character.HumanoidRootPart.CFrame =
    CFrame.new(
    Vector3.new(
        randomPlayer.Character.Head.Position.X,
        randomPlayer.Character.Head.Position.Y,
        randomPlayer.Character.Head.Position.Z
    )
)
end
})

P4:AddButton({
Name = "Lag Switch F3",
Callback = function()
local ass = false
local bitch = settings()
game:service "UserInputService".InputEnded:connect(
    function(i)
        if i.KeyCode == Enum.KeyCode.F3 then
            ass = not ass
            bitch.Network.IncomingReplicationLag = ass and 10 or 0
        end
    end
)
end
}) 

P4:AddButton({
Name = "Serverhop",
Callback = function()
local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local File = pcall(function()
    AllIDs = HttpService:JSONDecode(readfile("NotSameServers.json"))
end)
if not File then
    table.insert(AllIDs, actualHour)
    writefile("NotSameServers.json", HttpService:JSONEncode(AllIDs))
end
function TPReturner()
    local Site;
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", HttpService:JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, Player)
                end)
                wait(4)
            end
        end
    end
end
function Teleport()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end
-- If you'd like to use a script before server hopping (Like a Automatic Chest collector you can put the Teleport() after it collected everything.
Teleport() 
end
})

P4:AddButton({
Name = "Rejoin",
Callback = function()
game:GetService("TeleportService"):Teleport(game.PlaceId, Player) end
})

--Settings--
local ESP = {
    Enabled = false,
    Boxes = true,
    BoxShift = CFrame.new(0,-1.5,0),
	BoxSize = Vector3.new(4,6,0),
    Color = Color3.fromRGB(0, 255, 0),
    FaceCamera = false,
    Names = false,
    TeamColor = true,
    Thickness = 2,
    AttachShift = 1,
    TeamMates = true,
    Players = false,
    
    Objects = setmetatable({}, {__mode="kv"}),
    Overrides = {}
}

--Declarations--
local Workspace = game.Workspace
local Players = game.Players
local Player = Players.LocalPlayer
local cam = Workspace.CurrentCamera
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local mouse = Player:GetMouse()

local V3new = Vector3.new
local WorldToViewportPoint = cam.WorldToViewportPoint

--Functions--
local function Draw(A, props)
	local new = Drawing.new(A)
	
	props = props or {}
	for i,v in pairs(props) do
		new[i] = v
	end
	return new
end

function ESP:GetTeam(p)
	local ov = self.Overrides.GetTeam
	if ov then
		return ov(p)
	end
	
	return p and p.Team
end

function ESP:IsTeamMate(p)
    local ov = self.Overrides.IsTeamMate
	if ov then
		return ov(p)
    end
    
    return self:GetTeam(p) == self:GetTeam(Player)
end

function ESP:GetColor(A)
	local ov = self.Overrides.GetColor
	if ov then
		return ov(A)
    end
    local p = self:GetPlayerFromChar(A)
	return p and self.TeamColor and p.Team and p.Team.TeamColor.Color or self.Color
end

function ESP:GetPlayerFromChar(char)
	local ov = self.Overrides.GetPlayerFromChar
	if ov then
		return ov(char)
	end
	
	return Players:GetPlayerFromCharacter(char)
end

function ESP:Toggle(bool)
    self.Enabled = bool
    if not bool then
        for i,v in pairs(self.Objects) do
            if v.Type == "Box" then --fov circle etc
                if v.Temporary then
                    v:Remove()
                else
                    for i,v in pairs(v.Components) do
                        v.Visible = false
                    end
                end
            end
        end
    end
end

function ESP:GetBox(A)
    return self.Objects[A]
end

function ESP:AddObjectListener(parent, options)
    local function NewListener(c)
        if type(options.Type) == "string" and c:IsA(options.Type) or options.Type == nil then
            if type(options.Name) == "string" and c.Name == options.Name or options.Name == nil then
                if not options.Validator or options.Validator(c) then
                    local box = ESP:Add(c, {
                        PrimaryPart = type(options.PrimaryPart) == "string" and c:WaitForChild(options.PrimaryPart) or type(options.PrimaryPart) == "function" and options.PrimaryPart(c),
                        Color = type(options.Color) == "function" and options.Color(c) or options.Color,
                        ColorDynamic = options.ColorDynamic,
                        Name = type(options.CustomName) == "function" and options.CustomName(c) or options.CustomName,
                        IsEnabled = options.IsEnabled,
                        RenderInNil = options.RenderInNil
                    })
                    --TODO: add a better way of passing options
                    if options.OnAdded then
                        coroutine.wrap(options.OnAdded)(box)
                    end
                end
            end
        end
    end

    if options.Recursive then
        parent.DescendantAdded:Connect(NewListener)
        for i,v in pairs(parent:GetDescendants()) do
            coroutine.wrap(NewListener)(v)
        end
    else
        parent.ChildAdded:Connect(NewListener)
        for i,v in pairs(parent:GetChildren()) do
            coroutine.wrap(NewListener)(v)
        end
    end
end

local boxBase = {}
boxBase.__index = boxBase

function boxBase:Remove()
    ESP.Objects[self.Object] = nil
    for i,v in pairs(self.Components) do
        v.Visible = false
        v:Remove()
        self.Components[i] = nil
    end
end

function boxBase:Update()
    if not self.PrimaryPart then
        --warn("not supposed to print", self.Object)
        return self:Remove()
    end

    local color
    if ESP.Highlighted == self.Object then
       color = ESP.HighlightColor
    else
        color = self.Color or self.ColorDynamic and self:ColorDynamic() or ESP:GetColor(self.Object) or ESP.Color
    end

    local allow = true
    if ESP.Overrides.UpdateAllow and not ESP.Overrides.UpdateAllow(self) then
        allow = false
    end
    if self.Player and not ESP.TeamMates and ESP:IsTeamMate(self.Player) then
        allow = false
    end
    if self.Player and not ESP.Players then
        allow = false
    end
    if self.IsEnabled and (type(self.IsEnabled) == "string" and not ESP[self.IsEnabled] or type(self.IsEnabled) == "function" and not self:IsEnabled()) then
        allow = false
    end
    if not Workspace:IsAncestorOf(self.PrimaryPart) and not self.RenderInNil then
        allow = false
    end

    if not allow then
        for i,v in pairs(self.Components) do
            v.Visible = false
        end
        return
    end

    if ESP.Highlighted == self.Object then
        color = ESP.HighlightColor
    end

    --calculations--
    local cf = self.PrimaryPart.CFrame
    if ESP.FaceCamera then
        cf = CFrame.new(cf.p, cam.CFrame.p)
    end
    local size = self.Size
    local locs = {
        TopLeft = cf * ESP.BoxShift * CFrame.new(size.X/2,size.Y/2,0),
        TopRight = cf * ESP.BoxShift * CFrame.new(-size.X/2,size.Y/2,0),
        BottomLeft = cf * ESP.BoxShift * CFrame.new(size.X/2,-size.Y/2,0),
        BottomRight = cf * ESP.BoxShift * CFrame.new(-size.X/2,-size.Y/2,0),
        TagPos = cf * ESP.BoxShift * CFrame.new(0,size.Y/2,0),
        Torso = cf * ESP.BoxShift
    }

    if ESP.Boxes then
        local TopLeft, Vis1 = WorldToViewportPoint(cam, locs.TopLeft.p)
        local TopRight, Vis2 = WorldToViewportPoint(cam, locs.TopRight.p)
        local BottomLeft, Vis3 = WorldToViewportPoint(cam, locs.BottomLeft.p)
        local BottomRight, Vis4 = WorldToViewportPoint(cam, locs.BottomRight.p)

        if self.Components.Quad then
            if Vis1 or Vis2 or Vis3 or Vis4 then
                self.Components.Quad.Visible = true
                self.Components.Quad.PointA = Vector2.new(TopRight.X, TopRight.Y)
                self.Components.Quad.PointB = Vector2.new(TopLeft.X, TopLeft.Y)
                self.Components.Quad.PointC = Vector2.new(BottomLeft.X, BottomLeft.Y)
                self.Components.Quad.PointD = Vector2.new(BottomRight.X, BottomRight.Y)
                self.Components.Quad.Color = color
            else
                self.Components.Quad.Visible = false
            end
        end
    else
        self.Components.Quad.Visible = false
    end

    if ESP.Names then
        local TagPos, Vis5 = WorldToViewportPoint(cam, locs.TagPos.p)
        
        if Vis5 then
            self.Components.Name.Visible = true
            self.Components.Name.Position = Vector2.new(TagPos.X, TagPos.Y)
            self.Components.Name.Text = self.Name
            self.Components.Name.Color = color
            
            self.Components.Distance.Visible = true
            self.Components.Distance.Position = Vector2.new(TagPos.X, TagPos.Y + 14)
            self.Components.Distance.Text = math.floor((cam.CFrame.p - cf.p).magnitude) .."m away"
            self.Components.Distance.Color = color
        else
            self.Components.Name.Visible = false
            self.Components.Distance.Visible = false
        end
    else
        self.Components.Name.Visible = false
        self.Components.Distance.Visible = false
    end
    
    if ESP.Tracers then
        local TorsoPos, Vis6 = WorldToViewportPoint(cam, locs.Torso.p)

        if Vis6 then
            self.Components.Tracer.Visible = true
            self.Components.Tracer.From = Vector2.new(TorsoPos.X, TorsoPos.Y)
            self.Components.Tracer.To = Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/ESP.AttachShift)
            self.Components.Tracer.Color = color
        else
            self.Components.Tracer.Visible = false
        end
    else
        self.Components.Tracer.Visible = false
    end
end

function ESP:Add(obj, options)
    if not obj.Parent and not options.RenderInNil then
        return warn(obj, "has no parent")
    end

    local box = setmetatable({
        Name = options.Name or obj.Name,
        Type = "Box",
        Color = options.Color --[[or self:GetColor(obj)]],
        Size = options.Size or self.BoxSize,
        Object = obj,
        Player = options.Player or Players:GetPlayerFromCharacter(obj),
        PrimaryPart = options.PrimaryPart or obj.ClassName == "Model" and (obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")) or obj:IsA("BasePart") and obj,
        Components = {},
        IsEnabled = options.IsEnabled,
        Temporary = options.Temporary,
        ColorDynamic = options.ColorDynamic,
        RenderInNil = options.RenderInNil
    }, boxBase)

    if self:GetBox(obj) then
        self:GetBox(obj):Remove()
    end

    box.Components["Quad"] = Draw("Quad", {
        Thickness = self.Thickness,
        Color = color,
        Transparency = 1,
        Filled = false,
        Visible = self.Enabled and self.Boxes
    })
    box.Components["Name"] = Draw("Text", {
		Text = box.Name,
		Color = box.Color,
		Center = true,
		Outline = true,
        Size = 19,
        Visible = self.Enabled and self.Names
	})
	box.Components["Distance"] = Draw("Text", {
		Color = box.Color,
		Center = true,
		Outline = true,
        Size = 19,
        Visible = self.Enabled and self.Names
	})
	
	box.Components["Tracer"] = Draw("Line", {
		Thickness = ESP.Thickness,
		Color = box.Color,
        Transparency = 1,
        Visible = self.Enabled and self.Tracers
    })
    self.Objects[obj] = box
    
    obj.AncestryChanged:Connect(function(_, parent)
        if parent == nil and ESP.AutoRemove ~= false then
            box:Remove()
        end
    end)
    obj:GetPropertyChangedSignal("Parent"):Connect(function()
        if obj.Parent == nil and ESP.AutoRemove ~= false then
            box:Remove()
        end
    end)

    local hum = obj:FindFirstChildOfClass("Humanoid")
	if hum then
        hum.Died:Connect(function()
            if ESP.AutoRemove ~= false then
                box:Remove()
            end
		end)
    end

    return box
end

local function CharAdded(char)
    local p = Players:GetPlayerFromCharacter(char)
    if not char:FindFirstChild("HumanoidRootPart") then
        local ev
        ev = char.ChildAdded:Connect(function(c)
            if c.Name == "HumanoidRootPart" then
                ev:Disconnect()
                ESP:Add(char, {
                    Name = p.Name,
                    Player = p,
                    PrimaryPart = c
                })
            end
        end)
    else
        ESP:Add(char, {
            Name = p.Name,
            Player = p,
            PrimaryPart = char.HumanoidRootPart
        })
    end
end
local function PlayerAdded(p)
    p.CharacterAdded:Connect(CharAdded)
    if p.Character then
        coroutine.wrap(CharAdded)(p.Character)
    end
end
Players.PlayerAdded:Connect(PlayerAdded)
for i,v in pairs(Players:GetPlayers()) do
    if v ~= Player then
        PlayerAdded(v)
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    cam = Workspace.CurrentCamera
    for i,v in (ESP.Enabled and pairs or ipairs)(ESP.Objects) do
        if v.Update then
            local s,e = pcall(v.Update, v)
            if not s then warn("[EU]", e, v.Object:GetFullName()) end
        end
    end
end)



P4:AddToggle({
Name = "Enable ESP",
Default = false,
Callback = function(Value)
    Settings.Esp = Value
    ESP:Toggle(Settings.Esp)
end
})

P4:AddToggle({
Name = "Player ESP",
Default = false,
Callback = function(Value)
    Settings.PlayerEsp = Value
    ESP.Players = Settings.PlayerEsp
end
})

P4:AddToggle({
Name = "Zombie ESP",
Default = false,
Callback = function(Value)
    Settings.Orange = Value
    ESP.Orange = Settings.Orange

ESP:AddObjectListener(Workspace.Zombies, {
    Color =  Color3.new(255, 0, 0),
    Type = "Model",
    PrimaryPart = function(v)
        local H = v:FindFirstChild("Torso")
        while not H do
            wait()
            H = v:FindFirstChild("Torso")
        end
        return H
    end,
    Validator = function(v)
        return not game.Players:GetPlayerFromCharacter(v) and v
    end,
    CustomName = function(v)
        return "Zombie"
    end,
    IsEnabled = "Orange",
})

end
})



P3:AddToggle({
Name = "Tracers ESP",
Default = false,
Callback = function(Value)
    Settings.Tracers = Value
    ESP.Tracers = Settings.Tracers
end
})

P3:AddToggle({
Name = "Name ESP",
Default = false,
Callback = function(Value)
    ESP.Names = Settings.EspNames
    Settings.EspNames = Value
end
})

P3:AddToggle({
Name = "Boxes ESP",
Default = false,
Callback = function(Value)
    Settings.Boxes = Value
    ESP.Boxes = Settings.Boxes
end
})
