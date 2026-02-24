-- Object: PROCEDURE dbo.rpt_albmpnetqty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_albmpnetqty    Script Date: 04/27/2001 4:32:32 PM ******/

/* report: bill report
   file : albmwbill.asp
   displays settlement wise,  partywise, scripwise,seriewise net quantity
*/
/* changed  by mousami on 9/4/2001
     added tradeqty * albmrate instead of marketrate in calculation 
     Following two views do it	 
   */
CREATE PROCEDURE rpt_albmpnetqty 
@partycode varchar(10),
@scripcd  varchar(21),
@settno varchar(7)
 AS


if ( select Count(sett_no) from settlement where sett_no =@settno and sett_type ='P' ) > 0 
begin

	select netamt = isnull((select amt from rpt_albmwsett where sett_no=@settno 
	and party_code=@partycode and scrip_cd=@scripcd  and sell_buy= 1),0) 
	- isnull((select amt  from rpt_albmwsett where sett_no=@settno 
	and party_code=@partycode and scrip_cd=@scripcd  and sell_buy= 2 ),0)
	
	
end 
else
begin 
	
	select netamt = isnull((select amt from rpt_albmwhist  where sett_no=@settno  
	and party_code=@partycode and scrip_cd=@scripcd  and sell_buy= 1 
	 ),0) 
	- isnull((select amt  from rpt_albmwhist where sett_no=@settno
	and party_code=@partycode and scrip_cd=@scripcd  and sell_buy= 2 
	 ),0) 
	

end

GO
