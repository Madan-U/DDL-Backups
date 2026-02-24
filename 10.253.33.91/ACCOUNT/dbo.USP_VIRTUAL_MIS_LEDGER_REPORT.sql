-- Object: PROCEDURE dbo.USP_VIRTUAL_MIS_LEDGER_REPORT
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

----EXEC USP_VIRTUAL_MIS_LEDGER_REPORT 'Aug 16 2022', 'Aug 16 2022', '0000000000','zzzzzzzzzz' ,'broker', 'broker'
CREATE PROC [dbo].[USP_VIRTUAL_MIS_LEDGER_REPORT]   
(        
  @FROM_DATE VARCHAR(11),                  
  @TO_DATE VARCHAR(11),                  
  @FROM_PARTY VARCHAR(10),                  
  @TO_PARTY VARCHAR(10)          ,      
  @STATUSID VARCHAR(10),      
  @STATUSNAME VARCHAR(10)      
)        
AS        

/*        
SELECT * FROM VIRTUAL_MIS_LEDGER_REPORT        
*/  

--DECLARE
--@FROM_DATE VARCHAR(11),                  
--@TO_DATE VARCHAR(11),                  
--@FROM_PARTY VARCHAR(10),                  
--@TO_PARTY VARCHAR(10)          ,      
--@STATUSID VARCHAR(10),      
--@STATUSNAME VARCHAR(10)  

--SELECT 
--@FROM_DATE    ='Aug 22 2022'      ,        
--@TO_DATE      ='Aug 22 2022'      ,        
--@FROM_PARTY   ='0000000000'       ,        
--@TO_PARTY     ='zzzzzzzzzz'               ,
--@STATUSID     ='broker'           ,
--@STATUSNAME   ='broker'
 

IF LEN(@FROM_DATE) = 10            
BEGIN 
--return 0           
 SELECT @FROM_DATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROM_DATE, 103), 109)            
 SELECT @TO_DATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @TO_DATE, 103), 109)            
END            
 

 IF OBJECT_ID('tempdb..#virtual') IS NOT NULL
    DROP TABLE #virtual
 Select * into #virtual from  VIRTUAL_MIS_LEDGER_REPORT  V WITH(NOLOCK) WHERE  TXN_DATE >= @FROM_DATE AND TXN_DATE <= @TO_DATE 
                                                         AND V.PARTY_CODE BETWEEN @FROM_PARTY AND @TO_PARTY   
 IF OBJECT_ID('tempdb..#Led') IS NOT NULL
    DROP TABLE #Led
 SELECT Cltcode,NARRATION,VDT,vamt,drcr into #Led FROM LEDGER_ALL With(nolock) WHERE VDT >=@FROM_DATE AND VDT <=@TO_DATE +' 23:59' AND VTYP =2  and NARRATION like 'Virtual%'

 Create Index #vi on #virtual (PARTY_CODE)

 Create Index #Clt on #Led (CLTCODE ) INCLUDE(NARRATION)

  
 IF OBJECT_ID('tempdb..#InnerTable') IS NOT NULL
    DROP TABLE #InnerTable
  SELECT        
  BR_CODE,SB_CODE,V.PARTY_CODE,PARTY_NAME,SEGMENT,AMOUNT,TXN_DATE,SOURCE_BANK_ACNO,BANK_REF_NO,
  TXN_REF_NO,PRODUCT,REMARKS        
  INTO #InnerTable
  FROM  #virtual V With(nolock)  
  INNER JOIN MSAJAG..CLIENT_DETAILS C1  With(nolock) ON V.PARTY_CODE=C1.CL_CODE 
 
CREATE INDEX IX_#InnerTable On #InnerTable (PARTY_CODE) INCLUDE(TXN_REF_NO)
    
 DELETE from  #Led  where NARRATION Like 'VIRTUAL  99CA%' AND NARRATION LIKE '%UPI%'
 --DELETE from  #Led  where NARRATION Like '%99CAP%'  


 --select * from #InnerTable
 --select NARRATION,* from #Led

 SELECT DISTINCT A.*, 

 (CASE WHEN VAMT <> 0 THEN 'Y' ELSE 'N' END) AS LEDGERPOST 
 FROM       
      #InnerTable A
 LEFT OUTER JOIN  #Led AS B  ON A.PARTY_CODE=B.CLTCODE
--AND  
--      A.TXN_REF_NO =
--      CASE WHEN NARRATION NOT LIKE  'VIRTUAL UPI/%' THEN LEFT((RIGHT (NARRATION,len(NARRATION)-CHARINDEX('|', NARRATION))),CHARINDEX('|',(RIGHT (NARRATION , len(NARRATION)-CHARINDEX('|', NARRATION) ))) -1)
--      ELSE REPLACE(REPLACE(.DBO.PIECE(REPLACE(NARRATION,'VIRTUAL ',''), '|', 1),'UPI/',''),'/','') END
AND txn_date=CONVERT(VARCHAR(11),VDT,120)
order by TXN_DATE,A.PARTY_CODE,BR_CODE

GO
