-- Object: PROCEDURE dbo.sbbrokmain1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbbrokmain1    Script Date: 3/17/01 9:56:06 PM ******/

/****** Object:  Stored Procedure dbo.sbbrokmain1    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.sbbrokmain1    Script Date: 20-Mar-01 11:39:04 PM ******/

/****** Object:  Stored Procedure dbo.sbbrokmain1    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbbrokmain1    Script Date: 12/27/00 8:58:59 PM ******/

/***   file : brokmain.asp
  report : broekerage
displays sett nos in which a particular subbroker has done trading
   ***/
CREATE PROCEDURE
 sbbrokmain1
@subbroker varchar(15)
 AS
select distinct s.sett_no 
from settlement s ,Client1 c1,client2 c2,subbrokers sb
where c1.cl_code=c2.cl_code and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
and s.party_code=c2.party_code
union 
select distinct h.sett_no 
from history h ,Client1 c1,client2 c2,subbrokers sb
where c1.cl_code=c2.cl_code and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
and h.party_code=c2.party_code
 order by sett_no

GO
