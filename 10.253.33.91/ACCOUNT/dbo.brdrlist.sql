-- Object: PROCEDURE dbo.brdrlist
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brdrlist    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.brdrlist    Script Date: 11/28/2001 12:23:41 PM ******/

/****** Object:  Stored Procedure dbo.brdrlist    Script Date: 29-Sep-01 8:12:02 PM ******/

/****** Object:  Stored Procedure dbo.brdrlist    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.brdrlist    Script Date: 8/7/01 6:03:47 PM ******/

/****** Object:  Stored Procedure dbo.brdrlist    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.brdrlist    Script Date: 2/17/01 3:34:14 PM ******/


/****** Object:  Stored Procedure dbo.brdrlist    Script Date: 20-Mar-01 11:43:32 PM ******/

CREATE PROCEDURE brdrlist 
@vdt smalldatetime,
@br varchar(3)
AS
select l.cltcode , l.acname, clcode=(select cl_code from MSAJAG.DBO.client2 
c2 where c2.party_code=l.cltcode),Amount = ( select isnull(sum(vamt),0) from ledger 
where drcr = 'D' and cltcode = l.cltcode and vdt <=@vdt  +  '11:59pm')
- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and 
cltcode = l.cltcode and vdt <= @vdt + '11:59pm') From Ledger l , acmast a , MSAJAG.DBO.client2 c2, 
MSAJAG.DBO.branches b, MSAJAG.DBO.client1 c1
where a.accat=4 and a.cltcode=l.cltcode and l.cltcode=c2.party_code and b.short_name=c1.trader 
and c1.cl_code=c2.cl_code and b.branch_cd=@br
group by l.Cltcode,l.acname

GO
