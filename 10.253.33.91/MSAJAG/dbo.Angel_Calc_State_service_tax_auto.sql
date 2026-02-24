-- Object: PROCEDURE dbo.Angel_Calc_State_service_tax_auto
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure Angel_Calc_State_service_tax_auto        
as              
SET NOCOUNT ON              
              
declare @mdate as varchar(11)    
--Added by Rozina Raje---Start
select @mdate= convert(varchar(21),DATEADD(mm, DATEDIFF(m,0,getdate())-1,0))
----End---
/* Previously used
--convert(varchar(11),DBO.GETFIRSTDATE(case when datepart(mm,(getdate()))=1 then 12 else datepart(mm,getdate()) end,convert(varchar(4),case when datepart(mm,(getdate()))=1 then datepart(yy,(getdate()))-1 else datepart(yy,(getdate())) end)))   
--convert(varchar(3),substring(datename(mm,case when datepart(mm,(getdate()))=1 then 12 else datepart(mm,getdate())-1 end),1,3))+' 01 '+    
--convert(varchar(4),case when datepart(mm,(getdate()))=1 then datepart(yy,(getdate()))-1 else datepart(yy,(getdate())) end)    
  */  

DECLARE error_cursor CURSOR FOR               
select distinct convert(varchar(11),mdate)    
from intranet.risk.dbo.cal_full     
where mdate>=@mdate and mdate <=getdate()    
              
OPEN error_cursor              
              
FETCH NEXT FROM error_cursor               
INTO @mdate        
              
WHILE @@FETCH_STATUS = 0              
BEGIN              
  exec Angel_Calc_State_service_tax @mdate       
  --print  'calc_remi_bsecm_2 '+@mdate        
  FETCH NEXT FROM error_cursor               
  INTO @mdate        
              
END              
              
CLOSE error_cursor              
DEALLOCATE error_cursor              
            
Set Nocount Off

GO
