-- Object: PROCEDURE dbo.sbmngallclient1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbmngallclient1    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbmngallclient1    Script Date: 3/21/01 12:50:26 PM ******/

/****** Object:  Stored Procedure dbo.sbmngallclient1    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbmngallclient1    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbmngallclient1    Script Date: 12/27/00 8:59:00 PM ******/

/* report management info
file allclients.asp
displays all clients who have done trading today for a subbroker
*/
CREATE PROCEDURE sbmngallclient1
@tdate varchar(10),
@subbroker varchar(15)
 AS
select distinct t.party_code,c1.short_name 
from Trade t, client1 c1,client2 c2 ,subbrokers sb
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code
and sb.sub_broker=c1.sub_broker and
convert(varchar,t.sauda_date,101)=@tdate and sb.sub_broker=@subbroker
order by c1.short_name,t.party_code

GO
