-- Object: PROCEDURE dbo.traderwiseclient
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.traderwiseclient    Script Date: 01/04/1980 1:40:43 AM ******/



/****** Object:  Stored Procedure dbo.traderwiseclient    Script Date: 11/28/2001 12:23:53 PM ******/

/****** Object:  Stored Procedure dbo.traderwiseclient    Script Date: 29-Sep-01 8:12:08 PM ******/

/****** Object:  Stored Procedure dbo.traderwiseclient    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.traderwiseclient    Script Date: 8/7/01 6:03:54 PM ******/

/****** Object:  Stored Procedure dbo.traderwiseclient    Script Date: 7/8/01 3:22:52 PM ******/

/****** Object:  Stored Procedure dbo.traderwiseclient    Script Date: 2/17/01 3:34:19 PM ******/


/****** Object:  Stored Procedure dbo.traderwiseclient    Script Date: 20-Mar-01 11:43:36 PM ******/

CREATE PROCEDURE traderwiseclient 
@branchcd varchar(3),
@trader varchar(15)
 AS
select l.cltcode , c1.cl_code, Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode) 
- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) From Ledger l , MSAJAG.DBO.client1 c1,
MSAJAG.DBO.client2 c2, MSAJAG.DBO.branches b
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.trader=b.short_name and b.branch_cd=@branchcd
and c1.trader=@trader
group by  c1.cl_code,l.Cltcode
order by l.cltcode

GO
