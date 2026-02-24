-- Object: PROCEDURE dbo.rpt_focllistmargin
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_focllistmargin    Script Date: 5/11/01 6:19:47 PM ******/
CREATE PROCEDURE rpt_focllistmargin

@cltype varchar(3)

AS

select distinct "<option value="+rtrim(s.party_code)+">"+rtrim(s.party_code)+"</option>" 
from fomarginnew s
where cl_type like ltrim(@cltype)+'%'

GO
