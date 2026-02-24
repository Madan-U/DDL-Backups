-- Object: PROCEDURE dbo.sbposmainsettno
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbposmainsettno    Script Date: 01/04/1980 1:40:43 AM ******/



/****** Object:  Stored Procedure dbo.sbposmainsettno    Script Date: 11/28/2001 12:23:52 PM ******/

/****** Object:  Stored Procedure dbo.sbposmainsettno    Script Date: 29-Sep-01 8:12:07 PM ******/

/****** Object:  Stored Procedure dbo.sbposmainsettno    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.sbposmainsettno    Script Date: 8/7/01 6:03:53 PM ******/

/****** Object:  Stored Procedure dbo.sbposmainsettno    Script Date: 7/8/01 3:22:51 PM ******/

/****** Object:  Stored Procedure dbo.sbposmainsettno    Script Date: 2/17/01 3:34:18 PM ******/


/****** Object:  Stored Procedure dbo.sbposmainsettno    Script Date: 20-Mar-01 11:43:36 PM ******/

CREATE PROCEDURE  sbposmainsettno
@subbroker varchar(15)
 AS
 select distinct sett_no from settlement s ,client1 c1,client2 c2,subbrokers sb
 where
c1.cl_code=c2.cl_code and c2.party_code=s.party_code and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
order by  sett_no

GO
