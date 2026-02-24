-- Object: PROCEDURE dbo.REC_CHQ_DATE
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE PROC REC_CHQ_DATE (@FROMDATE DATETIME)

AS

SELECT [BANKCODE]=CLTCODE,   
                     [VDT] =L.VDT,   
                     [VNO] =L.VNO,   
                     [NARRATION]=L.NARRATION,   
                     [VAMT] =L.VAMT,   
                     [DRCR] =L.DRCR,   
                     [DDNO] =L1.DDNO,   
                     [VTYP] =L.VTYP,   
                     [RELDT] =L1.RELDT,   
					 [ENTRY_DATE]=CDT,  
                     [BOOKTYPE]=L.BOOKTYPE,   
                     [EXCHANGE]='NSE' ,      ENTEREDBY  INTO   #TEMP   
              FROM   LEDGER L (NOLOCK),   
                     LEDGER1 L1 (NOLOCK)   
              WHERE  L.VNO = L1.VNO   
                     AND L.VTYP = L1.VTYP   
                     AND L.BOOKTYPE = L1.BOOKTYPE   
                     AND L.DRCR = 'D'   
                     AND L.VTYP = 2   
                     AND L.VDT >= @FROMDATE   
                   --  AND L.VDT < = @TODATE + ' 23:59'   
					 AND ENTEREDBY NOT IN ('TPR','B_TPR','B_KYC','TPR1','PMTGATEWAY')
					 AND CHECKEDBY IN ('OFFLINE','E67852','E65199','E73403','E84561','E78077')
					 AND LEN(DDNO) <= 7
					 AND L.CLTCODE IN ('03014','02014','02086','05016','04033')


				DELETE	#TEMP WHERE NARRATION LIKE '%VIRTUAL%' 
				DELETE	#TEMP WHERE NARRATION LIKE '%AMOUNT RECIEVED%'
				DELETE	#TEMP WHERE NARRATION LIKE '%NEFT%'
				DELETE	#TEMP WHERE NARRATION LIKE '%BEING AMOUNT REVERSED%'
				DELETE	#TEMP WHERE NARRATION LIKE '%UPI%'

	 SELECT A.*,L.CLTCODE INTO #TEMP1 FROM #TEMP A, LEDGER L (NOLOCK) WHERE A.VNO = L.VNO AND A.VTYP = L.VTYP AND A.[BANKCODE] <> L.CLTCODE 

	 UPDATE #TEMP1 SET [DRCR] = 'C'


      SELECT [BANKCODE],[CLTCODE]=REPLACE(LTRIM(RTRIM(A.CLTCODE)), ' ', ''),   
             CONVERT(VARCHAR(11), CONVERT(DATETIME, A.VDT, 103), 103)   AS VDT,   
			 CONVERT(TIME(0), A.VDT) AS VDT_TIME,  
             [VNO]=REPLACE(LTRIM(RTRIM(A.VNO)), ' ', ''),   
             [NARRATION]=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LEFT(REPLACE(LTRIM(RTRIM(A.NARRATION)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', ''),':', ''),'-', ''),'.', ''),  
             [EXCHANGE]=REPLACE(LTRIM(RTRIM(A.EXCHANGE)), ' ', ''),   
             [VAMT]=REPLACE(LTRIM(RTRIM(A.VAMT)), ' ', ''),   
             [DRCR]=REPLACE(LTRIM(RTRIM(A.DRCR)), ' ', ''),   
             [DDNO]=REPLACE(REPLACE(LTRIM(RTRIM(A.DDNO)), ' ', ''),'''',''),   
             [VTYP]=REPLACE(LTRIM(RTRIM(A.VTYP)), ' ', ''),   
             CONVERT(VARCHAR(11), CONVERT(DATETIME, A.RELDT, 103), 103) AS RELDT  ,   
			 [ENTRY_DATE],  ENTEREDBY ,  
             [BOOKTYPE]=REPLACE(LTRIM(RTRIM(A.BOOKTYPE)), ' ', '')  ,   
             [SHORT_NAME]=ISNULL(REPLACE(LTRIM(RTRIM(B.SHORT_NAME)), ' ', ''),''),   
             [REGION]=ISNULL(REPLACE(LTRIM(RTRIM(B.REGION)), ' ', ''),''),   
             [BRANCH_CD]=ISNULL(REPLACE(LTRIM(RTRIM(B.BRANCH_CD)), ' ', ''),''),   
             [SUB_BROKER]=ISNULL(REPLACE(LTRIM(RTRIM(B.SUB_BROKER)), ' ', ''),''),   
             ISNULL(REPLACE(REPLACE(REPLACE(B.BANK_NAME,',',' '),'"',''),'''',''),'')  AS BANK_NAME,   
             [AC_NUM]=ISNULL(REPLACE(LTRIM(RTRIM(B.AC_NUM)), ' ', ''),'')  INTO #FINAL  
      FROM   #TEMP1 AS A   
             LEFT OUTER JOIN MSAJAG.DBO.CLIENT_DETAILS AS B   
                          ON A.CLTCODE = B.CL_CODE   
      ORDER  BY EXCHANGE,VDT,BANKCODE   
    
  SELECT * FROM  #FINAL  ORDER  BY EXCHANGE   


  DROP TABLE #TEMP
  DROP TABLE #TEMP1
  DROP TABLE #FINAL

GO
