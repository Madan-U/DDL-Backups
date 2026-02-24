-- Object: PROCEDURE dbo.CLIENTWISE_DATA
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

--CLIENTWISE_DATA 'OCT  1 2019','NOV  1 2019'      
      
      
CREATE PROCEDURE [dbo].[CLIENTWISE_DATA]      
      
(       
      
@Fdate varchar(15),      
@Tdate varchar(15)        
      
)      
      
AS      
BEGIN      
       
      
DECLARE @FromDate DATETIME=CAST(@Fdate  AS DATETIME)      
      
DECLARE @ToDate DATETIME=dateadd(ms, -3, (dateadd(day, +1, convert(varchar, @Tdate, 101))))--DATEADD(DD, -1, DATEADD(D, 1, CONVERT(DATETIME2, @Tdate)))       
      
----196 MSajag        
--declare @FromDate datetime='2019-10-01'        
--declare @ToDate datetime='2019-11-01'        
        
      
        
select party_code,SAUDA_DATE, sum(Brokage)Brokage,sum(TURNOVER)TURNOVER        
into #cash        
from        
(        
        
SELECT  party_code,cast(SAUDA_DATE as date)SAUDA_DATE,        
Sum (PBROKTRD + SBROKTRD + PBROKDEL + SBROKDEL) as  Brokage,SUM(TRDAMT)as TURNOVER         
FROM msajag.dbo.CmBillValan B WITH(NOLOCK)        
WHERE SAUDA_DATE>=@FromDate AND SAUDA_DATE <=@ToDate        
group by party_code,cast(SAUDA_DATE as date)        
Union         
        
SELECT   party_code,cast(SAUDA_DATE as date)SAUDA_DATE,        
Sum (PBROKTRD + SBROKTRD + PBROKDEL + SBROKDEL) as  Brokage,SUM(TRDAMT)as TURNOVER         
FROM [AngelBSECM].BSEDB_AB.dbo.CmBillValan B WITH(NOLOCK)        
WHERE SAUDA_DATE>=@FromDate AND SAUDA_DATE <=@ToDate        
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
         
         
        
        
        
create nonclustered index clx3 on #OrderCountComm (sauda_date,party_code)        
        
        
        
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
        
        
        
        
select * into #FinalComm        
From #OrderCountComm #AllClients where #AllClients.Brokerage<>0         
union all        
select #AllClients.sauda_date,#AllClients.Party_code,#AllClients.INST_Type,OrderNoCount,T_O,#Brokerage2.Brokerage--,ActiveFrom,VBB,DB_clienttype         
from #OrderCountComm #AllClients         
inner join #Brokerage2 on #Brokerage2.Sauda_date=#AllClients .Sauda_date and #Brokerage2.party_code=#AllClients .party_code         
 and #Brokerage2.INST_Type=#AllClients .INST_Type        
where #AllClients.Brokerage=0   and #AllClients.INST_Type='COMM'--and #AllClients.Party_code='A150007'        
order by #AllClients.sauda_date,#AllClients.party_code        
        
        
     
-----------------------####################COMM ENDS#################         
-----------------------####################CURR Starts#################         
        
        
        
        
         
        
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
        
-----------------------####################CURR ENDS#################         
        
        
         
select   sauda_date,Party_code,INST_Type,sum(orderNoCount)OrderNoCount,sum(T_O)T_O,sum(Brokerage)Brokerage into #step1        
from #FinalCash group by sauda_date,Party_code,INST_Type union all        
select   sauda_date,Party_code,INST_Type,sum(orderNoCount)OrderNoCount,sum(T_O)T_O,sum(Brokerage)Brokerage        
from #FinalFNO group by sauda_date,Party_code,INST_Type union all        
select   sauda_date,Party_code,INST_Type,sum(orderNoCount)OrderNoCount,sum(T_O)T_O,sum(Brokerage)Brokerage        
from #FinalComm group by sauda_date,Party_code,INST_Type union all        
select   sauda_date,Party_code,INST_Type,sum(orderNoCount)OrderNoCount,sum(T_O)T_O,sum(Brokerage)Brokerage        
from #FinalCurr group by sauda_date,Party_code,INST_Type        
        
create clustered index clx on #step1(sauda_date,party_code)         
        
        
        
        
        
        
        
        
        
        
select party_code,ActiveFrom,Inactivefrom,db_clientType         
into #party        
From ABVSINSURANCEBO.ispacescorecard.dbo. Angelclient1         
where ActiveFrom>=@FromDate and ActiveFrom<@todate      
  and activefrom<getdate()         
        
create clustered index clx on #party(party_code)         
        
        
select #party.*,Vw_VBB_SCHEME .SCHEME_NAME,Vw_VBB_SCHEME .SP_Date_From into #schemed from #party        
left join Vw_VBB_SCHEME on Vw_VBB_SCHEME.SP_Party_Code=#party.party_code        
        
        
select #step1.*,#schemed.SCHEME_NAME,#schemed.SP_Date_From,ActiveFrom,Inactivefrom,db_clientType From #step1        
inner join #schemed on #schemed.party_code=#step1.PARTY_CODE        
where #step1.sauda_date>=@FromDate and #step1.sauda_date<@ToDate      
      
      
END

GO
