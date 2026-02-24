-- Object: PROCEDURE dbo.rpt_nseposscripalbm
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/* report : nse netposition */
/* displays normal and albm effect for all scrips for a particular settlement and type
*/

CREATE PROCEDURE rpt_nseposscripalbm

@settno varchar(7),
@settype varchar(3),
@scrip varchar(12),
@series varchar(3),
@flag char(1)


AS

/* if user has selected n or w type */
if  @flag='1'
begin
select  Scrip_Cd,series,sell_buy,pqty=isnull(pqty,0),sqty=isnull(sqty,0),pamt=isnull(pamt,0),samt=isnull(samt,0),sett_no,sett_type,saudadate=convert(varchar, sauda_date,103)  from finalsumscripdatewise where sett_no=@settno and sett_type=@settype and scrip_cd=@scrip and series=@series
union all
select   Scrip_Cd,series,sell_buy,pqty=isnull(pqty,0),sqty=isnull(sqty,0),pamt=isnull(pamt,0),samt=isnull(samt,0),sett_no,sett_type,saudadate=convert(varchar, sauda_date,103)  from oppalbmscripdatewise where sett_no=@settno and sett_type=@settype  and scrip_cd=@scrip and series=@series
union all
select   Scrip_Cd,series,sell_buy,pqty=isnull(pqty,0),sqty=isnull(sqty,0),pamt=isnull(pamt,0),samt=isnull(samt,0),sett_no,sett_type,saudadate=convert(varchar, sauda_date,103)   from plusonealbmscripdatewise where sett_no = ( select min(Sett_no) from sett_mst where sett_no >@settno  and sett_type = 'L' ) and sett_type =@settype  and scrip_cd=@scrip and series=@series
order by scrip_cd, series,convert(varchar, sauda_date,103)
end 

/* if user has selected n-l(p) */
if @flag='2'
begin
select  Scrip_Cd,series,sell_buy,pqty=isnull(pqty,0),sqty=isnull(sqty,0),pamt=isnull(pamt,0),samt=isnull(samt,0),sett_no,sett_type,saudadate=convert(varchar, sauda_date,103)  from finalsumscripdatewise where sett_no=@settno and sett_type=@settype and scrip_cd=@scrip and series=@series
union all
select   Scrip_Cd,series,sell_buy,pqty=isnull(pqty,0),sqty=isnull(sqty,0),pamt=isnull(pamt,0),samt=isnull(samt,0),sett_no,sett_type,saudadate=convert(varchar, sauda_date,103)  from oppalbmScripdatewisenot$  where sett_no=@settno and sett_type=@settype  and scrip_cd=@scrip and series=@series
union all
select   Scrip_Cd,series,sell_buy,pqty=isnull(pqty,0),sqty=isnull(sqty,0),pamt=isnull(pamt,0),samt=isnull(samt,0),sett_no,sett_type,saudadate=convert(varchar, sauda_date,103)   from plusonealbmscripdatewisenot$ where sett_no = ( select min(Sett_no) from sett_mst where sett_no >@settno  and sett_type = 'L' ) and sett_type =@settype  and scrip_cd=@scrip and series=@series
order by scrip_cd, series,convert(varchar, sauda_date,103)
end

/* if user has selected n-l(d) */
if @flag='3'
begin
select  Scrip_Cd,series,sell_buy,pqty=isnull(pqty,0),sqty=isnull(sqty,0),pamt=isnull(pamt,0),samt=isnull(samt,0),sett_no,sett_type,saudadate=convert(varchar, sauda_date,103)  from finalsumscripdatewise where sett_no=@settno and sett_type=@settype and scrip_cd=@scrip and series=@series
union all
select   Scrip_Cd,series,sell_buy,pqty=isnull(pqty,0),sqty=isnull(sqty,0),pamt=isnull(pamt,0),samt=isnull(samt,0),sett_no,sett_type,saudadate=convert(varchar, sauda_date,103)  from oppalbmscripdatewise$  where sett_no=@settno and sett_type=@settype  and scrip_cd=@scrip and series=@series
union all
select   Scrip_Cd,series,sell_buy,pqty=isnull(pqty,0),sqty=isnull(sqty,0),pamt=isnull(pamt,0),samt=isnull(samt,0),sett_no,sett_type,saudadate=convert(varchar, sauda_date,103)   from plusonealbmscripdatewise$  where sett_no = ( select min(Sett_no) from sett_mst where sett_no >@settno  and sett_type = 'L' ) and sett_type =@settype  and scrip_cd=@scrip and series=@series
order by scrip_cd, series,convert(varchar, sauda_date,103)
end

GO
