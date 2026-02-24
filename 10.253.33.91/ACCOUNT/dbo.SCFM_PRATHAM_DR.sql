-- Object: PROCEDURE dbo.SCFM_PRATHAM_DR
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

---SELECT *FROM SYS.procedures WHERE name LIKE '%SCFM%' ORDER BY modify_date DESC  
  
  
--SELECT * FROM SYS.procedures WHERE name LIKE '%SCFM%' ORDER BY modify_date DESC                    
                    
---SCFM_PRATHAM_bak '2020-04-30'       
--`       
      
--SCFM_PRATHAM_dr '2020-04-30'                                  
                                    
                                    
                              
 CREATE  proc [dbo].[SCFM_PRATHAM_DR]                           
  (                                        
                              
@TODATE  DATETIME ,          
@DRCR VARCHAR(20)                               
                             
)AS                                        
          
     
                                  
                                
---SCFM_PRATHAM '2020-02-28'                                    
                                 
BEGIN                                         
 DECLARE @FROMDATE DATETIME                                
SELECT @FROMDATE =sdtcur FROM PARAMETER WHERE @TODATE BETWEEN SDTCUR AND ldtcur                                     
                               
                                    
select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)                                                
 into #nsecm                   
 from ledger where Vdt >=@FROMDATE                   
 and edt <=@todate  + ' 23:59'                   
  group by cltcode                
  CREATE NONCLUSTERED INDEX [IX_CLTCODE] ON [dbo].[#nsecm]      
      
(      
[CLTCODE] ASC,      
[NETAMT]  ASC      
)                              
                                    
                                
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)                                              
 into #bsecm                                              
 from anand.account_ab.dbo.ledger where Vdt >=@FROMDATE                                     
 and edt <=@todate  + ' 23:59'                                    
 group by cltcode             
       
                CREATE NONCLUSTERED INDEX [IX_CLTCODE] ON [dbo].[#Bsecm]      
      
(      
[CLTCODE] ASC,      
[NETAMT]  ASC      
)                     
                                    
                                 
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)                                              
into #nsefo                                              
from angelfo.accountfo.dbo.ledger where Vdt >=@FROMDATE                                      
and edt <=@todate  + ' 23:59'                                    
 group by cltcode                     
       
   CREATE NONCLUSTERED INDEX [IX_CLTCODE] ON [dbo].[#nseFO]      
      
(      
[CLTCODE] ASC,      
[NETAMT]  ASC      
)                           
                                    
                          
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)                                              
 into #nsx                                              
 from angelfo.accountcurfo.dbo.ledger where Vdt >=@FROMDATE                                  
 and edt <=@todate  + ' 23:59'                                    
 group by cltcode                
   CREATE NONCLUSTERED INDEX [IX_CLTCODE] ON [dbo].[#nsx]      
      
(      
[CLTCODE] ASC,      
[NETAMT]  ASC      
)                                 
                                    
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)                                              
into #mcd                                              
 from angelcommodity.accountmcdxcds.dbo.ledger where Vdt >=@FROMDATE                                    
 and edt <=@todate  + ' 23:59'                                    
 group by cltcode             
       
   CREATE NONCLUSTERED INDEX [IX_CLTCODE] ON [dbo].[#mcd]      
      
(      
[CLTCODE] ASC,      
[NETAMT]  ASC      
)                                    
                           
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)                                              
 into #MTF                                              
 from MTFTRADE.dbo.ledger where Vdt >=@FROMDATE                                            
 and edt <=@todate  + ' 23:59'                
 group by cltcode        
       
   CREATE NONCLUSTERED INDEX [IX_CLTCODE] ON [dbo].[#MTF]      
      
(      
[CLTCODE] ASC,      
[NETAMT]  ASC      
)                  
                                    
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)                                              
 into #mcx                                    
 from ANGELCOMMODITY.accountMcdx.dbo.ledger where Vdt >=@FROMDATE                                           
 and edt <=@todate +' 23:59'                          
 and cltcode between 'a' and 'zzzz9999'                                   
 group by cltcode               
   CREATE NONCLUSTERED INDEX [IX_CLTCODE] ON [dbo].[#mcx]      
      
(      
[CLTCODE] ASC,      
[NETAMT]  ASC      
)         
                               
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)                                              
 into #ncx                                              
 from ANGELCOMMODITY.accountncdx.dbo.ledger where Vdt >=@FROMDATE                                            
 and edt <=@todate +' 23:59'                           
 and cltcode between 'a' and 'zzzz9999'              
 group by cltcode       
       
   CREATE NONCLUSTERED INDEX [IX_CLTCODE] ON [dbo].[#ncx]      
      
(      
[CLTCODE] ASC,      
[NETAMT]  ASC      
)                                        
  select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)                               
 into #BSEFO                                              
 from ANGELCOMMODITY.accountBFO.dbo.ledger where Vdt >=@FROMDATE                                  
 and edt <=@todate +' 23:59'                             
 and cltcode between 'a' and 'zzzz9999'                                
 group by cltcode          
   CREATE NONCLUSTERED INDEX [IX_CLTCODE] ON [dbo].[#BSEFO]      
      
(      
[CLTCODE] ASC,      
[NETAMT]  ASC      
)         
                              
                           
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)                                              
 into #BSX                             
 from ANGELCOMMODITY.accountCURBFO.dbo.ledger where Vdt >=@FROMDATE                                          
 and edt <=@todate +' 23:59'                        
 and cltcode between 'a' and 'zzzz9999'                                     
 group by cltcode          
   CREATE NONCLUSTERED INDEX [IX_CLTCODE] ON [dbo].[#bsx]      
      
(      
[CLTCODE] ASC,      
[NETAMT]  ASC      
)         
                                       
                                    
                          
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
WHERE vdt >=@RECSDATE AND vdt <=@todate +' 23:59'   AND L.VTYP=L1.VTYP AND L.VTYP ='2' AND L.VNO=L1.VNO AND L.BOOKTYPE =L1.BOOKTYPE                                     
---AND ENTEREDBY <>'B_TPR'  
AND ( RELDT ='' OR RELDT >=@RECODATE)  GROUP BY CLTCODE                                 
UNION ALL                                   
SELECT CLTCODE,SUM(CASE WHEN L.DRCR ='C' THEN VAMT*-1 ELSE VAMT END) AS BALANCE ,'MTF' AS EXCHANGE FROM MTFTRADE..LEDGER L (NOLOCK)  ,MTFTRADE..LEDGER1 L1                                       
WHERE vdt >=@RECSDATE AND vdt <=@todate +' 23:59'   AND L.VTYP=L1.VTYP AND L.VTYP ='2' AND L.VNO=L1.VNO AND L.BOOKTYPE =L1.BOOKTYPE                                     
---AND ENTEREDBY <>'B_TPR'   
AND ( RELDT ='' OR RELDT >=@RECODATE) GROUP BY CLTCODE                                    
UNION ALL                                      
SELECT CLTCODE,SUM(CASE WHEN L.DRCR ='C' THEN VAMT*-1 ELSE VAMT END) AS BALANCE ,'BSE' AS EXCHANGE FROM ANAND.ACCOUNT_AB.DBO.LEDGER L WITH (NOLOCK) ,                                    
ANAND.ACCOUNT_AB.DBO.LEDGER1 L1 WITH (NOLOCK)                                         
WHERE vdt >=@RECSDATE AND vdt <=@todate +' 23:59'   AND L.VTYP=L1.VTYP AND L.VTYP ='2' AND L.VNO=L1.VNO AND L.BOOKTYPE =L1.BOOKTYPE                                     
---AND ENTEREDBY <>'B_TPR'   
AND ( RELDT ='' OR RELDT >=@RECODATE) GROUP BY CLTCODE                                    
UNION ALL                                      
SELECT CLTCODE,SUM(CASE WHEN L.DRCR ='C' THEN VAMT*-1 ELSE VAMT END) AS BALANCE ,'NSEFO' AS EXCHANGE FROM ANGELFO.ACCOUNTFO.DBO.LEDGER L WITH (NOLOCK) ,                                    
ANGELFO.ACCOUNTFO.DBO.LEDGER1 L1 WITH (NOLOCK)                                     
WHERE vdt >=@RECSDATE AND vdt <=@todate +' 23:59'   AND L.VTYP=L1.VTYP AND L.VTYP ='2' AND L.VNO=L1.VNO AND L.BOOKTYPE =L1.BOOKTYPE                                     
---AND ENTEREDBY <>'B_TPR'   
AND ( RELDT ='' OR RELDT >=@RECODATE) GROUP BY CLTCODE                         
UNION ALL                                      
SELECT CLTCODE,SUM(CASE WHEN L.DRCR ='C' THEN VAMT*-1 ELSE VAMT END) AS BALANCE ,'NSECURFO' AS EXCHANGE  FROM ANGELFO.ACCOUNTCURFO.DBO.LEDGER L WITH (NOLOCK) ,                                    
ANGELFO.ACCOUNTCURFO.DBO.LEDGER1 L1 WITH (NOLOCK)                                        
WHERE vdt >=@RECSDATE AND vdt <=@todate +' 23:59'   AND L.VTYP=L1.VTYP AND L.VTYP ='2' AND L.VNO=L1.VNO AND L.BOOKTYPE =L1.BOOKTYPE                                     
----AND ENTEREDBY <>'B_TPR'   
AND ( RELDT ='' OR RELDT >=@RECODATE) GROUP BY CLTCODE                         
UNION ALL                                      
SELECT CLTCODE,SUM(CASE WHEN L.DRCR ='C' THEN VAMT*-1 ELSE VAMT END) AS BALANCE ,'MCDXCDS' AS EXCHANGE FROM ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER L WITH (NOLOCK),                                    
ANGELCOMMODITY.ACCOUNTMCDXCDS.DBO.LEDGER1 L1 WITH (NOLOCK)                                    
WHERE vdt >=@RECSDATE AND vdt <=@todate +' 23:59'   AND L.VTYP=L1.VTYP AND L.VTYP ='2' AND L.VNO=L1.VNO AND L.BOOKTYPE =L1.BOOKTYPE                                     
----AND ENTEREDBY <>'B_TPR'  
AND ( RELDT ='' OR RELDT >=@RECODATE) GROUP BY CLTCODE                                   
UNION ALL   
SELECT CLTCODE,SUM(CASE WHEN L.DRCR ='C' THEN VAMT*-1 ELSE VAMT END) AS BALANCE ,'BSEFO' AS EXCHANGE FROM ANGELCOMMODITY.ACCOUNTBFO.DBO.LEDGER L WITH (NOLOCK) ,                                    
ANGELCOMMODITY.ACCOUNTBFO.DBO.LEDGER1 L1 WITH (NOLOCK)                                    
WHERE vdt >=@RECSDATE AND vdt <=@todate +' 23:59'   AND L.VTYP=L1.VTYP AND L.VTYP ='2' AND L.VNO=L1.VNO AND L.BOOKTYPE =L1.BOOKTYPE                                     
---AND ENTEREDBY <>'B_TPR'  
AND ( RELDT ='' OR RELDT >=@RECODATE)  GROUP BY CLTCODE                                   
UNION ALL                                      
SELECT CLTCODE,SUM(CASE WHEN L.DRCR ='C' THEN VAMT*-1 ELSE VAMT END) AS BALANCE  ,'BSECURFO' AS EXCHANGE FROM ANGELCOMMODITY.ACCOUNTCURBFO.DBO.LEDGER L WITH (NOLOCK),                                    
ANGELCOMMODITY.ACCOUNTCURBFO.DBO.LEDGER1 L1 WITH (NOLOCK)         
WHERE vdt >=@RECSDATE AND vdt <=@todate +' 23:59'   AND L.VTYP=L1.VTYP AND L.VTYP ='2' AND L.VNO=L1.VNO AND L.BOOKTYPE =L1.BOOKTYPE                                     
--AND ENTEREDBY <>'B_TPR'   
AND ( RELDT ='' OR RELDT >=@RECODATE) GROUP BY CLTCODE                           
UNION ALL                                      
SELECT CLTCODE,SUM(CASE WHEN L.DRCR ='C' THEN VAMT*-1 ELSE VAMT END) AS BALANCE ,'MCX' AS EXCHANGE FROM ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER L WITH (NOLOCK) ,                                    
ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER1 L1 WITH (NOLOCK)                                    
WHERE vdt >=@RECSDATE AND vdt <=@todate +' 23:59'   AND L.VTYP=L1.VTYP AND L.VTYP ='2' AND L.VNO=L1.VNO AND L.BOOKTYPE =L1.BOOKTYPE                                     
----AND ENTEREDBY <>'B_TPR'   
AND ( RELDT ='' OR RELDT >=@RECODATE) GROUP BY CLTCODE                                     
UNION ALL                                      
SELECT CLTCODE,SUM(CASE WHEN L.DRCR ='C' THEN VAMT*-1 ELSE VAMT END) AS BALANCE ,'NCX' AS EXCHANGE FROM ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER L WITH (NOLOCK) ,                                    
ANGELCOMMODITY.ACCOUNTNCDX.DBO.LEDGER1 L1 WITH (NOLOCK)                                    
WHERE vdt >=@RECSDATE AND vdt <=@todate +' 23:59'   AND L.VTYP=L1.VTYP AND L.VTYP ='2' AND L.VNO=L1.VNO AND L.BOOKTYPE =L1.BOOKTYPE                                     
----AND ENTEREDBY <>'B_TPR'  
 AND ( RELDT ='' OR RELDT >=@RECODATE) GROUP BY CLTCODE                                     
 ) A                                    
GROUP BY CLTCODE,EXCHANGE         
      
                                    
                                    
INSERT INTO #ab                                    
SELECT * FROM #TDAY_UNRECO          
CREATE NONCLUSTERED INDEX [IX_CLTCODE] ON [dbo].[#ab]      
      
(      
[CLTCODE] ASC      
)      
      
      
                             
                                    
UPDATE  #ab SET CLTCODE =PARENTCODE FROM MSAJAG.DBO.CLIENT_DETAILS C                                          
WHERE  CLTCODE LIKE '98%' AND CLTCODE=CL_cODE                                    
                                    
    create table  #cc                                    
    (cltcode varchar(10),LONG_NAME VARCHAR(100),PAN_GIR_NO VARCHAR(20) , Balance money)        
          
    CREATE NONCLUSTERED INDEX [IX_CODE] ON [dbo].[#cc]      
      
(      
      
[CLTCODE] ASC,      
[Balance] ASC      
      
      
)                                   
                               
                                    
  insert into   #cc                                           
 select cltcode,long_name,PAN_GIR_NO,sum(netamt) as Balance  from #ab a,MSAJAG.DBO.CLIENT_DETAILS m                                    
 where cltcode between 'a' and 'zzzz9999' and a.CLTCODE=m.cl_code group by cltcode   ,long_name,PAN_GIR_NO                          
                     
                         
                         
                                    
--select  'CR'AS DATA ,* from #CC   where balance >0       order by cltcode                         
--select 'DR'AS DATA ,*  from #CC   where balance <0       order by cltcode                   
                  
        
        IF @DRCR='DEBTORS'       
    BEGIN      
   select 'DR'AS DATA ,*,convert(varchar,(sum(balance)/10000000))AS Balance_new INTO #DEBTORS from #CC where balance <0 and cltcode not like '%ERROR%' group by    cltcode,long_name,PAN_GIR_NO   ,balance                  
       
   truncate table scfm_final     
       
   insert into scfm_final    
   select *,@TODATE from #DEBTORS    
     
DECLARE @FILE VARCHAR(MAX),@PATH VARCHAR(MAX) = 'J:\BackOffice\Automation\Banking\'                       
SET @FILE = @PATH + 'SCFM_DATA_DEBTORS' +'_'+ CONVERT(VARCHAR(11),@TODATE , 112) + '.csv' --Folder Name     
DECLARE @S VARCHAR(MAX)                              
SET @S = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''DATA'''',''''CLTCODE'''',''''LONG_NAME'''',''''PAN_GIR_NO'''',''''Balance'''',''''Balance_new'''',''''todate'''''    --Column Name    
SET @S = @S + ' UNION ALL SELECT  cast([DATA] as varchar), cast([CLTCODE] as varchar), cast([LONG_NAME] as varchar), cast([PAN_GIR_NO] as varchar), cast([Balance] as varchar), cast([Balance_new] as varchar),CONVERT (VARCHAR (11),todate,109) as todate FRO
  
M [ACCOUNT].[dbo].[scfm_final]    " QUERYOUT ' --Convert data type if required    
    
 +@file+ ' -c -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'''     
--       PRINT  (@S)     
EXEC(@S)      
    
end    
   else    
      begin            
select  'CR'AS DATA ,*,convert(varchar,(sum(balance)/10000000))  AS Balance_new into #CEBTORS  from #CC where balance >0 and cltcode not like '%ERROR%'  group by    cltcode,long_name,PAN_GIR_NO ,balance                      
---union ALL     
   truncate table scfm_final     
        
   insert into scfm_final    
   select *,@TODATE from #CEBTORS     
       
      
DECLARE @FILE1 VARCHAR(MAX),@PATH1 VARCHAR(MAX) = 'J:\BackOffice\Automation\Banking\'                       
SET @FILE1 = @PATH1 + 'SCFM_DATA_CREDITORS' +'_'+ CONVERT(VARCHAR(11),@TODATE , 112) + '.csv' --Folder Name     
DECLARE @S1 VARCHAR(MAX)                              
SET @S1 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''DATA'''',''''CLTCODE'''',''''LONG_NAME'''',''''PAN_GIR_NO'''',''''Balance'''',''''Balance_new'''',''''todate'''''    --Column Name    
SET @S1 = @S1 + ' UNION ALL SELECT  cast([DATA] as varchar), cast([CLTCODE] as varchar), cast([LONG_NAME] as varchar), cast([PAN_GIR_NO] as varchar), cast([Balance] as varchar), cast([Balance_new] as varchar),CONVERT (VARCHAR (11),todate,109) as todate FR
  
OM [ACCOUNT].[dbo].[scfm_final]    " QUERYOUT ' --Convert data type if required    
    
 +@file+ ' -c -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'''     
--       PRINT  (@S)     
EXEC(@S1)                         
  end                
       
    
    
               
                                     
END

GO
