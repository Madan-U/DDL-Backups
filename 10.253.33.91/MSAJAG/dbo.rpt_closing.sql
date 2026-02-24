-- Object: PROCEDURE dbo.rpt_closing
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE   PROCEDURE rpt_closing
@scripcd varchar(10)
 AS
select MARKET,SCRIP_CD,SERIES, Cl_Rate   , convert(varchar,SysDate,103) as sysdate
from closing 
where scrip_cd like ltrim( @scripcd+'%' )
order by scrip_cd

GO
