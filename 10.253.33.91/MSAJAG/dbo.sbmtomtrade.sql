-- Object: PROCEDURE dbo.sbmtomtrade
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbmtomtrade    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomtrade    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomtrade    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomtrade    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomtrade    Script Date: 12/27/00 8:59:00 PM ******/

/** file :mtomrepot2.asp
    report : MTOM  **/
CREATE PROCEDURE
sbmtomtrade
@short_name varchar(21),
@partycode varchar(10),
@subbroker varchar(15)
 AS
     select * from trademtom t,client1 c1,client2 c2 ,subbroker sb,settlement s WHERE short_name like ltrim(@short_name)  and party_code like ltrim(@partycode)  
     and c1.cl_code=c2.cl_code and s.party_code=c2.party_code and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
     union 
     select * from settmtom WHERE short_name like ltrim(@short_name) and party_code like ltrim(@partycode) 
     and c1.cl_code=c2.cl_code and s.party_code=c2.party_code and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker

GO
