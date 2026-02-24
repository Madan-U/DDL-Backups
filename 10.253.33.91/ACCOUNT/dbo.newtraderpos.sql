-- Object: PROCEDURE dbo.newtraderpos
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.newtraderpos    Script Date: 01/04/1980 1:40:38 AM ******/



/****** Object:  Stored Procedure dbo.newtraderpos    Script Date: 11/28/2001 12:23:45 PM ******/

/****** Object:  Stored Procedure dbo.newtraderpos    Script Date: 29-Sep-01 8:12:05 PM ******/

/****** Object:  Stored Procedure dbo.newtraderpos    Script Date: 8/8/01 1:37:31 PM ******/

/****** Object:  Stored Procedure dbo.newtraderpos    Script Date: 8/7/01 6:03:49 PM ******/

/****** Object:  Stored Procedure dbo.newtraderpos    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.newtraderpos    Script Date: 2/17/01 3:34:15 PM ******/


/****** Object:  Stored Procedure dbo.newtraderpos    Script Date: 20-Mar-01 11:43:34 PM ******/

CREATE PROCEDURE newtraderpos
@br varchar(3)
 AS
select  l.Cltcode,c1.cl_code, C1.TRADER ,Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode) 
- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) From Ledger l , MSAJAG.DBO.client1 c1,
MSAJAG.DBO.client2 c2, MSAJAG.DBO.branches b
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.trader=b.short_name and b.branch_cd=@br
group by  C1.TRADER,c1.cl_code,l.Cltcode
ORDER BY C1.TRADER,c1.cl_code

GO
