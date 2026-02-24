-- Object: PROCEDURE dbo.setttypewise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.setttypewise    Script Date: 3/17/01 9:56:10 PM ******/

/****** Object:  Stored Procedure dbo.setttypewise    Script Date: 3/21/01 12:50:30 PM ******/

/****** Object:  Stored Procedure dbo.setttypewise    Script Date: 20-Mar-01 11:39:09 PM ******/

/****** Object:  Stored Procedure dbo.setttypewise    Script Date: 2/5/01 12:06:28 PM ******/

/****** Object:  Stored Procedure dbo.setttypewise    Script Date: 12/27/00 8:59:03 PM ******/

CREATE PROCEDURE setttypewise
@subbroker varchar(15)
AS
select distinct sett_type from settlement s, subbrokers sb, client1 c1, client2 c2
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
union
select distinct sett_type from history s, subbrokers sb, client1 c1, client2 c2
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
order by sett_type

GO
