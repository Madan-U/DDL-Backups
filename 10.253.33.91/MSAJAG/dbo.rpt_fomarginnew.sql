-- Object: PROCEDURE dbo.rpt_fomarginnew
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fomarginnew    Script Date: 5/11/01 6:19:48 PM ******/
CREATE PROCEDURE rpt_fomarginnew

@code varchar(10),
@sdate varchar(12),
@cltm varchar(3)

AS

select m.party_code, spreadmargin, nonspreadmargin, totalmargin , PMarginAmount, pmargin
from fomarginnew m
where m.party_code LIKE ltrim(@code)+'%'
and  LEFT(convert(varchar,m.mdate,109),11)  = @sdate
and cl_type like ltrim(@cltm)+'%'
order by party_code

GO
