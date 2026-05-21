-- Auto Shoot GUI Script para Murders vs Sheriffs
-- Este script crea un GUI con un botón de auto-shoot

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables de configuración
local autoShootActive = false
local shootCooldown = 0.1 -- Intervalo entre disparos (segundos)
local lastShootTime = 0
local maxRange = 100 -- Rango máximo de disparo

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoShootGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Crear botón de Auto Shoot
local autoShootButton = Instance.new("TextButton")
autoShootButton.Name = "AutoShootButton"
autoShootButton.Size = UDim2.new(0, 120, 0, 50)
autoShootButton.Position = UDim2.new(0, 20, 0, 20)
autoShootButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Rojo (desactivado)
autoShootButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoShootButton.TextSize = 18
autoShootButton.Text = "Auto Shoot\nOFF"
autoShootButton.Font = Enum.Font.GothamBold
autoShootButton.Parent = screenGui

-- Función para obtener el enemigo más cercano
local function getNearestEnemy()
	local character = player.Character
	if not character then return nil end
	
	local playerPosition = character:FindFirstChild("HumanoidRootPart")
	if not playerPosition then return nil end
	
	local nearestEnemy = nil
	local nearestDistance = maxRange
	
	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if otherPlayer ~= player then
			local otherCharacter = otherPlayer.Character
			if otherCharacter then
				local otherHRP = otherCharacter:FindFirstChild("HumanoidRootPart")
				local otherHumanoid = otherCharacter:FindFirstChild("Humanoid")
				
				if otherHRP and otherHumanoid and otherHumanoid.Health > 0 then
					local distance = (playerPosition.Position - otherHRP.Position).Magnitude
					
					if distance < nearestDistance then
						nearestDistance = distance
						nearestEnemy = otherCharacter
					end
				end
			end
		end
	end
	
	return nearestEnemy
end

-- Función para disparar (ajusta esto según tu juego)
local function shootAtEnemy(enemy)
	local character = player.Character
	if not character then return end
	
	-- Buscar el arma en el inventario del jugador
	local tool = character:FindFirstChildOfClass("Tool")
	
	if tool and tool:FindFirstChild("Activate") then
		-- Si la herramienta tiene una función Activate
		tool:Activate()
	elseif tool and tool:FindFirstChild("Fire") then
		-- Si hay una función Fire
		tool.Fire:FireServer()
	else
		-- Intenta activar la herramienta directamente
		if tool then
			tool:Activate()
		end
	end
end

-- Evento del botón
autoShootButton.MouseButton1Click:Connect(function()
	autoShootActive = not autoShootActive
	
	if autoShootActive then
		autoShootButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Verde (activado)
		autoShootButton.Text = "Auto Shoot\nON"
	else
		autoShootButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Rojo (desactivado)
		autoShootButton.Text = "Auto Shoot\nOFF"
	end
end)

-- Loop de disparo automático
RunService.RenderStepped:Connect(function()
	if autoShootActive then
		local currentTime = tick()
		
		if currentTime - lastShootTime >= shootCooldown then
			local nearestEnemy = getNearestEnemy()
			
			if nearestEnemy then
				shootAtEnemy(nearestEnemy)
				lastShootTime = currentTime
			end
		end
	end
end)

-- Limpiar GUI al respawnear
player.CharacterAdded:Connect(function()
	-- El GUI permanecerá gracias a ResetOnSpawn = false
end)