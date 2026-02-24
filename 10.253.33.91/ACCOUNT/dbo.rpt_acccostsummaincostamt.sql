-- Object: PROCEDURE dbo.rpt_acccostsummaincostamt
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_acccostsummaincostamt    Script Date: 01/04/1980 1:40:39 AM ******/



/****** Object:  Stored Procedure dbo.rpt_acccostsummaincostamt    Script Date: 11/28/2001 12:23:46 PM ******/


/*report  : cost center summary */ 

/* calculates total debit and credit and balance of a cost center of a category */


CREATE PROCEDURE  rpt_acccostsummaincostamt

@grpcode varchar(20),
@catcode smallint,
@vdt datetime

AS




select dramt=isnull(sum(dramt),0), cramt=isnull(sum(cramt),0), amt = isnull(sum(dramt)-sum(cramt) ,0)
from rpt_acccostwisedrcr
where  catcode=@catcode
and grpcode like ltrim(@grpcode) + '%'
and vdt <= @vdt +  ' 23:59:59'

GO
