-- Object: PROCEDURE dbo.singlepartydrcr
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.singlepartydrcr    Script Date: 01/04/1980 1:40:43 AM ******/



/****** Object:  Stored Procedure dbo.singlepartydrcr    Script Date: 11/28/2001 12:23:52 PM ******/

/****** Object:  Stored Procedure dbo.singlepartydrcr    Script Date: 29-Sep-01 8:12:07 PM ******/

/****** Object:  Stored Procedure dbo.singlepartydrcr    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.singlepartydrcr    Script Date: 8/7/01 6:03:53 PM ******/

/****** Object:  Stored Procedure dbo.singlepartydrcr    Script Date: 7/8/01 3:22:51 PM ******/

/****** Object:  Stored Procedure dbo.singlepartydrcr    Script Date: 2/17/01 3:34:19 PM ******/


/****** Object:  Stored Procedure dbo.singlepartydrcr    Script Date: 20-Mar-01 11:43:36 PM ******/

CREATE PROCEDURE singlepartydrcr
@partycode varchar(10)
as
select drtot=isnull((case drcr when 'd' then sum(vamt) end),0), crtot=isnull((case drcr when 'c' then sum(vamt) end),0) 
from ledger WHERE VDT <= getdate() + "11:59PM" and CLTCODE=@partycode
group by drcr

GO
