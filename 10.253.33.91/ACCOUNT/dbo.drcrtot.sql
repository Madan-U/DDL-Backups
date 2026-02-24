-- Object: PROCEDURE dbo.drcrtot
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.drcrtot    Script Date: 01/04/1980 1:40:37 AM ******/



/****** Object:  Stored Procedure dbo.drcrtot    Script Date: 11/28/2001 12:23:43 PM ******/

/****** Object:  Stored Procedure dbo.drcrtot    Script Date: 29-Sep-01 8:12:04 PM ******/

/****** Object:  Stored Procedure dbo.drcrtot    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.drcrtot    Script Date: 8/7/01 6:03:48 PM ******/

/****** Object:  Stored Procedure dbo.drcrtot    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.drcrtot    Script Date: 2/17/01 3:34:15 PM ******/


/****** Object:  Stored Procedure dbo.drcrtot    Script Date: 20-Mar-01 11:43:33 PM ******/

CREATE PROCEDURE drcrtot
@cname varchar(35),
@fromdt datetime,
@todt datetime
AS
select  dramt=isnull((case drcr when 'd' then sum(vamt) end),0), 
cramt=isnull((case drcr when 'c' then sum(vamt) end),0)  
from ledger l , vmast,  MSAJAG.DBO.client2 c2 , 
MSAJAG.DBO.client1 c1 where 
l.acname = c1.short_Name and c1.cl_code = c2.cl_code and c2.party_code=l.cltcode 
and l.acname = @cname and vtyp=vtype and vdt >=@fromdt and
vdt<=@todt +  "11:59pm"
group by drcr

GO
