-- Object: PROCEDURE dbo.Angel_GetNseHistoryData
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
 CREATE procedure Angel_GetNseHistoryData          
as 
begin         
declare @fromdate as datetime          
select @fromdate=(locked_upto+1) from mis.remisior.dbo.company where coshrtname='ACDLCM'          
          
insert into nsedata_temp select * from history with(nolock) where sauda_date >= @fromdate          
          
--insert into nsedata_temp select * from inhouse.dbo.history_jan where sauda_date >= @fromdate          
end

GO
