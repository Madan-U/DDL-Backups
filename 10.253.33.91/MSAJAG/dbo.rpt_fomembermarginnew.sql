-- Object: PROCEDURE dbo.rpt_fomembermarginnew
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomembermarginnew    Script Date: 5/11/01 6:19:48 PM ******/
CREATE PROCEDURE rpt_fomembermarginnew

@sdate varchar(12)

AS

select party_code, totalmargin, cl_type
from fomarginnew
where left(convert(varchar,MDATE,109),11) = @sdate
and cl_type = 'CL'
order by party_code

GO
