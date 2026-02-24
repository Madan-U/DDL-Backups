-- Object: PROCEDURE dbo.STT_Charges_Exchg
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




CREATE Proc STT_Charges_Exchg (@Sauda_Date Varchar(11)) As
Declare @Party_Code Varchar(10),
@OrgParty_Code Varchar(10),
@Sett_No Varchar(7),
@Scrip_Cd Varchar(12),
@Series Varchar(2),
@Amt Numeric(18,4),
@Trade_No Varchar(14),
@Order_No Varchar(16),
@TotTax Numeric(18,4),
@Sett_Type Varchar(2), 
@STTCur Cursor

update settlement set ins_chrg = 0
where
sauda_date like @Sauda_Date + '%' and 
auctionpart not in ('AP','AR','FP','FL','FA','FC') and
trade_no not like '%C%'

Select Sett_No, Sett_Type, Branch_Id, Scrip_Cd, Series, Trade_No = Min(Trade_No) 
Into #SettSTT From Settlement Where Sauda_Date Like @Sauda_Date + '%' And TradeQty > 0 
And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')  And trade_no not like '%C%'
Group By Sett_No, Sett_Type, Branch_Id, Scrip_Cd, Series

Update Settlement Set Ins_Chrg = TotalSTT 
From STT_Exchg S, #SettStt A
Where Settlement.Sett_Type = S.Sett_Type
And Sauda_Date Like @Sauda_Date + '%' And TradeQty > 0 
And Settlement.Scrip_Cd = S.Scrip_CD
And Settlement.Series = S.Series
And Settlement.Branch_id = S.Party_Code  
And Settlement.Sett_No = A.Sett_No
And Settlement.Sett_Type = A.Sett_Type
And Settlement.Scrip_Cd = A.Scrip_CD
And Settlement.Series = A.Series
And Settlement.Branch_id = A.Branch_Id
And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')
And Settlement.Trade_No = A.Trade_No
And RecType = 30 

update isettlement set ins_chrg = 0
where
sauda_date like @Sauda_Date + '%' and 
auctionpart not in ('AP','AR','FP','FL','FA','FC') and
trade_no not like '%C%'

Select Sett_No, Sett_Type, ContractNo, Branch_Id, Scrip_Cd, Series, Trade_No = Min(Trade_No) 
Into #ISettSTT From iSettlement Where Sauda_Date Like @Sauda_Date + '%' And TradeQty > 0 
And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')  And trade_no not like '%C%'
Group By Sett_No, Sett_Type, ContractNo, Branch_Id, Scrip_Cd, Series

Update iSettlement Set Ins_Chrg = TotalSTT 
From STT_Exchg S, #ISettStt A
Where iSettlement.Sett_Type = S.Sett_Type
And Sauda_Date Like @Sauda_Date + '%' And TradeQty > 0 
And iSettlement.Scrip_Cd = S.Scrip_CD
And iSettlement.Series = S.Series
And iSettlement.Branch_id = S.Party_Code  
And iSettlement.Sett_No = A.Sett_No
And iSettlement.Sett_Type = A.Sett_Type
And iSettlement.Scrip_Cd = A.Scrip_CD
And iSettlement.Series = A.Series
And iSettlement.Branch_id = A.Branch_Id
And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')
And iSettlement.Trade_No = A.Trade_No
And RecType = 30 

Select Branch_Id, Sett_No, Sett_Type, ActChrg = Sum(Ins_Chrg), TobeChrg = Round(Sum(Ins_Chrg),0) 
Into #AniSettRound From Settlement 
Where Sauda_Date Like @Sauda_Date + '%' And TradeQty > 0 
And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')
Group By Branch_Id, Sett_No, Sett_Type

Select S.Sett_No, S.Sett_Type, S.Branch_Id, Trade_No = Min(Trade_No) 
Into #SettSTTParty From Settlement S, #AniSettRound A 
Where Sauda_Date Like @Sauda_Date + '%' And TradeQty > 0 
And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')
And A.Sett_Type = S.Sett_Type
And A.Sett_No = S.Sett_No
And A.Branch_Id = S.Branch_Id
And Ins_Chrg >= (Case When ToBeChrg-ActChrg < 0 Then abs(ToBeChrg-ActChrg) Else 0 End)
And Ins_Chrg > 0  
Group By S.Sett_No, S.Sett_Type, S.Branch_Id

Update Settlement set Ins_Chrg = 0 
Where Sauda_Date Like @Sauda_Date + '%' And TradeQty > 0 
And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')
And Branch_Id in ( Select Branch_Id From #AniSettRound A
Where Settlement.Sett_No = A.Sett_No
And Settlement.Sett_Type = A.Sett_Type
And Settlement.Branch_id = A.Branch_Id
And TobeChrg = 0)

Update Settlement Set Ins_Chrg = Ins_Chrg + (ToBeChrg-ActChrg)
From #SettSTTParty A, #AniSettRound S
Where Sauda_Date Like @Sauda_Date + '%' And TradeQty > 0 
And Settlement.Sett_No = A.Sett_No
And Settlement.Sett_Type = A.Sett_Type
And Settlement.Branch_id = A.Branch_Id
And Settlement.Sett_No = S.Sett_No
And Settlement.Sett_Type = S.Sett_Type
And Settlement.Branch_id = S.Branch_Id
And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')
And Settlement.Trade_No = A.Trade_No

Select Branch_Id, Sett_No, Sett_Type, ActChrg = Sum(Ins_Chrg), TobeChrg = Round(Sum(Ins_Chrg),0) 
Into #AniISettRound From iSettlement 
Where Sauda_Date Like @Sauda_Date + '%' And TradeQty > 0 
And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')
Group By Branch_Id, Sett_No, Sett_Type

Select S.Sett_No, S.Sett_Type, S.Branch_Id, Trade_No = Min(Trade_No) 
Into #ISettSTTParty From iSettlement S, #AniISettRound A 
Where Sauda_Date Like @Sauda_Date + '%' And TradeQty > 0 
And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')
And A.Sett_Type = S.Sett_Type
And A.Sett_No = S.Sett_No
And A.Branch_Id = S.Branch_Id
And Ins_Chrg >= (Case When ToBeChrg-ActChrg < 0 Then abs(ToBeChrg-ActChrg) Else 0 End)
And Ins_Chrg > 0 
Group By S.Sett_No, S.Sett_Type, S.Branch_Id

Update iSettlement set Ins_Chrg = 0 
Where Sauda_Date Like @Sauda_Date + '%' And TradeQty > 0 
And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')
And Branch_Id in ( Select Branch_Id From #AniISettRound A
Where iSettlement.Sett_No = A.Sett_No
And iSettlement.Sett_Type = A.Sett_Type
And iSettlement.Branch_id = A.Branch_Id
And TobeChrg = 0)

Update iSettlement Set Ins_Chrg = Ins_Chrg + (ToBeChrg-ActChrg)
From #ISettSTTParty A, #AniISettRound S
Where Sauda_Date Like @Sauda_Date + '%' And TradeQty > 0 
And iSettlement.Sett_No = A.Sett_No
And iSettlement.Sett_Type = A.Sett_Type
And iSettlement.Branch_id = A.Branch_Id
And iSettlement.Sett_No = S.Sett_No
And iSettlement.Sett_Type = S.Sett_Type
And iSettlement.Branch_id = S.Branch_Id
And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')
And iSettlement.Trade_No = A.Trade_No

Delete From STT_ClientDetail Where Sauda_Date Like @Sauda_Date + '%' 

Insert Into STT_ClientDetail
Select RecType,Sett_no,Sett_Type,'0',Party_Code,Scrip_Cd,Series,Stt_Date,
Party_Code,AvgRate,TPQtyDel,TPAmtDel,TPSTTDel,AvgRate,TSQtyDel,TSAmtDel,TSSTTDel,
AvgRate,TSQtyTrd,TSAmtTrd,TSSTTTrd,TotalSTT From STT_Exchg 
Where Stt_Date Like @Sauda_Date + '%' 

Update STT_ClientDetail Set ContractNo = S.ContractNo
From Settlement S Where S.Sauda_Date Like @Sauda_Date + '%'
And STT_ClientDetail.Sauda_Date Like @Sauda_Date + '%'
And RecType = 30 And S.Sett_Type = STT_ClientDetail.Sett_Type
And S.Scrip_Cd = STT_ClientDetail.Scrip_cd And S.Series = STT_ClientDetail.Series
And S.Branch_Id = STT_ClientDetail.Party_Code And Trade_No Like '%C%'

Update STT_ClientDetail Set ContractNo = S.ContractNo
From ISettlement S Where S.Sauda_Date Like @Sauda_Date + '%'
And STT_ClientDetail.Sauda_Date Like @Sauda_Date + '%'
And RecType = 20 And S.Sett_Type = STT_ClientDetail.Sett_Type
And S.Scrip_Cd = STT_ClientDetail.Scrip_cd And S.Series = STT_ClientDetail.Series
And S.Branch_Id = STT_ClientDetail.Party_Code And Trade_No Like '%C%'

GO
