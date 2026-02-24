-- Object: PROCEDURE dbo.SCFM_NEW_PRATHAM_A100077
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

  
  

--SCFM_NEW 'APR  1 2019','NOV 29 2019'



----18 TO 23 OCT  
  
---SCFM_NEW_PRATHAM_A100077 'apr  1 2019','NOV 29 2019'  
  
CREATE PROC [dbo].[SCFM_NEW_PRATHAM_A100077]   
  
  
  
(  
  
  
  
 @FROMDATE DATETIME,@TODATE DATETIME  
  
 )  
  
  
  
 As  
  
  
  
select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)            
  
 into #nsecm            
  
 from ledger where vdt >=@fromdate           
  
 and edt <=@todate  + ' 23:59'   
  
  group by cltcode      
  
         
  
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)            
  
 into #bsecm            
  
 from anand.account_ab.dbo.ledger where vdt >=@fromdate           
  
 and edt <=@todate  + ' 23:59'  
  
 group by cltcode    
  
           
  
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)            
  
 into #nsefo            
  
 from angelfo.accountfo.dbo.ledger where vdt >=@fromdate           
  
 and edt <=@todate  + ' 23:59'  
  
 group by cltcode        
  
       
  
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)            
  
 into #nsx            
  
 from angelfo.accountcurfo.dbo.ledger where vdt >=@fromdate           
  
 and edt <=@todate  + ' 23:59'  
  
 group by cltcode      
  
         
  
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)            
  
 into #mcd            
  
 from angelcommodity.accountmcdxcds.dbo.ledger where vdt >=@fromdate           
  
 and edt <=@todate  + ' 23:59'  
  
 group by cltcode      
  
   
  
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)            
  
 into #MTF            
  
 from MTFTRADE.dbo.ledger where vdt >=@fromdate           
  
 and edt <=@todate  + ' 23:59'  
  
 group by cltcode           
  
       
  
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)            
  
 into #mcx  
  
 from ANGELCOMMODITY.accountMcdx.dbo.ledger where vdt >=@fromdate            
  
 and edt <=@todate +' 23:59'  
  
 and cltcode between 'a' and 'zzzz9999'            
  
 group by cltcode      
  
         
  
 select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)            
  
 into #ncx            
  
 from ANGELCOMMODITY.accountncdx.dbo.ledger where vdt >=@fromdate            
  
 and edt <=@todate +' 23:59'  
  
  and cltcode between 'a' and 'zzzz9999'            
  
 group by cltcode     
  
   
  
  select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)            
  
 into #BSEFO          
  
 from ANGELCOMMODITY.accountBFO.dbo.ledger where vdt >=@fromdate            
  
 and edt <=@todate +' 23:59'  
  
  and cltcode between 'a' and 'zzzz9999'            
  
 group by cltcode    
  
   
  
  select cltcode,NETAMT=sum(case when drcr='D' then -VAMT else VAMT end)            
  
 into #BSX      
  
 from ANGELCOMMODITY.accountCURBFO.dbo.ledger where vdt >=@fromdate            
  
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
  
  UNION ALL  
  
  SELECT * FROM #BSEFO  
  
  UNION ALL  
  
  SELECT * FROM #BSX  
  
  )x       
  
        
  
        
  
          
  
UPDATE  #ab SET CLTCODE =PARENTCODE FROM MSAJAG.DBO.CLIENT_DETAILS C        
  
WHERE  CLTCODE LIKE '98%' AND CLTCODE=CL_cODE  
  
     
  
   
  
        
  
   create table  #cc  
  
    (cltcode varchar(10),  
  
  Balance money,  
  
  UNRECO_CREDIT MONEY,UNRECO_DEBIT MONEY  
  
  ,NSEFO_MARGIN MONEY,  
  
  NSX_MARGIN MONEY,  
  
  NSE_MARGIN MONEY,  
  
   BSE_MARGIN MONEY,  
  
   MCX_MARGIN MONEY,  
  
   NCX_MARGIN MONEY,  
  
   BSEFO_MARGIN MONEY,  
  
   BSX_MARGIN MONEY,  
  
  FO_NON_CASH MONEY,  
  
  CUR_NON_CASH MONEY,  
  
  MCX_NON_CASH MONEY,  
  
  NCX_NON_CASH MONEY,  
  
  BSEFO_NON_CASH MONEY,  
  
  BSX_NON_CASH MONEY,  
  
  FO_CASH MONEY,  
  
  CUR_CASH MONEY,  
  
  MCX_CASH MONEY,  
  
  NCX_CASH MONEY,  
  
  BSEFO_CASH MONEY,  
  
  BSX_CASH MONEY  )  
  
      
  
   
  
            
  
             
  
  insert into   #cc         
  
 select cltcode,sum(netamt) as Balance,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0  from #ab where cltcode between 'a' and 'zzzz9999'  group by cltcode            
  
             
  
           
  
          
  
             
  
      
  
            
  
 --select * from SCFM_FY1516      
  
 ---------  
  
   
  
    
  
/*NSECM*/   
  
 SELECT   l.vtyp, l.booktype, l.vno, vdt,   
  
 tdate = Convert(datetime,convert(VARCHAR, l.vdt, 103),103), isnull(L1.ddno, '') ddno,   
  
 isnull(l.cltcode, '') cltcode, isnull(l.acname, '') acname, l.drcr,  Cramt = (          
  
   CASE           
  
    WHEN upper(l.drcr) = 'C'          
  
     THEN l.vamt          
  
    ELSE l.vamt*-1          
  
    END          
  
   ), treldt = isnull(Convert(datetime,convert(VARCHAR, L1.reldt, 103),103), '')  
  
 INTO #nsecmreco  
  
 FROM account.dbo.ledger l(NOLOCK)          
  
 LEFT OUTER JOIN account.dbo.LEDGER1 L1(NOLOCK)          
  
  ON l.vtyp = l1.vtyp          
  
   AND l.booktype = l1.booktype          
  
   AND l.vno = l1.vno          
  
   AND l.lno = l1.lno  
  
 WHERE   
  
    l.cltcode >= 'a'          
  
  AND l.cltcode <= 'ZZZZZ99999'          
  
  AND l.drcr in ('C','D')  
  
  AND l.vdt>= @FROMDATE and  l.vdt<=@todate  + ' 23:59' and  
  
 l.vtyp in (2,17)          
  
  AND  ( l1.reldt >= @TODATE +1    or l1.RELDT ='')    and edt <=@todate  + ' 23:59'  
  
  /*  
  
  and l.cltcode='DELL4132' and l.vdt='2016-03-22 00:00:00.000'    
  
  */  
  
  
  
select cltcode,VDT,treldt,Cramt=SUM(Cramt) into #nsecmreco_final from #nsecmreco group by cltcode,VDT,treldt  
  
  
  
/**********************************************/  



  
  
  
/**********************************************/  

  
  
  
  
  
   
  
/*BSECM*/   
  
 SELECT   l.vtyp, l.booktype, l.vno, vdt,   
  
 tdate = Convert(datetime,convert(VARCHAR, l.vdt, 103),103), isnull(L1.ddno, '') ddno,   
  
 isnull(l.cltcode, '') cltcode, isnull(l.acname, '') acname, l.drcr,  Cramt = (          
  
   CASE           
  
    WHEN upper(l.drcr) = 'C'          
  
     THEN l.vamt          
  
    ELSE l.vamt*-1          
  
    END                 
  
   ), treldt = isnull(Convert(datetime,convert(VARCHAR, L1.reldt, 103),103), '')  
  
 INTO #bsecmreco  
  
 FROM anand.account_ab.dbo.ledger l(NOLOCK)          
  
 LEFT OUTER JOIN anand.account_ab.dbo.LEDGER1 L1(NOLOCK)          
  
  ON l.vtyp = l1.vtyp          
  
   AND l.booktype = l1.booktype          
  
   AND l.vno = l1.vno          
  
   AND l.lno = l1.lno  
  
 WHERE   
  
    l.cltcode >= 'a'          
  
  AND l.cltcode <= 'ZZZZZ99999'          
  
  AND l.drcr in ('C','D')        
  
  AND l.vdt>= @FROMDATE and  l.vdt<=@todate  + ' 23:59' and  
  
 l.vtyp in (2,17)          
  
  AND  ( l1.reldt >= @TODATE +1    or l1.RELDT ='')   and edt <=@todate  + ' 23:59'  
  
  
  
  
  
select cltcode,VDT,treldt,Cramt=SUM(Cramt) into #bsecmreco_final from #bsecmreco group by cltcode,VDT,treldt  
  
  
  
/**********************************************/  
  
  
  
  
  
   
  
/*NSEFO*/   
  
 SELECT   l.vtyp, l.booktype, l.vno, vdt,   
  
 tdate = Convert(datetime,convert(VARCHAR, l.vdt, 103),103), isnull(L1.ddno, '') ddno,   
  
 isnull(l.cltcode, '') cltcode, isnull(l.acname, '') acname, l.drcr,  Cramt = (          
  
   CASE           
  
    WHEN upper(l.drcr) = 'C'          
  
     THEN l.vamt          
  
    ELSE l.vamt*-1          
  
    END                
  
   ), treldt = isnull(Convert(datetime,convert(VARCHAR, L1.reldt, 103),103), '')  
  
 INTO #nseforeco  
  
 FROM angelfo.accountfo.dbo.ledger l(NOLOCK)          
  
 LEFT OUTER JOIN angelfo.accountfo.dbo.LEDGER1 L1(NOLOCK)          
  
  ON l.vtyp = l1.vtyp          
  
   AND l.booktype = l1.booktype          
  
   AND l.vno = l1.vno          
  
   AND l.lno = l1.lno  
  
 WHERE   
  
    l.cltcode >= 'a'          
  
  AND l.cltcode <= 'ZZZZZ99999'          
  
 AND l.drcr in ('C','D')         
  
  AND l.vdt>= @FROMDATE and  l.vdt<=@todate  + ' 23:59' and  
  
 l.vtyp in (2,17)          
  
  AND  ( l1.reldt >= @TODATE +1    or l1.RELDT ='')   and edt <=@todate  + ' 23:59'  
  
  
  
  
  
select cltcode,VDT,treldt,Cramt=SUM(Cramt) into #nseforeco_final from #nseforeco group by cltcode,VDT,treldt  
  
  
  
/**********************************************/  
  
  
  
  
  
/*NSX*/   
  
 SELECT   l.vtyp, l.booktype, l.vno, vdt,   
  
 tdate = Convert(datetime,convert(VARCHAR, l.vdt, 103),103), isnull(L1.ddno, '') ddno,   
  
 isnull(l.cltcode, '') cltcode, isnull(l.acname, '') acname, l.drcr,  Cramt = (          
  
   CASE           
  
    WHEN upper(l.drcr) = 'C'          
  
     THEN l.vamt          
  
    ELSE l.vamt*-1          
  
    END              
  
   ), treldt = isnull(Convert(datetime,convert(VARCHAR, L1.reldt, 103),103), '')  
  
 INTO #nsxreco  
  
 FROM angelfo.accountcurfo.dbo.ledger l(NOLOCK)          
  
 LEFT OUTER JOIN angelfo.accountcurfo.dbo.LEDGER1 L1(NOLOCK)          
  
  ON l.vtyp = l1.vtyp          
  
   AND l.booktype = l1.booktype          
  
   AND l.vno = l1.vno          
  
   AND l.lno = l1.lno  
  
 WHERE   
  
    l.cltcode >= 'a'          
  
  AND l.cltcode <= 'ZZZZZ99999'          
  
AND l.drcr in ('C','D')          
  
  AND l.vdt>= @FROMDATE and  l.vdt<=@todate  + ' 23:59' and  
  
 l.vtyp in (2,17)          
  
  AND  ( l1.reldt >= @TODATE +1    or l1.RELDT ='')   and edt <=@todate  + ' 23:59'  
  
  
  
  
  
select cltcode,VDT,treldt,Cramt=SUM(Cramt) into #nsxreco_final from #nsxreco group by cltcode,VDT,treldt  
  
  
  
/**********************************************/  
  
  
  
  
  
  
  
  
  
/*MCD*/   
  
 SELECT   l.vtyp, l.booktype, l.vno, vdt,   
  
 tdate = Convert(datetime,convert(VARCHAR, l.vdt, 103),103), isnull(L1.ddno, '') ddno,   
  
 isnull(l.cltcode, '') cltcode, isnull(l.acname, '') acname, l.drcr,  Cramt = (          
  
   CASE           
  
    WHEN upper(l.drcr) = 'C'          
  
     THEN l.vamt          
  
    ELSE l.vamt*-1          
  
    END               
  
   ), treldt = isnull(Convert(datetime,convert(VARCHAR, L1.reldt, 103),103), '')  
  
 INTO #mcdreco  
  
 FROM ANGELCOMMODITY.accountmcdxcds.dbo.ledger l(NOLOCK)          
  
 LEFT OUTER JOIN ANGELCOMMODITY.accountmcdxcds.dbo.LEDGER1 L1(NOLOCK)          
  
  ON l.vtyp = l1.vtyp          
  
   AND l.booktype = l1.booktype          
  
   AND l.vno = l1.vno          
  
   AND l.lno = l1.lno  
  
 WHERE   
  
    l.cltcode >= 'a'          
  
  AND l.cltcode <= 'ZZZZZ99999'          
  
  AND l.drcr in ('C','D')           
  
  AND l.vdt>= @FROMDATE and  l.vdt<=@todate  + ' 23:59' and  
  
 l.vtyp in (2,17)          
  
  AND  ( l1.reldt >= @TODATE +1    or l1.RELDT ='')   and edt <=@todate  + ' 23:59'  
  
  
  
  
  
select cltcode,VDT,treldt,Cramt=SUM(Cramt) into #mcdreco_final from #mcdreco group by cltcode,VDT,treldt  
  
  
  
  
  
/********************mcx*****************************/  
  
SELECT   l.vtyp, l.booktype, l.vno, vdt,   
  
 tdate = Convert(datetime,convert(VARCHAR, l.vdt, 103),103), isnull(L1.ddno, '') ddno,   
  
 isnull(l.cltcode, '') cltcode, isnull(l.acname, '') acname, l.drcr,  Cramt = (          
  
   CASE           
  
    WHEN upper(l.drcr) = 'C'          
  
     THEN l.vamt          
  
    ELSE l.vamt*-1          
  
    END                
  
   ), treldt = isnull(Convert(datetime,convert(VARCHAR, L1.reldt, 103),103), '')  
  
 INTO #MCXreco  
  
 FROM ANGELCOMMODITY.ACCOUNTMCDX.DBO.ledger l(NOLOCK)          
  
 LEFT OUTER JOIN ANGELCOMMODITY.ACCOUNTMCDX.DBO.LEDGER1 L1(NOLOCK)          
  
  ON l.vtyp = l1.vtyp          
  
   AND l.booktype = l1.booktype          
  
   AND l.vno = l1.vno          
  
   AND l.lno = l1.lno  
  
 WHERE   
  
    l.cltcode >= 'a'          
  
  AND l.cltcode <= 'ZZZZZ99999'          
  
 AND l.drcr in ('C','D')         
  
  AND l.vdt>= @fromdate and  l.vdt<=@todate +' 23:59' and  
  
 l.vtyp in (2,17)          
  
  AND  ( l1.reldt >= @TODATE + 1     or l1.RELDT ='')   and edt <=@todate  + ' 23:59'  
  
  
  
  
  
select cltcode,VDT,treldt,Cramt=SUM(Cramt) into #MCXreco_final from #MCXreco group by cltcode,VDT,treldt  
  
  
  
/**********************************************/  
  
  
  
  
  
/*NSX*/   
  
 SELECT   l.vtyp, l.booktype, l.vno, vdt,   
  
 tdate = Convert(datetime,convert(VARCHAR, l.vdt, 103),103), isnull(L1.ddno, '') ddno,   
  
 isnull(l.cltcode, '') cltcode, isnull(l.acname, '') acname, l.drcr,  Cramt = (          
  
   CASE           
  
    WHEN upper(l.drcr) = 'C'          
  
     THEN l.vamt          
  
    ELSE l.vamt*-1          
  
    END              
  
   ), treldt = isnull(Convert(datetime,convert(VARCHAR, L1.reldt, 103),103), '')  
  
 INTO #nCDreco  
  
 FROM ANGELCOMMODITY.accountncdx.dbo.ledger l(NOLOCK)          
  
 LEFT OUTER JOIN ANGELCOMMODITY.accountncdx.dbo.ledger1 L1(NOLOCK)          
  
  ON l.vtyp = l1.vtyp          
  
   AND l.booktype = l1.booktype          
  
   AND l.vno = l1.vno          
  
   AND l.lno = l1.lno  
  
 WHERE   
  
    l.cltcode >= 'a'          
  
  AND l.cltcode <= 'ZZZZZ99999'          
  
AND l.drcr in ('C','D')          
  
  AND l.vdt>= @fromdate and l.vdt<=@todate +' 23:59' and  
  
 l.vtyp in (2,17)          
  
  AND  ( l1.reldt >= @TODATE + 1     or l1.RELDT ='')   and edt <=@todate  + ' 23:59'  
  
  
  
  
  
select cltcode,VDT,treldt,Cramt=SUM(Cramt) into #nCDreco_final from #nCDreco group by cltcode,VDT,treldt  
  
  
  
/**********************************************/  
  
  
  
  
  
/*BSEFO*/   
  
 SELECT   l.vtyp, l.booktype, l.vno, vdt,   
  
 tdate = Convert(datetime,convert(VARCHAR, l.vdt, 103),103), isnull(L1.ddno, '') ddno,   
  
 isnull(l.cltcode, '') cltcode, isnull(l.acname, '') acname, l.drcr,  Cramt = (          
  
   CASE           
  
    WHEN upper(l.drcr) = 'C'          
  
     THEN l.vamt          
  
    ELSE l.vamt*-1          
  
    END              
  
   ), treldt = isnull(Convert(datetime,convert(VARCHAR, L1.reldt, 103),103), '')  
  
 INTO #BFOreco  
  
 FROM ANGELCOMMODITY.accountBFO.dbo.ledger l(NOLOCK)          
  
 LEFT OUTER JOIN ANGELCOMMODITY.accountBFO.dbo.ledger1 L1(NOLOCK)          
  
  ON l.vtyp = l1.vtyp          
  
   AND l.booktype = l1.booktype          
  
   AND l.vno = l1.vno          
  
   AND l.lno = l1.lno  
  
 WHERE   
  
    l.cltcode >= 'a'          
  
  AND l.cltcode <= 'ZZZZZ99999'          
  
AND l.drcr in ('C','D')          
  
  AND l.vdt>= @fromdate and  l.vdt<=@todate +' 23:59' and  
  
 l.vtyp in (2,17)          
  
  AND  ( l1.reldt >= @TODATE + 1     or l1.RELDT ='')   and edt <=@todate  + ' 23:59'  
  
  
  
  
  
select cltcode,VDT,treldt,Cramt=SUM(Cramt) into #BFOreco_final from #BFOreco group by cltcode,VDT,treldt  
  
  
  
  
  
/**********************************************/  
  
  
  
  
  
/*BSX*/   
  
 SELECT   l.vtyp, l.booktype, l.vno, vdt,   
  
 tdate = Convert(datetime,convert(VARCHAR, l.vdt, 103),103), isnull(L1.ddno, '') ddno,   
  
 isnull(l.cltcode, '') cltcode, isnull(l.acname, '') acname, l.drcr,  Cramt = (          
  
   CASE           
  
    WHEN upper(l.drcr) = 'C'          
  
     THEN l.vamt          
  
    ELSE l.vamt*-1          
  
    END              
  
   ), treldt = isnull(Convert(datetime,convert(VARCHAR, L1.reldt, 103),103), '')  
  
 INTO #BCURFOreco  
  
 FROM ANGELCOMMODITY.accountCURBFO.dbo.ledger l(NOLOCK)          
  
 LEFT OUTER JOIN ANGELCOMMODITY.accountCURBFO.dbo.ledger1 L1(NOLOCK)          
  
  ON l.vtyp = l1.vtyp          
  
   AND l.booktype = l1.booktype          
  
   AND l.vno = l1.vno          
  
   AND l.lno = l1.lno  
  
 WHERE   
  
    l.cltcode >= 'a'          
  
  AND l.cltcode <= 'ZZZZZ99999'          
  
AND l.drcr in ('C','D')          
  
  AND l.vdt>= @fromdate and  l.vdt<=@todate +' 23:59' and  
  
 l.vtyp in (2,17)          
  
  AND  ( l1.reldt >= @TODATE + 1     or l1.RELDT ='')   and edt <=@todate  + ' 23:59'  
  
  
  
  
  
select cltcode,VDT,treldt,Cramt=SUM(Cramt) into #BCURFOreco_final from #BCURFOreco group by cltcode,VDT,treldt  
  
  
  
  
  
  
  
  
  
  
  
  
  
/**********************************************/  
  
  
  
select cltcode,vdt,treldt,cramt=sum(cramt) into #unrecocredit from   
  
(select * from  #nsecmreco_final   

  
union all  
  
select * from  #bsecmreco_final
  
  
union all  
  
select * from  #nseforeco_final  
  
union all  
  
select * from  #nsxreco_final  
  
union all  
  
select * from  #mcdreco_final  
  
union all  
  
select * from  #mcxreco_final  
  
union all  
  
select * from  #nCDreco_final  
  
union all  
  
select * from  #BFOreco_final  
  
union all  
  
select * from  #BCURFOreco_final  
  
  
  
  
  
)x  
  
group by cltcode,vdt,treldt  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
-------- pAYMENT   
  
  
  
/*NSECM*/   
  
 SELECT   l.vtyp, l.booktype, l.vno, vdt,   
  
 tdate = Convert(datetime,convert(VARCHAR, l.vdt, 103),103), isnull(L1.ddno, '') ddno,   
  
 isnull(l.cltcode, '') cltcode, isnull(l.acname, '') acname, l.drcr,  Cramt = (          
  
   CASE           
  
    WHEN upper(l.drcr) = 'C'          
  
     THEN l.vamt          
  
    ELSE l.vamt*-1          
  
    END          
  
   ), treldt = isnull(Convert(datetime,convert(VARCHAR, L1.reldt, 103),103), '')  
  
 INTO #nsecmrecoPAY  
  
 FROM account.dbo.ledger l(NOLOCK)          
  
 LEFT OUTER JOIN account.dbo.LEDGER1 L1(NOLOCK)          
  
  ON l.vtyp = l1.vtyp          
  
   AND l.booktype = l1.booktype          
  
   AND l.vno = l1.vno          
  
   AND l.lno = l1.lno  
  
 WHERE   
  
    l.cltcode >= 'a'          
  
  AND l.cltcode <= 'ZZZZZ99999'          
  
  AND l.drcr in ('C','D')  
  
  AND l.vdt>= @FROMDATE and  l.vdt<=@todate  + ' 23:59' and  
  
 l.vtyp in (3)          
  
  AND  ( l1.reldt >= @TODATE +1    or l1.RELDT ='')   and edt <=@todate  + ' 23:59'  
  
  /*  
  
  and l.cltcode='DELL4132' and l.vdt='2016-03-22 00:00:00.000'    
  
  */  
  
  
  
select cltcode,VDT,treldt,Cramt=SUM(Cramt) into #nsecmrecoPAY_final from #nsecmrecoPAY group by cltcode,VDT,treldt  
  
  
  
/**********************************************/  
  
  
  
/**********************************************/  
  
  
  
  
  
   
  
/*BSECM*/   
  
 SELECT   l.vtyp, l.booktype, l.vno, vdt,   
  
 tdate = Convert(datetime,convert(VARCHAR, l.vdt, 103),103), isnull(L1.ddno, '') ddno,   
  
 isnull(l.cltcode, '') cltcode, isnull(l.acname, '') acname, l.drcr,  Cramt = (          
  
   CASE           
  
    WHEN upper(l.drcr) = 'C'          
  
     THEN l.vamt          
  
    ELSE l.vamt*-1          
  
    END                 
  
   ), treldt = isnull(Convert(datetime,convert(VARCHAR, L1.reldt, 103),103), '')  
  
 INTO #bsecmrecoPAY  
  
 FROM anand.account_ab.dbo.ledger l(NOLOCK)          
  
 LEFT OUTER JOIN anand.account_ab.dbo.LEDGER1 L1(NOLOCK)          
  
  ON l.vtyp = l1.vtyp          
  
   AND l.booktype = l1.booktype          
  
   AND l.vno = l1.vno          
  
   AND l.lno = l1.lno  
  
 WHERE   
  
    l.cltcode >= 'a'          
  
  AND l.cltcode <= 'ZZZZZ99999'          
  
  AND l.drcr in ('C','D')        
  
  AND l.vdt>= @FROMDATE and  l.vdt<=@todate  + ' 23:59' and  
  
 l.vtyp in (3)          
  
  AND  ( l1.reldt >= @TODATE +1    or l1.RELDT ='')   and edt <=@todate  + ' 23:59'  
  
  
  
  
  
select cltcode,VDT,treldt,Cramt=SUM(Cramt) into #bsecmrecoPAY_final from #bsecmrecoPAY group by cltcode,VDT,treldt  
  
  
  
/**********************************************/  
  
  
  
  
  
   
  
/*NSEFO*/   
  
 SELECT   l.vtyp, l.booktype, l.vno, vdt,   
  
 tdate = Convert(datetime,convert(VARCHAR, l.vdt, 103),103), isnull(L1.ddno, '') ddno,   
  
 isnull(l.cltcode, '') cltcode, isnull(l.acname, '') acname, l.drcr,  Cramt = (          
  
   CASE           
  
    WHEN upper(l.drcr) = 'C'          
  
     THEN l.vamt          
  
    ELSE l.vamt*-1          
  
    END                
  
   ), treldt = isnull(Convert(datetime,convert(VARCHAR, L1.reldt, 103),103), '')  
  
 INTO #nseforecoPAY  
  
 FROM angelfo.accountfo.dbo.ledger l(NOLOCK)          
  
 LEFT OUTER JOIN angelfo.accountfo.dbo.LEDGER1 L1(NOLOCK)          
  
  ON l.vtyp = l1.vtyp          
  
   AND l.booktype = l1.booktype          
  
   AND l.vno = l1.vno          
  
   AND l.lno = l1.lno  
  
 WHERE   
  
    l.cltcode >= 'a'          
  
  AND l.cltcode <= 'ZZZZZ99999'          
  
 AND l.drcr in ('C','D')         
  
  AND l.vdt>= @FROMDATE and  l.vdt<=@todate  + ' 23:59' and  
  
 l.vtyp in (3)          
  
  AND  ( l1.reldt >= @TODATE +1    or l1.RELDT ='')  and edt <=@todate  + ' 23:59'   
  
  
  
  
  
select cltcode,VDT,treldt,Cramt=SUM(Cramt) into #nseforecoPAY_final from #nseforecoPAY group by cltcode,VDT,treldt  
  
  
  
/**********************************************/  
  
  
  
  
  
/*NSX*/   
  
 SELECT   l.vtyp, l.booktype, l.vno, vdt,   
  
 tdate = Convert(datetime,convert(VARCHAR, l.vdt, 103),103), isnull(L1.ddno, '') ddno,   
  
 isnull(l.cltcode, '') cltcode, isnull(l.acname, '') acname, l.drcr,  Cramt = (          
  
   CASE           
  
    WHEN upper(l.drcr) = 'C'          
  
     THEN l.vamt          
  
    ELSE l.vamt*-1          
  
    END              
  
   ), treldt = isnull(Convert(datetime,convert(VARCHAR, L1.reldt, 103),103), '')  
  
 INTO #nsxrecoPAY  
  
 FROM angelfo.accountcurfo.dbo.ledger l(NOLOCK)          
  
 LEFT OUTER JOIN angelfo.accountcurfo.dbo.LEDGER1 L1(NOLOCK)          
  
  ON l.vtyp = l1.vtyp          
  
   AND l.booktype = l1.booktype          
  
   AND l.vno = l1.vno          
  
   AND l.lno = l1.lno  
  
 WHERE   
  
    l.cltcode >= 'a'          
  
  AND l.cltcode <= 'ZZZZZ99999'          
  
AND l.drcr in ('C','D')          
  
  AND l.vdt>= @FROMDATE and  l.vdt<=@todate  + ' 23:59' and  
  
 l.vtyp in (3)          
  
  AND  ( l1.reldt >= @TODATE +1    or l1.RELDT ='')   and edt <=@todate  + ' 23:59'  
  
  
  
  
  
select cltcode,VDT,treldt,Cramt=SUM(Cramt) into #nsxrecoPAY_final from #nsxrecoPAY group by cltcode,VDT,treldt  
  
  
  
/**********************************************/  
  
  
  
  
  
  
  
  
  
/*MCD*/   
  
 SELECT   l.vtyp, l.booktype, l.vno, vdt,   
  
 tdate = Convert(datetime,convert(VARCHAR, l.vdt, 103),103), isnull(L1.ddno, '') ddno,   
  
 isnull(l.cltcode, '') cltcode, isnull(l.acname, '') acname, l.drcr,  Cramt = (          
  
   CASE           
  
    WHEN upper(l.drcr) = 'C'          
  
     THEN l.vamt          
  
    ELSE l.vamt*-1          
  
    END               
  
   ), treldt = isnull(Convert(datetime,convert(VARCHAR, L1.reldt, 103),103), '')  
  
 INTO #mcdrecoPAY  
  
 FROM ANGELCOMMODITY.accountmcdxcds.dbo.ledger l(NOLOCK)          
  
 LEFT OUTER JOIN ANGELCOMMODITY.accountmcdxcds.dbo.LEDGER1 L1(NOLOCK)          
  
  ON l.vtyp = l1.vtyp          
  
   AND l.booktype = l1.booktype          
  
   AND l.vno = l1.vno          
  
   AND l.lno = l1.lno  
  
 WHERE   
  
    l.cltcode >= 'a'          
  
  AND l.cltcode <= 'ZZZZZ99999'          
  
  AND l.drcr in ('C','D')           
  
  AND l.vdt>= @FROMDATE and  l.vdt<=@todate  + ' 23:59' and  
  
 l.vtyp in (3)          
  
  AND  ( l1.reldt >= @TODATE +1    or l1.RELDT ='')  
   and edt <=@todate  + ' 23:59'  
  
  
  
  
select cltcode,VDT,treldt,Cramt=SUM(Cramt) into #mcdrecoPAY_final from #mcdrecoPAY group by cltcode,VDT,treldt  
  
  
  
/**********************************************/  
  
/*mcx*/   
  
 SELECT   l.vtyp, l.booktype, l.vno, vdt,   
  
 tdate = Convert(datetime,convert(VARCHAR, l.vdt, 103),103), isnull(L1.ddno, '') ddno,   
  
 isnull(l.cltcode, '') cltcode, isnull(l.acname, '') acname, l.drcr,  Cramt = (          
  
   CASE           
  
    WHEN upper(l.drcr) = 'C'          
  
     THEN l.vamt          
  
    ELSE l.vamt*-1          
  
    END               
  
   ), treldt = isnull(Convert(datetime,convert(VARCHAR, L1.reldt, 103),103), '')  
  
 INTO #mcxrecoPAY  
  
 FROM ANGELCOMMODITY.accountmcdx.dbo.ledger l(NOLOCK)          
  
 LEFT OUTER JOIN ANGELCOMMODITY.accountmcdx.dbo.LEDGER1 L1(NOLOCK)          
  
  ON l.vtyp = l1.vtyp          
  
   AND l.booktype = l1.booktype          
  
   AND l.vno = l1.vno          
  
   AND l.lno = l1.lno  
  
 WHERE   
  
    l.cltcode >= 'a'          
  
  AND l.cltcode <= 'ZZZZZ99999'          
  
  AND l.drcr in ('C','D')           
  
  AND l.vdt>= @FROMDATE and  l.vdt<=@todate  + ' 23:59' and  
  
 l.vtyp in (3)          
  
  AND  ( l1.reldt >= @TODATE +1    or l1.RELDT ='')   and edt <=@todate  + ' 23:59'  
  
  
  
  
  
select cltcode,VDT,treldt,Cramt=SUM(Cramt) into #mcxrecoPAY_final from #mcxrecoPAY group by cltcode,VDT,treldt  
  
  
  
/******************************************************/  
  
/*mcx*/   
  
 SELECT   l.vtyp, l.booktype, l.vno, vdt,   
  
 tdate = Convert(datetime,convert(VARCHAR, l.vdt, 103),103), isnull(L1.ddno, '') ddno,   
  
 isnull(l.cltcode, '') cltcode, isnull(l.acname, '') acname, l.drcr,  Cramt = (          
  
   CASE           
  
    WHEN upper(l.drcr) = 'C'          
  
     THEN l.vamt          
  
    ELSE l.vamt*-1          
  
    END               
  
   ), treldt = isnull(Convert(datetime,convert(VARCHAR, L1.reldt, 103),103), '')  
  
 INTO #ncxrecoPAY  
  
 FROM ANGELCOMMODITY.accountncdx.dbo.ledger l(NOLOCK)          
  
 LEFT OUTER JOIN ANGELCOMMODITY.accountncdx.dbo.LEDGER1 L1(NOLOCK)          
  
  ON l.vtyp = l1.vtyp          
  
   AND l.booktype = l1.booktype          
  
   AND l.vno = l1.vno          
  
   AND l.lno = l1.lno  
  
 WHERE   
  
    l.cltcode >= 'a'          
  
  AND l.cltcode <= 'ZZZZZ99999'          
  
  AND l.drcr in ('C','D')           
  
  AND l.vdt>= @FROMDATE and  l.vdt<=@todate  + ' 23:59' and  
  
 l.vtyp in (3)          
  
  AND  ( l1.reldt >= @TODATE +1    or l1.RELDT ='')   and edt <=@todate  + ' 23:59'  
  
  
  
  
  
select cltcode,VDT,treldt,Cramt=SUM(Cramt) into #ncxrecoPAY_final from #ncxrecoPAY group by cltcode,VDT,treldt  
  
  
  
----------  
  
/*BSEFO*/   
  
 SELECT   l.vtyp, l.booktype, l.vno, vdt,   
  
 tdate = Convert(datetime,convert(VARCHAR, l.vdt, 103),103), isnull(L1.ddno, '') ddno,   
  
 isnull(l.cltcode, '') cltcode, isnull(l.acname, '') acname, l.drcr,  Cramt = (          
  
   CASE           
  
    WHEN upper(l.drcr) = 'C'          
  
     THEN l.vamt          
  
    ELSE l.vamt*-1          
  
    END               
  
   ), treldt = isnull(Convert(datetime,convert(VARCHAR, L1.reldt, 103),103), '')  
  
 INTO #BSEFOrecoPAY  
  
 FROM ANGELCOMMODITY.accountBFO.dbo.ledger l(NOLOCK)          
  
 LEFT OUTER JOIN ANGELCOMMODITY.accountBFO.dbo.LEDGER1 L1(NOLOCK)          
  
  ON l.vtyp = l1.vtyp          
  
   AND l.booktype = l1.booktype          
  
   AND l.vno = l1.vno          
  
   AND l.lno = l1.lno  
  
 WHERE   
  
    l.cltcode >= 'a'          
  
  AND l.cltcode <= 'ZZZZZ99999'          
  
  AND l.drcr in ('C','D')           
  
  AND l.vdt>= @FROMDATE and  l.vdt<=@todate  + ' 23:59' and  
  
 l.vtyp in (3)          
  
  AND  ( l1.reldt >= @TODATE +1    or l1.RELDT ='')   and edt <=@todate  + ' 23:59'  
  
  
  
  
  
select cltcode,VDT,treldt,Cramt=SUM(Cramt) into #BSEFOrecoPAY_final from #BSEFOrecoPAY group by cltcode,VDT,treldt  
  
  
  
/*BSX*/   
  
 SELECT   l.vtyp, l.booktype, l.vno, vdt,   
  
 tdate = Convert(datetime,convert(VARCHAR, l.vdt, 103),103), isnull(L1.ddno, '') ddno,   
  
 isnull(l.cltcode, '') cltcode, isnull(l.acname, '') acname, l.drcr,  Cramt = (          
  
   CASE           
  
    WHEN upper(l.drcr) = 'C'          
  
     THEN l.vamt          
  
    ELSE l.vamt*-1          
  
    END               
  
   ), treldt = isnull(Convert(datetime,convert(VARCHAR, L1.reldt, 103),103), '')  
  
 INTO #BSXRecoPAY  
  
 FROM ANGELCOMMODITY.accountCURBFO.dbo.ledger l(NOLOCK)          
  
 LEFT OUTER JOIN ANGELCOMMODITY.accountCURBFO.dbo.LEDGER1 L1(NOLOCK)          
  
  ON l.vtyp = l1.vtyp          
  
   AND l.booktype = l1.booktype          
  
   AND l.vno = l1.vno          
  
   AND l.lno = l1.lno  
  
 WHERE   
  
    l.cltcode >= 'a'          
  
  AND l.cltcode <= 'ZZZZZ99999'          
  
  AND l.drcr in ('C','D')           
  
  AND l.vdt>= @FROMDATE and  l.vdt<=@todate  + ' 23:59' and  
  
 l.vtyp in (3)          
  
  AND  ( l1.reldt >= @TODATE +1    or l1.RELDT ='')   and edt <=@todate  + ' 23:59'  
  
  
  
  
  
select cltcode,VDT,treldt,Cramt=SUM(Cramt) into #BSXRecoPAY_final from #BSXRecoPAY group by cltcode,VDT,treldt  
  
  
  
  
  
select cltcode,vdt,treldt,cramt=sum(cramt) into #unrecoDEBIT from   
  
(select * from  #nsecmrecoPAY_final   

  
union all  
  
select * from  #bsecmrecoPAY_final  
  
union all  
  
select * from  #nseforecoPAY_final  
  
union all  
  
select * from  #nsxrecoPAY_final  
  
union all  
  
select * from  #mcdrecoPAY_final  
  
UNION all   
  
select * from #mcxrecoPAY_final  
  
UNION all   
  
select * from #ncxrecoPAY_final  
  
UNION all   
  
select * from #BSEFOrecoPAY_final  
  
UNION all   
  
select * from #BSXRecoPAY_final  
  
  
  
)x  
  
group by cltcode,vdt,treldt  
  
  
  
  
  
SELECT CLTCODE,SUM(CRAMT) DRMAT INTO #CR FROM #unrecocredit GROUP BY CLTCODE  
  
  
  
SELECT CLTCODE,SUM(CRAMT) DRMAT INTO #DR FROM #unrecoDEBIT  GROUP BY CLTCODE  
  
  
  
   
  
  
  
--UPDATE #CC SET UNRECO_CREDIT=0,UNRECO_DEBIT=0,NSEFO_MARGIN=0,NSX_MARGIN=0,NSE_MARGIN=0,BSE_MARGIN=0  
  
  
  
UPDATE #CC SET UNRECO_CREDIT =DRMAT FROM #CR WHERE #CR.CLTCODE=#CC.CLTCODE   
  
UPDATE #CC SET UNRECO_DEBIT =DRMAT FROM #DR WHERE #DR.CLTCODE=#CC.CLTCODE   
  
  
  
SELECT PARTY_CODE,SUM(initialmargin+MTMMARGIN+ADDMARGIN+PREMIUM_MARGIN) MARGIN ,SUM(NONCASH_COLL)  NONCASH_COLL,SUM(CASH_COLL)  CASH_COLL   
  
 INTO #FOMARGIN12 FROM ANGELFO.NSEFO.DBO.TBL_CLIENTMARGIN WHERE MARGINDATE =@TODATE   
  
GROUP BY PARTY_CODE  
  
   
  
 SELECT PARTY_CODE,SUM(initialmargin+MTMMARGIN+ADDMARGIN+PREMIUM_MARGIN) MARGIN,SUM(NONCASH_COLL)  NONCASH_COLL,SUM(CASH_COLL)  CASH_COLL   
  
 INTO #CURMARGIN12 FROM ANGELFO.NSECURFO.DBO.TBL_CLIENTMARGIN WHERE MARGINDATE =@TODATE  
  
GROUP BY PARTY_CODE  
  
  
  
SELECT PARTY_CODE,SUM(initialmargin+ADDMARGIN+PREMIUM_MARGIN) MARGIN,SUM(NONCASH_COLL)  NONCASH_COLL,SUM(CASH_COLL)  CASH_COLL  INTO #mcxMARGIN   
  
FROM ANGELCOMMODITY.MCDX.DBO.TBL_CLIENTMARGIN WHERE MARGINDATE =@TODATE   
  
GROUP BY PARTY_CODE  
  
   
  
 SELECT PARTY_CODE,SUM(initialmargin+ADDMARGIN+PREMIUM_MARGIN) MARGIN,SUM(NONCASH_COLL)  NONCASH_COLL,SUM(CASH_COLL)  CASH_COLL  INTO #NCXMARGIN   
  
 FROM ANGELCOMMODITY.NCDX.DBO.TBL_CLIENTMARGIN WHERE MARGINDATE =@TODATE  
  
GROUP BY PARTY_CODE  
  
  
  
  
  
 SELECT PARTY_CODE,SUM(initialmargin+ADDMARGIN) MARGIN,SUM(NONCASH_COLL)  NONCASH_COLL,SUM(CASH_COLL)  CASH_COLL INTO #BSEFOMARGIN   
  
 FROM ANGELCOMMODITY.BSEFO.DBO.TBL_CLIENTMARGIN WHERE MARGINDATE =@TODATE  
  
GROUP BY PARTY_CODE  
  
  
  
 SELECT PARTY_CODE,SUM(initialmargin+ADDMARGIN+PREMIUM_MARGIN) MARGIN,SUM(NONCASH_COLL)  NONCASH_COLL,SUM(CASH_COLL)  CASH_COLL INTO #BSXMARGIN   
  
 FROM ANGELCOMMODITY.BSECURFO.DBO.TBL_CLIENTMARGIN WHERE MARGINDATE =@TODATE  
  
GROUP BY PARTY_CODE  
  
  
  
  
  
   
  
SELECT PARTY_CODE,SUM(VARAMT +(CASE WHEN MTOM >0 THEN 0 ELSE MTOM*-1 END))  MARGIN INTO #NSE1 FROM (  
  
SELECT PARTY_CODE,SETT_NO,SUM(VARAMT)VARAMT,SUM(MTOM)MTOM   
  
FROM MSAJAG.DBO.TBL_MG02 WHERE MARGIN_DATE =@TODATE AND Rec_Type ='10' ---AND PARTY_CODE ='A100219'    
  
GROUP BY PARTY_CODE,SETT_NO)A  
  
GROUP BY PARTY_CODE  
  
   
  
SELECT PARTY_CODE ,SUM(VARAMT+ELM) MARGIN INTO #BSE FROM ANAND.BSEDB_AB.DBO.TBL_MG02 WHERE MARGIN_DATE =@TODATE GROUP BY PARTY_CODE  
  
  
  
  
  
  
  
  
  
  
  
UPDATE #CC SET NSEFO_MARGIN =MARGIN,FO_NON_CASH= NONCASH_COLL ,FO_CASH=CASH_COLL FROM #FOMARGIN12 WHERE #FOMARGIN12.PARTY_CODE=#CC.CLTCODE   
  
UPDATE #CC SET NSX_MARGIN =MARGIN ,CUR_NON_CASH = NONCASH_COLL,CUR_CASH =CASH_COLL FROM #CURMARGIN12 WHERE #CURMARGIN12.PARTY_CODE=#CC.CLTCODE   
  
  
  
UPDATE #CC SET MCX_MARGIN =MARGIN,MCX_NON_CASH= NONCASH_COLL ,MCX_CASH=CASH_COLL FROM #mcxMARGIN WHERE #mcxMARGIN.PARTY_CODE=#CC.CLTCODE   
  
UPDATE #CC SET NCX_MARGIN =MARGIN ,NCX_NON_CASH = NONCASH_COLL,NCX_CASH =CASH_COLL FROM #NCXMARGIN WHERE #NCXMARGIN.PARTY_CODE=#CC.CLTCODE   
  
   
  
UPDATE #CC SET BSEFO_MARGIN =MARGIN,BSEFO_NON_CASH= NONCASH_COLL ,BSEFO_CASH=CASH_COLL FROM #BSEFOMARGIN WHERE #BSEFOMARGIN.PARTY_CODE=#CC.CLTCODE   
  
UPDATE #CC SET BSX_MARGIN =MARGIN ,BSX_NON_CASH = NONCASH_COLL,BSX_CASH =CASH_COLL FROM #BSXMARGIN WHERE #BSXMARGIN.PARTY_CODE=#CC.CLTCODE    
  
  
  
  
  
UPDATE #CC SET NSE_MARGIN =MARGIN FROM #NSE1 WHERE #NSE1.PARTY_CODE=#CC.CLTCODE   
  
UPDATE #CC SET BSE_MARGIN =MARGIN FROM #BSE WHERE #BSE.PARTY_CODE=#CC.CLTCODE   
  
  
  
   
  
  
  
   
  
 DELETE FROM #CC  
  
 WHERE Balance =0.00 AND  
  
 UNRECO_CREDIT=0.00 AND UNRECO_DEBIT=0.00 AND   
  
 NSEFO_MARGIN=0.00 AND NSX_MARGIN=0.00 AND   
  
 NSE_MARGIN=0.00 AND   
  
 BSE_MARGIN=0.00 AND MCX_MARGIN=0.00 AND   
  
 NCX_MARGIN=0.00 AND   
  
 FO_NON_CASH=0.00 AND   
  
 CUR_NON_CASH=0.00 AND   
  
 MCX_NON_CASH=0.00 AND   
  
 NCX_NON_CASH=0.00 AND   
  
 FO_CASH=0.00 AND   
  
 CUR_CASH=0.00 AND   
  
 MCX_CASH=0.00 AND NCX_CASH=0.00  AND  
  
 BSEFO_CASH=0.00 AND BSX_CASH=0.00    
  
  
  
  
  
  SELECT a.* FROM #CC a,acmast b where a.cltcode=b.cltcode and accat=4 AND A.CLTCODE='A100077' ORDER BY cltcode

GO
