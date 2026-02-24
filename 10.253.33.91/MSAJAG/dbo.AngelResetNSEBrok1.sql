-- Object: PROCEDURE dbo.AngelResetNSEBrok1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE Procedure [dbo].[AngelResetNSEBrok1] (@sauda_date Varchar(11))
As
Declare @@Sett_no Varchar(10)
Declare @@Maxdate Smalldatetime

--AngelResetNSEBrok1 'JUL 15 2010'
If @Sauda_date = ''
   Return
Select Top 1 @@Sett_no =  Sett_no from SETTLEMENT 
--where sauda_date like @Sauda_date+ '%'
where sauda_date >= @Sauda_date 
	and sauda_date <= @Sauda_date+ ' 23:59'
	and Sett_type in ('N','W')

Truncate Table AngelNSEResetBrok

Insert Into AngelNSEResetBrok
Select Party_code,ContractNo = '',Sauda_date = Cast(Left(Convert(varchar,sauda_date,109),11) As SmallDatetime),Turnover = Sum(Trade_amount),
NSEBrokerage = Sum(NBrokApp * Tradeqty) ,CD_Tot_Brok = 0,Sett_no ='',
Sett_type = 'N',FLAG1 = 'Y',SettCount = Count(Distinct Sett_type),MaxTurnover = 0
from SETTLEMENT 
	where sauda_date >= @Sauda_date+ ' 00:00' and sauda_date <= @Sauda_date+ ' 23:59'
		and Sett_type in ('N','W','M','Z')
			and [status] <> 'N' 
Group by Party_code,Cast(Left(Convert(varchar,sauda_date,109),11) As SmallDatetime) --,sett_no

Delete AngelNSEResetBrok where settcount = 1 and sauda_date >= @Sauda_date+ ' 00:00' and sauda_date <= @Sauda_date+ ' 23:59'

Delete AngelNSEResetBrok  where party_code in (select cr_party_code from AngelNseCM.msajag.dbo.contract_rounding 
	where CR_Min_ContractAmt = 0 and CR_Date_From <= @Sauda_date and CR_Date_to >= @Sauda_date )
			and sauda_date >= @Sauda_date+ ' 00:00' and sauda_date <= @Sauda_date+ ' 23:59'

	-- Added by Mukesh on May 29 2013 to delete error trades
	select CR_Party_code, CR_Date_From = max(CR_Date_From), CR_Date_To = max(CR_Date_To) 
	into #ContractRounding from  AngelNseCM.msajag.dbo.contract_rounding with (nolock) group by CR_Party_code 
	
	delete AngelNSEResetBrok from #ContractRounding c where AngelNSEResetBrok.Party_Code = c.CR_Party_Code  and c.CR_Date_To < getdate()


 
Delete charges_detail where cd_party_code in 
(
	Select Party_code from AngelNSEResetBrok WITH(NOLOCK) 
	where Nsebrokerage >= 30 
	and Cast(Left(Convert(varchar,sauda_date,109),11) As SmallDatetime) >= @Sauda_date+ ' 00:00' 
	and Cast(Left(Convert(varchar,sauda_date,109),11) As SmallDatetime) <= @Sauda_date+ ' 23:59'
)
And Cast(Left(Convert(varchar,cd_Sauda_date,109),11) As SmallDatetime) >= @Sauda_date+ ' 00:00' 
and Cast(Left(Convert(varchar,cd_Sauda_date,109),11) As SmallDatetime) <= @Sauda_date+ ' 23:59' 
and cd_sett_type in ('N','W','M','Z')
 
Delete  AngelNSEResetBrok where Nsebrokerage >= 30 and sauda_date like @Sauda_date+ '%'


Update  AngelNSEResetBrok Set Cd_tot_brok = ( Case When  TurnoverBrok < 30  Then TurnoverBrok - Nsebrokerage Else 30 - Nsebrokerage End)
Where sauda_date >= @Sauda_date+ ' 00:00' and sauda_date <= @Sauda_date+ ' 23:59'
Update AngelNSEResetBrok Set Cd_tot_brok = 0 where Cd_tot_brok < 0
and sauda_date >= @Sauda_date+ ' 00:00' and sauda_date <= @Sauda_date+ ' 23:59'



--Update AngelNSEResetBrok Set Contractno = Settlement.ContractNo 
--From Settlement where
--Settlement.Sett_type = 'N'
--and
--Settlement.Party_code = AngelNSEResetBrok.Party_code
--and
--Settlement.sauda_date >= @Sauda_date+ ' 00:00' and Settlement.sauda_date <= @Sauda_date+ ' 23:59'
--and AngelNSEResetBrok.sauda_date >= @Sauda_date+ ' 00:00' and AngelNSEResetBrok.sauda_date <= @Sauda_date+ ' 23:59'


Update AngelNSEResetBrok Set Contractno = Settlement.ContractNo 
From Settlement where
Settlement.Sett_type = 'N'
and
Settlement.Party_code = AngelNSEResetBrok.Party_code
and Cast(Left(Convert(varchar,Settlement.sauda_date,109),11) As SmallDatetime) >= @Sauda_date+ ' 00:00' 
and Cast(Left(Convert(varchar,Settlement.sauda_date,109),11) As SmallDatetime) <= @Sauda_date+ ' 23:59'
and Cast(Left(Convert(varchar,AngelNSEResetBrok.sauda_date,109),11) As SmallDatetime) >= @Sauda_date+ ' 00:00' 
and Cast(Left(Convert(varchar,AngelNSEResetBrok.sauda_date,109),11) As SmallDatetime) <= @Sauda_date+ ' 23:59'



Select * into #Temp1 from 
(Select party_code,sett_type,Amount = Sum(trade_amount) 
from settlement 
where party_code in 
(
select party_code from AngelNSEResetBrok where sauda_date >= @Sauda_date+ ' 00:00' and sauda_date <= @Sauda_date+ ' 23:59')
and sauda_date >= @Sauda_date+ ' 00:00' and sauda_date <= @Sauda_date+ ' 23:59'
Group by Party_code,Sett_type)A

Update AngelNSEResetBrok  Set MaxTurnover = Amount from
( Select Party_code,Amount = Max(Amount) from #Temp1 
  Group By Party_code )A
  Where
  A.Party_code = AngelNSEResetBrok.Party_code
  and
  AngelNSEResetBrok.sauda_date >= @Sauda_date+ ' 00:00' and AngelNSEResetBrok.sauda_date <= @Sauda_date+ ' 23:59'
  
Update AngelNSEResetBrok  Set Flag1 = 'N' From ( 
Select party_code,NSEBrokerage,CD_Tot_Brok,T = NSEBrokerage + CD_Tot_Brok ,Turnover,MaxTurnover,MaxTurnBrok = MaxTurnover * (2.5000/100)
From 
AngelNSEResetBrok 
Where
NSEBrokerage + CD_Tot_Brok > MaxTurnover * (2.5000/100)
and sauda_date >= @Sauda_date+ ' 00:00' and sauda_date <= @Sauda_date+ ' 23:59'
)A
Where
A.Party_code = AngelNSEResetBrok.Party_code
and
AngelNSEResetBrok.sauda_date >= @Sauda_date+ ' 00:00' and AngelNSEResetBrok.sauda_date <= @Sauda_date+ ' 23:59'

insert into Nsecharges_detailLog Select CD_SrNo,
CD_Party_Code,
CD_Sett_No,
CD_Sett_Type,
CD_Sauda_Date,
CD_ContractNo,
CD_Trade_No,
CD_Order_No,
CD_Scrip_Cd,
CD_Series,
CD_BuyRate,
CD_SellRate,
CD_TrdBuy_Qty,
CD_TrdSell_Qty,
CD_DelBuy_Qty,
CD_DelSell_Qty,
CD_TrdBuyBrokerage,
CD_TrdSellBrokerage,
CD_DelBuyBrokerage,
CD_DelSellBrokerage,
CD_TotalBrokerage,
CD_TrdBuySerTax,
CD_TrdSellSerTax,
CD_DelBuySerTax,
CD_DelSellSerTax,
CD_TotalSerTax,
CD_TrdBuy_TurnOver,
CD_TrdSell_TurnOver,
CD_DelBuy_TurnOver,
CD_DelSell_TurnOver ,
CD_Computation_Level,
CD_Min_BrokAmt,
CD_Max_BrokAmt,
CD_Min_ScripAmt,
CD_Max_ScripAmt,CD_TimeStamp,
CD_LOGTIMESTAMP = Getdate()
from  CHARGES_DETAIL where cd_party_code in(Select party_code from AngelNSEResetBrok where Flag1 = 'Y' )
and cd_Sauda_date >= @Sauda_date+ ' 00:00' and CD_Sauda_Date <= @Sauda_date+ ' 23:59'

Delete CHARGES_DETAIL where cd_party_code in
(
Select party_code from AngelNSEResetBrok WITH(NOLOCK)
Where Flag1 = 'Y')
and  Cast(Left(Convert(varchar,cd_Sauda_date,109),11) As SmallDatetime)>= @Sauda_date+ ' 00:00' 
and Cast(Left(Convert(varchar,cd_Sauda_date,109),11) As SmallDatetime) <= @Sauda_date+ ' 23:59'

Insert into charges_detail Select 
CD_Party_Code = Party_code,
CD_Sett_No = Sett_no,
CD_Sett_Type = Sett_type,
CD_Sauda_Date = Sauda_date,
CD_ContractNo = ContractNo,
CD_Trade_No = '0000',
CD_Order_No = '',
CD_Scrip_Cd = 'BROKERAGE',
CD_Series = 'EQ',
CD_BuyRate = 0,
CD_SellRate = 0,
CD_TrdBuy_Qty = 0,
CD_TrdSell_Qty = 0,
CD_DelBuy_Qty = 0,
CD_DelSell_Qty = 0,
CD_TrdBuyBrokerage = 0,
CD_TrdSellBrokerage = 0,
CD_DelBuyBrokerage = CD_TOT_BROK,
CD_DelSellBrokerage = 0,
CD_TotalBrokerage = CD_TOT_BROK,
CD_TrdBuySerTax = 0,
CD_TrdSellSerTax = 0,
--CD_DelBuySerTax = CD_TOT_BROK * (14.5000 /100), -- Service Tax Rate changed by Mukesh on Nov 16 2015, as per requirement from Vijay Mali
CD_DelBuySerTax = CD_TOT_BROK * (18.0000 /100), -- Service Tax Rate changed by Rajesh on Jun 01 2016, as per requirement from Vijay Mali, Changed to 18 from 15 on 3rd July 2017 GST

CD_DelSellSerTax = 0,
--CD_TotalSerTax = CD_TOT_BROK * (14.5000 /100), -- Service Tax Rate changed by Mukesh on Nov 16 2015, as per requirement from Vijay Mali
CD_TotalSerTax = CD_TOT_BROK * (18.0000 /100), -- Service Tax Rate changed by Rajesh on Jun 01 2016, as per requirement from Vijay Mali, Changed to 18 from 15 on 3rd July 2017 GST

CD_TrdBuy_TurnOver = 0 ,
CD_TrdSell_TurnOver = 0,
CD_DelBuy_TurnOver = 0,
CD_DelSell_TurnOver = 0,
CD_Computation_Level = '',
CD_Min_BrokAmt = 30,
CD_Max_BrokAmt = -1,
CD_Min_ScripAmt = 0,
CD_Max_ScripAmt = -1 ,CD_TimeStamp = Getdate()
from AngelNSEResetBrok
Where
sauda_date >= @Sauda_date+ ' 00:00' and sauda_date <= @Sauda_date+ ' 23:59'
and
Flag1 = 'Y'

--drop table #Temp

Select * Into #Temp from(
Select Party_code,ContractNo,Sauda_date = Cast(Left(Convert(varchar,sauda_date,109),11) As SmallDatetime) , Turnover = Sum(Trade_amount),
NSEBrokerage = Sum(NBrokApp * Tradeqty) ,CD_Tot_Brok = 0,--Sett_no,
Sett_type,FLAG1 = 'Y',SettCount = Count(Distinct Sett_type),
MaxTurnover = Sum(Trade_amount),MaxTurnbrok = Cast(0 As Money)
	from SETTLEMENT 
		where Cast(Left(Convert(varchar,sauda_date,109),11) As SmallDatetime) >= @Sauda_date+ ' 00:00' 
			and Cast(Left(Convert(varchar,sauda_date,109),11) As SmallDatetime) <= @Sauda_date+ ' 23:59'
				and Sett_type in ('N','W','M','Z') and [status] <> 'N'
					and party_code in(select party_code from AngelNSEResetBrok
		Where 	Cast(Left(Convert(varchar,sauda_date,109),11) As SmallDatetime) >= @Sauda_date+ ' 00:00' 
			and Cast(Left(Convert(varchar,sauda_date,109),11) As SmallDatetime) <= @Sauda_date+ ' 23:59'
				and Flag1 = 'N')
Group by Party_code,Cast(Left(Convert(varchar,sauda_date,109),11) As SmallDatetime),--sett_no,
Sett_type,Contractno
)A

Update #Temp set MaxTurnbrok = A.MaxTurnbrok from ( select party_code,MaxTurnBrok =  Max(MaxTurnover * (Cast(2.5000 As Money)/100))
From 
#Temp
Group By Party_code)A
Where
A.Party_code = #Temp.Party_code


Select * Into #Temp2 From ( select party_code,contractno,Sauda_date,Turnover,NSEBrokerage,
CD_Tot_Brok = (Case When MaxTurnbrok = Cast((MaxTurnover * (2.5000/100)) As Money) Then MaxTurnbrok - NseBrokerage Else 30 - Maxturnbrok - NseBrokerage End),
--Sett_no,
Sett_type,Flag1 = 'Y',SettCount = 1 ,MaxTurnover
	From 
		#Temp)A



Update #Temp2 Set Cd_TOT_BROK = #Temp2.CD_TOT_BROK + A.CD_TOT_BROK From
(Select Party_code,CD_TOT_BROK from #Temp2 Where CD_TOT_BROK < 0 
 )A
Where
A.Party_code = #Temp2.Party_code
and
#Temp2.CD_TOT_BROK > 0 

Update #Temp2 Set Cd_TOT_BROK = 0 
Where
#Temp2.CD_TOT_BROK < 0 

insert into Nsecharges_detailLog Select CD_SrNo,
CD_Party_Code,
CD_Sett_No,
CD_Sett_Type,
CD_Sauda_Date,
CD_ContractNo,
CD_Trade_No,
CD_Order_No,
CD_Scrip_Cd,
CD_Series,
CD_BuyRate,
CD_SellRate,
CD_TrdBuy_Qty,
CD_TrdSell_Qty,
CD_DelBuy_Qty,
CD_DelSell_Qty,
CD_TrdBuyBrokerage,
CD_TrdSellBrokerage,
CD_DelBuyBrokerage,
CD_DelSellBrokerage,
CD_TotalBrokerage,
CD_TrdBuySerTax,
CD_TrdSellSerTax,
CD_DelBuySerTax,
CD_DelSellSerTax,
CD_TotalSerTax,
CD_TrdBuy_TurnOver,
CD_TrdSell_TurnOver,
CD_DelBuy_TurnOver,
CD_DelSell_TurnOver ,
CD_Computation_Level,
CD_Min_BrokAmt,
CD_Max_BrokAmt,
CD_Min_ScripAmt,
CD_Max_ScripAmt,CD_TimeStamp,
CD_LOGTIMESTAMP = Getdate()
from CHARGES_DETAIL where cd_party_code in (Select Party_code from #Temp2 where Flag1 = 'Y')
and cd_Sauda_date>= @Sauda_date+ ' 00:00' and CD_Sauda_Date <= @Sauda_date+ ' 23:59'


Delete CHARGES_DETAIL where cd_party_code in (Select Party_code from #Temp2 Where Flag1 = 'Y')
and cd_Sauda_date>= @Sauda_date+ ' 00:00' and CD_Sauda_Date <= @Sauda_date+ ' 23:59'

Insert into MIMANSA.CRM.DBO.tbl_AngelNSEResetBrok
Select Party_code,ContractNo,Sauda_date,Turnover,NSEBrokerage,CD_Tot_Brok,Sett_no,Sett_Type,Flag1,SettCount,MaxTurnover,TurnoverBrok from AngelNSEResetBrok

Insert into CHARGES_DETAIL Select 
CD_Party_Code = Party_code,
CD_Sett_No = '', ---- SETT_NO is removed on 16-NOV-2022
CD_Sett_Type = Sett_type,
CD_Sauda_Date = Sauda_date,
CD_ContractNo = contractNo,
CD_Trade_No ='0000',
CD_Order_No ='',
CD_Scrip_Cd ='BROKERAGE',
CD_Series ='EQ',
CD_BuyRate =0,
CD_SellRate =0,
CD_TrdBuy_Qty =0,
CD_TrdSell_Qty =0,
CD_DelBuy_Qty =0,
CD_DelSell_Qty =0,
CD_TrdBuyBrokerage =0,
CD_TrdSellBrokerage =0,
CD_DelBuyBrokerage = CD_TOT_BROK,
CD_DelSellBrokerage =0,
CD_TotalBrokerage = CD_TOT_BROK,
CD_TrdBuySerTax = 0,
CD_TrdSellSerTax =0,
--CD_DelBuySerTax = CD_TOT_BROK * (14.5000 /100), -- Service Tax Rate changed by Mukesh on Nov 16 2015, as per requirement from Vijay Mali
CD_DelBuySerTax = CD_TOT_BROK * (18.0000 /100), -- Service Tax Rate changed by Rajesh on Jun 01 2016, as per requirement from Vijay Mali, Changed to 18 from 15 on 3rd July 2017 GST

CD_DelSellSerTax =0,
--CD_TotalSerTax = CD_TOT_BROK * (14.5000 /100), -- Service Tax Rate changed by Mukesh on Nov 16 2015, as per requirement from Vijay Mali
CD_TotalSerTax = CD_TOT_BROK * (18.0000 /100), -- Service Tax Rate changed by Rajesh on Jun 01 2016, as per requirement from Vijay Mali, Changed to 18 from 15 on 3rd July 2017 GST

CD_TrdBuy_TurnOver =0 ,
CD_TrdSell_TurnOver =0,
CD_DelBuy_TurnOver =0,
CD_DelSell_TurnOver =0,
CD_Computation_Level = '',
CD_Min_BrokAmt =30,
CD_Max_BrokAmt =-1,
CD_Min_ScripAmt = 0,
CD_Max_ScripAmt = -1 ,CD_TimeStamp = Getdate()
	from #Temp2
		Where sauda_date >= @Sauda_date+ ' 00:00' and sauda_date <= @Sauda_date+ ' 23:59' and Flag1 = 'Y'


		---- ADDED BY DHARMESH M on 16-NOV-2022

		SELECT DISTINCT SETT_NO,SETT_TYPE INTO #SETT FROM SETTLEMENT (NOLOCK)
			WHERE SAUDA_DATE >= @Sauda_date 	AND SAUDA_DATE <= @Sauda_date + ' 23:59'
				AND SETT_TYPE IN ('N','W','M','Z')

	
	UPDATE C SET CD_SETT_NO = SETT_NO FROM CHARGES_DETAIL C (NOLOCK), #SETT S (NOLOCK) 
	WHERE CD_SAUDA_DATE = @Sauda_date AND CD_SETT_NO = '' AND SETT_TYPE = CD_SETT_TYPE



--- Jammu and Kashmir Clients Service Tax set to ZERO :: Dharmesh


Insert into MIMANSA.CRM.DBO.tbl_charges_detail_NSE
Select a.* from charges_detail a join AngelNSEResetBrok b
On a.CD_Party_Code=b.Party_Code
 where CD_Sauda_Date >= @Sauda_date+ ' 00:00' and CD_Sauda_Date <= @Sauda_date+ ' 23:59'


IF (CONVERT(DATETIME,@Sauda_date) < 'OCT  1 2014')
BEGIN  
Update CHARGES_DETAIL set 
CD_TrdBuySerTax = 0,CD_TrdSellSerTax = 0,CD_DelBuySerTax = 0,CD_DelSellSerTax = 0,CD_TotalSerTax = 0
where CD_Sauda_date >= @Sauda_date+ ' 00:00' and CD_Sauda_date <= @Sauda_date+ ' 23:59' and CD_Trade_no <> '' and CD_Party_code in
(Select Cl_code from Client1 where L_State = 'JAMMU AND KASHMIR')
END

/* Below commented for ARPC */
If CONVERT(DATETIME,@Sauda_date) < 'AUG  1 2015'
Begin

     Select @@Maxdate = Max(Todate) from mimansa.bsedb_ab.dbo.Angel90daysbrokerage
		where Cast(Left(Convert(varchar,Todate,109),11) As Smalldatetime)<= Cast(@sauda_date As Smalldatetime)
     
	 Delete Angeldeletedchargesdetail  Where Sauda_date>= @Sauda_date+ ' 00:00' and Sauda_date <= @Sauda_date+ ' 23:59'

     Insert into Angeldeletedchargesdetail  
     Select CD_Party_Code,CD_Sett_No,CD_Sett_Type,CD_Sauda_Date,CD_ContractNo,CD_Trade_No,CD_Order_No,CD_Scrip_Cd,CD_Series,CD_BuyRate,CD_SellRate,
	 CD_TrdBuy_Qty,CD_TrdSell_Qty,CD_DelBuy_Qty,CD_DelSell_Qty,CD_TrdBuyBrokerage,CD_TrdSellBrokerage,CD_DelBuyBrokerage,CD_DelSellBrokerage,
	 CD_TotalBrokerage,CD_TrdBuySerTax,CD_TrdSellSerTax,CD_DelBuySerTax,CD_DelSellSerTax,CD_TotalSerTax,CD_TrdBuy_TurnOver,CD_TrdSell_TurnOver,
	 CD_DelBuy_TurnOver,CD_DelSell_TurnOver,CD_Computation_Level,CD_Min_BrokAmt,CD_Max_BrokAmt,CD_Min_ScripAmt,CD_Max_ScripAmt,CD_TimeStamp,
     Brokerage,TradeDays,Fromdate,Todate,Sauda_date = @Sauda_date
     From 
     CHARGES_DETAIL C, mimansa.bsedb_ab.dbo.Angel90daysbrokerage A
     Where
          C.CD_Party_code = A.Party_code
          and
          A.Todate = @@MaxDate
          and
          C.Cd_sauda_date>= @Sauda_date+ ' 00:00' and C.Cd_sauda_date <= @Sauda_date+ ' 23:59'
          and
          C.Cd_party_code >= ''
          and
          C.Cd_party_code <= 'ZZZZZZ'
          and
          C.Cd_scrip_cd = 'BROKERAGE'


          Delete Charges_detail From Angeldeletedchargesdetail  
          Where
          Charges_detail.CD_Party_code = Angeldeletedchargesdetail.cd_Party_code
          and charges_detail.cd_Scrip_cd = Angeldeletedchargesdetail.CD_Scrip_cd
          and
          Cast(Left(Convert(varchar,charges_detail.Cd_sauda_date,109),11) As SmallDatetime) =  Angeldeletedchargesdetail.Sauda_date
          and
          sauda_date >= @Sauda_date+ ' 00:00' and sauda_date <= @Sauda_date+ ' 23:59'
          and
          Charges_detail.Cd_scrip_cd = 'BROKERAGE'

End





/*
Print 'Going to Insert data in ContractData'
 Removed Call from Dharmesh Jun 30 2010 Insertion of data in to Contract_data table is handled by Backoffice vendor 
Select * into #Charges From
(Select CONTRACTNO ='0',PARTY_CODE = CD_PARTY_CODE,ORDER_NO ='',ORDER_TIME ='',TM ='',TRADE_NO = CD_TRADE_NO ,SAUDA_DATE = CD_SAUDA_DATE,
SCRIP_CD = CD_SCRIP_CD,SERIES = CD_SERIES,SCRIPNAME='BROKERAGE',
SDT =convert(varchar,Cd_Sauda_date,103),SELL_BUY = 1,BROKER_CHRG =0,
TURN_TAX =0,SEBI_TAX =0,OTHER_CHRG =0,INS_CHRG =0,SERVICE_TAX = CD_TotalSerTax,NSERTAX = CD_TotalSerTax,
SAUDA_DATE1 = Left(Convert(Varchar,cd_Sauda_date,109),11),
PQTY =0,SQTY =0,PRATE =0,SRATE =0,PBROK =0,SBROK =0,PNETRATE =0,SNETRATE =0,PAMT =CD_TotalBrokerage,SAMT =0,
BROKERAGE = CD_TotalBrokerage,SETT_NO = CD_SETT_NO,SETT_TYPE = Cd_SETT_TYPE,TRADETYPE ='',TMARK ='',PRINTF = 2,ORDERFLAG = 4,
SCRIPNAMEForOrderBy ='ZZZZZBROKERAGE',
SCRIPNAME1 ='',ActSell_buy = 1,ISIN ='',ROUNDTO = 2
From 
charges_detail
Where
cd_sett_no = @@Sett_no
and
CD_TRADE_NO = '0000'
)A
Print 'Records in #Charges '
Select count(*) from #Charges

Delete #Charges From CONTRACT_data where
CONTRACT_data.Party_code = #Charges.Party_code
and
CONTRACT_data.Scrip_cd = #Charges.Scrip_cd
and
CONTRACT_data.Scrip_cd = 'Brokerage'
and
CONTRACT_data.Sett_no = @@Sett_no

Print 'Records in #Charges after Delete'

Select * from #Charges


Insert into CONTRACT_data
Select CONTRACTNO ='0',PARTY_CODE = PARTY_CODE,ORDER_NO ='',ORDER_TIME ='',TM ='',TRADE_NO = TRADE_NO ,
SAUDA_DATE = SAUDA_DATE,SCRIP_CD = SCRIP_CD,
SERIES = SERIES,SCRIPNAME='BROKERAGE',
SDT =convert(varchar,Sauda_date,103),SELL_BUY = 1,BROKER_CHRG =0,
TURN_TAX =0,SEBI_TAX =0,OTHER_CHRG =0,INS_CHRG =0,SERVICE_TAX = Service_tax,NSERTAX = NSertax,
SAUDA_DATE1 = Left(Convert(Varchar,Sauda_date,109),11),
PQTY =0,SQTY =0,PRATE =0,SRATE =0,PBROK =0,SBROK =0,PNETRATE =0,SNETRATE =0,PAMT =Brokerage,SAMT =0,
BROKERAGE = Brokerage,SETT_NO = SETT_NO,SETT_TYPE = SETT_TYPE,TRADETYPE ='',TMARK ='',PRINTF = 2,ORDERFLAG = 4,SCRIPNAMEForOrderBy ='ZZZZZBROKERAGE',
SCRIPNAME1 ='',ActSell_buy = 1,ISIN ='',ROUNDTO = 2
From #charges


End Of Comment Removed Call from Dharmesh Jun 30 2010 Insertion of data in to Contract_data table is handled by Backoffice vendor 
*/

GO
