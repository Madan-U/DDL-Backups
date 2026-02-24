-- Object: PROCEDURE dbo.C_AddBankCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------






CREATE PROCEDURE C_AddBankCursor(@Exchange varchar(3), @Segment varchar(20))
As

Declare @@BankCur  cursor,
@@Bank_code varchar(15),
@@Bank_name varchar(50),
@@branch_name Varchar(15),
@@Tcode int,
@@GenTcode Cursor,
@@Adress1 varchar(50),
@@Adress2 varchar(50),
@@City varchar(25),
@@State varchar(25),
@@Nation varchar(25),
@@Zip varchar(15),
@@Phone1 varchar(15),
@@Phone2 varchar(15),
@@Fax varchar(15)

Set @@BankCur = Cursor For
	Select distinct P.BankId, Bank_name, branch_name, Address1, Address2,  City,  State,  Nation,  Zip ,  Phone1,   Phone2,   Fax
	 from msajag.DBO.POBANK P, msajag.dbo.bankguarantee B where  P.bankid = b.bankid
	
Open @@BankCur
Fetch Next from @@BankCur into @@Bank_code,@@bank_name,@@branch_name, @@Adress1,@@Adress2, @@City ,@@State ,@@Nation ,@@Zip ,@@Phone1 ,@@Phone2 ,@@Fax 
While @@Fetch_Status = 0
Begin
	Set @@GenTcode = Cursor For
	Select isnull(Max(tcode),0) + 1 tcode from msajag.DBO.collateralbank
	
	Open @@GenTcode
	Fetch Next from @@GenTcode into @@Tcode
	If @@Fetch_Status = 0 
	begin			
		insert into msajag.dbo.collateralbank values( 'Apr  1 2001',@Exchange,@Segment, @@Bank_code, @@Bank_name,'PUBLIC','Y','Y',461168601842739.0000, 461168601842739.0000, 
		922337203685477.0000,461168601842739.0000,'',1, @@tcode,'Add', '','Apr  1 2001',1,1,1)
	end
	close @@GenTcode
	deallocate @@GenTcode	
	
	Set @@GenTcode = Cursor For
	Select isnull(Max(tcode),0) + 1 tcode from msajag.DBO.c_bank_branch_master
	
	Open @@GenTcode
	Fetch Next from @@GenTcode into @@Tcode
	If @@Fetch_Status = 0 
	begin			
		insert into msajag.dbo.c_bank_branch_master values(@Exchange, @Segment, @@Bank_code, @@Bank_name,left(@@Branch_name,10), @@Branch_name,
		@@Adress1,@@Adress2, @@City ,@@State ,@@Nation ,@@Zip ,@@Phone1 ,@@Phone2 ,@@Fax ,'',1, @@tcode,'Add', '','Apr  1 2001','','','','','')
	end
	close @@GenTcode
	deallocate @@GenTcode	
Fetch Next from @@BankCur into @@Bank_code,@@bank_name,@@branch_name, @@Adress1,@@Adress2, @@City ,@@State ,@@Nation ,@@Zip ,@@Phone1 ,@@Phone2 ,@@Fax 
End
close @@BankCur
deallocate @@BankCur

/*Exchange Segment   Bank_Code    Bank_Name    Branch_Code Branch_Name   Address1  Address2  City  State  Nation  Zip   Phone1   Phone2   Fax   MICR_Code Active TCode  
 Remarks  LoginName    LoginTime    Cushion001 Cushion002 Cushion003 Cushion004 Cushion005 */

GO
