-- Object: PROCEDURE dbo.V2_INTEREST_CUR
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------



CREATE PROCEDURE V2_INTEREST_CUR  
(  
        @@NOFDAYS INT 
)  
  
AS  
  
/*==============================================================================================================  
        EXEC V2_INTEREST_CUR  
                @@NOFDAYS = 70 
==============================================================================================================*/  
  
        SET NOCOUNT ON

	DECLARE 
		@@VDATE DATETIME, 
		@@BALDATE INT 

	SET @@VDATE = LEFT(GETDATE() - @@NOFDAYS,11)

	WHILE @@VDATE <= LEFT(GETDATE(),11) 
	BEGIN 
		SET @@BALDATE = CONVERT(INT,CONVERT(VARCHAR,@@VDATE,112))

		DELETE FROM V2_INTEREST WHERE INTDATE = @@BALDATE

		INSERT INTO V2_INTEREST EXEC V2_INTEREST_CAL @@BALDATE

		SET @@VDATE = @@VDATE + 1
	END

GO
