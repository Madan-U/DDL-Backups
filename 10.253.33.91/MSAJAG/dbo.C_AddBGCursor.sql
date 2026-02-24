-- Object: PROCEDURE dbo.C_AddBGCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------






CREATE PROCEDURE C_AddBGCursor  (@Exchange varchar(3), @Segment varchar(20))
As

Declare @@BGCur  cursor,
@@GenTcode Cursor,
@@Bank_code varchar(15),
@@Party_code varchar(15),
@@Bg_no varchar(20),
@@Bgamt money,
@@Issue_dt varchar(11),
@@Maturity_dt varchar(11),
@@receive_dt varchar(11),
@@release_dt varchar(11),
@@Status varchar(2),
@@Tcode int,
@@OldBg varchar(20),
@@Branch_code varchar(10)

Set @@BGCur = Cursor For
	Select distinct party_code,bankId,bk_guarantee_no,bk_guarantee_amt, issue_dt,maturity_dt,guarantee_rec_dt,lastclaim_dt,status,old_id, P.Branch_code
	from  msajag.dbo.bankguarantee B, C_bank_branch_master P where exch_indicator = @Exchange and seg_indicator like @Segment + '%'
	and convert(varchar,b.bankid) = convert(varchar,p.bank_code)
	
Open @@BGCur
Fetch Next from @@BGCur into @@Party_code, @@Bank_code,@@Bg_no ,@@Bgamt ,@@Issue_dt ,@@Maturity_dt ,@@receive_dt ,@@release_dt ,@@Status, @@OldBg, @@Branch_code
While @@Fetch_Status = 0
Begin
	Set @@GenTcode = Cursor For
	Select isnull(Max(tcode),0) + 1 tcode from msajag.DBO.bankguaranteemst
	
	Open @@GenTcode
	Fetch Next from @@GenTcode into @@Tcode
	If @@Fetch_Status = 0 
	begin			
		insert into msajag.DBO.bankguaranteemst values(@Exchange, @Segment, @@party_code,@@bank_code,@@Bg_no, @@bgamt, @@issue_dt, @@maturity_dt, @@receive_dt, @@Release_dt,
		(case when @@status='N' then 'C' else 'V' end),'Add', @@oldBg, (case when @@status='V' then 1 else 0 end), @@Tcode,'',getdate(),@@Branch_code,'N')
	
	/*	Bank_Code       Party_Code Bg_No     DrCr Bg_Amount    Balance     Trans_Date    Status Active Tcode    Remarks    LoginName       LoginTime       Branch_Code */
	
		insert into msajag.DBO.bankguaranteetrans values(@@bank_code,@@party_code,@@Bg_no, 'D',@@bgamt,@@bgamt, @@receive_dt, 
		(case when @@status='N' then 'C' else 'V' end), (case when @@status='V' then 1 else 0 end), @@Tcode,'Add','',getdate(),@@Branch_code)
				
	end
	close @@GenTcode
	deallocate @@GenTcode	
Fetch Next from @@BGCur into @@Party_code, @@Bank_code, @@Bg_no ,@@Bgamt ,@@Issue_dt ,@@Maturity_dt ,@@receive_dt ,@@release_dt ,@@Status ,@@OldBg, @@Branch_code
End
close @@BGCur
deallocate @@BGCur

GO
