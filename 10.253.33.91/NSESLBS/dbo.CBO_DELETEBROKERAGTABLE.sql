-- Object: PROCEDURE dbo.CBO_DELETEBROKERAGTABLE
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

--EXEC CBO_DELETEBROKERAGTABLE 'NSE', 'CAPITAL',1001,'BROKER','BROKER'
  
CREATE PROCEDURE CBO_DELETEBROKERAGTABLE
	@Exchange VARCHAR(5),    
	@Segment VARCHAR(10),
	@BrokTableNo INT,
	@STATUSID VARCHAR(25) = 'BROKER',   
	@STATUSNAME VARCHAR(25) = 'BROKER'
AS

 IF @Segment = 'CAPITAL'
 BEGIN
  IF NOT EXISTS(SELECT TOP 1 * FROM Client_Brok_Details
	 WHERE (Trd_Brok = @BrokTableNo OR Del_Brok = @BrokTableNo)    
    		  AND Exchange = @Exchange AND Segment = @Segment)
 	BEGIN
   	DELETE FROM BROKTABLE WHERE TABLE_NO=@BrokTableNo
   END
	ELSE 
	  RAISERROR ('Few parties being used this brokerage.Can not to be removed from the system...', 16, 1)         
	END
  
IF @Segment = 'FUTURES'
BEGIN
  IF NOT EXISTS(SELECT TOP 1 * FROM Client_Brok_Details
    WHERE (Fut_Brok = @BrokTableNo OR Fut_Opt_Brok = @BrokTableNo
    		  OR Fut_Fut_Fin_Brok = @BrokTableNo OR Fut_Opt_Exc = @BrokTableNo)
		     AND Exchange = @Exchange AND Segment = @Segment)
 BEGIN  
  DELETE FROM BROKTABLE WHERE TABLE_NO=@BrokTableNo  
 END
	ELSE  
	   RAISERROR ('Few parties being used this brokerage.Can not to be removed from the system...', 16, 1)  
	END

GO
