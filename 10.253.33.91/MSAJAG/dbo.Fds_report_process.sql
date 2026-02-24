-- Object: PROCEDURE dbo.Fds_report_process
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc [dbo].[Fds_report_process] 
as

DECLARE @FROMDATE DATETIME,@TODATE DATETIME 
 

 SELECT  @FROMDATE =sdtcur  FROM ACCOUNT.DBO.parameter WHERE CONVERT(VARCHAR(11),GETDATE()-1,120) BETWEEN sdtcur AND ldtcur
 SET @TODATE =CONVERT(VARCHAR(11),GETDATE()-1,120) 
 PRINT @FROMDATE 
 PRINT @TODATE 

select PARTY_CODE,SCRIP_CD,c.series,ISIN,INTRA_DAY_PNL=SUM(PAMTTRD-SAMTTRD),sum(PAMTDEL-SAMTDEL)as delamt,sum(pqtydel-sqtydel) as netdel,DUMMY5 into #Nse
from cmbillvalan C with(nolock) ,SETT_MST S
where S.START_DATE >=@FROMDATE  AND C.SETT_NO=S.SETT_NO AND C.SETT_TYPE =S.SETT_TYPE 
and S.START_DATE  <= @TODATE + ' 23:59' 
GROUP BY PARTY_CODE,SCRIP_CD,ISIN,DUMMY5,c.series

select PARTY_CODE,SCRIP_CD,c.series,ISIN,INTRA_DAY_PNL=SUM(PAMTTRD-SAMTTRD),sum(PAMTDEL-SAMTDEL)as delamt,sum(pqtydel-sqtydel) as netdel,DUMMY5
into #Bse from AngelBSECM.bsedb_ab.dbo.cmbillvalan c where sauda_date >=@FROMDATE 
and sauda_date <= @TODATE + ' 23:59' 
GROUP BY PARTY_CODE,SCRIP_CD,ISIN,DUMMY5,c.series

-----------------update ISIN

select * into #isin from angeldemat.msajag.dbo.multiisin
select * into #isinb from angeldemat.bsedb.dbo.multiisin

update n set n.isin=s.isin  from #nse n
inner join #isin s
on s.scrip_cd=n.scrip_cd
and s.series=n.series
where n.isin=''

update n set n.isin=s.isin  from #bse n
inner join #isinb s
on s.scrip_cd=n.scrip_cd
and s.series=n.series
where n.isin=''

select party_code,sum(INTRA_DAY_PNL) as trdpnl  into #intrapnl
from (select * from #nse
union all
select * from #bse
)a
group by party_code
 
select PARTY_CODE,SCRIP_CD,ISIN,sum(delamt)as delamt,sum(netdel) as netdel,DUMMY5 into #delsqrup
from (select * from #nse WHERE netdel =0
union all
select * from #bSE WHERE netdel =0
)a
group by Party_code,SCRIP_CD,ISIN,DUMMY5




select PARTY_CODE,SCRIP_CD,ISIN,sum(delamt)as delamt,sum(netdel) as netdel,DUMMY5
into #neqdel
from #nse 
--where party_code ='a10046'
group by PARTY_CODE,SCRIP_CD,ISIN,DUMMY5
having sum(netdel) <>0


select PARTY_CODE,SCRIP_CD,ISIN,sum(delamt)as delamt,sum(netdel) as netdel,DUMMY5
into #Beqdel
from #Bse 
--where party_code ='a10046'
group by PARTY_CODE,SCRIP_CD,ISIN,DUMMY5
having sum(netdel) <>0



-----------combine



select * into #comdel 
from (select * from #beqdel
union all
select * from #Neqdel
)a


select party_code,isin,sum(delamt) as delamt,sum(netdel) as netdel,dummy5
into  #a
from #comdel 
--where party_code ='a10046' 
group by party_code,isin ,dummy5
having sum(netdel)  =0

select party_code,sum(delamt) as delamt
into #delsqrup1
from #a 
group by party_code




select party_code,isin,sum(delamt) as delamt,sum(netdel) as netdel,dummy5
into  #b
from #comdel 
--where party_code ='a10046' 
group by party_code,isin ,dummy5
having sum(netdel)  <>0


select party_code,sum(delamt) as delamt
into #delinvestment
from #b
group by party_code

 /******************* Trade details Complete **************************************/

 /*** Trade Bills ***********/
select cltcode,sum(case when drcr='D' then vamt else -vamt end ) VAMT,EXCHANGE INTO #BILLS FROM 
ACCOUNT.DBO.LEDGER_ALL WHERE  vtyp ='15' and vdt >=@FROMDATE  
and vdt <= @TODATE + ' 23:59'
group by cltcode,EXCHANGE

    ---- opening Balance ------------
select CLTCODE,SUM(CASE WHEN DRCR ='D' THEN VAMT ELSE -VAMT END) BALANCE INTO #LED1  FROM 
(SELECT CLTCODE,DRCR,VAMT 
from ACCOUNT.DBO.LEDGER_ALL where VDT>=@FROMDATE  AND VTYP='18'  and vdt <= @TODATE + ' 23:59'
UNION ALL
SELECT CLTCODE,DRCR,VAMT 
from MTFTRADE.DBO.LEDGER where VDT>=@FROMDATE AND VTYP='18' and vdt <= @TODATE + ' 23:59'
UNION ALL
SELECT CLTCODE,DRCR,VAMT 
from ABVSCITRUS.ACCOUNTNBFC.DBO.LEDGER where VDT>=@FROMDATE AND VTYP='18' and vdt <= @TODATE + ' 23:59' 

 ) A
GROUP BY  CLTCODE 
HAVING SUM(CASE WHEN DRCR ='D' THEN VAMT ELSE -VAMT END) <> 0
----------------------- Fund Details -------------------------------
 select CLTCODE,SUM(CASE WHEN DRCR ='D' THEN VAMT ELSE -VAMT END) BALANCE INTO #fund  FROM 
(SELECT CLTCODE,DRCR,VAMT 
from ACCOUNT.DBO.LEDGER_ALL where VDT>=@FROMDATE  AND vtyp in ('2','3','17','16') and vdt <= @TODATE + ' 23:59'
UNION ALL
SELECT CLTCODE,DRCR,VAMT 
from MTFTRADE.DBO.LEDGER where VDT>=@FROMDATE AND  vtyp in ('2','3','17','16') and vdt <= @TODATE + ' 23:59'
UNION ALL
SELECT CLTCODE,DRCR,VAMT 
from ABVSCITRUS.ACCOUNTNBFC.DBO.LEDGER where VDT>=@FROMDATE AND  vtyp in ('2','3','17','16') and vdt <= @TODATE + ' 23:59'


 ) A
GROUP BY  CLTCODE 
HAVING SUM(CASE WHEN DRCR ='D' THEN VAMT ELSE -VAMT END) <> 0

------------- Ledger balance as on date----------
select CLTCODE,SUM(CASE WHEN DRCR ='D' THEN VAMT ELSE -VAMT END) BALANCE INTO #CLSOING_BAL  FROM 
(SELECT CLTCODE,DRCR,VAMT 
from ACCOUNT.DBO.LEDGER_ALL where VDT>=@FROMDATE    and vdt <= @TODATE + ' 23:59'
UNION ALL
SELECT CLTCODE,DRCR,VAMT 
from MTFTRADE.DBO.LEDGER where VDT>=@FROMDATE and vdt <= @TODATE + ' 23:59'  
UNION ALL
SELECT CLTCODE,DRCR,VAMT 
from ABVSCITRUS.ACCOUNTNBFC.DBO.LEDGER where VDT>=@FROMDATE and vdt <= @TODATE + ' 23:59'  
 ) A
GROUP BY  CLTCODE 
HAVING SUM(CASE WHEN DRCR ='D' THEN VAMT ELSE -VAMT END) <> 0

/************** Ledger Process Completed*****************/
/********** Starts POOl Holding *************/


 DECLARE @CDATE DATETIME ,@UPD_DATE   DATETIME
 
 SELECT  @CDATE =MAX(effdate)  FROM collateraldetails WHERE effdate  < @FROMDATE  

 SELECT @UPD_DATE = MAX(upd_date) FROM  [CSOKYC-6].history.dbo.rms_holding  WHERE  upd_date >=@CDATE AND UPD_DATE <=@CDATE + '23:59'

 




select   party_code,sum(qty*ISNULL(clsrate,0)) poolValue  into #poolhld 
 from [CSOKYC-6].history.dbo.rms_holding with (nolock) 
WHERE  UPD_DATE=@UPD_DATE
and source <>'DP'
group by party_code 



INSERT INTO #poolhld 
SELECT X.PARTY_CODE, SUM(X.TOTAL)  -- INTO #NBFC_DPID
 from [CSOKYC-6].HISTORY.[dbo].[securityholdingdata_rpt_hist]  X with (nolock) inner join  [CSOKYC-6].GENERAL.DBO.vw_rms_client_vertical y on x.party_code=y.client 
 where EXCHANGE ='NBFC'  and Update_Date >=@CDATE and Update_Date <=@CDATE +' 23:59' 
 GROUP BY X.PARTY_CODE 

 select party_code ,sum(poolvalue) as poolvalue   into #openpool from  #poolhld group  by party_code 

select party_code,sum(qty*ISNULL(clsrate,0)) poolValue  into #poolhldCLSA from [CSOKYC-6].history.dbo.rms_holding with (nolock) 
WHERE  PROCESSDATE >= @TODATE
AND PROCESSDATE < = @TODATE + ' 23:59'
and source <>'DP'
group by party_code 


INSERT INTO #poolhldCLSA
SELECT X.PARTY_CODE, SUM(X.TOTAL)  -- INTO #NBFC_DPID
 from [CSOKYC-6].GENERAL.DBO.securityholdingdata_rpt X with (nolock) inner join  [CSOKYC-6].GENERAL.DBO.vw_rms_client_vertical y on x.party_code=y.client where EXCHANGE ='NBFC'
 GROUP BY X.PARTY_CODE 

  select party_code ,sum(poolvalue) as poolvalue   into #closepool from  #poolhldCLSA group  by party_code 

 /****************End ********************/
 /******* Collateral *************/



select party_code,sum(cl_rate*qty) as COll_value 
into #coll_value_op
from collateraldetails 
where effdate >=@CDATE and effdate <=@CDATE 
group by party_code


select party_code,sum(cl_rate*qty) as COll_value 
 into #coll_value_cls
from collateraldetails 
where effdate >=@TODATE 
and effdate <=@TODATE  +' 23:59'
group by party_code
 

 /*******End Collateral *************/

 /************ DP AUM****************/

 

 SELECT * INTO #HOLD FROM AGMUBODPL3.dmat.DBO.SYNERGY_HOLDING WHERE HLD_HOLD_DATE =@CDATE
 
 SELECT V.* INTO #CLOSIN FROM AGMUBODPL3.dmat.CITRUS_USR.VW_ISIN_RATE_MASTER V,
  (SELECT ISIN,MAX(RATE_DATE) AS RD FROM AGMUBODPL3.dmat.CITRUS_USR.VW_ISIN_RATE_MASTER  WHERE  RATE_DATE <=@CDATE  GROUP BY ISIN ) B
  WHERE  RATE_DATE <=@CDATE AND V.ISIN=B.ISIN AND RD=RATE_DATE

 SELECT HLD_AC_CODE,SUM(HLD_AC_POS*CLOSE_PRICE)VALUE  INTO #VAL  FROM #HOLD H, #CLOSIN WHERE ISIN=HLD_ISIN_CODE  GROUP BY HLD_AC_CODE

SELECT NISE_PARTY_CODE,V.* INTO #OLD FROM #VAL V,AGMUBODPL3.DMAT.DBO.TBL_CLIENT_MASTER T
WHERE HLD_AC_CODE=CLIENT_CODE 
---392340
SELECT * INTO #HOLD1 FROM AGMUBODPL3.dmat.DBO.SYNERGY_HOLDING WHERE HLD_HOLD_DATE =@TODATE
 
 SELECT V.* INTO #CLOSIN1 FROM AGMUBODPL3.dmat.CITRUS_USR.VW_ISIN_RATE_MASTER V,
  (SELECT ISIN,MAX(RATE_DATE) AS RD FROM AGMUBODPL3.dmat.CITRUS_USR.VW_ISIN_RATE_MASTER  WHERE  RATE_DATE <=@TODATE  GROUP BY ISIN ) B
  WHERE  RATE_DATE <=@TODATE  AND V.ISIN=B.ISIN AND RD=RATE_DATE

 SELECT HLD_AC_CODE,SUM(HLD_AC_POS*CLOSE_PRICE)VALUE  INTO #VAL1  FROM #HOLD1 H, #CLOSIN1 WHERE ISIN=HLD_ISIN_CODE  GROUP BY HLD_AC_CODE

SELECT NISE_PARTY_CODE,V.* INTO #current FROM #VAL1 V,AGMUBODPL3.DMAT.DBO.TBL_CLIENT_MASTER T
WHERE HLD_AC_CODE=CLIENT_CODE 
 
SELECT DISTINCT HLD_AC_CODE INTO #FINAL  FROM (
SELECT * FROM #current
UNION 
SELECT * FROM #OLD )A 
 
ALTER TABLE #FINAL
ADD   Current_Value VARCHAR(50)

ALTER TABLE #FINAL
ADD   Old_Value VARCHAR(50)

UPDATE #FINAL SET Old_Value = VALUE
FROM #OLD WHERE #FINAL.HLD_AC_CODE=#OLD.HLD_AC_CODE

UPDATE #FINAL SET Current_Value = VALUE
FROM #current WHERE #FINAL.HLD_AC_CODE=#current.HLD_AC_CODE

SELECT NISE_PARTY_CODE,F.* into #dpaum FROM #FINAL F ,AGMUBODPL3.DMAT.DBO.TBL_CLIENT_MASTER T
WHERE HLD_AC_CODE=CLIENT_CODE 


/********** End  **********/

----------------  Transaction summary---------------
Create Table #Trans
(CL_CODE varchar(10),
 DELAMT MONEY,TRDPNL MONEY,delamt_delsqrup1 MONEY,delsqramt MONEY,foamount MONEY,
 foamount_NSECUR1 MONEY,foamount_MCDX1 MONEY, foamount_NCDX1 MONEY)



 INSERT INTO #Trans (CL_CODE)
 SELECT DISTINCT CLTCODE FROM #BILLS WHERE cltcode >='A00' AND CLTCODE <='ZZZZ' 

  INSERT INTO #Trans (CL_CODE)
 SELECT DISTINCT CLTCODE FROM #BILLS WHERE LEFT(cltcode,2) ='98'


 UPDATE #Trans SET DELAMT =0,TRDPNL=0,delamt_delsqrup1=0,delsqramt=0,foamount=0,foamount_NSECUR1=0,foamount_MCDX1=0,foamount_NCDX1=0

UPDATE #Trans SET delamt=D.delamt  FROM #delinvestment D WHERE #Trans.CL_CODE=d.party_code
UPDATE #Trans SET TRDPNL=D.trdpnl  FROM #intrapnl D WHERE #Trans.CL_CODE=d.party_code
UPDATE #Trans SET delamt_delsqrup1=D.delamt  FROM #delsqrup1 D WHERE #Trans.CL_CODE=d.party_code
UPDATE #Trans SET delsqramt=D.delamt  FROM #delsqrup D WHERE #Trans.CL_CODE=d.party_code
UPDATE #Trans SET foamount=D.VAMT  FROM #BILLS D WHERE #Trans.CL_CODE=d.cltcode  AND EXCHANGE ='NSEFO'
UPDATE #Trans SET foamount_NSECUR1=D.VAMT  FROM #BILLS D WHERE #Trans.CL_CODE=d.cltcode AND EXCHANGE ='NSX'
UPDATE #Trans SET foamount_MCDX1=D.VAMT  FROM #BILLS D WHERE #Trans.CL_CODE=d.cltcode AND EXCHANGE ='MCX'
UPDATE #Trans SET foamount_NCDX1=D.VAMT  FROM #BILLS D WHERE #Trans.CL_CODE=d.cltcode AND EXCHANGE ='NCX'


select party_code,sum(ledger) as Ledger,sum(holding_approved) as holding,sum(imargin)as MArgin,sum(noncash_colleteral) as FOCOlleteral
INTO #test 
from [CSOKYC-6].general.dbo.RMS_DtClFi 
group by party_code

--select party_code,sum(ledger+holding_approved-imargin+noncash_colleteral) as Netavailable
--into #test1
--from [CSOKYC-6].general.dbo.RMS_DtclFi_summ 
--group by party_code


create table #finalbal
(PartyCode Varchar(10) ,
Led_Op_Bal money DEFAULT '0' ,
Pool_HLD money  DEFAULT '0' ,
FO_Collateral money  DEFAULT '0' ,
DP_hold money  DEFAULT '0' ,
delamt money  DEFAULT '0' ,
trdpnl money  DEFAULT '0' ,
delamt_delsqrup1 money  DEFAULT '0' ,
delsqramt money  DEFAULT '0' ,
foamount money  DEFAULT '0' ,
foamount_NSECUR1 money  DEFAULT '0' ,
foamount_MCXCUR1 money  DEFAULT '0' ,
foamount_NCDX1 money DEFAULT '0',
foamount_MCDX1 money  DEFAULT '0' ,
[NET_FUND Recd/Paid] money  DEFAULT '0' ,
Led_CLS_Bal money  DEFAULT '0' ,
Cls_Pool_Hld money  DEFAULT '0' ,
Cls_DP_HLD money  DEFAULT '0' ,
FO_Collateral_new money  DEFAULT '0' ,
[Off Market Value] money  DEFAULT '0' ,
B2C Varchar(12) DEFAULT 'Y'  )


insert into #finalbal (PartyCode)
select distinct party_code from #test

 
 
UPDATE F SET LED_OP_BAL = BALANCE FROM  #finalbal f ,#LED1 l where f.PartyCode =cltcode 

UPDATE F SET Pool_HLD = poolValue FROM  #finalbal f ,#openpool l where f.PartyCode =party_code 
UPDATE F SET Cls_Pool_Hld = poolValue FROM  #finalbal f ,#closepool l where f.PartyCode =party_code 


UPDATE F SET FO_Collateral = COll_value FROM  #finalbal f ,#coll_value_op l where f.PartyCode =party_code 

UPDATE F SET FO_Collateral_new = COll_value FROM  #finalbal f ,#coll_value_cls l where f.PartyCode =party_code 

UPDATE F SET DP_hold = isnull(l.old_value,0)  FROM  #finalbal f ,#dpaum l where f.PartyCode =nise_party_code  

UPDATE F SET Cls_DP_HLD = isnull(l.current_value,0)  FROM  #finalbal f ,#dpaum l where f.PartyCode =nise_party_code 

UPDATE F SET delamt=L.DELAMT,trdpnl =L.TRDPNL ,delamt_delsqrup1=L.delamt_delsqrup1,delsqramt=l.delsqramt,
foamount =L.foamount ,foamount_NSECUR1=L.foamount_NSECUR1 ,foamount_MCDX1=L.foamount_MCDX1,foamount_NCDX1=L.foamount_NCDX1 
FROM  #finalbal f ,#Trans l where f.PartyCode =cl_code   
 
UPDATE F SET Led_CLS_Bal = BALANCE  FROM  #finalbal f ,#CLSOING_BAL l where f.PartyCode =CLTCODE   
UPDATE F SET [NET_FUND Recd/Paid] = BALANCE  FROM  #finalbal f ,#fund l where f.PartyCode =CLTCODE 

UPDATE F SET [NET_FUND Recd/Paid] = BALANCE  FROM  #finalbal f ,#fund l where f.PartyCode =CLTCODE 


UPDATE F SET B2C= l.B2C   FROM  #finalbal f ,INTRANET.risk.dbo.client_details  l where f.PartyCode =cl_code  AND l.B2C ='N'

DELETE FROM FDS_REPORT where MDATE   = @TODATE 
--DELETE FROM FDS_REPORT where MDATE   ='2018-08-07'

INSERT INTO FDS_REPORT 
SELECT *,process_date =GETDATE(),MDATE = @TODATE,'0',0,0    FROM   #finalbal  WHERE B2C ='N'
 
 
-- SELECT  top 100 * FROM FDS_REPORT WHERE MDATE ='2018-08-03' 

update FDS_REPORT  set open_aum = Led_Op_Bal -Pool_HLD-FO_Collateral-DP_hold+[NET_FUND Recd/Paid]
, close_aum =Led_CLS_Bal-Cls_Pool_Hld-Cls_DP_HLD-FO_Collateral_new  where  MDATE = @TODATE   

update FDS_REPORT  set net_value = open_aum-close_aum where  MDATE = @TODATE    
 
 

 --SELECT * FROM FDS_REPORT WHERE  
 --process_date >='2018-08-07'

GO
