-- Object: PROCEDURE dbo.CBO_DELTerminalLimit
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE CBO_DELTerminalLimit
(
      @USERID  varchar(20),
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
		@TLCur Cursor,
		@share_db   varchar(50),
		@share_server varchar(50),
		@SQL Varchar(2000),
		@TL_COUNT INT
CREATE TABLE #TERMLIMITEXIST (USERID VARCHAR(20))
Set @TLCur = Cursor for  Select sharedb,shareserver From Pradnya.dbo.multicompany where primaryserver = 1
Open @TLCur
Fetch Next From @TLCur into @share_db,@share_server
While @@Fetch_Status = 0       
	BEGIN
		SELECT @TL_COUNT = COUNT(1) FROM #TERMLIMITEXIST
		IF @TL_COUNT = 0
			BEGIN
				SET @SQL = "DELETE " + @share_server + "." + @share_db + ".DBO.TERMLIMIT "
                SET @SQL =  @SQL + " where 	UserId = '" + @USERID + "'"
                --PRINT @SQL
				EXEC (@SQL)
				IF @@ERROR <> 0
					BEGIN
						RETURN
					END
			END
	     TRUNCATE TABLE #TERMLIMITEXIST 
         Fetch Next From @TLCur into @share_db,@share_server
	END     
Close @TLCur  
DeAllocate @TLCur

GO
