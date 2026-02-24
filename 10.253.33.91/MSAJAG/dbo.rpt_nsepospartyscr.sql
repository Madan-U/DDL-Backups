-- Object: PROCEDURE dbo.rpt_nsepospartyscr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/* nse net position report 
    displays list of all scrips for a particular party code
*/    
CREATE PROCEDURE  rpt_nsepospartyscr

@settno varchar(7),
@settype varchar(3),
@saudadate   varchar(12),
@partycode varchar(10),
@flag char(1)


as

if @flag='1' 
begin
select  party_code, Scrip_Cd,series,sell_buy,pqty=isnull(pqty,0),sqty=isnull(sqty,0),pamt=isnull(pamt,0),
samt=isnull(samt,0),
sett_no,sett_type,
saudadate=convert(varchar, sauda_date,103)  from finalsumscripdatewise where sett_no=@settno  and sett_type=@settype
and convert(varchar, sauda_date,103)  = @saudadate  and party_code=@partycode
union all
select   party_code, Scrip_Cd,series,sell_buy,pqty=isnull(pqty,0),sqty=isnull(sqty,0),pamt=isnull(pamt,0),
samt=isnull(samt,0),sett_no,sett_type,saudadate=convert(varchar, sauda_date,103)  
from oppalbmscripdatewise where sett_no=@settno and sett_type=@settype 
and convert(varchar, sauda_date,103)  = @saudadate   and party_code=@partycode
union all
select party_code,  Scrip_Cd,series,sell_buy,pqty=isnull(pqty,0),sqty=isnull(sqty,0),pamt=isnull(pamt,0),
samt=isnull(samt,0),sett_no,sett_type,saudadate=convert(varchar, sauda_date,103)  
 from plusonealbmscripdatewise where sett_no = ( select min(Sett_no) from sett_mst 
where sett_no > @settno and sett_type = 'L' ) and sett_type =@settype   
and convert(varchar, sauda_date,103)  = @saudadate    and party_code=@partycode
order by party_code,  scrip_cd, series
end

if @flag='2' 
begin
select  party_code, Scrip_Cd,series,sell_buy,pqty=isnull(pqty,0),sqty=isnull(sqty,0),pamt=isnull(pamt,0),
samt=isnull(samt,0),
sett_no,sett_type,
saudadate=convert(varchar, sauda_date,103)  from finalsumscripdatewise where sett_no=@settno  and sett_type=@settype
and convert(varchar, sauda_date,103)  = @saudadate  and party_code=@partycode
union all
select   party_code, Scrip_Cd,series,sell_buy,pqty=isnull(pqty,0),sqty=isnull(sqty,0),pamt=isnull(pamt,0),
samt=isnull(samt,0),sett_no,sett_type,saudadate=convert(varchar, sauda_date,103)  
from oppalbmScripdatewisenot$   where sett_no=@settno and sett_type=@settype 
and convert(varchar, sauda_date,103)  = @saudadate   and party_code=@partycode
union all
select party_code,  Scrip_Cd,series,sell_buy,pqty=isnull(pqty,0),sqty=isnull(sqty,0),pamt=isnull(pamt,0),
samt=isnull(samt,0),sett_no,sett_type,saudadate=convert(varchar, sauda_date,103)  
 from plusonealbmscripdatewisenot$  where sett_no = ( select min(Sett_no) from sett_mst 
where sett_no > @settno and sett_type = 'L' ) and sett_type =@settype   
and convert(varchar, sauda_date,103)  = @saudadate    and party_code=@partycode
order by party_code,  scrip_cd, series
end

if @flag='3' 
begin
select  party_code, Scrip_Cd,series,sell_buy,pqty=isnull(pqty,0),sqty=isnull(sqty,0),pamt=isnull(pamt,0),
samt=isnull(samt,0),
sett_no,sett_type,
saudadate=convert(varchar, sauda_date,103)  from finalsumscripdatewise where sett_no=@settno  and sett_type=@settype
and convert(varchar, sauda_date,103)  = @saudadate  and party_code=@partycode
union all
select   party_code, Scrip_Cd,series,sell_buy,pqty=isnull(pqty,0),sqty=isnull(sqty,0),pamt=isnull(pamt,0),
samt=isnull(samt,0),sett_no,sett_type,saudadate=convert(varchar, sauda_date,103)  
from oppalbmscripdatewise$ where sett_no=@settno and sett_type=@settype 
and convert(varchar, sauda_date,103)  = @saudadate   and party_code=@partycode
union all
select party_code,  Scrip_Cd,series,sell_buy,pqty=isnull(pqty,0),sqty=isnull(sqty,0),pamt=isnull(pamt,0),
samt=isnull(samt,0),sett_no,sett_type,saudadate=convert(varchar, sauda_date,103)  
 from plusonealbmscripdatewise$ where sett_no = ( select min(Sett_no) from sett_mst 
where sett_no > @settno and sett_type = 'L' ) and sett_type =@settype   
and convert(varchar, sauda_date,103)  = @saudadate    and party_code=@partycode
order by party_code,  scrip_cd, series
end

GO
