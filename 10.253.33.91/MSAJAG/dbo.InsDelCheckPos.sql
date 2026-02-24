-- Object: PROCEDURE dbo.InsDelCheckPos
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/*modified by bhagyashree on 16-5-2002  for updating the series in demattranse according to multiisin*/
/****** Object:  Stored Procedure dbo.InsDelCheckPos    Script Date: 04/15/2002 3:51:44 PM ******/



/****** Object:  Stored Procedure dbo.InsDelCheckPos    Script Date: 4/12/01 1:05:15 PM ******/
CREATE Proc InsDelCheckPos (@RefNo int) As
Declare
@@SNo Numeric(18,0),
@@Sett_No Varchar(7),
@@Sett_Type Varchar(2),
@@Party_Code Varchar(10),
@@Scrip_Cd varchar(12),
@@Series Varchar(3),
@@DematQty int,
@@CertQty Int,
@@DelQty Int,
@@DQty Int,
@@RemQty int,
@@CltAccNo Varchar(16),
@@BankCode Varchar(16),
@@TransNo Varchar(16),
@@DematCur Cursor,
@@DelCur Cursor,
@@MCur Cursor,
@@DCur Cursor,
@@CertCur Cursor

update demattrans set series= multiisin.series from multiisin where demattrans.scrip_cd=multiisin.scrip_cd
and demattrans.isin=multiisin.isin

Update DematTrans Set DpId = Left(CltAccNo,8) Where DpId = '' and DpType = 'CDSL'

Set @@DematCur = Cursor for
Select Sett_No,Sett_Type,CltAccno,DpId,Qty,Scrip_Cd,Series,TransNo,SNo from DematTrans
where Party_Code = 'Party' and DrCr = 'C' and DpId <> '' and RefNo = @RefNo 
Open @@DematCur
Fetch Next from @@DematCur into @@Sett_No,@@Sett_Type,@@CltAccno,@@BankCode,@@DematQty,@@Scrip_Cd,@@Series,@@TransNo,@@SNo 
if @@Fetch_Status = 0 
Begin
	While @@Fetch_Status = 0 
	Begin 
		Set @@MCur = Cursor for
		Select Party_Code From MultiCltId Where DpId = @@BankCode and CltDpNo = @@CltAccNo
		Open @@MCur 
		Fetch Next from @@MCur into @@Party_Code 
		if @@Fetch_Status = 0 
		Begin	
			While @@Fetch_Status = 0 and @@DematQty > 0 
			Begin
				Set @@DelCur = Cursor for
				Select IsNull(Sum(Qty),0) from DeliveryClt Where Sett_No = @@Sett_No 
				and Sett_Type = @@Sett_Type and Party_Code = @@Party_Code 
				and Scrip_Cd = @@Scrip_Cd and Series = @@Series and InOut = 'I'
				Open @@DelCur
				Fetch Next from @@DelCur into @@DelQty
				Close @@DelCur
				
				set @@CertCur = Cursor For						
				select IsNull(Sum(Qty),0) from DelTrans Where Party_Code = @@Party_Code 
				and Scrip_Cd = @@Scrip_Cd and Series = @@Series and 
				sett_no = @@sett_no and sett_type = @@sett_type and DrCr = 'C' and RefNo = @RefNo 
				Open @@CertCur
				Fetch NExt From @@CertCur into @@CertQty
				Close @@CertCur		
				
				
				set @@DCur = Cursor For						
				select IsNull(Sum(Qty),0) from DematTrans Where Party_Code = @@Party_Code 
				and Scrip_Cd = @@Scrip_Cd and Series = @@Series and 
				sett_no = @@sett_no and sett_type = @@sett_type and DrCr = 'C' and RefNo = @RefNo 
				Open @@DCur
				Fetch NExt From @@DCur into @@DQty
				Close @@DCur		

				Select @@RemQty = @@DelQty - @@CertQty - @@DQty 
 
				if @@DematQty <= @@RemQty and @@RemQty > 0
				Begin
					Update DematTrans Set Party_Code = @@Party_Code 
					where Sett_No = @@Sett_No and Sett_Type = @@Sett_Type and Party_Code = 'Party' 
					and Scrip_Cd = @@Scrip_Cd and Series = @@Series and DrCr = 'C' and Sno = @@Sno
					and TransNo = @@TransNo and CltAccNo = @@CltAccNo and DpId = @@BankCode and RefNo = @RefNo 
				        	and Qty = @@DematQty
					Select @@DematQty = 0 
				end
				else if @@DematQty > @@RemQty and @@RemQty > 0
				Begin
					Insert into DematTrans ( Sett_No,Sett_Type,RefNo,TCode,TrType,Party_Code,Scrip_Cd,Series,Qty,TrDate,CltAccNo,DpId,DpName,IsIn,Branch_Cd,PartiPantCode,DpType,TransNo,DrCr,BDpType,BDpId,BCltAccNo,Filler1,Filler2,Filler3,Filler4,Filler5 )
					select Sett_No,Sett_Type,RefNo,TCode,TrType,Party_Code,Scrip_Cd,Series,@@DematQty-@@RemQty,TrDate,CltAccNo,DpId,DpName,IsIn,Branch_Cd,PartiPantCode,DpType,TransNo,DrCr,BDpType,BDpId,BCltAccNo,Filler1,Filler2,Filler3,Filler4,Filler5
					from DematTrans Where Sett_No = @@Sett_No and
					Sett_Type = @@Sett_Type and Scrip_cd = @@Scrip_cd and Series = @@Series and
					Party_Code = 'Party' and DrCr = 'C' and Sno = @@Sno and TransNo = @@TransNo
  					and CltAccNo = @@CltAccNo and DpId = @@BankCode and Qty = @@DematQty and RefNo = @RefNo 
						
					Update DematTrans Set Party_Code = @@Party_Code,Qty = @@RemQty  
					where Sett_No = @@Sett_No and Sett_Type = @@Sett_Type and 
					Party_Code = 'Party' and Scrip_Cd = @@Scrip_Cd and Series = @@Series 
					and DrCr = 'C' and Sno = @@Sno and TransNo = @@TransNo and CltAccNo = @@CltAccNo and 
					DpId = @@BankCode and Qty = @@DematQty and RefNo = @RefNo 
					Select @@DematQty = @@DematQty-@@RemQty
				End
				Fetch Next from @@MCur into @@Party_Code 
			End					
		End
		close @@MCur
		
		Fetch Next from @@DematCur into @@Sett_No,@@Sett_Type,@@CltAccno,@@BankCode,@@DematQty,@@Scrip_Cd,@@Series,@@TransNo,@@SNo
	End
End
Close @@DematCur						


Update DematTrans Set Party_code = MultiCltId.Party_Code from MultiCltId where MultiCltId.DpId = DematTrans.DpId 
and MultiCltId.CltDpNo = Demattrans.cltaccno and demattrans.Party_code = 'Party'

GO
