-- Object: PROCEDURE dbo.sbconfdrcrtot
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbconfdrcrtot    Script Date: 01/04/1980 1:40:42 AM ******/



/****** Object:  Stored Procedure dbo.sbconfdrcrtot    Script Date: 11/28/2001 12:23:51 PM ******/

/****** Object:  Stored Procedure dbo.sbconfdrcrtot    Script Date: 29-Sep-01 8:12:07 PM ******/

/****** Object:  Stored Procedure dbo.sbconfdrcrtot    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.sbconfdrcrtot    Script Date: 8/7/01 6:03:53 PM ******/

/****** Object:  Stored Procedure dbo.sbconfdrcrtot    Script Date: 7/8/01 3:22:51 PM ******/

/****** Object:  Stored Procedure dbo.sbconfdrcrtot    Script Date: 2/17/01 3:34:18 PM ******/


/****** Object:  Stored Procedure dbo.sbconfdrcrtot    Script Date: 20-Mar-01 11:43:36 PM ******/

CREATE PROCEDURE sbconfdrcrtot
@cname varchar(35)
AS
select  dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
cramt=isnull((case drcr when 'c' then sum(vamt) end),0)  
from ledger l , vmast,  MSAJAG.DBO.client2 c2 , 
MSAJAG.DBO.client1 c1 where 
l.acname = c1.short_Name and c1.cl_code = c2.cl_code and c2.party_code=l.cltcode 
and l.acname = @cname and vtyp=vtype group by drcr

GO
