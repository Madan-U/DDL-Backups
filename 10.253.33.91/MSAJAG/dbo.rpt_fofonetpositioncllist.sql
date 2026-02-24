-- Object: PROCEDURE dbo.rpt_fofonetpositioncllist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fofonetpositioncllist    Script Date: 5/11/01 6:19:47 PM ******/
CREATE PROCEDURE rpt_fofonetpositioncllist

@cltype varchar(3)

AS

select distinct s.party_code 
from client1 c1, client2 c2, fosettlement s
where c1.cl_code = c2.cl_code
and c2.party_code = s.party_code
and c1.cl_type = @cltype

GO
