-- Object: PROCEDURE dbo.SCFM_PRATHAM
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

     
    
 ---SCFM_PRATHAM 'DEC 31 2019'        
        
 CREATE proc [dbo].[SCFM_PRATHAM]  (            
        
@TODATE  DATETIME           
        
)AS            
        
        
        
---SCFM_PRATHAM '2019-11-15'        
        
BEGIN             
DECLARE @FROMDATE DATETIME          
SELECT @FROMDATE =sdtcur FROM PARAMETER WHERE @TODATE BETWEEN SDTCUR AND ldtcur         
        
        
         
select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)                  
 into #nsecm                  
 from ledger where vdt >=@FROMDATE        
 and edt <=@todate  + ' 23:59'        
  group by cltcode            
        
        
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)                  
 into #bsecm                  
 from AngelBSECM.account_ab.dbo.ledger where vdt >=@FROMDATE        
 and edt <=@todate  + ' 23:59'        
 group by cltcode          
        
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)                  
 into #nsefo                  
 from angelfo.accountfo.dbo.ledger where vdt >=@FROMDATE        
 and edt <=@todate  + ' 23:59'        
 group by cltcode           
            
        
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)                  
 into #nsx                  
 from angelfo.accountcurfo.dbo.ledger where vdt >=@FROMDATE        
 and edt <=@todate  + ' 23:59'        
 group by cltcode            
               
        
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)                  
 into #mcd                  
 from angelcommodity.accountmcdxcds.dbo.ledger where vdt >=@FROMDATE        
 and edt <=@todate  + ' 23:59'        
 group by cltcode            
        
        
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)                  
 into #MTF                  
 from MTFTRADE.dbo.ledger where vdt >=@FROMDATE            
 and edt <=@todate  + ' 23:59'        
 group by cltcode           
               
        
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)                  
 into #mcx        
 from ANGELCOMMODITY.accountMcdx.dbo.ledger where vdt >=@FROMDATE             
 and edt <=@todate +' 23:59'        
 and cltcode between 'a' and 'zzzz9999'                  
 group by cltcode            
        
        
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)                  
 into #ncx                  
 from ANGELCOMMODITY.accountncdx.dbo.ledger where vdt >=@FROMDATE             
 and edt <=@todate +' 23:59'        
  and cltcode between 'a' and 'zzzz9999'                  
 group by cltcode          
        
  select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)                  
 into #BSEFO                  
 from ANGELCOMMODITY.accountBFO.dbo.ledger where vdt >=@FROMDATE             
 and edt <=@todate +' 23:59'        
  and cltcode between 'a' and 'zzzz9999'              
 group by cltcode          
        
        
        
   select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)                  
 into #BSX                 
 from ANGELCOMMODITY.accountCURBFO.dbo.ledger where vdt >=@FROMDATE             
 and edt <=@todate +' 23:59'        
  and cltcode between 'a' and 'zzzz9999'                  
 group by cltcode              
        
  select * into #ab from (                  
  select * from #nsecm                  
  union all                  
  select * from #bsecm                  
  union all                  
  select * from #nsefo                  
  union all                  
  select * from #nsx                  
  union all                  
  select * from #mcd         
  union all                  
  select * from #MTF        
  union all        
  select * from #mcx                  
  union all                  
  select * from #ncx          
  union all                  
  select * from #BSEFO          
  union all                  
  select * from #BSX          
  )x             
        
        
        
declare @RECSDATE DATETIME , @RECODATE DATETIME        
        
        
SET @RECSDATE =@TODATE-90        
SET @RECODATE=@TODATE+1         
        
        
        
        
        
SELECT CLTCODE,SUM(BALANCE) AS BALANCE   INTO #TDAY_UNRECO  FROM (        
SELECT CLTCODE,SUM(CASE WHEN L.DRCR ='C' THEN VAMT*-1 ELSE VAMT END) AS BALANCE ,'NSE' AS EXCHANGE FROM LEDGER L (NOLOCK)  ,LEDGER1 L1           
WHERE VDT >=@RECSDATE AND VDT <=@todate +' 23:59' AND L.VTYP in ('2','3')  AND L.VTYP=L1.VTYP AND L.VNO=L1.VNO AND L.BOOKTYPE =L1.BOOKTYPE         
--AND ENTEREDBY Not in ('B_TPR' ,'TPR')        
AND ( RELDT ='' OR RELDT >=@RECODATE) GROUP BY CLTCODE         
UNION ALL          
SELECT CLTCODE,SUM(CASE WHEN L.DRCR ='C' THEN VAMT*-1 ELSE VAMT END) AS BALANCE ,'BSE' AS EXCHANGE FROM AngelBSECM.ACCOUNT_AB.DBO.LEDGER L WITH (NOLOCK) ,        
AngelBSECM.ACCOUNT_AB.DBO.LEDGER1 L1 WITH (NOLOCK)             
WHERE VDT >=@RECSDATE AND VDT <=@todate +' 23:59' AND  L.VTYP in ('2','3') AND L.VTYP=L1.VTYP AND L.VNO=L1.VNO AND L.BOOKTYPE =L1.BOOKTYPE         
--AND ENTEREDBY Not in ('B_TPR' ,'TPR')             
AND ( RELDT ='' OR RELDT >=@RECODATE)         
GROUP BY CLTCODE         
UNION ALL          
SELECT CLTCODE,SUM(CASE WHEN L.DRCR ='C' THEN VAMT*-1 ELSE VAMT END) AS BALANCE ,'NSEFO' AS EXCHANGE FROM ANGELFO.ACCOUNTFO.DBO.LEDGER L WITH (NOLOCK) ,        
ANGELFO.ACCOUNTFO.DBO.LEDGER1 L1 WITH (NOLOCK)         
WHERE VDT >=@RECSDATE AND VDT <=@todate +' 23:59' AND  L.VTYP  in ('2','3')  AND L.VTYP=L1.VTYP AND L.VNO=L1.VNO AND L.BOOKTYPE =L1.BOOKTYPE         
 --   AND ENTEREDBY Not in ('B_TPR' ,'TPR')         
AND ( RELDT ='' OR RELDT >=@RECODATE)         
GROUP BY CLTCODE         
UNION ALL          
SELECT CLTCODE,SUM(CASE WHEN L.DRCR ='C' THEN VAMT*-1 ELSE VAMT END) AS BALANCE ,'NSECURFO' AS EXCHANGE  FROM ANGELFO.ACCOUNTCURFO.DBO.LEDGER L WITH (NOLOCK) ,        
ANGELFO.ACCOUNTCURFO.DBO.LEDGER1 L1 WITH (NOLOCK)             
WHERE VDT >=@RECSDATE AND VDT <=@todate +' 23:59' AND L.VTYP in ('2','3')  AND L.VTYP=L1.VTYP AND L.VNO=L1.VNO AND L.BOOKTYPE =L1.BOOKTYPE         
--AND ENTEREDBY Not in ('B_TPR' ,'TPR')    
AND ( RELDT ='' OR RELDT >=@RECODATE)         
GROUP BY CLTCODE         
UNION ALL          
SELECT CLTCODE,SUM(CASE WHEN L.DRCR ='C' THEN VAMT*-1 ELSE VAMT END) AS BALANCE ,'MCDXCDS' AS EXCHANGE FROM ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER L WITH (NOLOCK),        
ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER1 L1 WITH (NOLOCK)        
WHERE VDT >=@RECSDATE AND VDT <=@todate +' 23:59' AND L.VTYP in ('2','3') AND L.VTYP=L1.VTYP AND L.VNO=L1.VNO AND L.BOOKTYPE =L1.BOOKTYPE         
  --  AND ENTEREDBY Not in ('B_TPR' ,'TPR')        
AND ( RELDT ='' OR RELDT >=@RECODATE)         
GROUP BY CLTCODE         
UNION ALL          
SELECT CLTCODE,SUM(CASE WHEN L.DRCR ='C' THEN VAMT*-1 ELSE VAMT END) AS BALANCE ,'BSEFO' AS EXCHANGE FROM ANGELCOMMODITY.ACCOUNTBFO.DBO.LEDGER L WITH (NOLOCK) ,        
ANGELCOMMODITY.ACCOUNTBFO.DBO.LEDGER1 L1 WITH (NOLOCK)        
WHERE VDT >=@RECSDATE AND VDT <=@todate +' 23:59' AND L.VTYP in ('2','3') AND L.VTYP=L1.VTYP AND L.VNO=L1.VNO AND L.BOOKTYPE =L1.BOOKTYPE         
  --  AND ENTEREDBY <>'B_TPR'        
AND ( RELDT ='' OR RELDT >=@RECODATE)         
GROUP BY CLTCODE         
UNION ALL          
SELECT CLTCODE,SUM(CASE WHEN L.DRCR ='C' THEN VAMT*-1 ELSE VAMT END) AS BALANCE  ,'BSECURFO' AS EXCHANGE FROM ANGELCOMMODITY.ACCOUNTCURBFO.DBO.LEDGER L WITH (NOLOCK),        
ANGELCOMMODITY.ACCOUNTCURBFO.DBO.LEDGER1 L1 WITH (NOLOCK)        
WHERE VDT >=@RECSDATE AND VDT <=@todate +' 23:59' AND L.VTYP in ('2','3') AND L.VTYP=L1.VTYP AND L.VNO=L1.VNO AND L.BOOKTYPE =L1.BOOKTYPE         
  --AND ENTEREDBY Not in ('B_TPR' ,'TPR')           
AND ( RELDT ='' OR RELDT >=@RECODATE) GROUP BY CLTCODE         
UNION ALL          
SELECT CLTCODE,SUM(CASE WHEN L.DRCR ='C' THEN VAMT*-1 ELSE VAMT END) AS BALANCE ,'MCX' AS EXCHANGE FROM ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER L WITH (NOLOCK) ,        
ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER1 L1 WITH (NOLOCK)        
WHERE VDT >=@RECSDATE AND VDT <=@todate +' 23:59' AND L.VTYP in ('2','3')  AND L.VTYP=L1.VTYP AND L.VNO=L1.VNO AND L.BOOKTYPE =L1.BOOKTYPE         
--    AND ENTEREDBY Not in ('B_TPR' ,'TPR')       
AND ( RELDT ='' OR RELDT >=@RECODATE)         
GROUP BY CLTCODE          
UNION ALL          
SELECT CLTCODE,SUM(CASE WHEN L.DRCR ='C' THEN VAMT*-1 ELSE VAMT END) AS BALANCE ,'NCX' AS EXCHANGE FROM ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER L WITH (NOLOCK) ,        
ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER1 L1 WITH (NOLOCK)        
WHERE VDT >=@RECSDATE AND VDT <=@todate +' 23:59' AND L.VTYP in ('2','3')  AND L.VTYP=L1.VTYP AND L.VNO=L1.VNO AND L.BOOKTYPE =L1.BOOKTYPE         
--    AND ENTEREDBY Not in ('B_TPR' ,'TPR')       
AND ( RELDT ='' OR RELDT >=@RECODATE)         
GROUP BY CLTCODE           
    UNION ALL          
SELECT CLTCODE,SUM(CASE WHEN L.DRCR ='C' THEN VAMT*-1 ELSE VAMT END) AS BALANCE ,'MTF' AS EXCHANGE FROM MTFTRADE.DBO.LEDGER L WITH (NOLOCK) ,        
MTFTRADE.DBO.LEDGER1 L1 WITH (NOLOCK)        
WHERE VDT >=@RECSDATE AND VDT <=@todate +' 23:59' AND L.VTYP in ('2','3')  AND L.VTYP=L1.VTYP AND L.VNO=L1.VNO AND L.BOOKTYPE =L1.BOOKTYPE         
AND ( RELDT ='' OR RELDT >=@RECODATE)         
GROUP BY CLTCODE     
 ) A        
GROUP BY CLTCODE,EXCHANGE        
        
        
        
INSERT INTO #ab        
SELECT * FROM #TDAY_UNRECO        
        
        
        
        
UPDATE  #ab SET CLTCODE =PARENTCODE FROM MSAJAG.DBO.CLIENT_DETAILS C              
WHERE  CLTCODE LIKE '98%' AND CLTCODE=CL_cODE        
        
        
    create table  #cc        
    (cltcode varchar(10),  Balance money)        
  insert into   #cc               
 select cltcode,sum(netamt) as Balance  from #ab a,MSAJAG.DBO.CLIENT_DETAILS m        
 where cltcode between 'a' and 'zzzz9999' and a.CLTCODE=m.cl_code group by cltcode            
        
           
        
          
select convert(varchar,(sum(balance)/10000000)) +' - CR' AS Balance from #CC where balance >0  and cltcode not like '%ERROR%'          
 union all          
select convert(varchar,(sum(balance)/10000000)) +' - DR' AS Balance from #CC where balance <0   and cltcode not like '%ERROR%'         
        
-----where cltcode ='DDNB1001'        
        
         
END

GO
