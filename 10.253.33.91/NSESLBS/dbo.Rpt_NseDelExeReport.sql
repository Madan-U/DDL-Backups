-- Object: PROCEDURE dbo.Rpt_NseDelExeReport
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_NseDelExeReport   
(@TDate Varchar(11),  
 @BDpId Varchar(8),  
 @BCltDpId Varchar(16),  
 @FParty Varchar(10),  
 @TParty Varchar(10),  
 @FScrip Varchar(12),  
 @TScrip Varchar(12)  
) As  
/* Pool To Client Trans */  
Set Transaction Isolation level read uncommitted  
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,Scrip_CD,Series,Qty=Sum(Qty),CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type,Remark='Pay-Out'   
From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2 Where DrCr = 'D' And Delivered = 'D'  
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType In ( 904 , 905 )  
and TransDate Like @TDate + '%' And Dp.Description Like '%POOL%' And Filler2 = 1   
And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId   
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code  
And D.Party_Code >= @FParty And D.Party_Code <= @TParty  
And Scrip_Cd >= @FScrip And Scrip_Cd <= @TScrip  
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,Scrip_CD,Series,CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type  
Union All  
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,Scrip_CD,Series,Qty=Sum(Qty),CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type,Remark='Pay-Out'   
From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2 Where DrCr = 'D' And Delivered = 'G'  
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType In ( 904 , 905 )  
And Dp.Description Like '%POOL%' And Filler2 = 1   
And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId   
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code  
And D.Party_Code >= @FParty And D.Party_Code <= @TParty  
And Scrip_Cd >= @FScrip And Scrip_Cd <= @TScrip  
And D.SNo in ( Select Sno From DelTransTemp Where BDpId = @BDpId And BCltDpId = @BCltDpId and TransDate Like @TDate + '%')   
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,Scrip_CD,Series,CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type  
Union All  
/* Pool To Pool InterSett */  
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,Scrip_CD,Series,Qty=Sum(Qty),CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type,Remark='Inter Sett'   
From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2  Where DrCr = 'D' And Delivered in ('G','D')  
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType = 907  
and TransDate Like @TDate + '%' And Dp.Description Like '%POOL%' And Filler2 = 1   
And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId   
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code  
And D.Party_Code >= @FParty And D.Party_Code <= @TParty  
And Scrip_Cd >= @FScrip And Scrip_Cd <= @TScrip  
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,Scrip_CD,Series,CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type  
Union All  
/* Pool To Ben Trans */  
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,Scrip_CD,Series,Qty=Sum(Qty),CertNo,FromNo,D.DpType,DP1.DpId,CltDpId=DP1.DpCltNo,ISett_No,ISett_Type,Remark='Pool To Ben'   
From DelTrans D, DeliveryDp DP, DeliveryDp Dp1, Client1 C1, Client2 C2  Where DrCr = 'D' And Delivered = 'G'  
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType In ( 904 , 905 )  
and TransDate Like @TDate + '%' And Dp.Description Like '%POOL%'  
And Dp1.Description Not Like '%POOL%' And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId   
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code  
And D.Party_Code >= @FParty And D.Party_Code <= @TParty  
And Scrip_Cd >= @FScrip And Scrip_Cd <= @TScrip  
And TCode in (Select TCode From DelTrans Where DrCr = 'D'   
And BDpId = Dp1.DpId And BCltDpId = Dp1.DpCltNo And Party_Code = D.Party_Code   
And Scrip_Cd = D.Scrip_Cd )  
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,Scrip_CD,Series,CertNo,FromNo,D.DpType,DP1.DpId,DP1.DpCltNo,ISett_No,ISett_Type  
Union All  
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,Scrip_CD,Series,Qty=Sum(Qty),CertNo,FromNo,D.DpType,DP1.DpId,CltDpId=DP1.DpCltNo,ISett_No,ISett_Type,Remark='Pool To Ben'   
From DelTrans D, DeliveryDp DP, DeliveryDp Dp1, Client1 C1, Client2 C2  Where DrCr = 'D' And Delivered = 'G'  
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType In ( 904 , 905 )  
And Dp.Description Like '%POOL%'  
And Dp1.Description Not Like '%POOL%' And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId   
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code  
And D.Party_Code >= @FParty And D.Party_Code <= @TParty  
And Scrip_Cd >= @FScrip And Scrip_Cd <= @TScrip  
And D.Sno in (Select Sno From DelTransTemp Where BDpId = Dp1.DpId And BCltDpId = Dp1.DpCltNo And Party_Code = D.Party_Code   
And Scrip_Cd = D.Scrip_Cd and TransDate Like @TDate + '%' )  
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,Scrip_CD,Series,CertNo,FromNo,D.DpType,DP1.DpId,DP1.DpCltNo,ISett_No,ISett_Type  
Union All  
/* Ben To Client Trans */  
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,Scrip_CD,Series,Qty=Sum(Qty),CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type,Remark='Ben To Client'   
From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2  Where DrCr = 'D' And Delivered = 'D'  
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType In ( 904 , 905 )  
and TransDate Like @TDate + '%' And Dp.Description Not Like '%POOL%' And Filler2 = 1  
And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId   
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code  
And D.Party_Code >= @FParty And D.Party_Code <= @TParty  
And Scrip_Cd >= @FScrip And Scrip_Cd <= @TScrip  
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,Scrip_CD,Series,CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type  
Union All  
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,Scrip_CD,Series,Qty=Sum(Qty),CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type,Remark='Ben To Client'   
From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2  Where DrCr = 'D' And Delivered = 'G'  
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType In ( 904 , 905 )  
And Dp.Description Not Like '%POOL%' And Filler2 = 1  
And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId   
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code  
And D.Party_Code >= @FParty And D.Party_Code <= @TParty  
And Scrip_Cd >= @FScrip And Scrip_Cd <= @TScrip  
And D.Sno In ( Select SNo From DelTransTemp Where DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId and TransDate Like @TDate + '%')  
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,Scrip_CD,Series,CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type  
Union All  
/* Ben To Pool InterSett */  
Select Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,Scrip_CD,Series,Qty=Sum(Qty),CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type,Remark='Ben To Pool'   
From DelTrans D, DeliveryDp DP, Client1 C1, Client2 C2  Where DrCr = 'D' And Delivered in ('G','D')  
And D.BDpId = Dp.DpId And BCltDpId = Dp.DpCltNo And TrType = 1000  
and TransDate Like @TDate + '%' And Dp.Description Not Like '%POOL%' And Filler2 = 1   
And DP.DpId = @BDpId And DP.DpCltNo = @BCltDpId   
And C2.Party_Code = D.Party_Code And C2.Cl_Code = C1.Cl_Code  
And D.Party_Code >= @FParty And D.Party_Code <= @TParty  
And Scrip_Cd >= @FScrip And Scrip_Cd <= @TScrip  
Group By Sett_no,Sett_Type,D.Party_Code,C1.Short_Name,Scrip_CD,Series,CertNo,FromNo,D.DpType,D.DpId,D.CltDpId,ISett_No,ISett_Type  
Order By D.Party_Code,C1.Short_Name,Scrip_CD,Series,CertNo,Remark,Sett_no,Sett_Type,ISett_No,ISett_Type

GO
