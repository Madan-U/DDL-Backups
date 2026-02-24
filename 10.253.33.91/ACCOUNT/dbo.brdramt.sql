-- Object: PROCEDURE dbo.brdramt
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brdramt    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.brdramt    Script Date: 11/28/2001 12:23:41 PM ******/

/****** Object:  Stored Procedure dbo.brdramt    Script Date: 29-Sep-01 8:12:02 PM ******/

/****** Object:  Stored Procedure dbo.brdramt    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.brdramt    Script Date: 8/7/01 6:03:47 PM ******/

/****** Object:  Stored Procedure dbo.brdramt    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.brdramt    Script Date: 2/17/01 3:34:14 PM ******/


/****** Object:  Stored Procedure dbo.brdramt    Script Date: 20-Mar-01 11:43:32 PM ******/

CREATE PROCEDURE brdramt
@clcode varchar(6)
AS
SELECT dramt=isnull((case drcr when 'd' then SUM(vamt)end),0),
cramt=isnull((case drcr when 'c' then SUM(vamt)end),0) 
from ledger,MSAJAG.DBO.client2 c2,MSAJAG.DBO.client1 c1
where cltcode in 
(SELECT DISTINCT PARTY_CODE 
FROM MSAJAG.DBO.CLIENT2  
WHERE CL_CODE=@clcode)
and c1.cl_code = c2.cl_code 
and cltcode=party_code
 group by drcr

GO
