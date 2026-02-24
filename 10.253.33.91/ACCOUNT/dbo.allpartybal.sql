-- Object: PROCEDURE dbo.allpartybal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.allpartybal    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.allpartybal    Script Date: 11/28/2001 12:23:39 PM ******/

/****** Object:  Stored Procedure dbo.allpartybal    Script Date: 29-Sep-01 8:12:01 PM ******/

/****** Object:  Stored Procedure dbo.allpartybal    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.allpartybal    Script Date: 8/7/01 6:03:47 PM ******/

/****** Object:  Stored Procedure dbo.allpartybal    Script Date: 7/8/01 3:22:47 PM ******/

/****** Object:  Stored Procedure dbo.allpartybal    Script Date: 2/17/01 3:34:13 PM ******/


/****** Object:  Stored Procedure dbo.allpartybal    Script Date: 20-Mar-01 11:43:32 PM ******/

CREATE PROCEDURE  allpartybal
@cname  varchar(35),
@fromdt datetime
AS
select  dramt=isnull((case drcr when 'd' then sum(vamt) end),0),
cramt=isnull((case drcr when 'c' then sum(vamt) end),0)  
from ledger l,  MSAJAG.DBO.client2 c2, MSAJAG.DBO.client1 c1 where 
l.acname = c1.short_Name  and c2.party_code=l.cltcode 
and l.acname = @cname  and vdt<  @fromdt  
group by drcr

GO
