GBR_HookService = GBR_Object:New();

function GBR_HookService:New(obj)

    return self:RegisterNew(obj);

end

function GBR_HookService:RegisterHooks()

    self:RegisterHyperlinkHook();

end

function GBR_HookService:RegisterHyperlinkHook()

    local OriginalSetHyperlink = ItemRefTooltip.SetHyperlink;

    function ItemRefTooltip:SetHyperlink(link, ...)
        local hyperlinkService = GBR_Singletons:FetchService(GBR_Constants.SRV_HYPERLINK_SERVICE);

        if link and link:sub(0, GBR_Constants.OPT_HOOK_HYPERLINKPREFIX:len()) == GBR_Constants.OPT_HOOK_HYPERLINKPREFIX then

            hyperlinkService:ProcessHyperlink(link);

            return;
        end

        return OriginalSetHyperlink(self, link, ...);
    end

end