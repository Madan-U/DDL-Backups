-- Object: PROCEDURE dbo.C_AddInstruTypeCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------






CREATE PROCEDURE C_AddInstruTypeCursor (@Exchange varchar(3), @Segment varchar(20))
As

Declare @@Cur  cursor,
@@Instru_Type varchar(5),
@@Tcode int,
@@GenTcode Cursor,
@@cash_ncash varchar(2)

Set @@Cur = Cursor For
	 select InstruType = (case when InstruType = 'FDR' then 'FD' else InstruType end), Cash_Ncash  = (case when Cash_Ncash = 0 then 'C' else 'N' end)
	 from msajag.dbo.focollateralinstru
	 where exchange = @Exchange and MarkerType like  @Segment + '%'
	
Open @@Cur
Fetch Next from @@Cur into @@Instru_Type , @@cash_ncash 

While @@Fetch_Status = 0
Begin
	Set @@GenTcode = Cursor For
	Select isnull(Max(tcode),0) + 1 tcode from msajag.DBO.instrutypemst
	
	Open @@GenTcode
	Fetch Next from @@GenTcode into @@Tcode
	If @@Fetch_Status = 0 
	begin	
	/*effDate    Exchange Segment              Party_Code Client_Type Instru_Type Cash_Ncash Active Tcode    Remarks  LoginName                 LoginTime          		*/
		insert into msajag.dbo.instrutypemst values('Apr  1 2001', @Exchange, @Segment, '','',@@Instru_Type , @@cash_ncash  ,1, @@tcode,'Add', '','Apr  1 2001')
	end
	close @@GenTcode
	deallocate @@GenTcode		
	
Fetch Next from @@Cur into @@Instru_Type , @@cash_ncash 
End
close @@Cur
deallocate @@Cur

GO
