-- Object: PROCEDURE dbo.pr_MigrateClientType
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE pr_MigrateClientType
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
	SELECT ID=CONVERT(INT, 0), *, MODIFIED=CONVERT(CHAR(1),'')  INTO #CLIENTTYPE FROM CLIENTTYPE WHERE 1=0

	DECLARE curClientType CURSOR FOR SELECT A.SrNo, A.RecordDetails, Modified=A.RecordStatus 
		FROM  DataMigrationDetails A, DataMigration B 
		WHERE A.ImportID = @ImportId AND A.ValidRecord = 'Y'
		AND A.TableCode = B.TableCode AND B.TableName = 'CLIENTTYPE'  

	OPEN curClientType 
	FETCH curClientType INTO @SrNo, @RecordDetails, @Modified
	WHILE @@FETCH_STATUS = 0
	BEGIN

		INSERT INTO #CLIENTTYPE(ID, Cl_Type, Description,Modified) 
		SELECT @SrNo,Cl_Type, Description, @Modified FROM Dbo.fn_StringToTableClientType(@RecordDetails, @Delimiter)

		FETCH curClientType INTO @SrNo, @RecordDetails, @Modified
	END
	CLOSE curClientType
	DEALLOCATE curClientType

END

SET NOCOUNT OFF

SELECT * FROM #CLIENTTYPE

/*

pr_MigrateClientType 1


*/

GO
