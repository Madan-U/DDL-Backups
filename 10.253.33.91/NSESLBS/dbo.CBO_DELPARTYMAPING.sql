-- Object: PROCEDURE dbo.CBO_DELPARTYMAPING
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE CBO_DELPARTYMAPING
(
      @OLDPARTY_CODE  varchar(20),
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
		@PMCur Cursor,
		@share_db   varchar(50),
		@share_server varchar(50),
		@SQL Varchar(2000),
		@PM_COUNT INT
CREATE TABLE #PARTYMAPPINGEXIST (OLDPARTY_CODE VARCHAR(20))
Set @PMCur = Cursor for  Select sharedb,shareserver From Pradnya.dbo.multicompany where primaryserver = 1
Open @PMCur
Fetch Next From @PMCur into @share_db,@share_server
While @@Fetch_Status = 0       
	BEGIN
		SELECT @PM_COUNT = COUNT(1) FROM #PARTYMAPPINGEXIST
		IF @PM_COUNT = 0
			BEGIN
				SET @SQL = "DELETE " + @share_server + "." + @share_db + ".DBO.PARTYMAPPING "
                SET @SQL =  @SQL + " where OLDPARTY_CODE= '" +  @OLDPARTY_CODE + "'"
                --PRINT @SQL
				EXEC (@SQL)
				IF @@ERROR <> 0
					BEGIN
						RETURN
					END
			END
	     TRUNCATE TABLE #PARTYMAPPINGEXIST
         Fetch Next From @PMCur into @share_db,@share_server
	END     
Close @PMCur  
DeAllocate @PMCur

GO
