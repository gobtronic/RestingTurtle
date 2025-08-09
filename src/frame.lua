local mainFrame = MainFrame

local function setupFrame()
    mainFrame:ClearAllPoints()
    mainFrame:SetFrameStrata('LOW')
    mainFrame:SetWidth(100)
    mainFrame:SetHeight(30)
    mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end

local function setupTitle()
    mainFrame.title = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    mainFrame.title:SetPoint("TOPLEFT", mainFrame, "TOPLEFT", 0, 0)
    mainFrame.title:SetText("RestingTurtle")
end

local function setupRestedInfo(topFrame)
    mainFrame.restedInfo = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    mainFrame.restedInfo:SetPoint("TOPLEFT", topFrame, "BOTTOMLEFT", 0, 0)
    mainFrame.restedInfo:SetText("Rested info")
end

local function setupRestingTent(topFrame)
    mainFrame.restingTent = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    mainFrame.restingTent:SetPoint("TOPLEFT", topFrame, "BOTTOMLEFT", 0, 0)
    mainFrame.restingTent:SetText("You are under a tent!")
end

local function setupDrag() 
    mainFrame:EnableMouse(true)
    mainFrame:SetMovable(true)
    mainFrame:RegisterForDrag("LeftButton")
    mainFrame:SetScript("OnDragStart", function()
        mainFrame:StartMoving()
    end)
    mainFrame:SetScript("OnDragStop", function()
        mainFrame:StopMovingOrSizing()
    end)
end

mainFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
mainFrame:SetScript('OnEvent', function ()
  if event == 'PLAYER_ENTERING_WORLD' then
    setupFrame()
    setupTitle()
    setupRestedInfo(mainFrame.title)
    setupRestingTent(mainFrame.restedInfo)
    setupDrag()
  end
end)
