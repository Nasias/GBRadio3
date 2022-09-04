GBR_TooltipService = GBR_Object:New();

function GBR_TooltipService:New(obj)
    
    self._tooltipWidget = nil;

    return self:RegisterNew(obj);

end

function GBR_TooltipService:_getTooltipWidget()

    self._tooltipWidget = self._tooltipWidget or CreateFrame("GameTooltip", "GBRadioTooltip", UIParent, "SharedTooltipTemplate");
    return self._tooltipWidget;

end

function GBR_TooltipService:ShowTooltip(parent, name, desc, note)

    local tooltip = self:_getTooltipWidget();

    tooltip:SetOwner(parent, "ANCHOR_TOPRIGHT");

    tooltip:SetText(name, 1, .82, 0, true);

    if desc then
        tooltip:AddLine(desc, 1, 1, 1, true);
    end

    if note then
        tooltip:AddLine(" ");
        tooltip:AddLine(note, 0, 1, 0, true);
    end

    tooltip:Show();

end

function GBR_TooltipService:HideTooltip()

    self._tooltipWidget:Hide();

end