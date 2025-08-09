MainFrame = CreateFrame("FRAME", "RTFrame", UIParent)

local tentPercentage = 0.002
local lastXPExhaustion = GetXPExhaustion()
local lastUpdate = GetTime()
local tentRestingStartTime = nil

local function registerEvents(frame)
    MainFrame:RegisterEvent("PLAYER_UPDATE_RESTING")
    MainFrame:RegisterEvent("UPDATE_EXHAUSTION")
    MainFrame:SetScript('OnEvent', function()
        this[event]()
    end)
    MainFrame:SetScript('OnUpdate', onUpdate)
end

local function getRestedXPPercentage()
	local XPMax = UnitXPMax("player")
    local XPExhaustion = GetXPExhaustion()
    return XPExhaustion / XPMax * 100
end

function updateRestedXP(label) 
    local roundedRestedXP = string.format("%.0f", getRestedXPPercentage())
    if (roundedRestedXP == "150") then
        label:SetText(string.format("%.0f", getRestedXPPercentage()) .. "%")
        updateRestingTent(MainFrame.restingTent, false)
    else
        label:SetText(string.format("%.0f", getRestedXPPercentage()) .. "% (Max: 150%)")
    end
end

function updateRestingTent(label, isUnderATent)
	local restedXPPercentage = getRestedXPPercentage()
    local remainingPercentage = 150.0 - restedXPPercentage
    if (remainingPercentage == 0.0) then
        label:Hide()
    end
    local tentPercentage = tentPercentage * 100
    local remainingSecondsTotal = remainingPercentage / tentPercentage
    local remainingMinutes = math.floor(remainingSecondsTotal / 60)
    local remainingSeconds = math.mod(remainingSecondsTotal, 60.0)
    label:SetText(string.format("%02d:%02d", remainingMinutes, remainingSeconds) .. " until max rested XP")
    label:Show()
end

function MainFrame:PLAYER_UPDATE_RESTING()
    lastXPExhaustion = GetXPExhaustion()
    updateRestedXP(MainFrame.restedInfo)
end

function MainFrame:UPDATE_EXHAUSTION()
    lastUpdate = GetTime()
    updateRestedXP(MainFrame.restedInfo)
	local XPMax = UnitXPMax("player")
    local XPExhaustion = GetXPExhaustion()
    local expectedTentGain = math.floor(XPMax * tentPercentage)
    local XPExhaustionGain = XPExhaustion - lastXPExhaustion
    lastXPExhaustion = XPExhaustion
    local XPExhaustionPercentage = XPExhaustion / XPMax * 100
    if (XPExhaustionGain < expectedTentGain) then
        updateRestingTent(MainFrame.restingTent, false)
        return
    end
    updateRestingTent(MainFrame.restingTent, true)
end

function onUpdate() 
    local elapsed = GetTime() - lastUpdate
    if (elapsed < 1.5) then
        return
    end
    MainFrame:UPDATE_EXHAUSTION()
end

registerEvents()
