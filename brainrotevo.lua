local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Moonlight Hub",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Moonlight Hub",
   LoadingSubtitle = "by Z",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Falsely"
   },

   Discord = {
      Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "GMsmhx9dFp", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

_G.farm = true

local Tab = Window:CreateTab("Main", 4483362458)

local Section = Tab:CreateSection("Farm")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer:WaitForChild(LocalPlayer.Character)
local Humanoid = Character:FindFirstChild("Humanoid") or Character:WaitForChild("Humanoid")
local HRP = Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

_G.incombat = false

local function hitablePOS()
    for _, model in pairs(workspace:GetChildren()) do
        if model:IsA("Model") then
            local hrp = model:FindFirstChild("HumanoidRootPart")
            local humanoid = model:FindFirstChild("Humanoid")
            if humanoid and hrp then
                if hrp:FindFirstChild("MonsterHUD") then
                    return hrp.CFrame, humanoid
                end 
            end
        end
    end
    return nil, nil
end

local function hit()
    local pk = ReplicatedStorage:FindFirstChild("Packages")
    if not (pk and pk:FindFirstChild("Knit")) then return end

    local knit = pk:FindFirstChild("Knit")
    local sv = knit and knit:FindFirstChild("Services")
    local MService = sv and sv:FindFirstChild("MonsterService")
    local rf = MService and MService:FindFirstChild("RF")
    local RAttack = rf and rf:FindFirstChild("RequestAttack")

    if not RAttack then
        warn("RequestAttack not found.")
        return
    end

    _G.incombat = true
    task.wait(0.1)

    while _G.incombat do
        local pos, targetHumanoid = hitablePOS()

        if pos and targetHumanoid and targetHumanoid.Health > 0 then
            -- Stay above and attack until that one dies
            while _G.incombat and targetHumanoid.Health > 0 do
                task.wait()
                local above = pos + Vector3.new(0, 5, 0)
                HRP.CFrame = above
                RAttack:InvokeServer(pos)
            end
        else
            -- No valid target found — wait and retry
            task.wait(0.1)
        end
    end
end

local Toggle = Tab:CreateToggle({
   Name = "Farm",
   CurrentValue = false,
   Callback = function(Value)
        _G.farm = Value
        while Value do task.wait()
            hit()
        end
   end,
})
