-- Object: PROCEDURE dbo.drcr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.drcr    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.drcr    Script Date: 3/21/01 12:50:06 PM ******/

/****** Object:  Stored Procedure dbo.drcr    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.drcr    Script Date: 2/5/01 12:06:12 PM ******/

/****** Object:  Stored Procedure dbo.drcr    Script Date: 12/27/00 8:58:49 PM ******/

CREATE PROCEDURE drcr
@todt datetime,
@partycode varchar(10)
AS
select drtot=isnull((case drcr when 'd' then sum(vamt) end),0), crtot=isnull((case drcr when 'c' then sum(vamt) end),0) 
from ledger WHERE VDT <= @todt +  " 11:59PM"
and CLTCODE=@partycode
group by drcr

GO
