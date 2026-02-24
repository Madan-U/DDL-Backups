-- Object: PROCEDURE dbo.DROP_MULTISERVER_REGION
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE DROP_MULTISERVER_REGION
(
      @region_code  varchar(20)
)
AS
   DECLARE
		@Result int,
		@BranchCur Cursor,
		@share_db   varchar(50),
		@share_server varchar(50),
		@SQL Varchar(2000),
		@AR_COUNT INT
CREATE TABLE #REGIONEXIST (REGIONCODE VARCHAR(20))
Set @BranchCur = Cursor for  Select sharedb,shareserver From Pradnya.dbo.multicompany where primaryserver = 1
Open @BranchCur
Fetch Next From @BranchCur into @share_db,@share_server
While @@Fetch_Status = 0       
	BEGIN
		SELECT @AR_COUNT = COUNT(1) FROM #REGIONEXIST
		IF @AR_COUNT = 0
			BEGIN
				SET @SQL = "DELETE " + @share_server + "." + @share_db + ".DBO.REGION "
                SET @SQL =  @SQL + " where regioncode = '" + @region_code + "'"
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
