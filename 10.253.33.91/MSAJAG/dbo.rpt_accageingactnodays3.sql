-- Object: PROCEDURE dbo.rpt_accageingactnodays3
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accageingactnodays3    Script Date: 01/19/2002 12:15:10 ******/

/****** Object:  Stored Procedure dbo.rpt_accageingactnodays3    Script Date: 01/04/1980 5:06:24 AM ******/

CREATE PROCEDURE rpt_accageingactnodays3

@openentrydate datetime,
@amount money,
@cltcode varchar(10),
@userdate datetime


AS

if @openentrydate  <> ''
begin
	select isnull(max(actNoDays),0) from account.dbo.ledger
	where balamt = @amount  and cltcode=@cltcode and balamt >=0 and vdt>=@openentrydate and vdt<= @userdate + ' 23:59:59'
end
else
begin
	select isnull(max(actNoDays),0) from account.dbo.ledger 
	where balamt =  @amount  and cltcode=@cltcode and balamt >=0 and  vdt<= @userdate  + ' 23:59:59'
end

GO
