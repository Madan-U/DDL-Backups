-- Object: PROCEDURE dbo.CBO_DELREGION
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE CBO_DELREGION
(
      @regioncode  varchar(10),
      @STATUSID VARCHAR(25),
      @STATUSNAME VARCHAR(25)
)
AS
   IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
   DECLARE
		@Result int,
		@BranchCur Cursor,
		@share_db   varchar(50),
		@share_server varchar(50),
		@SQL Varchar(2000),
		@RG_COUNT INT
CREATE TABLE #REGIONEXIST (REGIONCODE VARCHAR(10))
Set @BranchCur = Cursor for  Select sharedb,shareserver From Pradnya.dbo.multicompany where primaryserver = 1
Open @BranchCur
Fetch Next From @BranchCur into @share_db,@share_server
While @@Fetch_Status = 0       
	BEGIN
		SELECT @RG_COUNT = COUNT(1) FROM #REGIONEXIST
		IF @RG_COUNT = 0
			BEGIN
				SET @SQL = "DELETE " + @share_server + "." + @share_db + ".DBO.REGION "
                SET @SQL =  @SQL + " where REGIONCODE = '" + @regioncode + "'"
                --PRINT @SQL
				EXEC (@SQL)
				IF @@ERROR <> 0
					BEGIN
						RETURN
					END
			END
	     TRUNCATE TABLE #REGIONEXIST
         Fetch Next From @BranchCur into @share_db,@share_server
	END     
Close @BranchCur  
DeAllocate @BranchCur

GO
