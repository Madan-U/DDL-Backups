-- Object: PROCEDURE dbo.pr_MigrateSbuMaster
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE pr_MigrateSbuMaster
(@ImportId Int)
AS
BEGIN

	SET NOCOUNT ON

	DECLARE 
		@SrNo INT,
		@RecordDetails VARCHAR(1000),
		@Delimiter CHAR(1),
		@Modified  CHAR(1)

	SET @Delimiter = '|'
	SELECT ID=CONVERT(INT, 0), *, MODIFIED=CONVERT(CHAR(1),'')  INTO #SBU_MASTER FROM SBU_MASTER WHERE 1=0

	DECLARE curSbuMaster CURSOR FOR SELECT A.SrNo, A.RecordDetails, Modified=A.RecordStatus 
		FROM  DataMigrationDetails A, DataMigration B 
		WHERE A.ImportID = @ImportId AND A.ValidRecord = 'Y'
		AND A.TableCode = B.TableCode AND B.TableName = 'SBU_MASTER'  

	OPEN curSbuMaster 
	FETCH curSbuMaster INTO @SrNo, @RecordDetails, @Modified
	WHILE @@FETCH_STATUS = 0
	BEGIN

		INSERT INTO #SBU_MASTER(
				ID,
				Sbu_Code,
				Sbu_Name,
				Sbu_Addr1,
				Sbu_Addr2,
				Sbu_Addr3,
				Sbu_City,
				Sbu_State,
				Sbu_Zip,
				Sbu_Phone1,
				Sbu_Phone2,
				Sbu_Type,
				Sbu_Party_Code,
				Modified) 
		SELECT @SrNo,
				Sbu_Code,
				Sbu_Name,
				Sbu_Addr1,
				Sbu_Addr2,
				Sbu_Addr3,
				Sbu_City,
				Sbu_State,
				Sbu_Zip,
				Sbu_Phone1,
				Sbu_Phone2,
				Sbu_Type,
				Sbu_Party_Code,
				@Modified 
		FROM Dbo.fn_StringToTableSbuMaster(@RecordDetails, @Delimiter)

		FETCH curSbuMaster INTO @SrNo, @RecordDetails, @Modified
	END
	CLOSE curSbuMaster
	DEALLOCATE curSbuMaster

END

SET NOCOUNT OFF

SELECT * FROM #SBU_MASTER

/*

pr_MigrateSbuMaster 1


*/

GO
