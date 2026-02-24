-- Object: PROCEDURE dbo.rpt_nseposscriponlyn
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/* report : nse netposition */
/* displays normal and albm effect for all scrips for a particular settlement and type
*/

CREATE PROCEDURE rpt_nseposscriponlyn

@settno varchar(7),
@settype varchar(3),
@scrip varchar(12),
@series varchar(3)


AS



select  Scrip_Cd,series,sell_buy,pqty=isnull(pqty,0),sqty=isnull(sqty,0),pamt=isnull(pamt,0),samt=isnull(samt,0),sett_no,sett_type,
saudadate=convert(varchar, sauda_date,103)  from finalsumscripdatewise where sett_no=@settno and sett_type=@settype and scrip_cd=@scrip 
and series=@series
order by scrip_cd, series,convert(varchar, sauda_date,103)

GO
