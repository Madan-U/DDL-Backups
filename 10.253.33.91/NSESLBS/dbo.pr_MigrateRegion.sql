-- Object: PROCEDURE dbo.pr_MigrateRegion
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE pr_MigrateRegion
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
	SELECT ID=CONVERT(INT, 0), *, MODIFIED=CONVERT(CHAR(1),'')  INTO #REGION FROM REGION WHERE 1=0

	DECLARE curREGION CURSOR FOR SELECT A.SrNo, A.RecordDetails, Modified=A.RecordStatus 
		FROM  DataMigrationDetails A, DataMigration B 
		WHERE A.ImportID = @ImportId AND A.ValidRecord = 'Y'
		AND A.TableCode = B.TableCode AND B.TableName = 'REGION'  

	OPEN curREGION 
	FETCH curREGION INTO @SrNo, @RecordDetails, @Modified
	WHILE @@FETCH_STATUS = 0
	BEGIN

		INSERT INTO #REGION(ID, RegionCode, Description, Branch_Code, Modified) 
		SELECT @SrNo,RegionCode, Description, Branch_Code, @Modified FROM Dbo.fn_StringToTableRegion(@RecordDetails, @Delimiter)

		FETCH curREGION INTO @SrNo, @RecordDetails, @Modified
	END
	CLOSE curREGION
	DEALLOCATE curREGION

END

SET NOCOUNT OFF

SELECT * FROM #REGION

/*

pr_MigrateRegion 1


*/

GO
