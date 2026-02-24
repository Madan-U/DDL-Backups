-- Object: PROCEDURE dbo.USP_VIRTUAL_MIS_LEDGER_REPORT_NEW_FILEFORMAT
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROC [dbo].[USP_VIRTUAL_MIS_LEDGER_REPORT_NEW_FILEFORMAT]   
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
--@FROM_DATE    ='Jul 23 2022'      ,        
--@TO_DATE      ='Jul 23 2022'      ,        
--@FROM_PARTY   ='0000000000'       ,        
--@TO_PARTY     ='zz'               ,
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
 Select * into #virtual from  VIRTUAL_MIS_LEDGER_REPORT Where  TXN_DATE >= @FROM_DATE AND TXN_DATE <= @TO_DATE 

 IF OBJECT_ID('tempdb..#Led') IS NOT NULL
    DROP TABLE #Led
 SELECT Cltcode,NARRATION,VDT,vamt,drcr into #Led FROM LEDGER_ALL With(nolock) WHERE VDT >=@FROM_DATE AND VDT <=@TO_DATE +' 23:59' AND VTYP =2  and NARRATION like 'Virtual%'

 Create Index #vi on #virtual (PARTY_CODE)

 Create Index #Clt on #Led (CLTCODE )

 SELECT DISTINCT A.*, 

 (CASE WHEN VAMT <> 0 THEN 'Y' ELSE 'N' END) AS LEDGERPOST FROM       
(

SELECT        
 BR_CODE,SB_CODE,V.PARTY_CODE,PARTY_NAME,SEGMENT,AMOUNT,TXN_DATE,SOURCE_BANK_ACNO,BANK_REF_NO,
 TXN_REF_NO,PRODUCT,REMARKS        
FROM  #virtual V With(nolock)  ,MSAJAG..CLIENT_DETAILS C1  With(nolock)      
 WHERE             
 V.PARTY_CODE BETWEEN @FROM_PARTY AND @TO_PARTY            
 AND 
 V.PARTY_CODE=C1.CL_CODE     
 --AND V.PARTY_CODE IN ('S460931','N70096')
 AND TXN_DATE >= @FROM_DATE AND TXN_DATE <= @TO_DATE 
 ) A
 LEFT OUTER JOIN  #Led AS B  ON A.PARTY_CODE=B.CLTCODE
--  AND (CASE WHEN NARRATION LIKE '%IMPS|%' THEN  substring(narration,charindex('|',narration)+5,30) 
--            WHEN NARRATION LIKE '%IMPS/%' THEN  SUBSTRING(REPLACE(NARRATION,'VIRTUAL IMPS/P2A/',''),0, CHARINDEX('/', REPLACE(NARRATION,'VIRTUAL IMPS/P2A/',''))) 
--ELSE .DBO.PIECE(REPLACE(NARRATION,'VIRTUAL ',''), '|', 1) END  ) =TXN_REF_NO 
/*Below Condition Added By Ahsan Farooqui 202207 29*/
AND LEFT((RIGHT (NARRATION,len(NARRATION)-CHARINDEX('|', NARRATION))),CHARINDEX('|',(RIGHT (NARRATION , len(NARRATION)-CHARINDEX('|', NARRATION) ))) -1)
=TXN_REF_NO 
/*END 20220729*/
AND txn_date=CONVERT(VARCHAR(11),VDT,120)
--AND A.PARTY_CODE IN ('S460931','N70096')
--  AND EXCHANGE=SEGMENT
order by TXN_DATE,A.PARTY_CODE,BR_CODE

GO
