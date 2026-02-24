-- Object: PROCEDURE dbo.sbsettlementtype
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbsettlementtype    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbsettlementtype    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbsettlementtype    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbsettlementtype    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbsettlementtype    Script Date: 12/27/00 8:59:01 PM ******/

/*** file :positionreport.asp
     report :client position 
displays details of asettlement for a particular client
**/
CREATE PROCEDURE 
sbsettlementtype
@subbroker varchar(15)
 AS
select distinct sett_type from settlement sett ,client1 c1,client2 c2,subbrokers sb
where c1.cl_code=c2.cl_code and c1.sub_broker=sb.sub_broker and c2.party_code=sett.party_code
and sb.sub_broker=@subbroker

GO
