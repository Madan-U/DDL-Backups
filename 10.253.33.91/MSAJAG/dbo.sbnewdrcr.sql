-- Object: PROCEDURE dbo.sbnewdrcr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbnewdrcr    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbnewdrcr    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbnewdrcr    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbnewdrcr    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbnewdrcr    Script Date: 12/27/00 8:59:01 PM ******/

CREATE PROCEDURE sbnewdrcr
@subbroker varchar(15)
AS
select  sb.sub_broker,l.Cltcode ,Amount = ( select isnull(sum(vamt),0) from ledger where drcr = 'D' and cltcode = l.cltcode) 
- (select isnull(sum(vamt),0) from ledger where drcr = 'C' and cltcode = l.cltcode) From Ledger l , msajag.dbo.client1 c1,
msajag.dbo.client2 c2, msajag.dbo.subbrokers sb
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and sb.sub_broker=c1.sub_broker
and sb.sub_broker=@subbroker
group by  sb.sub_broker,l.Cltcode
ORDER BY sb.sub_broker

GO
