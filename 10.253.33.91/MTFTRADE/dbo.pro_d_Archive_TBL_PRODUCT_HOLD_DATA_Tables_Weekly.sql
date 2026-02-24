-- Object: PROCEDURE dbo.pro_d_Archive_TBL_PRODUCT_HOLD_DATA_Tables_Weekly
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE pro_d_Archive_TBL_PRODUCT_HOLD_DATA_Tables_Weekly
AS
--BEGIN
--	SET NOCOUNT ON;

--	-- to be scheduled on Saturday @02:30
--	DECLARE @ArchiveUpTo	DATETIME
--	SELECT @ArchiveUpTo = CONVERT(VARCHAR(10), GETDATE()-7, 121) + ' 23:59:59.999'

--	-- INSERT RECORDS
--	INSERT INTO MTFTRADE.dbo.TBL_PRODUCT_HOLD_DATA_HIST
--	SELECT * FROM MTFTRADE.dbo.TBL_PRODUCT_HOLD_DATA WITH (NOLOCK) WHERE SAUDA_DATE <= @ArchiveUpTo


	------ DELETE RECORDS IN LOOP 
	----WHILE EXISTS(SELECT SAUDA_DATE from MTFTRADE.dbo.TBL_PRODUCT_HOLD_DATA WITH (NOLOCK) WHERE SAUDA_DATE <= @ArchiveUpTo)
	----	BEGIN
	----		SET ROWCOUNT 200000
	----		DELETE from MTFTRADE.dbo.TBL_PRODUCT_HOLD_DATA WHERE SAUDA_DATE <= @ArchiveUpTo
	----		SET ROWCOUNT 0
	----		Waitfor DELAY '00:00:02.000' 
	------	END

	
--END

---TBL_PRODUCT_HOLD_DATA
--TBL_PRODUCT_HOLD_DATA_HIST

--MTFTRADE

GO
