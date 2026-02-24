-- Object: PROCEDURE dbo.Rpt_NseInternalShortage_New
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc [dbo].[Rpt_NseInternalShortage_New](@Sett_no Varchar(7), @Sett_Type Varchar(2)) as       
set transaction isolation level read uncommitted      
Truncate table DelInterMarketShrt_New      
       
Insert Into DelInterMarketShrt_New       
select Sett_no,Sett_Type,Party_Code,Scrip_CD,Series,      
ToRecQty=(case When InOut = 'I' Then Qty Else 0 End),      
ToGiveQty=(case When InOut = 'O' Then Qty Else 0 End),      
Rec          = 0,      
Give         = 0      
From DeliveryClt (nolock)       
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type      
      
insert Into DelInterMarketShrt_New      
select Sett_no,Sett_Type,Party_Code,Scrip_CD,Series,      
ToRecQty  = Sum (Case When DrCr = 'C' Then Qty Else 0 End),      
ToGiveQty = Sum (Case When DrCr = 'C' Then Qty Else 0 End),      
Rec          = 0,      
Give         = 0      
From DelTrans with(index(delhold),nolock) Where Sett_No = @Sett_No And Sett_Type = @Sett_Type      
And Filler2 = 1 And TrType <> 906 And shareType <> 'AUCTION' And Party_Code <> 'BROKER'      
And Party_Code Not in ( Select Party_Code From DelInterMarketShrt_New Where Scrip_Cd = DelTrans.Scrip_Cd And Series = DelTrans.Series)      
Group by Sett_no,Sett_Type,Party_Code,Scrip_CD,Series      
      
Update DelInterMarketShrt_New      
Set Rec = CQty,       
Give = DQty From       
(      
Select D.Sett_No, D.Sett_Type, D.Party_Code, D.Scrip_Cd, D.Series,       
CQty = Sum (Case When DrCr = 'C' Then Qty Else 0 End),       
DQty = Sum (Case When DrCr = 'D' Then Qty Else 0 End)      
From DelTrans D      
Where D.Sett_No = @Sett_No And D.Sett_Type = @Sett_Type      
And Filler2 = 1 And shareType <> 'AUCTION'        
Group By D.Sett_No, D.Sett_Type, D.Party_Code, D.Scrip_Cd, D.Series) D      
Where DelInterMarketShrt_New.Sett_No = D.Sett_No      
And DelInterMarketShrt_New.Sett_Type = D.Sett_Type      
And DelInterMarketShrt_New.Party_Code = D.Party_Code      
And DelInterMarketShrt_New.Scrip_Cd = D.Scrip_cd      
And DelInterMarketShrt_New.Series = D.Series
      
Select Sett_no,Sett_Type,Scrip_cd, Series,      
NetShort =  (Case When abs(Sum(Case When Qty < 0 Then Qty Else 0 End)) > Abs(Sum(Case When Qty > 0 Then Qty Else 0 End))      
                         Then abs(Sum(Case When Qty > 0 Then Qty Else 0 End))      
                         Else abs(Sum(Case When Qty < 0 Then Qty Else 0 End))      
                  End)      
From (       
Select Sett_no,Sett_Type,Party_Code,Scrip_cd, Series, Qty=Sum(ToRecQty-ToGiveQty-Rec+Give)       
from DelInterMarketShrt_New      
Group by Sett_no,Sett_Type,Party_Code,Scrip_Cd, Series      
Having Sum(ToRecQty-ToGiveQty-Rec+Give) <> 0 ) A      
Group By Sett_no,Sett_Type,Scrip_Cd, Series      
having (Case When abs(Sum(Case When Qty < 0 Then Qty Else 0 End)) > Abs(Sum(Case When Qty > 0 Then Qty Else 0 End))      
                         Then abs(Sum(Case When Qty > 0 Then Qty Else 0 End))      
                         Else abs(Sum(Case When Qty < 0 Then Qty Else 0 End))      
                  End) <> 0       
Order by Scrip_cd, Series

GO
