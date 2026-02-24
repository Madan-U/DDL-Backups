-- Object: PROCEDURE dbo.LedgerDetailAcmastSsP
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.LedgerDetailAcmastSsP    Script Date: 01/04/1980 1:40:38 AM ******/



/****** Object:  Stored Procedure dbo.LedgerDetailAcmastSsP    Script Date: 11/28/2001 12:23:44 PM ******/

/****** Object:  Stored Procedure dbo.LedgerDetailAcmastSsP    Script Date: 29-Sep-01 8:12:04 PM ******/

/****** Object:  Stored Procedure dbo.LedgerDetailAcmastSsP    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.LedgerDetailAcmastSsP    Script Date: 8/7/01 6:03:49 PM ******/

/****** Object:  Stored Procedure dbo.LedgerDetailAcmastSsP    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.LedgerDetailAcmastSsP    Script Date: 2/17/01 3:34:15 PM ******/


/****** Object:  Stored Procedure dbo.LedgerDetailAcmastSsP    Script Date: 20-Mar-01 11:43:33 PM ******/

CREATE PROCEDURE LedgerDetailAcmastSsP
 AS
select distinct acname 
from acmast 
 order by acname

GO
