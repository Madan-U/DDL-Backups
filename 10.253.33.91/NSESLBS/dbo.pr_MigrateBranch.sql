-- Object: PROCEDURE dbo.pr_MigrateBranch
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE pr_MigrateBranch
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
	SELECT ID=CONVERT(INT, 0), *, MODIFIED=CONVERT(CHAR(1),'')  INTO #BRANCH FROM BRANCH WHERE 1=0

	DECLARE curBRANCH CURSOR FOR SELECT A.SrNo, A.RecordDetails, Modified=A.RecordStatus 
		FROM  DataMigrationDetails A, DataMigration B 
		WHERE A.ImportID = @ImportId AND A.ValidRecord = 'Y'
		AND A.TableCode = B.TableCode AND B.TableName = 'BRANCH'  

	OPEN curBRANCH 
	FETCH curBRANCH INTO @SrNo, @RecordDetails, @Modified
	WHILE @@FETCH_STATUS = 0
	BEGIN

		INSERT INTO #BRANCH(
				ID,
				Branch_Code,
				Branch,
				Long_Name,
				Address1,
				Address2,
				City,
				State,
				Nation,
				Zip,
				Phone1,
				Phone2,
				Fax,
				Email,
				Remote,
				Security_Net,
				Money_Net,
				Excise_Reg,
				Contact_Person,
				Prefix,
				REMPARTYCODE,
				Modified) 
		SELECT @SrNo,
				Branch_Code,
				Branch,
				Long_Name,
				Address1,
				Address2,
				City,
				State,
				Nation,
				Zip,
				Phone1,
				Phone2,
				Fax,
				Email,
				Remote,
				Security_Net,
				Money_Net,
				Excise_Reg,
				Contact_Person,
				Prefix,
				REMPARTYCODE,
				@Modified 
		FROM Dbo.fn_StringToTableBranch(@RecordDetails, @Delimiter)

		FETCH curBRANCH INTO @SrNo, @RecordDetails, @Modified
	END
	CLOSE curBRANCH
	DEALLOCATE curBRANCH

END

SET NOCOUNT OFF

SELECT * FROM #BRANCH

/*

pr_MigrateBranch 1


*/

GO
