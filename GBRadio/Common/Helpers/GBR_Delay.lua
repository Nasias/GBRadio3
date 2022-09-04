GBR_Delay = {
  WaitTable = {},
  WaitFrame = nil
};

function GBR_Delay:Delay(delay, func, ...)
    if(type(delay)~="number" or type(func)~="function") then
      return false;
    end
    if(GBR_Delay.WaitFrame == nil) then
      GBR_Delay.WaitFrame = CreateFrame("Frame","GBRWaitFrame", UIParent);
      GBR_Delay.WaitFrame:SetScript("onUpdate",function (self,elapse)
        local count = #GBR_Delay.WaitTable;
        local i = 1;
        while(i<=count) do
          local waitRecord = tremove(GBR_Delay.WaitTable,i);
          local d = tremove(waitRecord,1);
          local f = tremove(waitRecord,1);
          local p = tremove(waitRecord,1);
          if(d>elapse) then
            tinsert(GBR_Delay.WaitTable,i,{d-elapse,f,p});
            i = i + 1;
          else
            count = count - 1;
            f(unpack(p));
          end
        end
      end);
    end
    tinsert(GBR_Delay.WaitTable,{delay,func,{...}});
    return true;
  end;