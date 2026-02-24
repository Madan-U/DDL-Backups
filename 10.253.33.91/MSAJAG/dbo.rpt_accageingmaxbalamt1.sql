-- Object: PROCEDURE dbo.rpt_accageingmaxbalamt1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_accageingmaxbalamt1    Script Date: 01/19/2002 12:15:10 ******/

/****** Object:  Stored Procedure dbo.rpt_accageingmaxbalamt1    Script Date: 01/04/1980 5:06:24 AM ******/

CREATE PROCEDURE  rpt_accageingmaxbalamt1

@cltcode varchar(10),
@openentrydate datetime,
@userdate datetime

AS

select convert(money,isnull(max(balamt),0)) from account.dbo.ledger 
where cltcode=@cltcode and balamt>0 and vdt>=@openentrydate and vdt<=@userdate + ' 23:59:59'

GO
