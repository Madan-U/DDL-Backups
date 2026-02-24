-- Object: PROCEDURE dbo.pr_MigrateClientStatus
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE pr_MigrateClientStatus
(@ImportId Int)
AS
BEGIN

	SET NOCOUNT ON

	DECLARE 
		@SrNo INT,
		@RecordDetails VARCHAR(100),
		@Delimiter CHAR(1),
		@Modified  CHAR(1)

	SET @Delimiter = '|'
	SELECT ID=CONVERT(INT, 0), *, MODIFIED=CONVERT(CHAR(1),'')  INTO #CLIENTSTATUS FROM CLIENTSTATUS WHERE 1=0

	DECLARE curClientStatus CURSOR FOR SELECT A.SrNo, A.RecordDetails, Modified=A.RecordStatus 
		FROM  DataMigrationDetails A, DataMigration B 
		WHERE A.ImportID = @ImportId AND A.ValidRecord = 'Y'
		AND A.TableCode = B.TableCode AND B.TableName = 'CLIENTSTATUS'  

	OPEN curClientStatus 
	FETCH curClientStatus INTO @SrNo, @RecordDetails, @Modified
	WHILE @@FETCH_STATUS = 0
	BEGIN

		INSERT INTO #CLIENTSTATUS(ID, Cl_Status, Description,Modified) 
		SELECT @SrNo,Cl_Status, Description, @Modified FROM Dbo.fn_StringToTableClientStatus(@RecordDetails, @Delimiter)

		FETCH curClientStatus INTO @SrNo, @RecordDetails, @Modified
	END
	CLOSE curClientStatus
	DEALLOCATE curClientStatus

END

SET NOCOUNT OFF

SELECT * FROM #CLIENTSTATUS

/*

pr_MigrateClientStatus 1


*/

GO
