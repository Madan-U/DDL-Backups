-- Object: PROCEDURE dbo.sbdrlist
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbdrlist    Script Date: 01/04/1980 1:40:43 AM ******/



/****** Object:  Stored Procedure dbo.sbdrlist    Script Date: 11/28/2001 12:23:52 PM ******/

/****** Object:  Stored Procedure dbo.sbdrlist    Script Date: 29-Sep-01 8:12:07 PM ******/

/****** Object:  Stored Procedure dbo.sbdrlist    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.sbdrlist    Script Date: 8/7/01 6:03:53 PM ******/

/****** Object:  Stored Procedure dbo.sbdrlist    Script Date: 7/8/01 3:22:51 PM ******/

/****** Object:  Stored Procedure dbo.sbdrlist    Script Date: 2/17/01 3:34:18 PM ******/


/****** Object:  Stored Procedure dbo.sbdrlist    Script Date: 20-Mar-01 11:43:36 PM ******/

CREATE PROCEDURE sbdrlist
@vdt smalldatetime ,
@subbroker varchar(15)
AS
select l.cltcode , l.acname, clcode=(select cl_code from MSAJAG.DBO.client2 
c2 where c2.party_code=l.cltcode),Amount = ( select isnull(sum(vamt),0) from ledger 
where drcr = 'D' and cltcode = l.cltcode and vdt <= @vdt +  '11:59pm')
- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and 
cltcode = l.cltcode and vdt <= @vdt  + '11:59pm') From Ledger l , acmast a , MSAJAG.DBO.client2 c2 , 
MSAJAG.DBO.client1 c1, MSAJAG.DBO.subbrokers sb
where a.accat=4 and a.cltcode=l.cltcode and l.cltcode=c2.party_code and sb.sub_broker=@subbroker and 
sb.sub_broker=c1.sub_broker and  c1.cl_code=c2.cl_code
group by l.Cltcode,l.acname

GO
