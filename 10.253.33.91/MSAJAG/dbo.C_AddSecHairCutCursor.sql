-- Object: PROCEDURE dbo.C_AddSecHairCutCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------






CREATE PROCEDURE C_AddSecHairCutCursor(@Exchange varchar(3), @Segment varchar(20))
As
Declare @@Cur  cursor,
@@party_code varchar(15),
@@Tcode int,
@@GenTcode Cursor,
@@effdate varchar(11),
@@haircut money,
@@scrip_cd varchar(12),
@@series varchar(3)

Set @@Cur = Cursor For
	select Party_code, Scrip_Cd, series, HairCut, Edate   
	from msajag.dbo.fohaircutinfo where Exchange = @Exchange and MarketType like + @Segment + '%'
Open @@Cur
Fetch Next from @@Cur into @@Party_code, @@Scrip_cd, @@series, @@haircut, @@effdate

While @@Fetch_Status = 0
Begin
	Set @@GenTcode = Cursor For
	Select isnull(Max(tcode),0) + 1 tcode from msajag.DBO.securityhaircut
	
	Open @@GenTcode
	Fetch Next from @@GenTcode into @@Tcode
	If @@Fetch_Status = 0 
	begin	
	/*EffDate  Exchange Segment  Client_Type Party_code Scrip_Cd   Series Group_Cd  Isin  Haircut  End_Date  Active Tcode   Remarks    LoginName    LoginTime */
		insert into msajag.dbo.securityhaircut values(@@EffDate, @Exchange, @Segment, '',@@party_code, @@Scrip_cd, @@Series, '' , '', @@haircut, @@Effdate,1, @@tcode,'Add', '',@@Effdate)
	end
	close @@GenTcode
	deallocate @@GenTcode		
	
Fetch Next from @@Cur into @@Party_code, @@Scrip_cd, @@series, @@haircut, @@effdate
End
close @@Cur
deallocate @@Cur

GO
