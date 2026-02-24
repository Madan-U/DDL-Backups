-- Object: PROCEDURE dbo.RECEIPT_DATA_NIK
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROC [DBO].[RECEIPT_DATA_NIK]          
(          
  @FROMDATE VARCHAR(11),          
  @TODATE VARCHAR(11),    
  @VTYP VARCHAR (11)          
 )                   
 AS          
 BEGIN          
 SELECT DISTINCT          
 [CLTCODE] = A.CLTCODE,          
 [SHORT_NAME]= B.SHORT_NAME,          
 [REGION] = B.REGION,          
 [BRANCH] = B.BRANCH_CD,          
 [SUBBROKER] = B.SUB_BROKER,          
 [VDATE] = A.VDT,          
 [V_NO] = A.VNO,          
 [NARRATION] = A.NARRATION,          
 [VAMT] = A.VAMT,          
 [DDNO] = C.DDNO,          
 [VTYP] = A.VTYP,          
 [BANKNAME] = B.Bank_Name,          
 [ACNUM] = b.AC_Num,          
 [RELDT] = C.RELDT,    
 [BOOKTYPE] = A.BOOKTYPE           
INTO  #TEMP2            
 FROM          
 LEDGER(NOLOCK) A,          
 msajag..client_details B,          
 LEDGER1(NOLOCK) C          
 WHERE A.VTYP in ('2','3') AND A.VDT >= @FROMDATE AND A.VDT < =@TODATE + ' 23:59:59'            
 AND ISNUMERIC(A.CLTCODE)  ='0' AND A.CLTCODE = B.Cl_Code AND  A.VTYP = C.VTYP AND A.VNO = C.VNO          
 AND A.CLTCODE IN (SELECT CLTCODE FROM ACMAST WHERE ACCAT=4) AND A.BOOKTYPE=C.BOOKTYPE     
 ORDER BY A.CLTCODE          
          
 SELECT          
 [CLTCODE] = CLTCODE,          
 [ACNAME]= ACNAME,          
 [VNO] = VNO,          
 [DRCR] = DRCR,BOOKTYPE            
 INTO #TEMP3          
 FROM LEDGER(NOLOCK) D          
 WHERE           
 D.VTYP in ('2','3') AND D.VDT >= @FROMDATE AND D.VDT <=@TODATE + ' 23:59:59'          
 AND D.VNO IN (SELECT V_NO FROM #TEMP2(NOLOCK))          
          
 SELECT B.CLTCODE,B.ACNAME,A.REGION,A.BRANCH,A.SUBBROKER,A.VDATE,A.V_NO,A.VAMT,B.DRCR,A.DDNO,A.NARRATION,A.RELDT,A.BANKNAME,A.ACNUM,A.BOOKTYPE,          
 'NSE' AS EXCHANGE          
 FROM #TEMP2(NOLOCK) A INNER JOIN #TEMP3(NOLOCK) B ON A.V_NO=B.VNO   AND A.BOOKTYPE=B.BOOKTYPE  AND A.VTYP =2   
 ORDER BY A.V_NO         
           
END

GO
