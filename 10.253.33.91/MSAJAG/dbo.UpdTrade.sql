-- Object: PROCEDURE dbo.UpdTrade
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

create Proc UpdTrade As 
Declare @@Trade_No Varchar(10),
@@TTrade_No Varchar(10),
@@TrdCur Cursor,
@@UpdTrd Cursor,
@@Alpha Varchar(5)
Set @@TrdCur = Cursor For
select Distinct Trade_no from Trade 
Order By Trade_No
Open @@TrdCur
Fetch Next from @@TrdCur into @@Trade_no
While @@Fetch_Status = 0
Begin	
	select @@Alpha = 'A'
	If (Select Count(*) from Settlement Where Trade_no = @@Trade_no) > 0 
	Begin
		Set @@UpdTrd = Cursor For
		Select Trade_No from Settlement Where Trade_no = @@Trade_no
		Open @@UpdTrd 
		Fetch Next from @@UpdTrd into @@TTrade_no	
		Fetch Next from @@UpdTrd into @@TTrade_no	
		While @@Fetch_Status = 0
		Begin
			Update Settlement Set Trade_no = @@Alpha+@@TTrade_no 
			where current of @@UpdTrd
			Select @@Alpha = Char(Ascii('A')+1)	
			Fetch Next from @@UpdTrd into @@TTrade_no		
		End
	End
	Fetch Next from @@TrdCur into @@Trade_no
End

GO
