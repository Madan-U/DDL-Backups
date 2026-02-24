-- Object: PROCEDURE dbo.V2_RUNNINGBALANCES_CUR
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------



CREATE PROCEDURE V2_RUNNINGBALANCES_CUR  
(  
        @@NOFDAYS INT 
)  
  
AS  
  
/*==============================================================================================================  
        EXEC V2_RUNNINGBALANCES_CUR  
                @@NOFDAYS = 80 
==============================================================================================================*/  
  
        SET NOCOUNT ON

	DECLARE 
		@@VDATE DATETIME, 
		@@BALDATE INT 

	SET @@VDATE = LEFT(GETDATE() - @@NOFDAYS,11)

	WHILE @@VDATE <= LEFT(GETDATE(),11) 
	BEGIN 
		SET @@BALDATE = CONVERT(INT,CONVERT(VARCHAR,@@VDATE,112))

		EXEC V2_RUNNINGBALANCES_UP @@BALDATE

		SET @@VDATE = @@VDATE + 1
	END

GO
