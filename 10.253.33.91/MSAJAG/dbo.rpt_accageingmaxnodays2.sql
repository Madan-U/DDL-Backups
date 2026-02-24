-- Object: PROCEDURE dbo.rpt_accageingmaxnodays2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accageingmaxnodays2    Script Date: 01/19/2002 12:15:10 ******/

/****** Object:  Stored Procedure dbo.rpt_accageingmaxnodays2    Script Date: 01/04/1980 5:06:24 AM ******/

CREATE PROCEDURE rpt_accageingmaxnodays2

@cltcode varchar(10),
@openentrydate datetime,
@userdate datetime

AS

if @openentrydate <> ''
begin
	select isnull(max(actnodays),0) from account.dbo.ledger where cltcode=@cltcode and balamt<0 and vdt>=@openentrydate and vdt<= @userdate + ' 23:59:59'
end 
else
begin
	select  isnull(max(actnodays),0) from account.dbo.ledger where cltcode=@cltcode and balamt<0 and vdt<=  @userdate + ' 23:59:59'
end

GO
