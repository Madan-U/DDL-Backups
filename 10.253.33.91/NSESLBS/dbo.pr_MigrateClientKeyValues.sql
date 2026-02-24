-- Object: PROCEDURE dbo.pr_MigrateClientKeyValues
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE pr_MigrateClientKeyValues
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
	SELECT ID=CONVERT(INT, 0), *, MODIFIED=CONVERT(CHAR(1),'')  INTO #DMSCLIENTKEYVALUEDETAILS FROM DMSCLIENTKEYVALUEDETAILS WHERE 1=0

	DECLARE curDmsClientKeyValuesDetails CURSOR FOR SELECT A.SrNo, A.RecordDetails, Modified=A.RecordStatus 
		FROM  DataMigrationDetails A, DataMigration B 
		WHERE A.ImportID = @ImportId AND A.ValidRecord = 'Y'
		AND A.TableCode = B.TableCode AND B.TableName = 'DMSCLIENTKEYVALUEDETAILS'  

	OPEN curDmsClientKeyValuesDetails 
	FETCH curDmsClientKeyValuesDetails INTO @SrNo, @RecordDetails, @Modified
	WHILE @@FETCH_STATUS = 0
	BEGIN

		INSERT INTO #DMSCLIENTKEYVALUEDETAILS(ID, RecordStatus, ClientCode, ClientType, ClientStatus, BranchCode, TraderCode,
								  SubBrokerCode, AreaCode, RegionCode, SbuCode, Modified) 
		SELECT @SrNo, @Modified, ClientCode, ClientType, ClientStatus, BranchCode, TraderCode,
								  SubBrokerCode, AreaCode, RegionCode, SbuCode, @Modified 
								  FROM Dbo.fn_StringToTableClientKeyValues(@RecordDetails, @Delimiter)

		FETCH curDmsClientKeyValuesDetails INTO @SrNo, @RecordDetails, @Modified
	END
	CLOSE curDmsClientKeyValuesDetails
	DEALLOCATE curDmsClientKeyValuesDetails

END

SET NOCOUNT OFF

SELECT * FROM #DMSCLIENTKEYVALUEDETAILS

/*

pr_MigrateClientKeyValues 1


*/

GO
