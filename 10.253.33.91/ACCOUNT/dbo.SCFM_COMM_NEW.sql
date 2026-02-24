-- Object: PROCEDURE dbo.SCFM_COMM_NEW
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE  PROC [dbo].[SCFM_COMM_NEW] 

(

 @FROMDATE DATETIME,@TODATE DATETIME
 )

 As

       
       
     
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
 
          
           
  select * into #ab from (          

  select * from #mcx          
  union all          
  select * from #ncx  
  )x     
      
      
        
UPDATE  #ab SET CLTCODE =PARENTCODE FROM MSAJAG.DBO.CLIENT_DETAILS C      
WHERE  CLTCODE LIKE '98%' AND CLTCODE=CL_cODE
   
 
      
   create table  #cc
    (cltcode varchar(10),
	 Balance money,UNRECO_CREDIT MONEY,UNRECO_DEBIT MONEY,MCX_MARGIN MONEY
	 ,NCX_MARGIN MONEY,MCX_NON_CASH MONEY,NCX_NON_CASH MONEY,
	 MCX_CASH MONEY,NCX_CASH MONEY  )
    
 
          
           
  insert into   #cc       
 select cltcode,sum(netamt) as Balance,0,0,0,0,0,0,0,0   from #ab where cltcode between 'a' and 'zzzz9999'  group by cltcode          
           
         
        
           
    
          
 --select * from SCFM_FY1516    
 ---------
 

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
  AND  ( l1.reldt >= @TODATE + 1     or l1.RELDT ='')


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
  AND l.vdt>= @fromdate and  l.vdt<=@todate +' 23:59' and
 l.vtyp in (2,17)        
  AND  ( l1.reldt >= @TODATE + 1     or l1.RELDT ='')


select cltcode,VDT,treldt,Cramt=SUM(Cramt) into #nCDreco_final from #nCDreco group by cltcode,VDT,treldt






/**********************************************/

select cltcode,vdt,treldt,cramt=sum(cramt) into #unrecocredit from 
(

select * from  #mcxreco_final
union all
select * from  #nCDreco_final


)x
group by cltcode,vdt,treldt








-------- pAYMENT 


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
  AND  ( l1.reldt >= @TODATE +1    or l1.RELDT ='')


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
  AND  ( l1.reldt >= @TODATE +1    or l1.RELDT ='')


select cltcode,VDT,treldt,Cramt=SUM(Cramt) into #ncxrecoPAY_final from #ncxrecoPAY group by cltcode,VDT,treldt


select cltcode,vdt,treldt,cramt=sum(cramt) into #unrecoDEBIT from 
(
select * from #mcxrecoPAY_final
UNION all 
select * from #ncxrecoPAY_final

)x
group by cltcode,vdt,treldt


SELECT CLTCODE,SUM(CRAMT) DRMAT INTO #CR FROM #unrecocredit GROUP BY CLTCODE

SELECT CLTCODE,SUM(CRAMT) DRMAT INTO #DR FROM #unrecoDEBIT  GROUP BY CLTCODE

 

--UPDATE #CC SET UNRECO_CREDIT=0,UNRECO_DEBIT=0,NSEFO_MARGIN=0,NSX_MARGIN=0,NSE_MARGIN=0,BSE_MARGIN=0

UPDATE #CC SET UNRECO_CREDIT =DRMAT FROM #CR WHERE #CR.CLTCODE=#CC.CLTCODE 
UPDATE #CC SET UNRECO_DEBIT =DRMAT FROM #DR WHERE #DR.CLTCODE=#CC.CLTCODE 



SELECT PARTY_CODE,SUM(initialmargin+ADDMARGIN+PREMIUM_MARGIN) MARGIN,SUM(NONCASH_COLL)  NONCASH_COLL,SUM(CASH_COLL)  CASH_COLL  INTO #mcxMARGIN 
FROM ANGELCOMMODITY.MCDX.DBO.TBL_CLIENTMARGIN WHERE MARGINDATE =@TODATE 
GROUP BY PARTY_CODE
 
 SELECT PARTY_CODE,SUM(initialmargin+ADDMARGIN+PREMIUM_MARGIN) MARGIN,SUM(NONCASH_COLL)  NONCASH_COLL,SUM(CASH_COLL)  CASH_COLL  INTO #NCXMARGIN 
 FROM ANGELCOMMODITY.NCDX.DBO.TBL_CLIENTMARGIN WHERE MARGINDATE =@TODATE
GROUP BY PARTY_CODE


 



UPDATE #CC SET MCX_MARGIN =MARGIN,MCX_NON_CASH= NONCASH_COLL ,MCX_CASH=CASH_COLL FROM #mcxMARGIN WHERE #mcxMARGIN.PARTY_CODE=#CC.CLTCODE 
UPDATE #CC SET NCX_MARGIN =MARGIN ,NCX_NON_CASH = NONCASH_COLL,NCX_CASH =CASH_COLL FROM #NCXMARGIN WHERE #NCXMARGIN.PARTY_CODE=#CC.CLTCODE 
 
 


--DELETE  FROM #CC WHERE BALANCE =0.00 AND UNRECO_CREDIT =0.00 AND UNRECO_DEBIT =0.00
--AND NSEFO_MARGIN =0.00 AND NSX_MARGIN  =0 AND NSE_MARGIN =0.00 AND BSE_MARGIN=0 AND MCX_MARGIN=0.00 AND NCX_MARGIN =0.00
 

-- INSERT INTO #CC
 
-- SELECT PARTY_CODE,0,0,0,MARGIN,0,0,0,0,0,0,0 FROM #FOMARGIN12 WHERE PARTY_CODE NOT IN ( SELECT CLTCODE FROM #CC  )
-- AND MARGIN <>0

--  INSERT INTO #CC
--  SELECT PARTY_CODE,0,0,0,0,MARGIN,0,0,0,0,0,0 FROM #CURMARGIN12 WHERE PARTY_CODE NOT IN ( SELECT CLTCODE FROM #CC  )
-- AND MARGIN <>0

--  INSERT INTO #CC
--  SELECT PARTY_CODE,0,0,0,0,0,MARGIN,0,0,0,0,0 FROM #NSE1 WHERE PARTY_CODE NOT IN ( SELECT CLTCODE FROM #CC  )
-- AND MARGIN <>0

--  INSERT INTO #CC
--  SELECT PARTY_CODE,0,0,0,0,0,0,MARGIN,0,0,0,0 FROM #BSE WHERE PARTY_CODE NOT IN ( SELECT CLTCODE FROM #CC  )
-- AND MARGIN <>0

 
 DELETE FROM #CC
 WHERE Balance =0.00 AND
 UNRECO_CREDIT=0.00 AND UNRECO_DEBIT=0.00 AND 
 
   MCX_MARGIN=0.00 AND 
 NCX_MARGIN=0.00 AND 
 
 MCX_NON_CASH=0.00 AND 
 NCX_NON_CASH=0.00 AND 
 
 MCX_CASH=0.00 AND NCX_CASH=0.00  


 SELECT * FROM #CC

GO
