-- Object: PROCEDURE dbo.rpt_bsefoclamt
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_bsefoclamt    Script Date: 01/04/1980 1:40:40 AM ******/



/****** Object:  Stored Procedure dbo.rpt_bsefoclamt    Script Date: 11/28/2001 12:23:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsefoclamt    Script Date: 29-Sep-01 8:12:06 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsefoclamt    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsefoclamt    Script Date: 8/7/01 6:03:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsefoclamt    Script Date: 7/8/01 3:22:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_bsefoclamt    Script Date: 2/17/01 3:34:16 PM ******/


/****** Object:  Stored Procedure dbo.rpt_bsefoclamt    Script Date: 20-Mar-01 11:43:34 PM ******/

/*Modified by Amolika on 7th feb'2001 : Added condition for sdate
Modified by Amolika on 12th feb'2001 
*/
CREATE PROCEDURE rpt_bsefoclamt

@code varchar(10),
@sdate varchar(12)

AS
/*select isnull(sum(cvamt),0) as cvamt, isnull(sum(dvamt),0) as dvamt 
from rpt_fopartybalamt 
where cltcode = @code
and left(convert(varchar,vdt,109),11) = @sdate
*/

select isnull(balamt,0)  as balamt
from ledger t
where cltcode = @code
and left(convert(varchar,vdt,109),11) = @sdate
and vno = (select max(vno) from ledger  where t.cltcode = cltcode and t.vdt = vdt)

GO
