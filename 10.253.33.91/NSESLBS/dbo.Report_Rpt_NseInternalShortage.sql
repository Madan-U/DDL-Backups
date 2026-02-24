-- Object: PROCEDURE dbo.Report_Rpt_NseInternalShortage
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------







/****** Object:  Stored Proc Report_dbo.Rpt_NseInternalShortage    Script Date: 04/02/2004 11:47:37 AM ******/
CREATE Proc Report_Rpt_NseInternalShortage(@Sett_no Varchar(7), @Sett_Type Varchar(2)) as 

Truncate table DelInterMarketShrt
Insert into DelInterMarketShrt
select Sett_no,Sett_Type,Party_Code,Scrip_CD,Series,
ToRecQty=(case When InOut = 'I' Then Qty Else 0 End),
ExRecQty = 0, 
ToGiveQty=(case When InOut = 'O' Then Qty Else 0 End),
ExGiveQty = 0,
Rec          = 0,
Give         = 0
From DeliveryClt_Report Where Sett_No = @Sett_No And Sett_Type = @Sett_Type

Insert into DelInterMarketShrt
select Sett_no,Sett_Type,Party_Code,Scrip_CD,Series,
ToRecQty  = 0,
ExRecQty  =Sum (Case When DrCr = 'C' Then Qty Else 0 End), 
ToGiveQty = 0,
ExGiveQty = 0,
Rec          = 0,
Give         = 0
From Deltrans_Report Where Sett_No = @Sett_No And Sett_Type = @Sett_Type
And Filler2 = 1 And TrType <> 906 And shareType = 'DEMAT' And Party_Code <> 'BROKER'
And Party_Code Not in ( Select Party_Code From DeliveryClt_Report Where Sett_No = @Sett_No And Sett_Type = @Sett_Type)
Group by Sett_no,Sett_Type,Party_Code,Scrip_CD,Series

Update DelInterMarketShrt Set Rec = IsNull((Select Sum(Qty) From Deltrans_Report Where Sett_No = @Sett_No And Sett_Type = @Sett_Type
And Filler2 = 1 And shareType = 'DEMAT' And Party_Code = DelInterMarketShrt.Party_Code And Scrip_Cd = DelInterMarketShrt.Scrip_CD
And Series = DelInterMarketShrt.Series And DrCr = 'C'),0)
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type

Update DelInterMarketShrt Set ExRecQty = Rec - ToRecQty Where Rec > ToRecQty
And Sett_No = @Sett_No And Sett_Type = @Sett_Type

Select D.Scrip_Cd, D.Series, RecQty=Sum(ToRecQty+ExRecQty),GiveQty=Sum(ToGiveQty+ExRecQty),
Rec=Sum(Rec),ExQty=Sum(ToRecQty-ToGiveQty),
shortage = (case When Sum(ToRecQty-ToGiveQty) > 0 
		  Then (Case When Sum(ToGiveQty+ExRecQty) > 0 
			       Then (Case When Sum(ToRecQty+ExRecQty)-sum(Rec)  < Sum(ToGiveQty+ExRecQty) 
					 Then Sum(ToRecQty+ExRecQty)-sum(Rec) 
					 Else Sum(ToGiveQty+ExRecQty) 
      				    End )					
		                   Else 0 
		           End )		 
		  Else Sum(ToGiveQty+ExRecQty)+Sum(ToRecQty-ToGiveQty)-Sum(Rec) 
	      End)
From DelInterMarketShrt D
Group By D.Scrip_Cd, D.Series
Having (case When Sum(ToRecQty-ToGiveQty) > 0 
		  Then (Case When Sum(ToGiveQty+ExRecQty) > 0 
			       Then Sum(ToRecQty+ExRecQty)-sum(Rec) 
		                   Else 0 End )		 
		  Else Sum(ToGiveQty+ExRecQty)+Sum(ToRecQty-ToGiveQty)-Sum(Rec) 
	      End) <> 0 
Order By D.Scrip_Cd, D.Series

GO
