getRestedXPPercentage = function()
	local XPMax = UnitXPMax("player")
    local XPExhaustion = GetXPExhaustion()
    if (not XPExhaustion) then return 0 end
    return XPExhaustion / XPMax * 100
end
