-- Object: PROCEDURE dbo.C_AddCashCompCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------






CREATE PROCEDURE C_AddCashCompCursor (@Exchange varchar(3), @Segment varchar(20))
As

Declare @@Cur  cursor,
@@party_code varchar(15),
@@Tcode int,
@@GenTcode Cursor,
@@effdate varchar(11),
@@cash money,
@@noncash money

Set @@Cur = Cursor For
	select Party_code, effdate,Cash=Sum(Cash),NonCash=sum(NonCash) 
	from C_SelCashNCashView
	 where exchange = @Exchange and markettype like  @Segment + '%'
	group by Party_code,exchange,markettype,effdate
	
Open @@Cur
Fetch Next from @@Cur into @@Party_code, @@effdate, @@cash, @@noncash 

While @@Fetch_Status = 0
Begin
	Set @@GenTcode = Cursor For
	Select isnull(Max(tcode),0) + 1 tcode from msajag.DBO.cashcomposition
	
	Open @@GenTcode
	Fetch Next from @@GenTcode into @@Tcode
	If @@Fetch_Status = 0 
	begin			
		insert into msajag.dbo.cashcomposition values(@@EffDate, @Exchange, @Segment, @@party_code, '', @@cash, @@noncash, 0, @@effdate ,1, @@tcode,'Add', '',@@Effdate)
	end
	close @@GenTcode
	deallocate @@GenTcode		
	
Fetch Next from @@Cur into @@Party_code, @@effdate, @@cash, @@noncash 
End
close @@Cur
deallocate @@Cur

GO
