-- Object: PROCEDURE dbo.FinalBill
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.FinalBill    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.FinalBill    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.FinalBill    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.FinalBill    Script Date: 2/5/01 12:06:12 PM ******/

/****** Object:  Stored Procedure dbo.FinalBill    Script Date: 12/27/00 8:59:07 PM ******/

/****** Object:  Stored Procedure dbo.FinalBill    Script Date: 12/18/99 8:24:13 AM ******/
CREATE PROCEDURE FinalBill
(@sett_no varchar(7),@sett_type varchar(2) ,@party varchar(10))
 AS
IF (SELECT COUNT(TRADE_NO) FROM SETTLEMENT WHERE party_code = @party and sett_no = @sett_no and sett_type = @sett_Type AND TRADEQTY >  0 AND BILLNO <> '0' ) 
>0 
EXEC SETTrebill @sett_no, @sett_type,@party
ELSE 
EXEC HISTORYrebill @sett_no, @sett_type,@party

GO
