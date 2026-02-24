-- Object: PROCEDURE dbo.InsDelSettNoUpdate
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



/* Drop Proc InsDelSettNoUpdate */
CREATE   Proc InsDelSettNoUpdate(@RefNo int) As
Declare 
@@SNo int,
@@Party_Code Varchar(10),
@@Scrip_Cd Varchar(12),
@@Series Varchar(3),
@@Qty int,
@@TCode int,
@@TrDate Varchar(11),
@@Sett_No Varchar(7),
@@Sett_Type Varchar(2),
@@SettDelQty int,
@@SettDelTransQty int,
@@DematCur Cursor,
@@SettDel Cursor,
@@SettDelTrans Cursor

Select @@SettDelQty = 0 
Select @@SettDelTransQty = 0
/* Getting All The Records From DematTrans Whose Settlement No was not Proper i.e. '9999999' */


Update DematTrans Set Sett_Type = (Case When Series = 'BE' then 'W' 
					   When Series = 'BSE' Then 'D' 
					   Else 'N' 
				       End)  Where Sett_no = '9999999' and Sett_Type = 'NO' 
/*
Set @@DematCur = Cursor For
Select SNo,D.Party_Code,Scrip_CD,D.Series,Qty,TCode,TrDate=Left(Convert(Varchar,TrDate,109),11) 
From DematTrans D
Where D.Sett_No = '9999999' And  RefNo = @RefNo 
Order By D.Party_Code,Scrip_CD,D.Series,Qty
Open @@DematCur 
Fetch Next From @@DematCur Into @@SNo,@@Party_Code,@@Scrip_Cd,@@Series,@@Qty,@@TCode,@@TrDate
While @@Fetch_Status = 0
Begin	

	Set @@SettDel = Cursor For
	Select D.Sett_No,D.Sett_Type,Qty From DeliveryClt D, Sett_Mst S Where D.Sett_No = S.Sett_No
	And D.Sett_Type = S.Sett_Type And D.Party_Code = @@Party_Code And S.Sec_Payin >= @@TrDate
	And D.Scrip_Cd = @@Scrip_Cd And D.Series = @@Series And InOut = 'I'
	order by D.Sett_No,D.Sett_Type
	Open @@SettDel
	Fetch Next From @@SettDel into @@Sett_No,@@Sett_Type,@@SettDelQty
	While @@Fetch_Status = 0 And @@Qty > 0 	
	Begin

		Set @@SettDelTrans = Cursor For
		Select IsNull(Sum(Qty),0) From DelTrans Where Sett_No = @@Sett_No
		And Sett_Type = @@Sett_Type And Party_Code = @@Party_Code And RefNo = @RefNo
		And Scrip_Cd = @@Scrip_Cd And Series = @@Series And DrCr = 'C' And Filler2 = 1 
		Open @@SettDelTrans
		Fetch Next From @@SettDelTrans into @@SettDelTransQty
		Close @@SettDelTrans
		DeAllocate @@SettDelTrans		
		
		Select @@SettDelQty = @@SettDelQty - @@SettDelTransQty 

		If @@SettDelQty > 0 and @@Qty > 0 
		Begin
			If @@SettDelQty >= @@Qty 
			Begin
				Update DematTrans Set Sett_No = @@Sett_no Where SNo = @@SNo
				And Sett_Type = @@Sett_Type and Party_Code = @@Party_Code 
				And Scrip_Cd = @@Scrip_Cd and Series = @@Series And RefNo = @RefNo
				Select @@Qty = 0				
			End
			Else
			Begin
				Insert Into DematTrans Select Sett_No,Sett_Type,RefNo,TCode,TrType,Party_Code,Scrip_Cd,
				Series,@@SettDelQty,TrDate,CltAccNo,DpId,DpName,IsIn,Branch_Cd,PartiPantCode,DpType,TransNo,
				DrCr,BDpType,BDpId,BCltAccNo,Filler1,Filler2,Filler3,Filler4,Filler5 From DematTrans 
				Where SNo = @@SNo And Sett_Type = @@Sett_Type and Party_Code = @@Party_Code 
				And Scrip_Cd = @@Scrip_Cd and Series = @@Series And RefNo = @RefNo
				
				Update DematTrans Set Sett_No = @@Sett_no,Qty = @@Qty-@@SettDelQty
				Where SNo = @@SNo And Sett_Type = @@Sett_Type and Party_Code = @@Party_Code 
				And Scrip_Cd = @@Scrip_Cd and Series = @@Series And RefNo = @RefNo
				
				Select @@Qty = @@Qty-@@SettDelQty
			End
		End
		Fetch Next From @@SettDel into @@Sett_No,@@Sett_Type, @@SettDelQty			
	End
	Close @@SettDel	
	DeAllocate @@SettDel
	Fetch Next From @@DematCur Into @@SNo,@@Party_Code,@@Scrip_Cd,@@Series,@@Qty,@@TCode,@@TrDate
End
Close @@DematCur
DeAllocate @@DematCur

*/

GO
