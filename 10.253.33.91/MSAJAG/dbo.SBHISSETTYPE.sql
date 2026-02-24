-- Object: PROCEDURE dbo.SBHISSETTYPE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SBHISSETTYPE    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.SBHISSETTYPE    Script Date: 3/21/01 12:50:26 PM ******/

/****** Object:  Stored Procedure dbo.SBHISSETTYPE    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.SBHISSETTYPE    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.SBHISSETTYPE    Script Date: 12/27/00 8:59:00 PM ******/

/*** file : hispositionmain.asp
     report :history position 
displays sett_type for a particular subbroker
  ***/
CREATE PROCEDURE
 SBHISSETTYPE
@subbroker varchar(15)
AS
select distinct h.sett_type from history h,client1 c1,client2 c2,subbrokers sb
WHERE  h.party_code= c2.party_code and
c1.cl_code=c2.cl_code and sb.sub_broker=c1.sub_broker and sb.sub_broker=@subbroker

GO
