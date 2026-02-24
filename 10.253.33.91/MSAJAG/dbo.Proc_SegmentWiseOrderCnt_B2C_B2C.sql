-- Object: PROCEDURE dbo.Proc_SegmentWiseOrderCnt_B2C_B2C
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

      
CREATE Proc [dbo].[Proc_SegmentWiseOrderCnt_B2C_B2C]      
      
as       
      
begin      
      
----196 MSajag        
       
 declare  @StartOfMonth DATETIME      
 IF @StartOfMonth IS NULL      
 Select @StartOfMonth=MAX(StartOfMonth)       
 From ABVSINSURANCEBO.Ispacescorecard.dbo.iSpc_Master_SCard_PERBRANCHMONTHLYTREND with (nolock)      
      
 DECLARE @FromDate   DATETIME,      
   @ToDate    DATETIME      
         
   SET @FromDate=@StartOfMonth        
 SET @ToDate=DATEADD(MONTH,1,@StartOfMonth)      
       
 print  @FromDate      
 print @ToDate       
        
--drop table #party        
        
        
----into #party        
----From ABVSINSURANCEBO.ispacescorecard.dbo. Angelclient1         
----where ActiveFrom>='2019-01-01'        
        
        
----create clustered index clx on #party(party_code)         
        
        
----select #party.*,Vw_VBB_SCHEME .SCHEME_NAME,Vw_VBB_SCHEME .SP_Date_From into #schemed from #party        
----left join Vw_VBB_SCHEME on Vw_VBB_SCHEME.SP_Party_Code=#party.party_code        
        
        
        
--declare @FromDate datetime='2019-01-01'        
--declare @ToDate datetime='2019-05-03'        
        
------------##########################Cash Starts######################         
        
select party_code,SAUDA_DATE, sum(Brokage)Brokage,sum(TURNOVER)TURNOVER        
into #cash        
from        
(        
        
SELECT  party_code,cast(SAUDA_DATE as date)SAUDA_DATE,        
Sum (PBROKTRD + SBROKTRD + PBROKDEL + SBROKDEL) as  Brokage,SUM(TRDAMT)as TURNOVER         
FROM CmBillValan B WITH(NOLOCK)        
WHERE SAUDA_DATE>=@FromDate AND SAUDA_DATE <@ToDate        
group by party_code,cast(SAUDA_DATE as date)        
Union         
        
SELECT   party_code,cast(SAUDA_DATE as date)SAUDA_DATE,        
Sum (PBROKTRD + SBROKTRD + PBROKDEL + SBROKDEL) as  Brokage,SUM(TRDAMT)as TURNOVER         
FROM [AngelBSECM].BSEDB_AB.dbo.CmBillValan B WITH(NOLOCK)        
WHERE SAUDA_DATE>=@FromDate AND SAUDA_DATE <@ToDate        
group by party_code,cast(SAUDA_DATE as date)        
)tbl        
group by party_code,SAUDA_DATE        
        
        
         
        
Select  cast(a.sauda_date as date)sauda_date ,a.Party_code,case when tmark='d'then 'Del' when tmark=''then 'Intr'else '' end INST_Type,         
a.order_no         
into #CashOC        
from   Msajag.dbo.Common_contract_data a with (nolock)         
--inner join #party on #party.party_code=a.party_code        
where ----Party_code in( 'GRGN6769') and        
exchange in('NSE','BSE') and Segment='capital'         
and a.Sauda_date >=@FromDate         
and a.Sauda_date <@ToDate        
         
        
create nonclustered index nclxc on #CashOC(party_code)        
        
select sauda_date,party_code,inst_type,sum(OrderNoCount)OrderNoCount into #OrderCount --drop table #OrderCount        
from(        
 select sauda_date,party_code,inst_type,count(distinct order_no)OrderNoCount From #CashOC       
 group by sauda_date,party_code,inst_type       
)b        
group by sauda_date,party_code,inst_type        
order by sauda_date,party_code,inst_type        
        
 ----select * From #cash where Brokage=0        
        
 ----select sauda_date,sum(OrderNoCount) From #OrderCount group by sauda_date        
 ----select sauda_date,sum(Brokage)/100000,sum(TURNOVER)/10000000 From #cash group by sauda_date        
        
         
--declare @FromDate datetime='2019-04-01'        
--declare @ToDate datetime='2019-04-23'        
        
Select  cast(a.sauda_date as date)sauda_date ,a.Party_code,case when tmark='d'then 'Del' when tmark=''then 'Intr'else '' end INST_Type,         
a.order_no, Sum (Qty * MarketRate) T_O,        
sum(a.Brokerage)Brokerage        
into #CashCommonContData        
from  Msajag.dbo.Common_contract_data a with (nolock)         
where exchange in('NSE','BSE') and Segment='capital'         
and a.Sauda_date >=@FromDate         
and a.Sauda_date <@ToDate        
group by  a.order_no, a.Party_code,cast(a.sauda_date as date),case when tmark='d'then 'Del' when tmark=''then 'Intr'else '' end        
order by  a.Party_code,a.order_no        
         
         
select sauda_date,Party_code,INST_Type,count(distinct ORDER_NO)orderNoCount,sum(T_O) T_O,sum(Brokerage)Brokerage into #s1--drop table #s1        
From  #CashCommonContData a with (nolock)          
group by sauda_date,Party_code,INST_Type        
        
--select * From  #cash a with (nolock) where sauda_date='2019-04-08'and Party_code='A101732'--and order_no='1200000001262422'             
        
select * into #FinalCash From #s1 where brokerage<>0        
union all        
select #s1.sauda_date,#s1.Party_code,#s1.INST_Type ,#s1.orderNoCount,#s1.T_O,Brok.ModBrokage From #s1        
inner join (        
 select #s1.*,(#s1.T_O/SumTo.T_O)*#cash.Brokage ModBrokage From #s1        
 inner join (       
 select sauda_date,Party_code,sum(T_O)T_O  From #s1 --where sauda_date='2019-04-08'and Party_code='A101732'        
 group by sauda_date,Party_code       
 )SumTo on SumTo.sauda_date=#s1.sauda_date and  SumTo.PARTY_CODE=#s1.PARTY_CODE       
 inner join #cash on #cash.SAUDA_DATE=#s1.sauda_date and  #cash.PARTY_CODE=#s1.PARTY_CODE       
)Brok on #s1.sauda_date=Brok.sauda_date and  #s1.Party_code=Brok.Party_code and   #s1.INST_Type=Brok.INST_Type        
where #s1.Brokerage=0         
------------##########################Cash Ends######################         
         
------------##########################FNO starts######################         
         
         
        
--declare @FromDate datetime='2019-04-24'        
--declare @ToDate datetime='2019-04-25'        
        
        
         
select Sauda_date,Party_code,        
case when Inst_type like 'fut%' then 'FUT' when Inst_type like 'opt%' then 'OPT'    end Inst_type         
,Sum (TradeQty * (Strike_price + Price)) T_O         
into #TurnOver---drop table #TurnOver        
from(        
 select cast(Sauda_date as Date)Sauda_date,Party_code,Inst_type,Strike_price,Price,TradeQty  from [AngelFO]. nsefo.dbo. FoSettlement a with (nolock)       
 where a.Sauda_date >=@FromDate and a.Sauda_date <@ToDate       
 union all       
 select cast(Sauda_date as Date)Sauda_date,Party_code,Inst_type ,Strike_price,Price,TradeQty from  [AngelFO]. pradnya.dbo. History_Fosettlement_Nsefo a with(nolock)       
 where a.Sauda_date >=@FromDate and a.Sauda_date <@ToDate       
 )b       
group by Sauda_date,Party_code,Inst_type        
order by Sauda_date,Party_code,Inst_type        
         
--select * from #TurnOver         
--where cast(sauda_date as date)='2019-04-24'and party_code='diyd38464'        
        
         
select sauda_date,Party_Code, case when Inst_type like 'fut%' then 'FUT' when Inst_type like 'opt%' then 'OPT'when Inst_type like '' then 'OPT'    end Inst_type         
,sum(Brokerage) Brokerage into #Brokerage--drop table #Brokerage    case when inst_type='' then 'OPTSTK'else inst_type end        
from(        
 select cast(a.Sauda_date as date) Sauda_date,Party_Code,inst_type,sum(PBROKAMT+SBROKAMT) as brokerage         
 from [AngelFO].NSEFO.DBO.FOBILLVALAN a       
 where  a.Sauda_date >=@FromDate and a.Sauda_date <@ToDate         
 group by cast(a.Sauda_date as date),Party_Code,inst_type       
)b        
group by sauda_date,Party_Code,inst_type        
order by sauda_date,Party_Code,inst_type        
        
         
--select * from #Brokerage         
--where cast(sauda_date as date)='2019-04-24'and party_code='diyd38464'        
        
Select cast(a.sauda_date as date)sauda_date, a.Party_code,case when Inst_type like 'fut%' then 'FUT' when Inst_type like 'opt%' then 'OPT'    end Inst_type ,a.order_no OrderNoCount        
into #FNO--drop table #fno        
from   Msajag.dbo.Common_contract_data a with (nolock),        
(select Trade_no,Sauda_date,Party_code,Inst_type ,Strike_price,Price,TradeQty  from [AngelFO]. nsefo.dbo. FoSettlement a with (nolock)        
where a.Sauda_date >=@FromDate and a.Sauda_date <@ToDate        
union all        
select  Trade_no,Sauda_date,Party_code,Inst_type ,Strike_price,Price,TradeQty from  [AngelFO]. pradnya.dbo. History_Fosettlement_Nsefo a with(nolock)        
where a.Sauda_date >=@FromDate and a.Sauda_date <@ToDate        
) b          
where         
exchange='NSE' and Segment='Futures'         
and a.Sauda_date >=@FromDate and a.Sauda_date <@ToDate         
and a.Trade_No = b.Trade_no        
and a.Party_code =  b.Party_code        
and cast(a.Sauda_date as date)=  cast(b.Sauda_date as date)         
         
select sauda_date,party_code,inst_type,sum(OrderNoCount)OrderNoCount into #OrderCountFno --drop table #OrderCount        
from(        
 select sauda_date,party_code,inst_type,count(distinct OrderNoCount)OrderNoCount From #FNO       
 group by sauda_date,party_code,inst_type       
)b        
group by sauda_date,party_code,inst_type        
order by sauda_date,party_code,inst_type        
         
        
select  B.sauda_date,B.Party_Code,B.Inst_type,sum(O.OrderNoCount)OrderNoCount,sum(T.T_O)T_O,sum(B.Brokerage)Brokerage into #FinalFNO         
from(        
select sauda_date,Party_Code,Inst_type,sum(Brokerage)Brokerage  From #Brokerage group by sauda_date,Party_Code,Inst_type        
) B inner join (        
select sauda_date,Party_Code,Inst_type,sum(T_O)T_O  From #TurnOver group by sauda_date,Party_Code,Inst_type        
)T on B.Sauda_date=T.Sauda_date and B.party_code=T.party_code and B.Inst_type=T.Inst_type        
inner join (        
select sauda_date,Party_Code,Inst_type,sum(OrderNoCount)OrderNoCount  From #OrderCountFno group by sauda_date,Party_Code,Inst_type        
)O on O.Sauda_date=T.Sauda_date and O.party_code=T.party_code and O.Inst_type=T.Inst_type        
--where cast(T.sauda_date as date)='2019-04-24'and T.party_code='diyd38464'        
group by B.sauda_date,B.Party_Code,B.Inst_type        
        
        
         
          
-----------------------####################FNO ENDS#################         
-----------------------####################COMM Starts#################         
          
        
        
--declare @FromDate datetime='2019-04-24'        
--declare @ToDate datetime='2019-04-25'        
        
         
        
SELECT cast(sauda_date as date)sauda_date, Party_code,'COMM'Inst_type, ORDER_NO,SUM(VOLUME)T_O,SUM(BROK)Brokerage         
into #Comm        
FROM (        
SELECT DISTINCT cast(sauda_date as date)sauda_date, Party_code,'COMM'Inst_type,  ORDER_NO,SUM((QTY*MARKETRATE)*NUMERATOR/DENOMINATOR) VOLUME,        
SUM(BROK*NUMERATOR/DENOMINATOR) BROK         
FROM [AngelCommodity].mcdx.dbo. COMMON_CONTRACT_DATA  WITH(NOLOCK) WHERE ---Party_code in( 'DDUB1006') and          
Sauda_date >=@FromDate and Sauda_date <@ToDate  and exchange='MCX'        
GROUP BY  cast(sauda_date as date) , Party_code, ORDER_NO          
)A        
group by cast(sauda_date as date), Party_code, ORDER_NO        
UNION ALL        
SELECT cast(sauda_date as date)sauda_date, Party_code,'COMM'Inst_type, ORDER_NO,SUM(VOLUME),SUM(BROK)    FROM (        
SELECT DISTINCT cast(sauda_date as date)sauda_date, Party_code,'COMM'Inst_type, ORDER_NO,SUM((QTY*MARKETRATE)*NUMERATOR/DENOMINATOR) VOLUME,SUM(BROK ) BROK         
FROM [AngelCommodity].mcdx.dbo.COMMON_CONTRACT_DATA  WITH(NOLOCK) WHERE --Party_code in( 'DDUB1006') and          
Sauda_date >=@FromDate and Sauda_date <@ToDate  and exchange='NCX'        
GROUP BY  cast(sauda_date as date) , Party_code, ORDER_NO  )A        
group by cast(sauda_date as date), Party_code, ORDER_NO        
order by  a.Party_code,a.order_no        
        
create clustered index nclxcom on #Comm(party_code)        
        
select  a.sauda_date,a.party_code,INST_Type,count(distinct order_no)OrderNoCount ,sum(T_o)T_o,sum(Brokerage)Brokerage  into #OrderCountComm --drop table #OrderCountComm        
From #Comm a        
group by a.sauda_date,a.party_code,INST_Type        
         
         
----select * into #ZeroBrokerageComm From #OrderCountComm  where brokerage=0        
----delete From #OrderCountComm  where brokerage=0        
        
        
--select sauda_date,#OrderCountComm.Party_code,INST_Type,OrderCount,T_O,Brokerage,#party.ActiveFrom ,VBB,Db_ClientType         
----into #AllClients--drop table #AllClients        
-- From #OrderCountComm        
-- #schemed #party on #party.Party_Code=#OrderCountComm.party_code       
-- Angelclient1  on Angelclient1.Party_Code=#OrderCountComm.party_code       
        
        
         
------declare @FromDate datetime='2019-01-01'        
------declare @ToDate datetime='2019-05-03'        
        
----select * into #FinalComm From #OrderCountComm union all        
----select cast(a.sauda_date as date)sauda_date,a.Party_code,'COMM'Inst_type,sum(OrderNoCount)OrderNoCount,SUM((QTY*MARKETRATE)*NUMERATOR/DENOMINATOR)  T_o,sum(a.brokerage)brokerage        
----FROM #ZeroBrokerageComm        
----left join  [AngelCommodity].mcdx.dbo. COMMON_CONTRACT_DATA a WITH(NOLOCK)  on #ZeroBrokerageComm.sauda_date=cast(a.sauda_date as date)        
---- and a.PARTY_CODE=#ZeroBrokerageComm.party_code       
----WHERE ---Party_code in( 'DDUB1006') and          
----a.Sauda_date >=@FromDate and a.Sauda_date <@ToDate  and exchange='MCX'        
        
        
create nonclustered index clx3 on #OrderCountComm (sauda_date,party_code)        
        
------select * From #OrderCountComm where brokerage=0        
        
select sauda_date, party_code ,INST_Type ,sum(Brokerage)Brokerage into #Brokerage2--drop table #Brokerage2      
 from        
 (       
 select cast(a.Sauda_date as date) Sauda_date ,a.party_code,INST_Type,sum(a.Brokerage)Brokerage  --225 drop table #Brokerage2       
 FROM [AngelCommodity].mcdx.dbo. COMMON_CONTRACT_DATA  a WITH(NOLOCK)        
 inner join #OrderCountComm #AllClients on #AllClients.sauda_date=a.sauda_date and #AllClients.party_code=a.party_code        
  and #AllClients .brokerage=0 and INST_Type='COMM'      
 WHERE ---Party_code in( 'DDUB1006') and         
 a.Sauda_date >=@FromDate and a.Sauda_date <@ToDate  and exchange='MCX'       
 --and a.party_code='A150007'       
 group by cast(a.Sauda_date as date)   ,a.party_code,INST_Type       
union all        
 select cast(a.Sauda_date as date) Sauda_date ,a.party_code,INST_Type,sum(a.Brokerage)Brokerage          
 FROM [AngelCommodity].mcdx.dbo. COMMON_CONTRACT_DATA  a WITH(NOLOCK)        
 inner join #OrderCountComm #AllClients on #AllClients.sauda_date=a.sauda_date and #AllClients.party_code=a.party_code        
  and #AllClients .brokerage=0 and INST_Type='COMM'      
 WHERE ---Party_code in( 'DDUB1006') and         
 a.Sauda_date >=@FromDate and a.Sauda_date <@ToDate  and exchange='NCX'       
 --and a.party_code='A150007'       
 group by cast(a.Sauda_date as date)   ,a.party_code,INST_Type       
)Brok        
group by sauda_date, party_code ,INST_Type       
        
        
--drop table #FinalComm        
        
select * into #FinalComm        
From #OrderCountComm #AllClients where #AllClients.Brokerage<>0         
union all        
select #AllClients.sauda_date,#AllClients.Party_code,#AllClients.INST_Type,OrderNoCount,T_O,#Brokerage2.Brokerage--,ActiveFrom,VBB,DB_clienttype         
from #OrderCountComm #AllClients         
inner join #Brokerage2 on #Brokerage2.Sauda_date=#AllClients .Sauda_date and #Brokerage2.party_code=#AllClients .party_code         
 and #Brokerage2.INST_Type=#AllClients .INST_Type        
where #AllClients.Brokerage=0   and #AllClients.INST_Type='COMM'--and #AllClients.Party_code='A150007'        
order by #AllClients.sauda_date,#AllClients.party_code        
        
alter table #FinalComm add PricePerOrder decimal(18,5)        
update #FinalComm  set PricePerOrder =Brokerage/OrderNoCount        
        
-----------------------####################COMM ENDS#################         
-----------------------####################CURR Starts#################         
        
        
-- declare @FromDate datetime='2019-04-24'       
--declare @ToDate datetime='2019-04-25'        
        
         
        
select cast(sauda_date as date)sauda_date,PARTY_CODE,Seg, (ORDER_NO) OC,(T_O)T_O,(Brokerage)Brokerage         
into #curr         
from(        
select a.Sauda_date,  a.PARTY_CODE,'Currency' Seg,ORDER_NO --,case when Db_ClientType ='y' then 'B2C' else 'B2B' end as BusinessType        
 ,((Qty * MarketRate)) T_O,(a.Brokerage)Brokerage        
 from  Msajag.dbo. Common_contract_data a with (nolock)        
        
 where exchange in('NSX') and Segment='Futures' and       
 a.Sauda_date >=@FromDate        
 and a.Sauda_date <@ToDate        
)b          
        
        
create clustered index nclxcur on #curr(party_code)        
        
select a.sauda_date,a.party_code,seg INST_Type,count(distinct oc)OrderNoCount ,sum(T_o)T_o,sum(Brokerage)Brokerage into #FinalCurr  From #Curr a        
group by a.sauda_date,a.party_code,seg        
        
create clustered index nclxcur1 on #FinalCurr(sauda_date,party_code)        
        
        
        
        
        
select * into #step1 from #FinalCash union all        
select * from #FinalFNO union all        
select sauda_date,party_code,INST_Type,OrderNoCount,T_o,Brokerage from #FinalComm         
union all        
select * from #FinalCurr        
        
        
        
select #step1.*,activefrom,db_clienttype into #step2        
from #step1 --drop table #step2        
left join ABVSINSURANCEBO.ispacescorecard.dbo.angelclient1 a with(nolock) on a.party_code=#step1.party_code        
        
        
        
        
        
----select sauda_date,Party_code,INST_Type,orderNoCount,T_O,Brokerage,db_clienttype From #step2         
----where sauda_date between '2019-05-01' and '2019-05-07' --and B2C='N'        
        
----select sauda_date,Party_code,INST_Type,orderNoCount,T_O,Brokerage,db_clienttype From #step2         
----where sauda_date between '2019-05-01' and '2019-05-07' --and B2C='Y'        
        
        
--select *  into B2C_may_19$ From #step2 where db_clienttype='Y'---for vasim        
--select * into B2B_may_19$  From #step2 where db_clienttype='n'---for swaraj        
        
        
select *   into  ##B2C_Order from  #step2 where db_clienttype='Y'---for vasim        
select *  into ##B2B_Order From #step2 where db_clienttype='n'---for swaraj        
end

GO
