-- Object: PROCEDURE dbo.table22
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc table22
as

begin




select cl_code,long_name, Branch_cd,sub_broker,l_address1,l_address2,l_address3,l_city,l_zip,l_state,l_nation into #temp1
 from Client_Details
where sub_broker in ('SEHE','YYAT','SWWV','LING','SUEN','SRHA','MMSZ','RRHJ','ADDY','MAER')
order by sub_broker



select a.cl_code,long_name, Branch_cd,sub_broker,Trader,Area,Region,SBU ,exchange,segment,inactive_from 
,Deactive_Remarks,Deactive_value into #temp2
from Client_Details a with (nolock),CLIENT_BROK_DETAILS b with (nolock)
where a.cl_code=b.Cl_Code 
and sub_broker in ('SEHE','YYAT','RRHJ','ADDY','MAER')
order by sub_broker

declare @sql  int

declare @sql1  int

set @sql = (select count (cl_code) from #temp1) 
 
set @sql1 =  (select count (cl_code) from #temp2) 

 --select   @sql
 --select   @sql1

  if @sql >=  @sql1
  (
  select distinct a.cl_code,b.cl_code from #temp1 a left outer join #temp2 b on a.cl_code = b.cl_code )
 -- else 
--( select distinct a.cl_code,b.cl_code from #temp2 a left outer join #temp1 b on a.cl_code = b.cl_code 
--)

else
  ( select distinct a.cl_code,b.cl_code from #temp2 a right outer join #temp1 b on a.cl_code = b.cl_code 
)
end



--exec table22

GO
