-- [[ KA HUB | ESTILO GRAVITY HUB - RED DESIGN ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // CONFIGURAÇÕES (Inicia tudo desligado)
_G.AutoFarm = false
_G.FastAttack = false
_G.BringMobs = false
_G.AutoBuso = false
_G.Weapon = "Melee"

local LP = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local VIM = game:GetService("VirtualInputManager")

-- // ANTI-AFK
local VirtualUser = game:GetService("VirtualUser")
LP.Idled:Connect(function() VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new()) end)

-- // CRIAÇÃO DA JANELA (ESTILO ESCURO/VERMELHO)
local Window = Rayfield:CreateWindow({
   Name = "KA HUB [ Freemium ] Version 1.4",
   LoadingTitle = "Carregando Layout Gravity...",
   ConfigurationSaving = { Enabled = false },
   Theme = "Default" -- O Rayfield aplicará o tema escuro padrão
})

-- // ABAS IGUAIS À IMAGEM
local TabHome = Window:CreateTab("Tab Home")
local TabGeneral = Window:CreateTab("Tab General")
local TabSetting = Window:CreateTab("Tab Setting")
local TabStats = Window:CreateTab("Tab Stats")

-- [[ ABA SETTING - DESIGN DA IMAGEM ]]
TabSetting:CreateSection("Settings / Configure")

TabSetting:CreateToggle({
   Name = "Fast Attack",
   CurrentValue = false,
   Callback = function(v) _G.FastAttack = v end,
})

TabSetting:CreateToggle({
   Name = "Bring Mobs",
   CurrentValue = false,
   Callback = function(v) _G.BringMobs = v end,
})

TabSetting:CreateToggle({
   Name = "Auto Turn on Buso",
   CurrentValue = false,
   Callback = function(v) _G.AutoBuso = v end,
})

-- [[ ABA GENERAL ]]
TabGeneral:CreateSection("Main Farm")

TabGeneral:CreateToggle({
   Name = "Auto Farm Level",
   CurrentValue = false,
   Callback = function(v) _G.AutoFarm = v end,
})

TabGeneral:CreateDropdown({
   Name = "Select Weapon",
   Options = {"Melee", "Sword", "Fruit"},
   CurrentOption = "Melee",
   Callback = function(v) _G.Weapon = v end,
})

-- // FUNÇÃO DE QUESTS
local function GetQuest()
    local lvl = LP.Data.Level.Value
    if lvl < 10 then return "BanditQuest1", 1, "Bandit", CFrame.new(1059, 15, 1550)
    elseif lvl < 15 then return "JungleQuest", 1, "Monkey", CFrame.new(-1598, 35, 153)
    else return "JungleQuest", 2, "Gorilla", CFrame.new(-1598, 35, 153) end
end

-- // LOOP CORE (FARM + COMBATE)
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                -- Auto Buso
                if _G.AutoBuso and not LP.Character:FindFirstChild("HasBuso") then
                    RS.Remotes.CommF_:InvokeServer("Buso")
                end

                local qN, qL, mN, qP = GetQuest()
                if not LP.PlayerGui.Main.Quest.Visible then
                    LP.Character.HumanoidRootPart.CFrame = qP
                    RS.Remotes.CommF_:InvokeServer("StartQuest", qN, qL)
                else
                    local enemy = workspace.Enemies:FindFirstChild(mN)
                    if enemy and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        -- Equipar
                        local tool = LP.Backpack:FindFirstChild(_G.Weapon) or LP.Character:FindFirstChild(_G.Weapon)
                        if tool then LP.Character.Humanoid:EquipTool(tool) end
                        
                        -- Farm Pos
                        LP.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0)
                        
                        -- Ataque (Fast Attack adaptado)
                        VIM:SendMouseButtonEvent(500, 500, 0, true, game, 0)
                        VIM:SendMouseButtonEvent(500, 500, 0, false, game, 0)
                        if _G.FastAttack then task.wait() end -- Reduz delay
                    end
                end
            end)
        end
    end
end)

Rayfield:Notify({Title = "KA HUB", Content = "Visual Gravity Carregado!", Duration = 5})
