-- Object: PROCEDURE citrus_usr.PR_HOLDINGDUMPLOG
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

create    PROC [citrus_usr].[PR_HOLDINGDUMPLOG](@pa_from_dt DATETIME, @pa_to_dt DATETIME    
,@pa_login_name varchar(100)    
)
AS
BEGIN 
SELECT TOP 2 STATUS , DT  FROM HOLDINGDUMPLOG  
ORDER BY DT DESC 
END

GO
