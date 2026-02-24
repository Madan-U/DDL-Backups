-- Object: PROCEDURE dbo.CBO_GETEXCESSHARE_PAYOUT
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



--SELECT SNO FROM DELTRANS  WHERE  RefNo = '110' and Sett_No = '2004046' and Sett_Type = 'N' and Party_Code = '0a141' and Scrip_CD like '%' and Series like '%' and Drcr = 'D' And Filler2 = 1

--exec CBO_GETDELTRANS_WITHPAGES '0',50,'F'

-- ALTER  Proc CBO_GETDELTRANS_WITHPAGES @SNO int=0, @PAGESIZE int =50, @FWDBACK CHAR(1) ='F'
-- AS
-- 
-- 	DECLARE @SQL VARCHAR(8000)
-- 	DECLARE @WHERE VARCHAR(100)
-- 
-- 	IF @SNO=0
-- 		SET @WHERE='1=1'	
-- 	ELSE
-- 		IF @FWDBACK='B'
-- 			SET @WHERE='SNO<'+ STR(@SNO)
-- 		ELSE
-- 			SET @WHERE='SNO>'+ STR(@SNO)
-- 	
-- --SELECT TOP 50  * FROM DELTRANS  WHERE  RefNo = '110' and Sett_No = '2004046' and Sett_Type = 'N' and Party_Code = '0a141' and Scrip_CD like '%' and Series like '%' and Drcr = 'D' And Filler2 = 1
-- 
-- 	--set @SQL='SELECT TOP '+ str(@PAGESIZE) +'  *  FROM DELTRANS ' 
-- 		set @SQL='SELECT TOP '+ str(@PAGESIZE) +'  *  FROM DELTRANS'-- WHERE  RefNo = '110' and Sett_No = '2004046' and Sett_Type = 'N' and Party_Code = '0a141' and Scrip_CD like '%' and Series like '%' and Drcr = 'D' And Filler2 = 1 ' 
-- 	--set @SQL=@SQL+ ' WHERE '+@WHERE  
--   set @SQL=@SQL+ ' WHERE '+@WHERE   RefNo = '110' and Sett_No = '2004046' and Sett_Type = 'N' and Party_Code = '0a141' and Scrip_CD like '%' and Series like '%' and Drcr = D And Filler2 = 1 '   
-- 
-- 	IF @FWDBACK='B'
-- 		set @SQL=@SQL+ ' ORDER BY SNO desc, '
-- 	
-- exec(@SQL)'





-- Sett_No = '2004046' and Sett_Type = 'N' and Party_Code = '0a141' and Scrip_CD like '%' and Series like '%' and Drcr = 'D' And Filler2 = 1


--EXEC CBO_GETEXCESSHARE_PAYOUT 0,50,'F','2004046','N','%','%','0A141','BROKER','BROKER'

CREATE     PROCEDURE [dbo].[CBO_GETEXCESSHARE_PAYOUT]
	  (  
        @SNO int,
        @PAGESIZE int,
        @FWDBACK CHAR(1) ='F',
        @SETTNO VARCHAR(10),
        @SETTYPE VARCHAR(10),
        @SCRIPCODE VARCHAR(10),
        @SERIES VARCHAR(10),
        @PARTYCODE  VARCHAR(10),
        @STATUSID VARCHAR(25) = 'BROKER',
	     @STATUSNAME VARCHAR(25) = 'BROKER'
)
AS
DECLARE
	@SQL Varchar(2000),
   @WHERE VARCHAR(100)
		
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
		--IF @SNO=0
 		--SET @WHERE='1=1'	
 	--ELSE 
   IF @FWDBACK='B'
			SET @WHERE='SNO<'+ STR(@SNO)
		ELSE
 			SET @WHERE='SNO>'+ STR(@SNO)
			BEGIN
                      SET @SQL="SELECT TOP "+str(@PAGESIZE)+"  *  FROM DELTRANS   WHERE  SNO>"+ STR(@SNO)+" AND RefNo = '110' and Sett_No = '"+@SETTNO+"' and Sett_Type = '"+@SETTYPE+"' and Party_Code = '"+@PARTYCODE+"' and Scrip_CD like '%' and Series like '%' and Drcr = 'D' And Filler2 = '1' ORDER BY SNO" --=-- And Scrip_Cd = '"+@SCRIPCODE+"' And Series = '"+@SERIES+"' And Delivered = '0' And  DrCr = 'D' And Filler2 = '1' And BDpId = '"+@DPID+"' And BCltDpId = '"+@CLTDPID+"' "
                      PRINT(@SQL)
                      EXECUTE(@SQL)
			END

GO
