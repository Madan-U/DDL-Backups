-- Object: PROCEDURE dbo.RPT_DELHOLDMATCH
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC RPT_DELHOLDMATCH 
( @CltDpId Varchar(16),
  @DpId Varchar(8) )
AS
If Len(@CltDpId) > 8 
Begin
Select IsIn=ISNull(CertNo,A.IsIn),Scrip_cd=A.Scrip_Cd,
Qty=Sum((Case When Delivered = '0' Then Qty Else 0 End)),
FreeQty=Sum((Case When TrType <> 909 Then (Case When Delivered = '0' Then Qty Else 0 End) Else 0 End)) ,
PledgeQty=Sum((Case When TrType = 909 Then Qty Else 0 End)),HoldQty=Isnull(CurrBal,0),
HoldFreeQty=IsNull(FreeBal,0),HoldPledgeQty=IsNull(PledgeBal,0),
/*ToDayQty=Sum(Case When Convert(Varchar,TransDate,106) = Convert(Varchar,GetDate(),106) And Delivered = 'G' Then Qty Else 0 End) */
ToDayQty=Sum(Case When Convert(DateTime,Convert(Varchar,TransDate,106) + ' 23:59:59') >= GetDate() And Delivered = 'G' Then Qty Else 0 End) 
From DelTrans D Left Outer Join RPT_DelCdslBalance A 
On ( A.IsIn = CertNo AND BCltDpId = a.CltDpId And BDpId = A.DpId) 
Where BCltDpId = @CltDpId And BDpId = @DpId And Drcr = 'D' 
And Delivered <> 'D' And Filler2 = 1 And CertNo Like 'IN%' And TrType <> 906  
Group by ISNull(CertNo,A.IsIn),A.Scrip_CD,FreeBal,CurrBal,PledgeBal 
Having ( Sum((Case When Delivered = '0' Then Qty Else 0 End)) <> 0 
Or Sum((Case When TrType <> 909 Then (Case When Delivered = '0' Then Qty Else 0 End) Else 0 End)) <> 0 
Or Sum((Case When TrType = 909 Then Qty Else 0 End)) <> 0 
Or Isnull(CurrBal,0) <> 0 Or IsNull(FreeBal,0) <> 0 Or IsNull(PledgeBal,0) <> 0 
Or Sum(Case When Convert(DateTime,Convert(Varchar,TransDate,106) + ' 23:59:59') >= GetDate() And Delivered = 'G' Then Qty Else 0 End) <> 0 )
union all Select IsIn=A.IsIn,Scrip_cd=S2.Scrip_Cd,Qty=0,FreeQty=0,PledgeQty=0,HoldQty=Isnull(CurrBal,0),
HoldFreeQty=IsNull(FreeBal,0),HoldPledgeQty=IsNull(PledgeBal,0),ToDayQty=0 
From Scrip2 S2, RPT_DelCdslBalance A Where CltDpId = @CltDpId
And DpId = @DpId And S2.Scrip_Cd = A.Scrip_Cd And S2.Series = A.Series And 
A.IsIn not in ( Select Distinct CertNo From DelTrans D where BCltDpId = a.CltDpId And 
BDpId = A.DpId And A.IsIn = CertNo 
And Drcr = 'D' And Delivered <> 'D' And Filler2 = 1 And CertNo Like 'IN%' And TrType <> 906 ) 
Group by A.IsIn,S2.Scrip_CD,FreeBal,CurrBal,PledgeBal 
Having ( Isnull(CurrBal,0) <> 0 Or IsNull(FreeBal,0) <> 0 Or IsNull(PledgeBal,0) <> 0 )
Order By S2.Scrip_CD 
End
Else
Begin
Select IsIn=ISNull(CertNo,A.IsIn),Scrip_Cd=D.Scrip_cd+' ('+ D.Sett_no + '-' + D.Sett_Type + ')' ,
Qty=Sum((Case When Delivered = '0' Then Qty Else 0 End)),
FreeQty=Sum((Case When TrType <> 909 Then (Case When Delivered = '0' Then Qty Else 0 End) Else 0 End)) ,
PledgeQty=Sum((Case When TrType = 909 Then Qty Else 0 End)),HoldQty=Isnull(CurrBal,0),
HoldFreeQty=IsNull(FreeBal,0),HoldPledgeQty=IsNull(PledgeBal,0),
/*ToDayQty=Sum(Case When Convert(Varchar,TransDate,106) = Convert(Varchar,GetDate(),106) And Delivered = 'G' Then Qty Else 0 End) */
ToDayQty=Sum(Case When Convert(DateTime,Convert(Varchar,TransDate,106) + ' 23:59:59') >= GetDate() And Delivered = 'G' Then Qty Else 0 End) 
From DelTrans D Left Outer Join DelCdslBalanceView A 
On ( A.IsIn = CertNo AND BCltDpId = a.CltDpId And BDpId = A.DpId And A.Party_Code= D.Sett_No+'-'+D.Sett_Type) 
Where BCltDpId = @CltDpId And BDpId = @DpId And Drcr = 'D' 
And Filler2 = 1 And CertNo Like 'IN%' And TrType <> 906 
Group by D.Sett_no,D.Sett_Type,ISNull(CertNo,A.IsIn),D.Scrip_CD,FreeBal,CurrBal,PledgeBal 
Having ( Sum((Case When Delivered = '0' Then Qty Else 0 End)) <> 0 
Or Sum((Case When TrType <> 909 Then (Case When Delivered = '0' Then Qty Else 0 End) Else 0 End)) <> 0 
Or Sum((Case When TrType = 909 Then Qty Else 0 End)) <> 0 
Or Isnull(CurrBal,0) <> 0 Or IsNull(FreeBal,0) <> 0 Or IsNull(PledgeBal,0) <> 0 
Or Sum(Case When Convert(DateTime,Convert(Varchar,TransDate,106) + ' 23:59:59') >= GetDate() And Delivered = 'G' Then Qty Else 0 End) <> 0 )
Union All
Select IsIn=A.IsIn,Scrip_cd=S2.Scrip_Cd+ ' (' + Party_Code + ')',Qty=0,FreeQty=0,PledgeQty=0,HoldQty=Isnull(CurrBal,0),
HoldFreeQty=IsNull(FreeBal,0),HoldPledgeQty=IsNull(PledgeBal,0),ToDayQty=0 
From Scrip2 S2, DelCdslBalanceView A Where CltDpId = @CltDpId
And DpId = @DpId And S2.Scrip_Cd = A.Scrip_Cd And S2.Series = A.Series And 
A.IsIn not in ( Select Distinct CertNo From DelTrans D where BCltDpId = a.CltDpId And 
BDpId = A.DpId And A.IsIn = CertNo And S2.Scrip_Cd = D.Scrip_Cd And S2.Series = D.Series 
And Drcr = 'D' And Delivered <> 'D' And Filler2 = 1 And CertNo Like 'IN%' And TrType <> 906 ) 
Order By D.Scrip_Cd
End

GO
