-- Object: PROCEDURE dbo.rpt_exchwiseallpartycldtl
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_exchwiseallpartycldtl    Script Date: 01/19/2002 12:15:14 ******/

/****** Object:  Stored Procedure dbo.rpt_exchwiseallpartycldtl    Script Date: 01/04/1980 5:06:26 AM ******/




/* report : exchangewise ledger */

/* displays client details */


CREATE PROCEDURE  rpt_exchwiseallpartycldtl

@clcode varchar(10)

AS

select Res_Phone1,Off_Phone1, short_name 
from clientmaster 
where cl_code=@clcode

GO
