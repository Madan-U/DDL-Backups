-- Object: PROCEDURE dbo.brdramt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brdramt    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.brdramt    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brdramt    Script Date: 20-Mar-01 11:38:44 PM ******/

/****** Object:  Stored Procedure dbo.brdramt    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brdramt    Script Date: 12/27/00 8:58:44 PM ******/

CREATE PROCEDURE brdramt
@clcode varchar(6)
AS
SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0),
cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) 
from ledger,MSAJAG.DBO.client2 c2,MSAJAG.DBO.client1 c1,MSAJAG.DBO
where cltcode in 
(SELECT DISTINCT PARTY_CODE 
FROM MSAJAG.DBO.CLIENT2  
WHERE CL_CODE=@clcode)
and c1.cl_code = c2.cl_code 
and cltcode=party_code
 group by drcr

GO
