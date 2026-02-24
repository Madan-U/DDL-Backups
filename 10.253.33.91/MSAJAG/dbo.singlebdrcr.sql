-- Object: PROCEDURE dbo.singlebdrcr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.singlebdrcr    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.singlebdrcr    Script Date: 3/21/01 12:50:30 PM ******/

/****** Object:  Stored Procedure dbo.singlebdrcr    Script Date: 20-Mar-01 11:39:09 PM ******/

/****** Object:  Stored Procedure dbo.singlebdrcr    Script Date: 2/5/01 12:06:28 PM ******/

/****** Object:  Stored Procedure dbo.singlebdrcr    Script Date: 12/27/00 8:59:03 PM ******/

CREATE PROCEDURE singlebdrcr
@br varchar(3)
AS 
select  b.branch_cd,l.Cltcode ,Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode) 
- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) From Ledger l , msajag.dbo.client1 c1,
msajag.dbo.client2 c2, msajag.dbo.branches b
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.trader=b.short_name and b.branch_cd=@br
group by  b.branch_cd,l.Cltcode
ORDER BY b.branch_cd

GO
