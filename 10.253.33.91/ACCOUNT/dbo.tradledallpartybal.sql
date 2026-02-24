-- Object: PROCEDURE dbo.tradledallpartybal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.tradledallpartybal    Script Date: 01/04/1980 1:40:43 AM ******/



/****** Object:  Stored Procedure dbo.tradledallpartybal    Script Date: 11/28/2001 12:23:53 PM ******/

/****** Object:  Stored Procedure dbo.tradledallpartybal    Script Date: 29-Sep-01 8:12:08 PM ******/

/****** Object:  Stored Procedure dbo.tradledallpartybal    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.tradledallpartybal    Script Date: 8/7/01 6:03:54 PM ******/

/****** Object:  Stored Procedure dbo.tradledallpartybal    Script Date: 7/8/01 3:22:52 PM ******/

/****** Object:  Stored Procedure dbo.tradledallpartybal    Script Date: 2/17/01 3:34:19 PM ******/


/****** Object:  Stored Procedure dbo.tradledallpartybal    Script Date: 20-Mar-01 11:43:36 PM ******/

CREATE PROCEDURE tradledallpartybal
@cname varchar(35)
 AS
select  dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
cramt=isnull((case drcr when 'c' then sum(vamt) end),0) 
from ledger l , vmast,  MSAJAG.DBO.client2 c2 , 
MSAJAG.DBO.client1 c1 where 
l.acname = c1.short_Name and c1.cl_code = c2.cl_code and c2.party_code=l.cltcode 
and l.acname = @cname and vtyp=vtype group by drcr

GO
