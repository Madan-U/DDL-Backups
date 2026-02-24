-- Object: PROCEDURE dbo.InsDelEarlyPayinGross_Net
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc InsDelEarlyPayinGross_Net (@Sett_No Varchar(7), @Sett_Type Varchar(2), 
@EarlyOrAuto Varchar(1), @GrossOrNet Varchar(1))
AS

Select * Into #DelTrans From DelTrans
Where Sett_No = @Sett_No And Sett_Type = @Sett_Type
And Filler2 = 1   
And ShareType = 'DEMAT' And DrCr = 'D'  

select Sett_no,Sett_Type,Scrip_Cd = Short_Name,D.Series,IsIn=CertNo,Qty = Sum(Qty)   
into #InsDelEarlyPayinNet from #DelTrans D, Scrip2 S2, Scrip1 S1   
where S1.Co_Code = S2.Co_Code  And S2.Scrip_Cd = D.Scrip_Cd   
And S2.Series = S1.Series And S2.Series = D.Series And TrType = 906 And Filler2 = 1   
And ShareType = 'DEMAT' And DrCr = 'D'  
Group By Sett_no,Sett_Type,Short_Name,D.Series,CertNo   

if @GrossOrNet = 'G' 
Begin
	Select * Into #DeliveryClt From DeliveryClt
	Where Sett_No = @Sett_No And Sett_Type = @Sett_Type
	And Inout = 'I'  
	
	select Sett_no,Sett_Type,Scrip_Cd = Short_Name,D.Series,M.IsIn,Qty = Sum(Qty) 
	into #InsDelAutoPayinGross from #DeliveryClt D, MultiIsin M, Scrip2 S2, Scrip1 S1   
	where Valid = 1 And D.Scrip_Cd = M.Scrip_Cd 
	And D.Series = M.Series And Inout = 'I'  
	And S1.Co_Code = S2.Co_Code  And S2.Scrip_Cd = D.Scrip_Cd 
	And S2.Series = S1.Series And S2.Series = D.Series   
	Group By Sett_no,Sett_Type,Short_Name,D.Series,M.IsIn   
	
	Select A.Scrip_Cd,A.Series,A.IsIn,Qty=A.Qty-IsNull(E.Qty,0)
	into #GrossDO From #InsDelAutoPayinGross A Left Outer Join #InsDelEarlyPayinNet E
	On ( A.IsIn = E.IsIn And A.Sett_No = E.Sett_No
	And A.Sett_Type = E.Sett_Type )
	Where A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type
	And A.Qty > IsNull(E.Qty,0)	
End

if @GrossOrNet = 'N' 
Begin	
	Select * Into #DelNet From DelNet 
	Where Sett_No = @Sett_No And Sett_Type = @Sett_Type
	And Inout = 'I'  
	
	select Sett_no,Sett_Type,Scrip_Cd = Short_Name,D.Series,M.IsIn,Qty = Sum(Qty) 
	into #InsDelAutoPayinNet from #DelNet D, MultiIsin M, Scrip2 S2, Scrip1 S1   
	where Valid = 1 And D.Scrip_Cd = M.Scrip_Cd And D.Series = M.Series And Inout = 'I'  
	And S1.Co_Code = S2.Co_Code  And S2.Scrip_Cd = D.Scrip_Cd And S2.Series = S1.Series 
        And S2.Series = D.Series   
	Group By Sett_no,Sett_Type,Short_Name,D.Series,M.IsIn   

	Select A.Scrip_Cd,A.Series,A.IsIn,Qty=A.Qty-IsNull(E.Qty,0)
	into #NetDO From #InsDelAutoPayinNet A Left Outer Join #InsDelEarlyPayinNet E
	On ( A.IsIn = E.IsIn And A.Sett_No = E.Sett_No
	And A.Sett_Type = E.Sett_Type )
	Where A.Sett_No = @Sett_No And A.Sett_Type = @Sett_Type
	And A.Qty > IsNull(E.Qty,0)
End

if @EarlyOrAuto = 'E' And @GrossOrNet = 'G'
Begin
	Select Scrip_Cd = Short_Name,D.Series,IsIn=CertNo,Qty = Sum(Qty), SellQty=0 
	Into #EarlyGrossDO from 
	#DelTrans D, Scrip2 S2, Scrip1 S1 
	where sett_no = @Sett_No and sett_type = @Sett_Type
	And S1.Co_Code = S2.Co_Code 
	And S2.Scrip_Cd = D.Scrip_Cd And S2.Series = S1.Series And S2.Series = D.Series and BDpType = 'NSDL' 
	And TrType = 904 And Party_Code = 'BROKER' And Filler2 = 1 And Delivered = '0' And ShareType = 'DEMAT' 
	Group By Short_Name,D.Series,CertNo

	Update #EarlyGrossDO Set SellQty = G.Qty
	From #GrossDO G Where G.IsIn = #EarlyGrossDO.IsIn
End

if @EarlyOrAuto = 'E' And @GrossOrNet = 'N'
Begin
	Select Scrip_Cd = Short_Name,D.Series,IsIn=CertNo,Qty = Sum(Qty), SellQty=0 
	Into #EarlyNetDO from 
	#DelTrans D, Scrip2 S2, Scrip1 S1 
	where sett_no = @Sett_No and sett_type = @Sett_Type
	And S1.Co_Code = S2.Co_Code 
	And S2.Scrip_Cd = D.Scrip_Cd And S2.Series = S1.Series And S2.Series = D.Series and BDpType = 'NSDL' 
	And TrType = 904 And Party_Code = 'BROKER' And Filler2 = 1 And Delivered = '0' And ShareType = 'DEMAT' 
	Group By Short_Name,D.Series,CertNo

	Update #EarlyNetDO Set SellQty = N.Qty
	From #NetDO N Where N.IsIn = #EarlyNetDO.IsIn
End
	
if @EarlyOrAuto = 'A' And @GrossOrNet = 'G' 
Begin
	Select * From #GrossDO
	Order By Scrip_Cd, Series
End
if @EarlyOrAuto = 'A' And @GrossOrNet = 'N' 
Begin
	Select * From #NetDO
	Order By Scrip_Cd, Series
End
if @EarlyOrAuto = 'E' And @GrossOrNet = 'G' 
Begin
	Select * From #EarlyGrossDO
	Where SellQty > 0 
	Order By Scrip_Cd, Series
End
if @EarlyOrAuto = 'E' And @GrossOrNet = 'N' 
Begin
	Select * From #EarlyNetDO
	Where SellQty > 0 
	Order By Scrip_Cd, Series
End

GO
