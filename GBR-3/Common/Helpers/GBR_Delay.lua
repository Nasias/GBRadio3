GBR_Delay = {};

function GBR_Delay:Delay(delay, func, ...)
    if(type(delay)~="number" or type(func)~="function") then
      return false;
    end
    if(waitFrame == nil) then
      waitFrame = CreateFrame("Frame","GBRWaitFrame", UIParent);
      waitFrame:SetScript("onUpdate",function (self,elapse)
        local count = #waitTable;
        local i = 1;
        while(i<=count) do
          local waitRecord = tremove(waitTable,i);
          local d = tremove(waitRecord,1);
          local f = tremove(waitRecord,1);
          local p = tremove(waitRecord,1);
          if(d>elapse) then
            tinsert(waitTable,i,{d-elapse,f,p});
            i = i + 1;
          else
            count = count - 1;
            f(unpack(p));
          end
        end
      end);
    end
    tinsert(waitTable,{delay,func,{...}});
    return true;
  end;