-- Object: PROCEDURE dbo.SpAdjustBal
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SpAdjustBal    Script Date: 01/04/1980 1:40:43 AM ******/



/****** Object:  Stored Procedure dbo.SpAdjustBal    Script Date: 11/28/2001 12:23:52 PM ******/

/****** Object:  Stored Procedure dbo.SpAdjustBal    Script Date: 29-Sep-01 8:12:07 PM ******/

/****** Object:  Stored Procedure dbo.SpAdjustBal    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.SpAdjustBal    Script Date: 8/7/01 6:03:53 PM ******/

/****** Object:  Stored Procedure dbo.SpAdjustBal    Script Date: 7/8/01 3:22:51 PM ******/

/****** Object:  Stored Procedure dbo.SpAdjustBal    Script Date: 2/17/01 3:34:19 PM ******/


/****** Object:  Stored Procedure dbo.SpAdjustBal    Script Date: 20-Mar-01 11:43:36 PM ******/

CREATE PROCEDURE  SpAdjustBal   @trefno varchar(12) 
,@tvamt   numeric(12,2 )
,@drcr varchar(1)
AS
if @drcr='d'
 update ledger set balamt = @tvamt  +  vamt    where refno=@trefno
else
 update ledger set balamt = @tvamt   -    vamt    where refno=@trefno

GO
