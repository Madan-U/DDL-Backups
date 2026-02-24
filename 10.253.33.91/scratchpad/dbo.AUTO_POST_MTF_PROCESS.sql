-- Object: PROCEDURE dbo.AUTO_POST_MTF_PROCESS
-- Server: 10.253.33.91 | DB: scratchpad
--------------------------------------------------

-------https://angelbrokingpl.atlassian.net/browse/ORE-5057-----------------------------------

CREATE PROC [dbo].[AUTO_POST_MTF_PROCESS](@SAUDA_DATE VARCHAR(11))
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SAUDA_DATE1 VARCHAR(11);

    -------------------------------------------------
    -- Get Latest SAUDA_DATE from Settlement Table
    -------------------------------------------------
    SELECT @SAUDA_DATE1 =CAST ( MAX (SAUDA_DATE) AS DATE)
    FROM MSAJAG.DBO.SETTLEMENT with (nolock) where sett_type='M'; 
    -------------------------------------------------
    -- Step 1: Populate MTF Data (PRE)
    -------------------------------------------------
	--TRUNCATE TABLE POPULATE_TBL_MTF_DATA_LOG
    INSERT INTO POPULATE_TBL_MTF_DATA_LOG
    VALUES ('MTFTRADE.DBO.PROC_POPULATE_TBL_MTF_DATA_PRE', GETDATE(), 'START');

   EXEC MTFTRADE.DBO.PROC_POPULATE_TBL_MTF_DATA_PRE @SAUDA_DATE1;

    INSERT INTO POPULATE_TBL_MTF_DATA_LOG
    VALUES ('MTFTRADE.DBO.PROC_POPULATE_TBL_MTF_DATA_PRE', GETDATE(), 'END');

    -------------------------------------------------
    -- Step 2: MTF Cash Margin Details
    -------------------------------------------------
    INSERT INTO POPULATE_TBL_MTF_DATA_LOG
    VALUES ('INHOUSE.DBO.PROC_MTF_CASH_MARGIN_DETAILS', GETDATE(), 'START');

    EXEC INHOUSE.DBO.PROC_MTF_CASH_MARGIN_DETAILS @SAUDA_DATE1;

    INSERT INTO POPULATE_TBL_MTF_DATA_LOG
    VALUES ('INHOUSE.DBO.PROC_MTF_CASH_MARGIN_DETAILS', GETDATE(), 'END');

    -------------------------------------------------
    -- Final Status
    -------------------------------------------------
    
   SELECT 'AUTO POST MTF PROCESS COMPLETED SUCCESSFULLY FOR DATED ' + @SAUDA_DATE1 AS REMARK
       
END;

GO
