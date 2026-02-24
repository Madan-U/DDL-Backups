-- Object: PROCEDURE dbo.acc_PrintReconcile
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------



    
CREATE PROCEDURE  [dbo].[acc_PrintReconcile]                      
@code varchar(10),                    
@reporttype varchar(10),                    
@tdate  datetime,                    
@fdate  datetime                    
AS                    
    --return 0      
			  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED               
                  
if upper(@reporttype) = 'STATEMENT'                    
begin                    
/*set transaction isolation level read uncommitted                  
                
select distinct vtyp, booktype, vno, lno into #tblbankreco from ledger where cltcode = @code           
        
CREATE CLUSTERED        
  INDEX [Partyvdt] ON [dbo].[#tblbankreco] ([vno], [vtyp], [BookType])        
WITH        
    FILLFACTOR = 90        
ON [PRIMARY]        
        
select l.* Into #Ledger        
From Ledger L, #tblbankreco T        
Where L.VNo = T.Vno         
And L.Vtyp = T.Vtyp        
And L.BookType = T.BookType        
--And L.Lno = T.LNo        
        
CREATE CLUSTERED        
  INDEX [Partyvdt] ON [dbo].[#Ledger] ([vno], [vtyp], [BookType], [LNO])        
WITH        
    FILLFACTOR = 90        
ON [PRIMARY]        
        
select l.* Into #Ledger1        
From Ledger1 L, #tblbankreco T        
Where L.VNo = T.Vno         
And L.Vtyp = T.Vtyp        
And L.BookType = T.BookType        
        
CREATE CLUSTERED        
  INDEX [Partyvdt] ON [dbo].[#Ledger1] ([vno], [vtyp], [BookType], [LNO])        
WITH        
    FILLFACTOR = 90        
ON [PRIMARY]        
                
 select l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,                     
 isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then relamt  else 0 end ),                    
 Cramt= (case when upper(l.drcr) = 'C' then relamt else 0 end ),                     
 treldt=isnull(convert(varchar, reldt , 103),''), l1.refno                    
 From #Ledger l, #Ledger1 L1 ,                    
 #tblbankreco t                     
 WHERE l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype                     
 and l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno        
 and cltcode <> @code and vdt <=@tdate --and l.vtyp not in ( 16, 17) and l1.clear_mode not in ('C', 'R')                    
 and rtrim(l1.ddno) + convert(varchar,relamt) + convert(varchar(11),dddt,109)             
 not in(select rtrim(ddno) + convert(varchar,relamt) + convert(varchar(11),dddt,109) from #Ledger1 l12, #Ledger l2         
 where l12.vno=l2.vno and l12.vtyp=l2.vtyp                                               
 and l12.booktype=l2.booktype and l12.vtyp='16' and l2.vdt < @tdate and cltcode= @code)                                            
 and (reldt ='1900-01-01 00:00:00.000' or reldt > @tdate )                     
 order by l.drcr, vdt, l.vtyp, l.vno                    
        
 DROP TABLE #tblbankreco        
 DROP TABLE #Ledger        
 DROP TABLE #Ledger1    */    

 CREATE TABLE #LEDGER_BANK
 (
	VNO VARCHAR(12),
	VTYP INT,
	BOOKTYPE VARCHAR(3)
  )

  --SELECT @tdate , CONVERT(DATETIME,CONVERT(VARCHAR(11),@tdate,109) ,103) RETURN
CREATE      
  INDEX [vno] ON [dbo].[#LEDGER_BANK] ([vno], [vtyp], [BookType]  )      
WITH        
    FILLFACTOR = 90        
ON [PRIMARY]    

  INSERT INTO #LEDGER_BANK
  SELECT VNO, VTYP, BOOKTYPE FROM LEDGER L (NOLOCK) WHERE CLTCODE = @code AND VDT>'MAR 31 2021 23:59:59' and  VDT <= @tdate
  --and L.vno in ('202104268075', '202104289454') and L.Vtyp=3 and L.booktype='01' 

  --SELECT * FROM #LEDGER_BANK WHERE VNO = '202100034822' AND VTYP = 16
  
  SELECT * INTO #LED1 FROM LEDGER1 L1 (NOLOCK) WHERE (RELDT ='1900-01-01 00:00:00.000' OR RELDT >  @tdate )    
  AND EXISTS(SELECT VNO FROM #LEDGER_BANK LL WHERE L1.VNO = LL.VNO AND L1.VTYP = LL.VTYP AND L1.BOOKTYPE = LL.BOOKTYPE)
	
	
		SELECT L.VTYP, L.BOOKTYPE, L.VNO, VDT, TDATE=CONVERT(VARCHAR,L.VDT,103), ISNULL(L1.DDNO,'') DDNO, ISNULL(CLTCODE ,'') CLTCODE ,                     
		ISNULL( ACNAME ,'') ACNAME, L.DRCR, DRAMT=(CASE WHEN UPPER(L.DRCR) = 'D' THEN L1.RELAMT  ELSE 0 END ),                    
		CRAMT= (CASE WHEN UPPER(L.DRCR) = 'C' THEN L1.RELAMT ELSE 0 END ),                     
		TRELDT=ISNULL(CONVERT(VARCHAR, L1.RELDT , 103),''), L1.REFNO 
		INTO #LED1FUTURE FROM LEDGER L(NOLOCK) ,LEDGER1 L1(NOLOCK) WHERE L.VNO=L1.VNO
		AND L.VTYP=L1.VTYP
		AND L.BOOKTYPE=L1.BOOKTYPE
		AND L.CLTCODE=@code
		AND RELDT<=@tdate-- CONVERT(DATETIME,CONVERT(VARCHAR(11),@tdate,109) ,103) 
		AND CONVERT(DATETIME,CONVERT(VARCHAR(11),EDT,109) ,103) > RELDT
		AND RELDT<>''
		AND VDT>@TDATE--CONVERT(DATETIME,CONVERT(VARCHAR(11),@TDATE,109) ,103) 
		ORDER BY     
		L.DRCR, VDT, L.VTYP, L.VNO

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
INSERT INTO #LED1FUTURE
SELECT     
 L.VTYP, L.BOOKTYPE, L.VNO, VDT, TDATE=CONVERT(VARCHAR,L.VDT,103), ISNULL(L1.DDNO,'') DDNO, ISNULL(CLTCODE ,'') CLTCODE ,                     
 ISNULL( ACNAME ,'') ACNAME, L.DRCR, DRAMT=(CASE WHEN UPPER(L.DRCR) = 'D' THEN L1.RELAMT  ELSE 0 END ),                    
 CRAMT= (CASE WHEN UPPER(L.DRCR) = 'C' THEN L1.RELAMT ELSE 0 END ),                     
 TRELDT=ISNULL(CONVERT(VARCHAR, L1.RELDT , 103),''), L1.REFNO                    
FROM     
 LEDGER L (NOLOCK),     
 #LED1 L1 ,                    
 #LEDGER_BANK L2   
WHERE     
 L.VTYP = L2.VTYP AND L.VNO= L2.VNO AND L.BOOKTYPE = L2.BOOKTYPE                     
 AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE AND L.VNO = L1.VNO AND L.LNO = L1.LNO  
 AND CLTCODE <> @code    
 AND NOT EXISTS    
  (SELECT L3.DDNO FROM LEDGER1 L3 (NOLOCK), (SELECT VNO, VTYP, BOOKTYPE FROM #LEDGER_BANK WHERE VTYP = 16) L4    
  WHERE L1.DDNO = L3.DDNO 
  AND CONVERT(VARCHAR(11),L1.DDDT,109) = CONVERT(VARCHAR(11),L3.DDDT,109) 
  AND L1.RELAMT = L3.RELAMT 
  AND L1.bnkname = L3.bnkname
  AND L1.BOOKTYPE = L3.BOOKTYPE   
  AND L3.VNO = L4.VNO 
  AND L3.VTYP = L4.VTYP 
  AND L3.BOOKTYPE = L4.BOOKTYPE AND L1.clear_mode = 'C'  
  )   
 AND (L1.RELDT ='1900-01-01 00:00:00.000' OR L1.RELDT >  @tdate )  AND L1.vtyp <> 16
  --and L.vno in ('202104268075', '202104289454') and L.Vtyp=3 and L.booktype='01' 
ORDER BY     
 L.DRCR, VDT, L.VTYP, L.VNO 
 
 SELECT * FROM #LED1FUTURE
 ORDER BY     
 DRCR, VDT, VTYP, VNO 

  DROP TABLE #LED1                     
  DROP TABLE #LEDGER_BANK  
  DROP TABLE #LED1FUTURE   
end                    
else                    
begin                    
        
select distinct vtyp, booktype, vno, lno into #tblbankreco_TMP from ledger where cltcode = @code           
and vdt >= @fdate and vdt <= @tdate         
        
CREATE CLUSTERED        
  INDEX [Partyvdt] ON [dbo].[#tblbankreco_TMP] ([vno], [vtyp], [BookType])        
WITH        
    FILLFACTOR = 90        
ON [PRIMARY]        
        
select l.* Into #Ledger_TMP        
From Ledger L, #tblbankreco_tmp T        
Where L.VNo = T.Vno         
And L.Vtyp = T.Vtyp        
And L.BookType = T.BookType        
        
CREATE CLUSTERED        
  INDEX [Partyvdt] ON [dbo].[#Ledger_TMP] ([vno], [vtyp], [BookType], [LNO])        
WITH        
    FILLFACTOR = 90        
ON [PRIMARY]        
        
select l.* Into #Ledger1_TMP        
From Ledger1 L, #tblbankreco_tmp T        
Where L.VNo = T.Vno         
And L.Vtyp = T.Vtyp        
And L.BookType = T.BookType        
        
CREATE CLUSTERED        
  INDEX [Partyvdt] ON [dbo].[#Ledger1_TMP] ([vno], [vtyp], [BookType], [LNO])        
WITH        
    FILLFACTOR = 90        
ON [PRIMARY]        
        
 select l.vtyp, l.booktype, l.vno, vdt, tdate=convert(varchar,l.vdt,103), isnull(ddno,'') ddno, isnull(cltcode ,'') cltcode ,                     
 isnull( acname ,'') acname, l.drcr, Dramt=(case when upper(l.drcr) = 'D' then relamt  else 0 end ),                    
 Cramt= (case when upper(l.drcr) = 'C' then relamt else 0 end ),                     
 treldt=isnull(convert(varchar, reldt , 103),''), l1.refno                    
 From #Ledger_TMP l, #Ledger1_TMP L1, #tblbankreco_TMP T        
 WHERE l.vtyp = t.vtyp and l.vno= t.vno and l.booktype = t.booktype                     
 AND l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno        
 and cltcode <> @code and vdt >= @fdate and vdt <= @tdate                    
 order by l.drcr, vdt, l.vtyp, l.vno        
        
DROP TABLE #tblbankreco_TMP        
DROP TABLE #Ledger_TMP        
DROP TABLE #Ledger1_TMP        
        
end

GO
