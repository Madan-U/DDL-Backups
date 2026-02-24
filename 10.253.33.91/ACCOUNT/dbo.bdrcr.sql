-- Object: PROCEDURE dbo.bdrcr
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.bdrcr    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.bdrcr    Script Date: 11/28/2001 12:23:40 PM ******/

/****** Object:  Stored Procedure dbo.bdrcr    Script Date: 29-Sep-01 8:12:02 PM ******/

/****** Object:  Stored Procedure dbo.bdrcr    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.bdrcr    Script Date: 8/7/01 6:03:47 PM ******/

/****** Object:  Stored Procedure dbo.bdrcr    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.bdrcr    Script Date: 2/17/01 3:34:13 PM ******/


/****** Object:  Stored Procedure dbo.bdrcr    Script Date: 20-Mar-01 11:43:32 PM ******/

/* calculates balances of all parties of all branches */
CREATE PROCEDURE bdrcr
AS
select  b.branch_cd,l.Cltcode ,Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode) 
- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) From Ledger l , MSAJAG.DBO.client1 c1,
MSAJAG.DBO.client2 c2, MSAJAG.DBO.branches b
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.trader=b.short_name
group by  b.branch_cd,l.Cltcode
ORDER BY b.branch_cd

GO
