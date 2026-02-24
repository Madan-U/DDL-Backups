-- Object: PROCEDURE dbo.C_AddBankCursor1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------






CREATE PROCEDURE C_AddBankCursor1 (@Exchange varchar(3), @Segment varchar(20),@Flag int)
As
Declare @@BankCur  cursor,
@@Tcode int,
@@GenTcode Cursor,
@@receive_dt varchar(11),
@@fd_name varchar(50)
If @Flag = 1
Begin
Set @@BankCur = Cursor For
	Select distinct fd_receive_dt,  fd_name from msajag.DBO.fixeddeposits 
	where fd_type = 'B' and exch_indicator = @Exchange and seg_indicator like @Segment + '%'
	and fd_name not in (select bank_name from msajag.dbo.collateralbank )
	
Open @@BankCur
Fetch Next from @@BankCur into @@receive_dt,@@fd_name
While @@Fetch_Status = 0
Begin
	Set @@GenTcode = Cursor For
	Select isnull(Max(tcode),0) + 1 tcode from msajag.DBO.collateralbank
	
	Open @@GenTcode
	Fetch Next from @@GenTcode into @@Tcode
	If @@Fetch_Status = 0 
	begin		
		insert into msajag.dbo.collateralbank values( 'Apr  1 2001',@Exchange, @Segment, left(@@fd_name,15), @@fd_name,'PUBLIC','Y','Y',461168601842739.0000, 461168601842739.0000, 
		922337203685477.0000,461168601842739.0000,'',1, @@tcode,'Add', '','Apr  1 2001',1,1,1)
	end
	close @@GenTcode
	deallocate @@GenTcode	
Fetch Next from @@BankCur into @@receive_dt,@@fd_name
End
close @@BankCur
deallocate @@BankCur
End

/*For CollateralCompany*/
If @Flag = 2
Begin

Set @@BankCur = Cursor For
	Select distinct fd_receive_dt,  fd_name from msajag.DBO.fixeddeposits  where fd_type = 'F' and exch_indicator = @Exchange and seg_indicator like @Segment + '%'
	
Open @@BankCur
Fetch Next from @@BankCur into @@receive_dt,@@fd_name
While @@Fetch_Status = 0
Begin
	Set @@GenTcode = Cursor For
	Select isnull(Max(tcode),0) + 1 tcode from msajag.DBO.collateralcompany
	
	Open @@GenTcode
	Fetch Next from @@GenTcode into @@Tcode
	If @@Fetch_Status = 0 
	begin		
		insert into msajag.dbo.collateralcompany values( 'Apr  1 2001', @Exchange, @Segment, left(@@fd_name,15), @@fd_name,'PUBLIC','Y',99999999999999.0000,99999999999999.0000, 
		1, @@tcode,'Add', '','Apr  1 2001',1,1)
	end
	close @@GenTcode
	deallocate @@GenTcode	
Fetch Next from @@BankCur into @@receive_dt,@@fd_name
End
close @@BankCur
deallocate @@BankCur
End

GO
