-- Script de Vuelo para Roblox
-- Creado por: GitHub Copilot Chat Assistant

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variables de vuelo
local flying = false
local speed = 50
local velocity = Instance.new("BodyVelocity")
local bodygyro = Instance.new("BodyGyro")

-- Crear GUI del botón
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Size = UDim2.new(0, 100, 0, 50)
flyButton.Position = UDim2.new(0, 10, 0, 10)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 18
flyButton.Font = Enum.Font.GothamBold
flyButton.Text = "FLY"
flyButton.Parent = screenGui

-- Función para activar/desactivar vuelo
local function toggleFly()
	flying = not flying
	
	if flying then
		print("bye Github")
		flyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
		flyButton.Text = "FLYING"
		
		-- Crear BodyVelocity
		velocity.Velocity = Vector3.new(0, 0, 0)
		velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		velocity.Parent = humanoidRootPart
		
		-- Crear BodyGyro
		bodygyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bodygyro.CFrame = humanoidRootPart.CFrame
		bodygyro.Parent = humanoidRootPart
		
	else
		print("Vuelo desactivado")
		flyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
		flyButton.Text = "FLY"
		
		-- Eliminar BodyVelocity y BodyGyro
		velocity.Parent = nil
		bodygyro.Parent = nil
	end
end

-- Conectar el botón
flyButton.MouseButton1Click:Connect(toggleFly)

-- Movimiento del vuelo
RunService.RenderStepped:Connect(function()
	if flying then
		local moveDirection = Vector3.new(0, 0, 0)
		
		-- Controles WASD
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			moveDirection = moveDirection + (humanoidRootPart.CFrame.LookVector * speed)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			moveDirection = moveDirection - (humanoidRootPart.CFrame.RightVector * speed)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			moveDirection = moveDirection - (humanoidRootPart.CFrame.LookVector * speed)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			moveDirection = moveDirection + (humanoidRootPart.CFrame.RightVector * speed)
		end
		
		-- Espacio para subir, Ctrl para bajar
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			moveDirection = moveDirection + Vector3.new(0, speed, 0)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			moveDirection = moveDirection - Vector3.new(0, speed, 0)
		end
		
		velocity.Velocity = moveDirection
		bodygyro.CFrame = humanoidRootPart.CFrame * CFrame.Angles(0, math.rad(mouse.Hit.p.X - humanoidRootPart.Position.X), 0)
	end
end)
