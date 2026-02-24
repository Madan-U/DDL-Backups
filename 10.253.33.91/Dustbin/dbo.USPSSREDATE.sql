-- Object: PROCEDURE dbo.USPSSREDATE
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------


CREATE PROC USPSSREDATE (@FDATE VARCHAR(11),@TDATE VARCHAR(11))
AS

SELECT @FDATE AS ' FROM_DATE' , @TDATE AS 'TO_DATE'

GO
