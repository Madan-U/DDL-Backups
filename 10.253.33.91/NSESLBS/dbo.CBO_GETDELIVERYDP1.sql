-- Object: PROCEDURE dbo.CBO_GETDELIVERYDP1
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure CBO_GETDELIVERYDP1
 (
  @dpid       VARCHAR(16),
  @partycode  char(10), 
  @scripcd    VARCHAR(12),
  @setttype   VARCHAR(3),
  @flag	      VARCHAR(1),
 	@STATUSID   VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
 )
 AS
  --DECLARE
  --  @SQLVAR  int,
	--	@SQL Varchar(2000),
	--	@SB_COUNT INT
  
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
  IF @FLAG <> 'A' AND @FLAG <> 'B' AND @FLAG <> 'C' AND @FLAG <> 'D' AND @FLAG <> 'E'AND @FLAG <> 'F'AND @FLAG <> 'G'AND @FLAG <> 'H'
	  BEGIN
		 RAISERROR ('Flags Not Set Properly', 16, 1)
		RETURN
	END
  IF @flag = 'A'
		BEGIN
			SELECT
				distinct Dpid
		 	FROM
		    DeliveryDp
	  END
  Else IF @flag = 'B'
				BEGIN
         Select
           Distinct DpCltNo 
         From
           DeliveryDp 
         Where 
           Description not Like '%POOL%' And DpId = @dpid
         END  
   Else IF @flag = 'C'
				BEGIN 
         Select
           Distinct PARTY_CODE 
         From
            CLIENT2 
         Where 
           PARTY_CODE = @partycode 
         END  
	        --CREATE TABLE #TEMP (FLD INT)
	       -- SET @SQL = "INSERT INTO #TEMP SELECT COUNT(1) FROM CLIENT2 WHERE PARTY_CODE = '" + @partycode + "'"
					--print(@SQL)
	        --EXEC(@SQL)
			    --SELECT @SQLVAR = FLD FROM #TEMP
	        --DROP TABLE #TEMP
	        --IF @SQLVAR <> 0
			    --BEGIN
	        --SET @SQL = "SELECT DISTINCT SCRIP_CD FROM SCRIP2"
	        --EXEC(@SQL)
	        --END
			  --END
    Else IF @flag = 'D'
				BEGIN
         Select
           Distinct Series
         From
           scrip2 
         where
          Scrip_CD = @scripcd
         END 
     Else IF @flag = 'E'
				BEGIN
         Select
           Distinct sett_type
         From
           Sett_Mst 
         END
       Else IF @flag = 'F'
				BEGIN
         Select
           Distinct sett_type
         From
           bsedb.DBO.Sett_Mst 
         END  
       Else IF @flag = 'G'
				BEGIN
         Select
           Distinct sett_no
         From
           Sett_Mst 
         Where
           sett_type = @setttype
         END 
       Else IF @flag = 'H'
				BEGIN
         Select
           Distinct sett_no
         From
           bsedb.DBO.Sett_Mst 
         Where
           sett_type = @setttype
         END

GO
