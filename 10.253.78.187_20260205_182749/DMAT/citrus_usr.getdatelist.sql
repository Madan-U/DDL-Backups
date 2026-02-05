-- Object: PROCEDURE citrus_usr.getdatelist
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[getdatelist]      
as      
begin      
declare @l_min_date datetime      
,@l_max_date datetime      
    delete from l_datalist  
      
select @l_min_date = min(cdshm_tras_dt)-1 from cdsl_holding_dtls      
select @l_max_date = max(cdshm_tras_dt) from cdsl_holding_dtls      
      
while @l_min_date <=@l_max_date      
begin       
      
insert into l_datalist      
select @l_min_date      
      
set @l_min_date  = @l_min_date  + 1       
end      
      
end

GO
