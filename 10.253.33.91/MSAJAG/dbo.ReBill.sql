-- Object: PROCEDURE dbo.ReBill
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ReBill    Script Date: 3/17/01 9:55:54 PM ******/

/****** Object:  Stored Procedure dbo.ReBill    Script Date: 3/21/01 12:50:11 PM ******/

/****** Object:  Stored Procedure dbo.ReBill    Script Date: 20-Mar-01 11:38:53 PM ******/

/****** Object:  Stored Procedure dbo.ReBill    Script Date: 2/5/01 12:06:15 PM ******/

/****** Object:  Stored Procedure dbo.ReBill    Script Date: 12/27/00 8:59:08 PM ******/

/****** Object:  Stored Procedure dbo.ReBill    Script Date: 12/18/99 8:24:10 AM ******/
CREATE PROCEDURE ReBill
(@sett_no varchar(7),@sett_Type varchar(2),@party varchar(10))
 AS
IF (SELECT COUNT(TRADE_NO) FROM SETTLEMENT WHERE  party_code = @party and sett_no = @sett_no and sett_Type = @sett_type) 
>0 
EXEC SETTNETPOS @sett_no,@sett_type,@party
ELSE 
EXEC HISTORYNETPOS @sett_no,@sett_Type,@party

GO
