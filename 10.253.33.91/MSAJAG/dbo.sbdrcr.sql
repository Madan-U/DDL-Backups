-- Object: PROCEDURE dbo.sbdrcr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbdrcr    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbdrcr    Script Date: 3/21/01 12:50:26 PM ******/

/****** Object:  Stored Procedure dbo.sbdrcr    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sbdrcr    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbdrcr    Script Date: 12/27/00 8:58:59 PM ******/

CREATE PROCEDURE sbdrcr
@subbroker varchar(15)
AS
select amt=sum(vamt),drcr from ledger l, msajag.dbo.client1 c1, msajag.dbo.client2 c2, msajag.dbo.subbrokers sb
where l.cltcode=c2.party_code and c1.cl_code=c2.cl_code and c1.sub_broker=sb.sub_broker
and sb.sub_broker=ltrim(@subbroker)
group by sb.sub_broker,l.drcr
order by sb.sub_broker,l.drcr

GO
