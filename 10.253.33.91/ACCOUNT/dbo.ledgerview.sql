-- Object: PROCEDURE dbo.ledgerview
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ledgerview    Script Date: 01/04/1980 1:40:38 AM ******/



/****** Object:  Stored Procedure dbo.ledgerview    Script Date: 11/28/2001 12:23:45 PM ******/

/****** Object:  Stored Procedure dbo.ledgerview    Script Date: 29-Sep-01 8:12:05 PM ******/

/****** Object:  Stored Procedure dbo.ledgerview    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.ledgerview    Script Date: 8/7/01 6:03:49 PM ******/

/****** Object:  Stored Procedure dbo.ledgerview    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.ledgerview    Script Date: 2/17/01 3:34:15 PM ******/


/****** Object:  Stored Procedure dbo.ledgerview    Script Date: 20-Mar-01 11:43:34 PM ******/

CREATE PROCEDURE ledgerview 
@fromdt datetime,
@todt datetime,
@partycode varchar(10)
AS
select drtot=isnull((case drcr when 'd' then sum(vamt) end),0), crtot=isnull((case drcr when 'c' then sum(vamt) end),0) 
from ledger WHERE (VDT >=@fromdt AND
 VDT <=@todt +  "11:59 pm"  )and CLTCODE=@partycode
group by drcr

GO
