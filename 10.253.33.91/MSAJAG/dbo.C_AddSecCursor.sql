-- Object: PROCEDURE dbo.C_AddSecCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------






CREATE PROCEDURE C_AddSecCursor (@Exchange varchar(3), @Segment varchar(20), @B_BankDpId varchar(16), @B_Dp_Acc_Code varchar(16))
As
Declare @@Cur  cursor,
@@GenTcode Cursor,
@@GetDpType Cursor,
@@GenTrans_code Cursor,
@@party_code varchar(15),
@@Tcode int,
@@Trans_code int,
@@effdate varchar(11),
@@scrip_cd varchar(12),
@@series varchar(3),
@@Isin varchar(20),
@@C_BankCode varchar(16),
@@C_Cltaccno varchar(16),
@@Qty int,
@@Remarks varchar(100),
@@C_Dp_Type varchar(4),
@@B_Dp_Type varchar(4)

Set @@GetDpType = Cursor for
	select DpType from Msajag.dbo.deliverydp where DpId = @B_BankDpId
	Open @@GetDpType 
	Fetch Next from @@GetDpType into @@B_Dp_Type
Close @@GetDpType 
Deallocate @@GetDpType 


Set @@Cur = Cursor For
	select party_code, scrip_cd, series, isin, qty, bankcode, cltaccno, rec_dt, remarks  
	from msajag.dbo.securities
	where exch_indicator = @Exchange and seg_indicator like @Segment + '%'
Open @@Cur
Fetch Next from @@Cur into @@Party_code, @@Scrip_cd, @@series, @@Isin, @@qty, @@C_BankCode, @@C_Cltaccno, @@effdate, @@Remarks

While @@Fetch_Status = 0
Begin
	Set @@GenTrans_code = Cursor For
	Select maxTrans_Code = isnull(max(Trans_Code),0)+1 from msajag.dbo.C_SecuritiesMst	
	Open @@GenTrans_code
	Fetch Next from @@GenTrans_code into @@Trans_code	
	close @@GenTrans_code
	deallocate @@GenTrans_code		

	Set @@GetDpType = Cursor for
	Select BankType from msajag.dbo.BANK where BankId = @@C_BankCode
	Open @@GetDpType 
	Fetch Next from @@GetDpType into @@C_Dp_Type
	Close @@GetDpType 
	Deallocate @@GetDpType 

		
	set @@GenTcode = Cursor for
	select maxTcode = isnull(max(Tcode),0)+1 from msajag.dbo.C_SecuritiesMst where Trans_Code = @@Trans_code
	Open @@GenTcode
	Fetch Next from @@GenTcode into @@Tcode
	close @@GenTcode
	deallocate @@GenTcode			

	/*fldAuto  Exchange Segment Company Party_Code BankDpId Dp_Acc_Code Dp_Type Inst_Type Isin  Scrip_Cd Series Qty DrCr 
	Trans_Code EffDate B_BankDpId  B_Dp_Acc_Code  B_Dp_Type TrType End_Date Tcode Remarks Active Status LoginName LoginTime
	TransToExch Filler11   Filler12   Filler13   Filler14   Filler15   */
	If @@Qty >= 0
	Begin
		insert into msajag.dbo.C_Securitiesmst values( @Exchange, @Segment, '',@@party_code, @@C_BankCode, @@C_Cltaccno, @@C_Dp_type, 'SEC', @@Isin, @@Scrip_cd, @@Series, 
		@@Qty,'C' , @@Trans_code, @@Effdate, @B_BankDpId, @B_Dp_Acc_Code, @@B_Dp_type, '', @@Effdate, @@tcode, @@Remarks,  1, '', '', @@Effdate, 'N', 'Party', '', '', '', '')

		insert into msajag.dbo.C_Securitiesmst values( @Exchange, @Segment, '','Broker', @B_BankDpId, @B_Dp_Acc_Code, @@C_Dp_type, 'SEC', @@Isin, @@Scrip_cd, @@Series, 
		@@Qty,'D' , @@Trans_code, @@Effdate, @B_BankDpId, @B_Dp_Acc_Code, @@B_Dp_type, '', @@Effdate, @@tcode+1, @@Remarks,  1, '', '', @@Effdate, 'N', 'Broker', '', '', '', '')		
	End
	Else
	Begin
		insert into msajag.dbo.C_Securitiesmst values( @Exchange, @Segment, '',@@party_code, @@C_BankCode, @@C_Cltaccno, @@C_Dp_type, 'SEC', @@Isin, @@Scrip_cd, @@Series, 
		abs(@@Qty),'D' , @@Trans_code, @@Effdate, @B_BankDpId, @B_Dp_Acc_Code, @@B_Dp_type, '', @@Effdate, @@tcode, @@Remarks,  1, '', '', @@Effdate, 'N', 'Party', '', '', '', '')

		insert into msajag.dbo.C_Securitiesmst values( @Exchange, @Segment, '','Broker', @B_BankDpId, @B_Dp_Acc_Code, @@C_Dp_type, 'SEC', @@Isin, @@Scrip_cd, @@Series, 
		abs(@@Qty),'C' , @@Trans_code, @@Effdate, @B_BankDpId, @B_Dp_Acc_Code, @@B_Dp_type, '', @@Effdate, @@tcode+1, @@Remarks,  1, '', '', @@Effdate, 'N', 'Broker', '', '', '', '')		

	End
	
Fetch Next from @@Cur into @@Party_code, @@Scrip_cd, @@series, @@Isin, @@qty, @@C_BankCode, @@C_Cltaccno, @@effdate, @@Remarks
End
close @@Cur
deallocate @@Cur

GO
