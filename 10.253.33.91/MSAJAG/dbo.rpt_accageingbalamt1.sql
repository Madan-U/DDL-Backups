-- Object: PROCEDURE dbo.rpt_accageingbalamt1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accageingbalamt1    Script Date: 01/19/2002 12:15:10 ******/

/****** Object:  Stored Procedure dbo.rpt_accageingbalamt1    Script Date: 01/04/1980 5:06:24 AM ******/

CREATE PROCEDURE rpt_accageingbalamt1

@cltcode varchar(10),
@actnodays int,
@openentrydate datetime,
@userdate datetime

AS

if @openentrydate <> ''
begin
	select balamt=isnull(balamt,0) from account.dbo.ledger 
	where cltcode=@cltcode and actnodays=@actnodays and balamt >0 and vdt>=@openentrydate and vdt<= @userdate + ' 23:59:59'
end 
else
begin
	select balamt=isnull(balamt,0) from account.dbo.ledger 
	where cltcode=@cltcode and actnodays=@actnodays  and balamt >0 and vdt<= @userdate + ' 23:59:59'
end

GO
