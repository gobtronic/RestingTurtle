local frame = CreateFrame("FRAME", "RTFrame", UIParent)
local tentPercentage = 0.002
local lastXPExhaustion = GetXPExhaustion("player")
local lastUpdate = GetTime()

local function setupFrame()
    frame:ClearAllPoints()
    frame:SetFrameStrata('LOW')
    frame:SetWidth(100)
    frame:SetHeight(30)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end

local function setupTitle(parent)
    parent.title = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    parent.title:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    parent.title:SetText("RestingTurtle")
end

local function setupRestedInfo(parent, topFrame)
    parent.restedInfo = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    parent.restedInfo:SetPoint("TOPLEFT", topFrame, "BOTTOMLEFT", 0, 0)
    parent.restedInfo:SetText("Rested info")
end

local function setupRestingTent(parent, topFrame)
    parent.restingTent = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    parent.restingTent:SetPoint("TOPLEFT", topFrame, "BOTTOMLEFT", 0, 0)
    parent.restingTent:SetText("You are under a tent!")
end

local function setupDrag(frame) 
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function()
        frame:StartMoving()
    end)
    frame:SetScript("OnDragStop", function()
        frame:StopMovingOrSizing()
    end)
end

local function registerEvents()
    frame:RegisterEvent("PLAYER_UPDATE_RESTING")
    frame:RegisterEvent("UPDATE_EXHAUSTION")
    frame:RegisterEvent("OnUpdate")
    frame:SetScript('OnEvent', function()
        this[event]()
    end)
    frame:SetScript('OnUpdate', onUpdate)
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
        updateRestingTent(frame.restingTent, false)
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


function frame:PLAYER_UPDATE_RESTING()
    lastXPExhaustion = GetXPExhaustion()
    updateRestedXP(frame.restedInfo)
end

function frame:UPDATE_EXHAUSTION()
    lastUpdate = GetTime()
    updateRestedXP(frame.restedInfo)
	local XPMax = UnitXPMax("player")
    local XPExhaustion = GetXPExhaustion()
    local expectedTentGain = math.floor(XPMax * tentPercentage)
    local XPExhaustionGain = XPExhaustion - lastXPExhaustion
    lastXPExhaustion = XPExhaustion
    local XPExhaustionPercentage = XPExhaustion / XPMax * 100
    if (XPExhaustionGain < expectedTentGain) then
        updateRestingTent(frame.restingTent, false)
        return
    end
    updateRestingTent(frame.restingTent, true)
end

function onUpdate() 
    local elapsed = GetTime() - lastUpdate
    if (elapsed < 1.5) then
        return
    end
    frame:UPDATE_EXHAUSTION()
end

setupFrame()
setupTitle(frame)
setupRestedInfo(frame, frame.title)
setupRestingTent(frame, frame.restedInfo)
setupDrag(frame)
registerEvents()
