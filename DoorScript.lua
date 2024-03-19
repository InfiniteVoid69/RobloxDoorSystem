local ts = game:GetService("TweenService")
local ss = game:GetService("ServerStorage")
local rs = game:GetService("ReplicatedStorage")
local sounds = ss.Assets.Sounds.DoorSounds
local Folder = workspace.Doors

---
local Tinfo = TweenInfo.new()

for _, v in pairs(Folder:GetChildren()) do
	if not v:IsA("Model") then continue end
	---
	local open = ts:Create(v.PrimaryPart, Tinfo, {
		CFrame = v.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(95),0)
	})
	local close = ts:Create(v.PrimaryPart, Tinfo, {
		CFrame = v.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(0),0)
	})


	local function check()
		if v:GetAttribute("Open") == false then
			v:SetAttribute("Open", true)
		else
			v:SetAttribute("Open", false)
		end
	end
	--
	local closeTime = v["Configuration"]:GetAttribute("AutoClose")

	v["ProximityPrompt"].Triggered:Connect(function(plr)
		if v["Configuration"]:GetAttribute("KeyCardRequired") == true then
			if not plr.Backpack:FindFirstChild("Keycard") then return end
		end
		check()
	end)

	v:GetAttributeChangedSignal("Open"):Connect(function()
		if v:GetAttribute("Open") == false then
			close:Play()
			return
		end
		if v:GetAttribute("Open") == true then
			open:Play()
		end

		if closeTime == 0 then
			return
		else
			while v:SetAttribute("Open", true) do
				task.wait(closeTime)
			end
			v:SetAttribute("Open", false)
		end
	end)

	rs.Events.Bindable.AutoOpen.Event:Connect(function()
		if v["Configuration"]:GetAttribute("AutoOpen") == true then
			check()
		end
	end)
end
