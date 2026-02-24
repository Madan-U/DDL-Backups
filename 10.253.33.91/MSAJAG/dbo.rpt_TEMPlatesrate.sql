-- Object: PROCEDURE dbo.rpt_TEMPlatesrate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_TEMPlatesrate    Script Date: 04/27/2001 4:32:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_TEMPlatesrate    Script Date: 3/21/01 12:50:24 PM ******/

/****** Object:  Stored Procedure dbo.rpt_TEMPlatesrate    Script Date: 20-Mar-01 11:39:03 PM ******/


/*
written by bhushan ghorpade on 18 oct 
gives the onlie rate if present or else takes the closing rate 
from the closing file if the closing file contains todays data
*/
CREATE Procedure rpt_TEMPlatesrate
@scripcd varchar(12),
@series varchar(3)
AS

select scrip_cd,series, Lastrate=(Case when lastrate is null then 
  isnull((select cl_rate from closing where ldbmkt.scrip_cd = scrip_cd and ldbmkt.series = series and SysDate like left(convert(varchar,getdate(),109),11)+ '%' ),0)
  else
  (lastrate)
  end)
from ldbmkt
where scrip_cd = @scripcd and series =@series

/*
changed by bhushan on 14-02-2001
select scrip_cd,series, Lastrate = isnull(lastrate,0)
from ldbmkt
where scrip_cd = @scripcd and series =@series

*/

GO
