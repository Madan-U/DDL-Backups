-- Object: FUNCTION citrus_usr.getfixedchargedate
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[getfixedchargedate](@startdate datetime,@bill_fr_date datetime,@bill_to_date datetime,@billinterval char(1), @billperiod int,@excmid int ) returns datetime    
as    
begin    
 while @bill_to_date >= @startdate    
 begin    
  if @billinterval = 'D'    
  begin    
  --    
    set @startdate = dateadd(d,@billperiod,@startdate)      
  --    
  end    
  else     
  begin    
  --    
    set @startdate = dateadd(m,@billperiod,@startdate)      
  --    
  end    
  if exists(select holm_excm_id from holiday_mstr where holm_excm_id = @excmid and holm_dt = @startdate and holm_deleted_ind = 1)    
  begin    
  set @startdate = citrus_usr.GetNextWorkingDate(@startdate,@excmid )    
  end    
  if (@bill_to_date = @startdate or (@startdate between @bill_fr_date and @bill_to_date))    
  begin    
   return @startdate    
  end    
 end    
    
return null    
    
    
end    
    




  
--select [citrus_usr].[getfixedchargedate]('aug 18 2008','sep 01 2008','sep 30 2008','m',1,4)

GO
