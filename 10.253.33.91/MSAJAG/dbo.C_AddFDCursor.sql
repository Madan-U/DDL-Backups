-- Object: PROCEDURE dbo.C_AddFDCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------






CREATE PROCEDURE C_AddFDCursor (@Exchange varchar(3), @Segment varchar(20))
As
Declare @@FdCur  cursor,
@@GenTcode Cursor,
@@Bank_code varchar(15),
@@Party_code varchar(15),
@@fdR_no varchar(20),
@@fdamt money,
@@Issue_dt varchar(11),
@@Maturity_dt varchar(11),
@@receive_dt varchar(11),
@@release_dt varchar(11),
@@Status varchar(2),
@@Tcode int,
@@Branch_code varchar(10),
@@REMARKS VARCHAR(125),
@@FIRST_HOLDER VARCHAR(50),
@@SECOND_HOLDER VARCHAR(50),
@@FD_TYPE VARCHAR(2)

Set @@FdCur = Cursor For
	Select distinct party_code, BANK_CODE = ( CASE WHEN FD_TYPE = 'F' THEN (SELECT COMPANY_CODE FROM MSAJAG.DBO.COLLATERALCOMPANY
						 WHERE Company_NAME = F.FD_NAME) ELSE (SELECT BANK_CODE FROM MSAJAG.DBO.COLLATERALBANK
						 WHERE BANK_NAME = F.FD_NAME) END),
	 FDR_NO,  FD_AMT,issue_dt,maturity_dt,FD_RECEIVE_DT, release_dt, FD_status, 	BRANCH_CODE = ISNULL((CASE WHEN FD_TYPE = 'B' THEN (SELECT B.BRANCH_CODE FROM MSAJAG.DBO.COLLATERALBANK C, MSAJAG.DBO.C_BANK_BRANCH_MASTER B
			    WHERE C.BANK_CODE = B.BANK_CODE and F.fd_name = C.bank_name) ELSE '' END),''), REMARKS, first_holder, second_holder, FD_TYPE
	from  msajag.dbo.fixeddepositS F where exch_indicator = @Exchange and seg_indicator like  @Segment + '%'
	
Open @@FdCur
Fetch Next from @@FdCur into @@Party_code, @@Bank_code,@@FDR_no ,@@FDamt ,@@Issue_dt ,@@Maturity_dt ,@@receive_dt ,@@release_dt ,@@Status,  @@Branch_code, @@REMARKS, @@FIRST_HOLDER, @@SECOND_HOLDER,@@FD_TYPE  
While @@Fetch_Status = 0
Begin
	Set @@GenTcode = Cursor For
	Select isnull(Max(tcode),0) + 1 tcode from msajag.DBO.FIXEDDEPOSITMST
	
	Open @@GenTcode
	Fetch Next from @@GenTcode into @@Tcode
	If @@Fetch_Status = 0 
	begin			
		/*Exchange Segment  Party_Code Fd_Type Bank_Code   FDR_No    Issue_Date   Maturity_Date  Receive_Date   Release_Date  First_Holder  Second_Holder  Remarks  TransToExch  Account_No    
		 Status Fd_Amount     Active  Tcode     LoginName    LoginTime    Branch_Code */
		insert into msajag.DBO.FIXEDDEPOSITMST values( @Exchange, @Segment, @@party_code, (CASE WHEN @@FD_TYPE='F' THEN 'C' ELSE 'B' END),@@bank_code,@@FDR_no, @@issue_dt, @@maturity_dt, @@receive_dt, @@Release_dt,
		 @@FIRST_HOLDER, @@SECOND_HOLDER, 'Add','N','', (case when @@status='N' then 'C' else 'V' end), @@FDamt, (case when @@status='V' then 1 else 0 end), @@Tcode,'',getdate(),@@Branch_code)
	
		/*Bank_Code   Party_Code FDR_No   DrCr FD_Amount   Balance   Trans_Date   Status Fd_Type Active Tcode   Remarks     LoginName    LoginTime   Branch_Code     */	
		insert into msajag.DBO.FIXEDDEPOSITTRANS values(@@bank_code,@@party_code,@@FDR_no, 'D',@@FDamt,@@FDamt, @@receive_dt, 
		(case when @@status='N' then 'C' else 'V' end), (CASE WHEN @@FD_TYPE='F' THEN 'C' ELSE 'B' END), (case when @@status='V' then 1 else 0 end), @@Tcode,'Add','',getdate(),@@Branch_code)
				
	end
	close @@GenTcode
	deallocate @@GenTcode	
Fetch Next from @@FdCur into @@Party_code, @@Bank_code,@@FDR_no ,@@FDamt ,@@Issue_dt ,@@Maturity_dt ,@@receive_dt ,@@release_dt ,@@Status,  @@Branch_code, @@REMARKS, @@FIRST_HOLDER, @@SECOND_HOLDER  ,@@FD_TYPE
End
close @@FdCur
deallocate @@FdCur

GO
