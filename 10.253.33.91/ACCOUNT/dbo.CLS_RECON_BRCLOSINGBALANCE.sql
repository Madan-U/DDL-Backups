-- Object: PROCEDURE dbo.CLS_RECON_BRCLOSINGBALANCE
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------



--EXEC ACC_PRINTRECONCILE '103','STATEMENT', 'MAR 23 2007 23:59:59', 'MAR 23 2007 23:59:59'
  
  
CREATE  PROCEDURE [dbo].[CLS_RECON_BRCLOSINGBALANCE] 
(
	@CLTCODE  VARCHAR(10),      
	@SDTCUR  VARCHAR(11),      
	@FROMDATE VARCHAR(11),      
	@VDTEDTFLAG TINYINT,      
	@FLAG   SMALLINT,      
	@COSTCODE  SMALLINT      
)
     
AS      
      
DECLARE      
	@@OPENBALDT   VARCHAR(11),      
	@@OPENENTRY   MONEY,      
	@@OPENINGBAL   MONEY,      
	@@STARTDATE  DATETIME,      
	@@ENDDATE  DATETIME 
  
	SELECT @@STARTDATE = SDTCUR, @@ENDDATE = LDTCUR FROM PARAMETER WHERE @FROMDATE BETWEEN SDTCUR  AND LDTCUR  
  
	IF @VDTEDTFLAG = 0      
	BEGIN      
	/*===============================================================================================================*/
		/*IF THE LOGIN IS NOT BRANCH AND THE USER HAS SELECTED THE OPTION 'ALL' AS BRANCHES, SO THE USER CAN VIEW THE TRANSACTIONS FOR ALL BRANCHES */      
	/*===============================================================================================================*/
		IF @FLAG = 0       
		BEGIN      
			SELECT @@OPENINGBAL = 0      

			SELECT 
				@@OPENINGBAL = ISNULL(SUM(CASE DRCR WHEN 'D' THEN ISNULL(-VAMT,0) ELSE ISNULL(VAMT,0) END),0) 
			FROM LEDGER (NOLOCK)
			WHERE 
				VDT >= @@STARTDATE 
				AND VDT <= @FROMDATE + ' 23:59:59'
				AND CLTCODE = @CLTCODE      

			SELECT @@OPENINGBAL       
		END      
		/*===============================================================================================================*/
			/*IF THE LOGIN = BRANCH THE ONLY THE ENTRIES FOR THAT BRANCH ARE RETRIEVED*/      
		/*===============================================================================================================*/
		ELSE IF @FLAG = 1        
		BEGIN       
			SELECT @@OPENINGBAL = 0      
				
			SELECT 
				@@OPENINGBAL = ISNULL(SUM(CASE L.DRCR WHEN 'D' THEN ISNULL(CAMT,0) ELSE ISNULL(-CAMT,0) END),0) 
			FROM 
				LEDGER L,
				LEDGER2 L2      
			WHERE 
				L.VTYP = L2.VTYPE 
				AND L.VNO = L2.VNO 
				AND L.LNO = L2.LNO 
				AND VDT > = @@OPENBALDT   
				AND VDT >= @@STARTDATE 
				AND VDT <= @FROMDATE + ' 23:59:59'
				AND L.CLTCODE = @CLTCODE 
				AND COSTCODE = @COSTCODE      
				
			SELECT @@OPENINGBAL      
		END      

	END      
	ELSE IF @VDTEDTFLAG = 1      
	BEGIN      
	/*===============================================================================================================*/
		/*IF THE LOGIN IS NOT BRANCH AND THE USER HAS SELECTED THE OPTION 'ALL' AS BRANCHES, SO THE USER CAN VIEW THE TRANSACTIONS FOR ALL BRANCHES */      
	/*===============================================================================================================*/
		IF @FLAG = 0       
		BEGIN      
			SELECT @@OPENINGBAL = 0      

			SELECT 
				@@OPENINGBAL = ISNULL(SUM(CASE DRCR WHEN 'D' THEN ISNULL(VAMT,0) ELSE ISNULL(-VAMT,0) END),0) 
			FROM 
				LEDGER 
			WHERE 
				VDT BETWEEN @@STARTDATE AND @FROMDATE + ' 23:59:59'
				AND EDT <= @FROMDATE + ' 23:59:59'
				AND CLTCODE = @CLTCODE 
				
			SELECT @@OPENINGBAL      
		END       
		/*===============================================================================================================*/
			/*IF THE LOGIN = BRANCH THE ONLY THE ENTRIES FOR THAT BRANCH ARE RETRIEVED*/      
		/*===============================================================================================================*/
		ELSE IF @FLAG = 1        
		BEGIN       
			SELECT @@OPENINGBAL = 0      
				
			SELECT 
				@@OPENINGBAL = ISNULL(SUM(CASE L.DRCR WHEN 'D' THEN ISNULL(CAMT,0) ELSE ISNULL(-CAMT,0) END),0) 
			FROM 
				LEDGER L,
				LEDGER2 L2      
			WHERE  
				L.VTYP = L2.VTYPE 
				AND L.VNO = L2.VNO 
				AND L.LNO = L2.LNO 
				AND VDT BETWEEN @@STARTDATE AND @FROMDATE + ' 23:59:59' 
				AND EDT <= @FROMDATE + ' 23:59:59'
				AND L.CLTCODE = @CLTCODE 
				AND COSTCODE = @COSTCODE      

			SELECT @@OPENINGBAL      
		END       
	END

GO
