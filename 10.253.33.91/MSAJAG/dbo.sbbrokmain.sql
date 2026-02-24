-- Object: PROCEDURE dbo.sbbrokmain
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbbrokmain    Script Date: 3/17/01 9:56:06 PM ******/

/****** Object:  Stored Procedure dbo.sbbrokmain    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.sbbrokmain    Script Date: 20-Mar-01 11:39:04 PM ******/

/****** Object:  Stored Procedure dbo.sbbrokmain    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbbrokmain    Script Date: 12/27/00 8:58:59 PM ******/

/*** file :Brokmain.asp
 report : Brokerage report 
displays sett type for which subbroker has traded
 ***/
CREATE PROCEDURE
sbbrokmain
@subbroker varchar(15)
 AS
select distinct s.sett_type 
from settlement s,client1 c1,client2 c2,subbrokers sb
where s.party_code=c2.party_code and c1.cl_code=c2.cl_code 
and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
union 
select distinct h.sett_type 
from history h ,client1 c1,client2 c2,subbrokers sb where
h.party_code=c2.party_code and c1.cl_code=c2.cl_code
 and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
order by sett_type

GO
