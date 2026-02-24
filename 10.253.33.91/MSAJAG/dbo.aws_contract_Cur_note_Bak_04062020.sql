-- Object: PROCEDURE dbo.aws_contract_Cur_note_Bak_04062020
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

--aws_contract_cur_note '2020-05-05' --,'2020-04-15'


Create  proc [dbo].[aws_contract_Cur_note_Bak_04062020] (@dt datetime)
as

declare @date varchar(30),@sdt varchar(11),@tdt varchar(11)


select @date= convert(varchar(11),@dt,103)

select @sdt=replace( convert(varchar(12),@dt,107),',','') 
select @tdt=replace( convert(varchar(12),@dt,107),',','') +' 23:59:59'
 

 truncate table Contractnote_curr_Daily
  
insert into  Contractnote_curr_Daily 
EXEC  V2_COMBINED_CONTRACTNOTE_NEW 'broker','broker',@sdt,@sdt,'A00001','zzzz999','','zzzzzzzzzzz','','zzzzzzzzzzz','','99999999','',
  'ALL',0,'ALL','Angel Broking Pvt Ltd.(Erstwhile Angel Broking Ltd.)','CURR'

	

/*
 SELECT DISTINCT A.PARTY_CODE,CONTRACT_HEADER_DET,A.EXCHANGE,A.SEGMENT INTO #TEMP1 
 FROM Contractnote_curr_Daily  A,(
select distinct  PARTY_CODE,EXCHANGE,SEGMENT
from Contractnote_curr_Daily WHERE  SAUDA_DATE =@date AND  CONTRACTNO ='0'
AND PARTY_CODE >='a00' AND PARTY_CODE <='zzzzzz'
and segment ='Futures' and CONTRACTNO ='0' )B
WHERE A.PARTY_CODE=B.PARTY_CODE AND A.EXCHANGE=B.EXCHANGE AND A.SEGMENT=B.SEGMENT 
AND  CONTRACTNO <>'0'

BEGIN TRAN 
UPDATE B SET CONTRACT_HEADER_DET=A.CONTRACT_HEADER_DET FROM  #TEMP1 A ,
Contractnote_curr_Daily B WHERE  SAUDA_DATE =@date and CONTRACTNO ='0'   
and B.segment ='Futures' 
AND  A.PARTY_CODE=B.PARTY_CODE AND A.EXCHANGE=B.EXCHANGE AND A.SEGMENT=B.SEGMENT AND  
a.segment ='Futures'  
COMMIT*/


--select * into cur_bulk_process from cur_bulk_process where 1=2

truncate table cur_bulk_process

 
SELECT * INTO #DELAING_ADDRESS FROM (
SELECT DISTINCT PARTY_CODE ,(CASE WHEN DEALING_ADDRESS='- ' THEN 'G-1, Akruti Trade Centre, Road No. 7,MIDC Marol, Andheri (East),MUMBAI-400093 MAHARASHTRA' ELSE DEALING_ADDRESS END)
 DEALING_ADDRESS,GST_LOCATION,SUB_BROKER,TGST_NO,roW_NUMBER()OVER (PARTITION BY PARTY_CODE ORDER BY PARTY_CODE) AS ROW_NO FROM (
SELECT distinct party_code,ISNULL(LTRIM(RTRIM(Address1)),'')+ ISNULL(LTRIM(RTRIM(Address2)),'')+ isnull(LTRIM(RTRIM(Address3)),'')+isnull(LTRIM(RTRIM(City)),'')+'-'+
isnull(LTRIM(RTRIM(ZIP)),'')+' '+isnull(LTRIM(RTRIM(sTATE)),'')  AS DEALING_ADDRESS,
SOURCESTATE +' ' +DEAL_CLIENT_ADD AS GST_LOCATION ,C.SUB_BROKER,TGST_NO
FROM Contractnote_curr_Daily C  
LEFT OUTER JOIN 
 vwGetSubBrokerDetail_dummY V  with(nolock)
ON  C.Sub_Broker =V.Sub_Broker )A )A
WHERE ROW_NO=1



 SELECT DISTINCT EXCHANGE,SEGMENT,PARTY_CODE,ORDER_NO,SCRIPNAME,SELL_BUY INTO #TEMP12 FROM Contractnote_curr_Daily 

SELECT CD_PARTY_CODE, EXCHANGE='NSX' ,SEGMENT ='FUTURES', CONVERT(VARCHAR(200),CD_SYMBOL) SCRIP_CD ,SELL_FLAG=CONVERT(VARCHAR(10),''), CONVERT(VARCHAR,CD_Order_No) CD_Order_No,
 CD_Tot_BuyQty	+CD_Tot_SellQty  AS TRD_QTY,CD_BUYRATE+CD_SELLRATE AS PRICE,
CD_TOT_TURNOVER TURNOVER ,CONVERT(VARCHAR,CD_TOT_BROK) AS BROKERAGE
INTO #ORDER_WISE
FROM ANGELFO.NSEcurFO.DBO.Charges_Detail   WHERE CD_SAUDA_DATE =@dt  AND CD_ComputationLevel ='O'  AND CD_PARTY_CODE >='A000' AND CD_PARTY_CODE <='ZZZZZ'

UPDATE O SET SCRIP_CD =T.SCRIPNAME,SELL_FLAG =SELL_BUY FROM #ORDER_WISE O,#TEMP12 T
WHERE O.CD_Order_No=ORDER_NO 
AND T.EXCHANGE=O.EXCHANGE AND T.SEGMENT=O.SEGMENT
AND T.PARTY_CODE =O.CD_Party_Code
 
 
  
 INSERT INTO cur_bulk_process
SELECT DISTINCT C.PARTY_CODE,'1' AS SNO,C.PARTY_CODE+'|'+'H'+'|'+C.PARTY_CODE+' ( '+c.branch_cd+'/'+c.sub_broker+' )'+'|'+PARTYNAME+'|'
+replace(C.L_ADDRESS1,'|','')+'|'+replace(isnull(C.L_ADDRESS2,''),'|','')+'|'+replace(isnull(C.L_ADDRESS3,''),'|','')+'|'+C.L_CITY+'|'+C.L_STATE+'-'+C.L_ZIP+'|'+CONTRACTNO_NEW+'|'+C.PAN_GIR_NO+'|'+
--CONVERT(VARCHAR(11),SAUDA_DATE,120) +'|'+email +'|'+mobile_pager +'|'+CLGSTNO AS TEXT ,'','','','',''
CONVERT(VARCHAR(11),SAUDA_DATE,120) +'|'+'shashi.soni@angelbroking.com' +'|'+'9321501694' +'|'+CLGSTNO AS TEXT ,'','','','',''
FROM Contractnote_curr_Daily D,CLIENT_DETAILS C
WHERE SAUDA_DATE =@date  AND C.PARTY_CODE >='a0' AND C.PARTY_CODE <='zzzzz'  
AND D.PARTY_CODE=C.CL_CODE 

 INSERT INTO cur_bulk_process 
SELECT PARTY_CODE,'2' AS SNO,LTRIM(RTRIM(PARTY_CODE))+'|'+'A'+'|'+DEALING_ADDRESS+'|'+GST_LOCATION+'|'+TGST_NO,'','','','','' FROM #DELAING_ADDRESS 

 
  
 INSERT INTO cur_bulk_process 
SELECT PARTY_CODE,'5' AS SNO,LTRIM(RTRIM(PARTY_CODE))+'|'+'D'+'|'+EXCHANGE+'|'+SEGMENT+'|'+CONVERT(VARCHAR,ORDER_NO)+'|'+CONVERT(VARCHAR,ORDER_TIME)+'|'+CONVERT(VARCHAR,TRADE_NO)+'|'+
CONVERT(VARCHAR,TRADE_TIME)
+'|'+CONVERT(VARCHAR(100),SCRIPNAME)+'|'+CONVERT(VARCHAR,SELL_BUY)+'|'+(CONVERT(VARCHAR,QTY)+CONVERT(VARCHAR,' '+TMARK))+'|'+convert( varchar(20), cast( MARKETRATE as decimal(18,4)))+'|'+
convert( varchar(20), cast( BROKERAGE as decimal(18,4)))
+'|'+convert( varchar(20), cast( NETRATE as decimal(18,4)))+'|'+convert( varchar(20), cast( CL_RATE as decimal(18,4)))+'|'+ convert( varchar(20), cast( NETAMOUNT as decimal(18,4)))
+'|'+ISIN+'|'+CONVERT(VARCHAR,SETT_NO)+'-'+CONVERT(VARCHAR,SETTTYPE_DESC)+'|'+CONVERT(VARCHAR,SETT_DATE)+'|'+
CONVERT(VARCHAR,CONTRACTNO) +'|'+CONVERT(VARCHAR,REMARK_DESC)+'|'+CONTRACT_HEADER_DET+'|'+convert( varchar(20), cast( FOREIGN_PRICE as decimal(18,4))), SRNO,EXCHANGE,SEGMENT,CONVERT(VARCHAR(100),SCRIPNAME),CONVERT(VARCHAR,ORDER_TIME)
FROM (
SELECT  dense_rank ()OVER(PARTITION BY PARTY_CODE ORDER BY PARTY_CODE,CONTRACTNO DESC, SCRIPNAME )AS SRNO, PARTY_CODE,EXCHANGE,SEGMENT
,ORDER_NO=(CASE WHEN ORDER_NO ='' AND BFCF_FLAG ='BF_F' THEN 'FUTBF' ELSE ORDER_NO END)
,ORDER_TIME,TRADE_NO,
TRADE_TIME,SCRIPNAME,SELL_BUY,QTY,MARKETRATE,BROKERAGE=Brok,TMARK
,NETRATE,CL_RATE,NETAMOUNT,ISIN,SETT_NO,SETT_DATE,CONTRACTNO ,(CASE WHEN REMARK_DESC ='' THEN '0' ELSE REMARK END) REMARK_DESC,CONTRACT_HEADER_DET,SETTTYPE_DESC ,FOREIGN_PRICE
FROM Contractnote_curr_Daily WITH(NOLOCK) WHERE  PARTY_CODE >='A0' AND PARTY_CODE <='ZZZZZ' AND SCRIPNAME NOT IN ('BROKERAGE','BRKSCR')   AND QTY <>0
---and party_code ='skit055'
UNION ALL
SELECT dense_rank ()OVER(PARTITION BY PARTY_CODE ORDER BY PARTY_CODE,CONTRACTNO DESC ,SCRIPNAME ) AS ROW_NO, PARTY_CODE,EXCHANGE,SEGMENT,ORDER_NO='',ORDER_TIME='23:59:59',TRADE_NO='',
TRADE_TIME='',SCRIPNAME,SELL_BUY='',SUM(CASE WHEN SELL_BUY='SELL' THEN QTY*-1 ELSE QTY END),MARKETRATE='',BROKERAGE ='',TMARK=''
,NETRATE='',CL_RATE='',NETAMOUNT=SUM(NETAMOUNT),ISIN ,SETT_NO ,SETT_DATE,CONTRACTNO =CONTRACTNO,REMARK_DESC ='0',CONTRACT_HEADER_DET,SETTTYPE_DESC ,'0'
FROM Contractnote_curr_Daily WITH(NOLOCK) WHERE   PARTY_CODE >='A0' AND PARTY_CODE <='ZZZZZZ' AND SCRIPNAME NOT IN ('BROKERAGE','BRKSCR')   AND QTY <>0
--and party_code ='skit055'
GROUP BY PARTY_CODE,EXCHANGE,SEGMENT,SCRIPNAME,ISIN,CONTRACTNO,CONTRACT_HEADER_DET,SETTTYPE_DESC,SETT_NO ,SETT_DATE --, TRADE_TIME
 ) A     ORDER BY PARTY_CODE,EXCHANGE,SEGMENT,CONTRACTNO DESC,SCRIPNAME,ORDER_TIME 
 
INSERT INTO cur_bulk_process
SELECT PARTY_CODE,'6' AS SNO,LTRIM(RTRIM(PARTY_CODE))+'|'+'D'+'|'+EXCHANGE+'|'+SEGMENT+'|'+CONVERT(VARCHAR,ORDER_NO)+'|'+CONVERT(VARCHAR,ORDER_TIME)+'|'+CONVERT(VARCHAR,TRADE_NO)+'|'+CONVERT(VARCHAR,TRADE_TIME)
+'|'+CONVERT(VARCHAR,'ADDITIONAL BROKERAGE')+'|'+CONVERT(VARCHAR,SELL_BUY)+'|'+CONVERT(VARCHAR,QTY)+'|'+CONVERT(VARCHAR,MARKETRATE)+'|'+convert( varchar(20), cast( BROKERAGE as decimal(18,4)))
+'|'+CONVERT(VARCHAR,NETRATE)+'|'+CONVERT(VARCHAR,CL_RATE)+'|'+convert( varchar(20), cast( NETAMOUNT as decimal(18,4)))+'|'+ 'Brokerage'+'|'+CONVERT(VARCHAR,SETT_NO)+'-'+CONVERT(VARCHAR,SETTTYPE_DESC)+'|'+CONVERT(VARCHAR,SETT_DATE)+'|'+
CONVERT(VARCHAR,CONTRACTNO) +'|'+CONVERT(VARCHAR,REMARK_DESC)+'|'+CONTRACT_HEADER_DET+'|'+convert( varchar(20), cast( FOREIGN_PRICE as decimal(18,4))),1,exchange,SEGMENT,'',''
FROM Contractnote_curr_Daily WHERE  SAUDA_DATE =@date AND SCRIPNAME IN ('BROKERAGE','BRKSCR')  AND PARTY_CODE >='a00' AND PARTY_CODE <='zzzzzz'
union all 
SELECT PARTY_CODE,'6' AS SNO,LTRIM(RTRIM(PARTY_CODE))+'|'+'D'+'|'+EXCHANGE+'|'+SEGMENT+'|'+CONVERT(VARCHAR,ORDER_NO)+'|'+CONVERT(VARCHAR,ORDER_TIME)+'|'+CONVERT(VARCHAR,TRADE_NO)+'|'+CONVERT(VARCHAR,TRADE_TIME)
+'|'+CONVERT(VARCHAR(35),'ADDITIONAL BROKERAGE (NET TOTAL)')+'|'+CONVERT(VARCHAR,SELL_BUY)+'|'+CONVERT(VARCHAR,QTY)+'|'+CONVERT(VARCHAR,MARKETRATE)+'|'+CONVERT(VARCHAR,0)
+'|'+CONVERT(VARCHAR,NETRATE)+'|'+CONVERT(VARCHAR,CL_RATE)+'|'+convert( varchar(20), cast( NETAMOUNT as decimal(18,4)))+'|'+ 'Brokerage'+'|'+CONVERT(VARCHAR,SETT_NO)+'-'+CONVERT(VARCHAR,SETTTYPE_DESC)+'|'+CONVERT(VARCHAR,SETT_DATE)+'|'+
CONVERT(VARCHAR,CONTRACTNO) +'|'+CONVERT(VARCHAR,REMARK_DESC)+'|'+CONTRACT_HEADER_DET+'|'+convert( varchar(20), cast( FOREIGN_PRICE as decimal(18,4))),2,exchange,SEGMENT,'',''
FROM Contractnote_curr_Daily WHERE  SAUDA_DATE =@date AND SCRIPNAME IN ('BROKERAGE','BRKSCR')  AND PARTY_CODE >='a00' AND PARTY_CODE <='zzzzzz'

---select * from Contractnote_curr_Daily where party_code ='M98420'

INSERT INTO cur_bulk_process

SELECT CD_PARTY_CODE,'7' AS SNO,LTRIM(RTRIM(CD_PARTY_CODE))+'|'+'O'+'|'+EXCHANGE+'|'+SEGMENT+'|'
+CONVERT(VARCHAR(100),SCRIP_CD)+'|'+SELL_FLAG+'|'+CONVERT(VARCHAR,CD_Order_No)+'|'+CONVERT(VARCHAR,TRD_QTY)+'|'+convert( varchar(20), cast( PRICE as decimal(18,2)))+'|'+
convert( varchar(20), cast( TURNOVER as decimal(18,2)))+'|'+convert( varchar(20), cast( BROKERAGE as decimal(18,2))),dense_rank ()OVER(PARTITION BY cd_PARTY_CODE ORDER BY cd_PARTY_CODE,exchange,segment ,scrip_cd,cd_order_no ) AS ROW_NO,'','','',''
FROM #ORDER_WISE  ---WHERE CD_PARTY_CODE ='HHTF1005'
ORDER BY CD_Party_Code,EXCHANGE,SEGMENT,SCRIP_CD

 /* MODIFIED ON 05052020 ADDED GST VALUES CONVERT(VARCHAR,BROKERAGE)
 INSERT INTO cur_bulk_process
SELECT PARTY_CODE,'8' AS SNO,PARTY_CODE+'|'+'F'+'|'+EXCHANGE+'|'+SEGMENT+'|'+CONVERT(VARCHAR,SUM(NETAMOUNT)) +'|'+
CONVERT(VARCHAR,SUM(INS_CHRG)) +'|'+CONVERT(VARCHAR,SUM(BROKERAGE+TURN_TAX+SEBI_TAX)) 
+'|'+CONVERT(VARCHAR(20),CAST(SUM(CGST) AS DECIMAL(18,2)))+'|'+CONVERT(VARCHAR(20),CAST(SUM(SGST) AS DECIMAL(18,2)))+'|'+CONVERT(VARCHAR,SUM(TURN_TAX))
+'|'+CONVERT(VARCHAR,SUM(SEBI_TAX))+'|'+CONVERT(VARCHAR,SUM(BROKER_CHRG))++'|'+CONVERT(VARCHAR,SUM(OTHER_CHRG))
+'|'+CONVERT(VARCHAR(20),CAST(SUM(NETAMOUNT-(INS_CHRG+TURN_TAX+SEBI_TAX+CGST+SGST+BROKER_CHRG+IGST+UGST)) AS DECIMAL(18,2)))+'|'+CONVERT(VARCHAR,SUM(BROKERAGE)) 
+'|'+CONVERT(VARCHAR(20),CAST(SUM(IGST) AS DECIMAL(18,2)))+'|'+CONVERT(VARCHAR(20),CAST(SUM(UGST) AS DECIMAL(18,2))),0,'','','',''
FROM Contractnote_curr_Daily WHERE SAUDA_DATE =@date   AND  PARTY_CODE >='a00' AND PARTY_CODE <='zzzzzz'
GROUP BY  PARTY_CODE,EXCHANGE,SEGMENT   
*/ 
INSERT INTO cur_bulk_process
SELECT PARTY_CODE,'8' AS SNO,PARTY_CODE+'|'+'F'+'|'+EXCHANGE+'|'+SEGMENT+'|'+CONVERT(VARCHAR,SUM(NETAMOUNT)) +'|'+
CONVERT(VARCHAR,SUM(INS_CHRG)) +'|'+CONVERT(VARCHAR,SUM(BROKERAGE+TURN_TAX+SEBI_TAX)) 
+'|'+CONVERT(VARCHAR(20),CAST(SUM(CGST) AS DECIMAL(18,2)))+'|'+CONVERT(VARCHAR(20),CAST(SUM(SGST) AS DECIMAL(18,2)))+'|'+CONVERT(VARCHAR,SUM(TURN_TAX))
+'|'+CONVERT(VARCHAR,SUM(SEBI_TAX))+'|'+CONVERT(VARCHAR,SUM(BROKER_CHRG))++'|'+CONVERT(VARCHAR,SUM(OTHER_CHRG))
+'|'+CONVERT(VARCHAR(20),CAST(SUM(NETAMOUNT-(INS_CHRG+TURN_TAX+SEBI_TAX+CGST+SGST+BROKER_CHRG+IGST+UGST)) AS DECIMAL(18,2)))+'|'+CONVERT(VARCHAR,SUM(BROKERAGE)) 
+'|'+CONVERT(VARCHAR(20),CAST(SUM(IGST) AS DECIMAL(18,2)))+'|'+CONVERT(VARCHAR(20),CAST(SUM(UGST) AS DECIMAL(18,2)))
+'|'+(case when MIN(CGST_PER) <>0 then 'CGST (@ '+ convert(varchar(10),MIN(CGST_PER))+'%)' ELSE 'NA' END)
+'|'+(case when MIN(SGST_PER) <>0 then 'SGST (@ '+ convert(varchar(10),MIN(SGST_PER))+'%)' ELSE 'NA' END)
+'|'+(case when MIN(IGST_PER) <>0 then 'IGST (@ '+ convert(varchar(10),MIN(IGST_PER))+'%)' ELSE 'NA' END)
+'|'+(case when MIN(UGST_PER) <>0 then 'UGST (@ '+ convert(varchar(10),MIN(UGST_PER))+'%)' ELSE 'NA' END)
 ,0,'','','',''
FROM Contractnote_curr_Daily WHERE SAUDA_DATE =@date    AND  PARTY_CODE >='a00' AND PARTY_CODE <='zzzzzz' --and UGST <>0
GROUP BY  PARTY_CODE,EXCHANGE,SEGMENT  




SELECT DISTINCT PARTY_CODE INTO #P FROM cur_bulk_process WHERE SNO=1

 create index #v on #P  (party_code)


delete FROM   cur_bulk_process WHERE     PARTY_CODE NOT IN (
SELECT DISTINCT PARTY_CODE FROM #P )


 
 select party_code into #party from cur_bulk_process where sno=1

 create index #v on #party  (party_code)

 DECLARE @SDATE DATETIME
 SELECT @SDATE = sdtcur FROM ACCOUNT.DBO.parameter WHERE @dt BETWEEN sdtcur AND ldtcur 

 


 select cltcode,sum(case when drcr ='d' then vamt else -vamt end) as balance into #vdt
 from account.dbo.ledger_all where vdt >=@SDATE and vdt <=@dt +' 23:59' and cltcode in (select * from #party)
 group by cltcode
  
  insert into #vdt
   select cltcode,sum(case when drcr ='d' then vamt else -vamt end) as balance  
 from mtftrade.dbo.ledger where vdt >=@SDATE and vdt <=@dt +' 23:59' and cltcode in (select * from #party)
 group by cltcode
  
  select cltcode,sum(balance)  as balance into #final from #vdt  group by cltcode
   create index #v on #final (cltcode)

update n set Data_text=data_text+'|'+convert(varchar(30),balance)   from cur_bulk_process n,#final f where sno=1 and cltcode=party_code 

SELECT B2C_SB INTO #BTWOB FROM [MIS].REMISIOR.DBO.B2C_SB WITH(NOLOCK)
WHERE ISNULL(B2C_SB,'')  NOT IN ('AMRVT')

update n set  Data_text=data_text+'|'+(case when B2C_SB is null then 'B2B' else 'B2C' end) 
from cur_bulk_process n,client_Details d
 left outer join #BTWOB on B2C_SB=sub_broker
 where n.party_code =d.cl_code and sno=1 



declare @NSEQUERY varchar(max)
set @NSEQUERY = ' bcp " select Data_text'
set @NSEQUERY = @NSEQUERY + ' from anand1.msajag.dbo.cur_bulk_process  order by party_code ,sno,SRNO,EXCHANGE,SEGMENT,SCRIP_CD,OD_TIME " queryout j:\Contract_Note\ContractNote_Curr_'+replace(convert(varchar,@dt,103),'/','')+'.txt -c -t"," -Sanand1 -Usa -Psuropt09'
set @NSEQUERY = '''' + @NSEQUERY + ''''
set @NSEQUERY = 'EXEC MASTER.DBO.XP_CMDSHELL '+ @NSEQUERY
print @NSEQUERY 
exec (@NSEQUERY)

GO
