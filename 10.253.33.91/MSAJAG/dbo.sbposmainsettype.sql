-- Object: PROCEDURE dbo.sbposmainsettype
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbposmainsettype    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbposmainsettype    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbposmainsettype    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbposmainsettype    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbposmainsettype    Script Date: 12/27/00 8:59:01 PM ******/

/***  file :positionmain.asp
 report :client position 
displays sett_type for settlements in which trading is done by subbroker's clients
  **/
CREATE PROCEDURE  sbposmainsettype
@subbroker varchar(15)
 AS
 select distinct sett_type from settlement s ,client1 c1,client2 c2,subbrokers sb
 where
c1.cl_code=c2.cl_code and c2.party_code=s.party_code and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
order by sett_type

GO
