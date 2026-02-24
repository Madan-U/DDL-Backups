-- Object: PROCEDURE dbo.RemissorAccValan
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.RemissorAccValan    Script Date: 05/20/2002 2:25:52 PM ******/
CREATE Proc RemissorAccValan (@Sett_No Varchar(7),@Sett_Type Varchar(2)) As

Delete from RemissorValan where Sett_no = @Sett_no and Sett_type = @Sett_Type
insert into RemissorValan 
Select B.Sett_no,B.Sett_Type,B.Sub_Broker,B.Scrip_cd,b.series,B.Party_Code,
NewBrokeRage=Sum(B.TradeQty*B.BrokApplied),OldBrokeRage=P.TradeQty*P.BrokApplied,
RemtrdBrok = Sum(B.TradeQty*B.TrdBrok),RemDelBrok = Sum(B.TradeQty*B.DelBrok),
PartyTrdBrok = P.TrdBrok,PartyDelBrok = P.DelBrok,
TrdTurn = P.TrdTurnOver,DelTurn = P.DelTurnOver
from RemissorBrok B, RemissorBrokParty P
Where B.Sett_no = P.Sett_No and B.Sett_Type = P.Sett_type
and B.Sub_Broker = P.Sub_Broker and B.Party_code = P.Party_code 
and B.Scrip_cd = P.Scrip_cd and Perc_Slab = 1
and B.Sett_no = @Sett_no and B.Sett_type = @Sett_Type
Group by B.Sett_no,B.Sett_Type,B.Sub_Broker,B.Scrip_cd,B.Series,B.Party_Code,
P.TradeQty,P.BrokApplied,P.TrdBrok,P.DelBrok,P.TrdTurnOver,P.DelTurnOver
union all
Select B.Sett_no,B.Sett_Type,B.Sub_Broker,B.Scrip_cd,B.series,B.Party_Code,
NewBrokeRage=B.TradeQty*B.BrokApplied*com_perc/100,OldBrokeRage=B.TradeQty*B.BrokApplied,
RemtrdBrok = Sum(B.TradeQty*B.TrdBrok)*com_perc/100,RemDelBrok = Sum(B.TradeQty*B.DelBrok)*com_perc/100,
PartyTrdBrok = B.TrdBrok,PartyDelBrok = B.DelBrok,
TrdTurn = B.TrdTurnOver,DelTurn = B.DelTurnOver
from RemissorBrokParty B Where Perc_Slab = 0 
and Sett_no = @Sett_no and Sett_type = @Sett_Type
Group by B.Sett_no,B.Sett_Type,B.Sub_Broker,B.Scrip_cd,B.Series,B.Party_Code,
B.TradeQty,B.BrokApplied,com_perc,B.TrdBrok,B.DelBrok,B.TrdTurnOver,B.DelTurnOver

Delete From RemissorBill Where Sett_no = @Sett_no and Sett_type = @Sett_Type

insert into RemissorBill
select Sub_broker,Party_Code,sell_buy=2,R.Sett_No,R.Sett_Type,Start_Date,End_Date,PayIn_Date=Funds_Payin,PayOut_Date=Funds_PayOut,Amount=Sum(OldBrokerage - NewBrokeRage),Client_Amount=sum(OldBrokerage),
RemTrdBrok = Sum(RemTrdBrok),RemDelBrok = Sum(RemDelBrok),
PartyTrdBrok = Sum(PartyTrdBrok),PartyDelBrok = Sum(PartyDelBrok),
TrdTurn = Sum(TrdTurn),PartyDelBrok = Sum(DelTurn)
from remissorValan R,Sett_Mst S
where R.Sett_no = S.Sett_no and R.Sett_type = S.Sett_Type
And R.Sett_no = @Sett_no and R.Sett_type = @Sett_Type
group by R.Sett_No,R.Sett_Type,Sub_Broker,Party_Code,Start_Date,End_Date,Funds_Payin,Funds_PayOut

insert into RemissorBill
select '99990','99990',sell_buy=1,Sett_No,Sett_Type,Start_Date,End_Date,PayIn_Date,PayOut_Date,Amount=Sum(Amount),Client_Amount=0,
RemTrdBrok = Sum(RemTrdBrok),RemDelBrok = Sum(RemDelBrok),
PartyTrdBrok = Sum(PartyTrdBrok),PartyDelBrok = Sum(PartyDelBrok),
TrdTurn = Sum(TrdTurn),
DelTurn = Sum(DelTurn) from RemissorBill
where Sett_no = @Sett_no and Sett_type = @Sett_Type
group by Sett_No,Sett_Type,Start_Date,End_Date,PayIn_Date,PayOut_Date

GO
