-- Object: PROCEDURE dbo.pr_MigrateSubBrokers
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE pr_MigrateSubBrokers
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
	SELECT ID=CONVERT(INT, 0), *, MODIFIED=CONVERT(CHAR(1),'')  INTO #SubBrokers FROM SubBrokers WHERE 1=0

	DECLARE curSubBrokers CURSOR FOR SELECT A.SrNo, A.RecordDetails, Modified=A.RecordStatus 
		FROM  DataMigrationDetails A, DataMigration B 
		WHERE A.ImportID = @ImportId AND A.ValidRecord = 'Y'
		AND A.TableCode = B.TableCode AND B.TableName = 'SUBBROKERS'  

	OPEN curSubBrokers 
	FETCH curSubBrokers INTO @SrNo, @RecordDetails, @Modified
	WHILE @@FETCH_STATUS = 0
	BEGIN

		INSERT INTO #SubBrokers(
				ID,
				Sub_Broker,
				Name,
				Address1,
				Address2,
				City,
				State,
				Nation,
				Zip,
				Fax,
				Phone1,
				Phone2,
				Reg_No,
				Registered,
				Main_Sub,
				Email,
				Com_Perc,
				Branch_Code,
				Contact_Person,
				REMPARTYCODE,
				Modified) 
		SELECT @SrNo,
				Sub_Broker,
				Name,
				Address1,
				Address2,
				City,
				State,
				Nation,
				Zip,
				Fax,
				Phone1,
				Phone2,
				Reg_No,
				Registered,
				Main_Sub,
				Email,
				Com_Perc,
				Branch_Code,
				Contact_Person,
				REMPARTYCODE,
				@Modified 
		FROM Dbo.fn_StringToTableSubBrokers(@RecordDetails, @Delimiter)

		FETCH curSubBrokers INTO @SrNo, @RecordDetails, @Modified
	END
	CLOSE curSubBrokers
	DEALLOCATE curSubBrokers

END

SET NOCOUNT OFF

SELECT * FROM #SubBrokers

/*

pr_MigrateSubBrokers 15


*/

GO
