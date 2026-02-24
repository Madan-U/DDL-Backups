-- Object: PROCEDURE dbo.pr_MigrateArea
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE pr_MigrateArea
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
	SELECT ID=CONVERT(INT, 0), *, MODIFIED=CONVERT(CHAR(1),'')  INTO #AREA FROM AREA WHERE 1=0

	DECLARE curAREA CURSOR FOR SELECT A.SrNo, A.RecordDetails, Modified=A.RecordStatus 
		FROM  DataMigrationDetails A, DataMigration B 
		WHERE A.ImportID = @ImportId AND A.ValidRecord = 'Y'
		AND A.TableCode = B.TableCode AND B.TableName = 'AREA'  

	OPEN curAREA 
	FETCH curAREA INTO @SrNo, @RecordDetails, @Modified
	WHILE @@FETCH_STATUS = 0
	BEGIN

		INSERT INTO #AREA(ID, AreaCode, Description, Branch_Code, Modified) 
		SELECT @SrNo,AreaCode, Description, Branch_Code, @Modified FROM Dbo.fn_StringToTableArea(@RecordDetails, @Delimiter)

		FETCH curAREA INTO @SrNo, @RecordDetails, @Modified
	END
	CLOSE curAREA
	DEALLOCATE curAREA

END

SET NOCOUNT OFF

SELECT * FROM #AREA

/*

pr_MigrateArea 1


*/

GO
