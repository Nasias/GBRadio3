GBR_HyperlinkService = GBR_Object:New();

function GBR_HyperlinkService:New(obj)
    
    return self:RegisterNew(obj);

end

function GBR_HyperlinkService:ProcessHyperlink(link)

    print(strsplit(":", link));

end

function GBR_HyperlinkService:Wrap(linkText, parameters)

    local parameters = table.concat(parameters, ":");
    local linkStart = string.format("|H%s:%s", GBR_Constants.OPT_HOOK_HYPERLINKPREFIX, parameters);
    local linkEnd = string.format("|h%s|h", linkText);

    return linkStart .. linkEnd;

end