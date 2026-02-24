-- Object: PROCEDURE dbo.sbnseSETTNO
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbnseSETTNO    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbnseSETTNO    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbnseSETTNO    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbnseSETTNO    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbnseSETTNO    Script Date: 12/27/00 8:59:01 PM ******/

/*** file : NetNsemain.asp , AND grossexpmain.asp
     report :Netposition (nse), AND  grossexposure  
displays sett nos
 ***/
CREATE PROCEDURE
sbnseSETTNO
@subbroker varchar(15)
AS
select distinct s.sett_no from settlement s,client1 c1,client2 c2,subbrokers sb
WHERE 
s.party_code=c2.party_code and
c1.cl_code=c2.cl_code and sb.sub_broker=c1.sub_broker and sb.sub_broker=@subbroker

GO
