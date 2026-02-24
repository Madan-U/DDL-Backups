-- Object: PROCEDURE dbo.pr_MigrateBranches
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE pr_MigrateBranches
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
	SELECT ID=CONVERT(INT, 0), *, MODIFIED=CONVERT(CHAR(1),'')  INTO #BRANCHES FROM BRANCHES WHERE 1=0

	DECLARE curBRANCHES CURSOR FOR SELECT A.SrNo, A.RecordDetails, Modified=A.RecordStatus 
		FROM  DataMigrationDetails A, DataMigration B 
		WHERE A.ImportID = @ImportId AND A.ValidRecord = 'Y'
		AND A.TableCode = B.TableCode AND B.TableName = 'BRANCHES'  

	OPEN curBRANCHES 
	FETCH curBRANCHES INTO @SrNo, @RecordDetails, @Modified
	WHILE @@FETCH_STATUS = 0
	BEGIN

		INSERT INTO #BRANCHES(
				ID,
				BRANCH_CD,
				Short_Name,
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
				Com_Perc,
				Terminal_ID,
				DefTrader,
				Modified) 
		SELECT @SrNo,
				BRANCH_CD,
				Short_Name,
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
				Com_Perc,
				Terminal_ID,
				DefTrader,
				@Modified 
		FROM Dbo.fn_StringToTableBranches(@RecordDetails, @Delimiter)

		FETCH curBRANCHES INTO @SrNo, @RecordDetails, @Modified
	END
	CLOSE curBRANCHES
	DEALLOCATE curBRANCHES

END

SET NOCOUNT OFF

SELECT * FROM #BRANCHES

/*

pr_MigrateBranches 1


*/

GO
