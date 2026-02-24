-- Object: PROCEDURE dbo.DelCheckPos
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

Create Proc DelCheckPos As
Declare
@@Sett_No Varchar(7),
@@Sett_Type Varchar(2),
@@Party_Code Varchar(10),
@@Scrip_Cd varchar(12),
@@Series Varchar(2),
@@DematQty int,
@@CertQty Int,
@@DelQty Int,
@@DQty Int,
@@RemQty int,
@@CltAccNo Varchar(16),
@@BankCode Varchar(30),
@@TransNo Varchar(16),
@@DematCur Cursor,
@@DelCur Cursor,
@@MCur Cursor,
@@DCur Cursor,
@@CertCur Cursor

Set @@DematCur = Cursor for
Select Sett_No,Sett_Type,CltAccno,BankCode,Qty,Scrip_Cd,Series,TransNo from dematdelivery
where Party_Code = 'Party' and Inout = 'I' 
Open @@DematCur
Fetch Next from @@DematCur into @@Sett_No,@@Sett_Type,@@CltAccno,@@BankCode,@@DematQty,@@Scrip_Cd,@@Series,@@TransNo 
if @@Fetch_Status = 0 
Begin
	While @@Fetch_Status = 0 
	Begin 
		Set @@MCur = Cursor for
		Select Party_Code From MultiCltId M,Bank B Where M.DpId = B.BankId and B.BankName = @@BankCode and CltDpNo = @@CltAccNo
		ORDER BY PARTY_CODE
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
				select IsNull(Sum(Qty),0) from CertInfo Where Party_Code = @@Party_Code 
				and Scrip_Cd = @@Scrip_Cd and Series = @@Series and 
				sett_no = @@sett_no and sett_type = @@sett_type
				Open @@CertCur
				Fetch NExt From @@CertCur into @@CertQty
				Close @@CertCur		

				
				set @@DCur = Cursor For						
				select IsNull(Sum(Qty),0) from DematDelivery Where Party_Code = @@Party_Code 
				and Scrip_Cd = @@Scrip_Cd and Series = @@Series and 
				sett_no = @@sett_no and sett_type = @@sett_type and InOut = 'I'
				Open @@DCur
				Fetch NExt From @@DCur into @@DQty
				Close @@DCur		

				Select @@RemQty = @@DelQty - @@CertQty - @@DQty 

				if @@DematQty <= @@RemQty and @@RemQty > 0
				Begin
					Update DematDelivery Set Party_Code = @@Party_Code 
					where Sett_No = @@Sett_No and Sett_Type = @@Sett_Type 
					and Scrip_Cd = @@Scrip_Cd and Series = @@Series and InOut = 'I' 
					and TransNo = @@TransNo and CltAccNo = @@CltAccNo and BankCode = @@BankCode 
				        and Qty = @@DematQty AND Party_Code = 'Party'

					Select @@DematQty = 0 
				end
				else if @@DematQty > @@RemQty and @@RemQty > 0
				Begin
					Insert into DematDelivery
					select Sett_no,sett_type,Party_code,Isin,BankCode,@@RemQty,Scrip_cd,series,
					InOut,CltAccno,'S'+TransNo,Date,DpType from DematDelivery Where Sett_No = @@Sett_No and
					Sett_Type = @@Sett_Type and Scrip_cd = @@Scrip_cd and Series = @@Series and
					Party_Code = 'Party' and Inout = 'I' and TransNo = @@TransNo
  					and CltAccNo = @@CltAccNo and BankCode = @@BankCode and Qty = @@DematQty
						
					Update DematDelivery Set Party_Code = @@Party_Code,Qty = @@DematQty-@@RemQty 
					where Sett_No = @@Sett_No and Sett_Type = @@Sett_Type and 
					Party_Code = 'Party' and Scrip_Cd = @@Scrip_Cd and Series = @@Series 
					and InOut = 'I' and TransNo = @@TransNo and CltAccNo = @@CltAccNo and 
					BankCode = @@BankCode and Qty = @@DematQty

					Select @@DematQty = @@DematQty-@@RemQty
				End
				Fetch Next from @@MCur into @@Party_Code 
			End					
		End
		close @@MCur
		
		Fetch Next from @@DematCur into @@Sett_No,@@Sett_Type,@@CltAccno,@@BankCode,@@DematQty,@@Scrip_Cd,@@Series,@@TransNo 
	End
End
Close @@DematCur

GO
