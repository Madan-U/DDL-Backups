-- Object: PROCEDURE dbo.drcr
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.drcr    Script Date: 01/04/1980 1:40:37 AM ******/



/****** Object:  Stored Procedure dbo.drcr    Script Date: 11/28/2001 12:23:43 PM ******/

/****** Object:  Stored Procedure dbo.drcr    Script Date: 29-Sep-01 8:12:04 PM ******/

/****** Object:  Stored Procedure dbo.drcr    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.drcr    Script Date: 8/7/01 6:03:48 PM ******/

/****** Object:  Stored Procedure dbo.drcr    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.drcr    Script Date: 2/17/01 3:34:14 PM ******/


/****** Object:  Stored Procedure dbo.drcr    Script Date: 20-Mar-01 11:43:33 PM ******/

CREATE PROCEDURE drcr
@todt datetime,
@partycode varchar(10)
AS
select drtot=isnull((case drcr when 'd' then sum(vamt) end),0), crtot=isnull((case drcr when 'c' then sum(vamt) end),0) 
from ledger WHERE VDT <= @todt +  " 11:59PM"
and CLTCODE=@partycode
group by drcr

GO
