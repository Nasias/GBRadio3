GBR_Table = {};

function GBR_Table.findIndex(table, value)

    for i,v in pairs(table) do

        if v == value then
            return i; 
        end

    end

    return 0;

end