-- Object: PROCEDURE dbo.C_AddScripCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





CREATE PROCEDURE C_AddScripCursor(@Exchange varchar(3), @Segment varchar(20))
As

Declare @@Cur  cursor,
@@scrip_cd varchar(12),
@@series varchar(3),
@@Tcode int,
@@GenTcode Cursor

Set @@Cur = Cursor For
	select distinct scrip_cd ,series from msajag.dbo.securities 
	where exch_indicator = @Exchange and seg_indicator = @Segment
	
Open @@Cur
Fetch Next from @@Cur into @@scrip_cd, @@series 
While @@Fetch_Status = 0
Begin
	Set @@GenTcode = Cursor For
	Select isnull(Max(tcode),0) + 1 tcode from msajag.DBO.C_ScripMaster
	
	Open @@GenTcode
	Fetch Next from @@GenTcode into @@Tcode
	If @@Fetch_Status = 0 
	begin		
/*EffDate  Exchange Segment Scrip_Cd Series Eligible AbsoluteLimit PaidUpCapital Prec_PaidUpCapital   TradingVolume Perc_TradingVolume   FaceValue Unlimited_AbsoluteLimit 
Unlimited_PaidUpCapital Unlimited_TradingVolume Active Tcode Remarks  LoginName LoginTime Dummy1 Dummy2 */
		insert into msajag.dbo.C_ScripMaster values( 'Apr  1 2001',@Exchange,@Segment, @@scrip_cd, @@series, 'Y',99999999999999.0000, 99999999999999.0000, 
		100,99999999999999.0000,100,10,1,1,1,1,@@tcode,'Add', '','Apr  1 2001','','')
	end
	close @@GenTcode
	deallocate @@GenTcode		
	
Fetch Next from @@Cur into @@scrip_cd, @@series 
End
close @@Cur
deallocate @@Cur

GO
