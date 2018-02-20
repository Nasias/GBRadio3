GBR_Converter = {};

function GBR_Converter.ColourToHex(colour)

    return string.format(GBR_Constants.STRING_FORMAT_HEX, colour * 255);

end

function GBR_Converter.EscapeCSV(s)

    if string.find(s, '[,"]') then
        s = '"' .. string.gsub(s, '"', '""') .. '"';
    end

    return s;
end
--region 
function GBR_Converter.StrToTable(s)

    s = s .. ',';

    local t = {};
    local fieldstart = 1;

    repeat
        if string.find(s, '^"', fieldstart) then

            local a, c;
            local i  = fieldstart;

            repeat
                a, i, c = string.find(s, '"("?)', i+1);
            until c ~= '"'

            if not i then 
                error('unmatched "') 
            end

            local f = string.sub(s, fieldstart+1, i-1);

            table.insert(t, (string.gsub(f, '""', '"')));
            fieldstart = string.find(s, ',', i) + 1;

        else

            local nexti = string.find(s, ',', fieldstart);
            table.insert(t, string.sub(s, fieldstart, nexti-1));
            fieldstart = nexti + 1;

        end
    until fieldstart > string.len(s)

    return t;

end

function GBR_Converter.TableToStr (tt)

    local s = "";

    for _,p in ipairs(tt) do  
        s = s .. ',' .. GBR_Converter.EscapeCSV(p);
    end

    return string.sub(s, 2);

end

