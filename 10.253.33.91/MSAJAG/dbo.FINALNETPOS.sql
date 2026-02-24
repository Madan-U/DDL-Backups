-- Object: PROCEDURE dbo.FINALNETPOS
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.FINALNETPOS    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.FINALNETPOS    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.FINALNETPOS    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.FINALNETPOS    Script Date: 2/5/01 12:06:12 PM ******/

/****** Object:  Stored Procedure dbo.FINALNETPOS    Script Date: 12/27/00 8:59:07 PM ******/

/****** Object:  Stored Procedure dbo.FINALNETPOS    Script Date: 12/18/99 8:24:09 AM ******/
CREATE PROCEDURE FINALNETPOS
(@date varchar(10),@user_id int )
 AS
IF (SELECT COUNT(TRADE_NO) FROM TRADE WHERE CONVERT(VARCHAR,SAUDA_DATE,3) = convert(varchar,@date,3) and user_id = @user_id) 
>0 
EXEC TRADENETPOS @DATE,@USER_ID
ELSE
IF (SELECT COUNT(TRADE_NO) FROM SETTLEMENT WHERE CONVERT(VARCHAR,SAUDA_DATE,3) = convert(varchar,@date,3) and user_id = @user_id) 
>0 
EXEC SETTNETPOS @DATE,@USER_ID
ELSE 
EXEC HISTORYNETPOS @DATE,@USER_ID

GO
