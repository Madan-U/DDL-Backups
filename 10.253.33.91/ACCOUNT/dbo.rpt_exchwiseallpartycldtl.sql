-- Object: PROCEDURE dbo.rpt_exchwiseallpartycldtl
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_exchwiseallpartycldtl    Script Date: 01/04/1980 1:40:41 AM ******/



/****** Object:  Stored Procedure dbo.rpt_exchwiseallpartycldtl    Script Date: 11/28/2001 12:23:49 PM ******/



/* report : exchangewise ledger */

/* displays client details */


CREATE PROCEDURE  rpt_exchwiseallpartycldtl

@clcode varchar(10)

AS

select Res_Phone1,Off_Phone1, short_name 
from msajag.dbo.clientmaster 
where cl_code=@clcode

GO
