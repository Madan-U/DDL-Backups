-- Object: PROCEDURE dbo.sbmngallclient2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbmngallclient2    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbmngallclient2    Script Date: 3/21/01 12:50:26 PM ******/

/****** Object:  Stored Procedure dbo.sbmngallclient2    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbmngallclient2    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbmngallclient2    Script Date: 12/27/00 8:59:00 PM ******/

/* *** file : allclients .asp
       report : managementinfo    
displays all clients who have done trading today for a subbroker till moment
***/
CREATE PROCEDURE sbmngallclient2
@subbroker varchar(15),
@tradername varchar(15),
@tdate varchar(10)
 AS
select distinct t.party_code,c1.short_name 
from Trade4432 t, client1 c1,client2 c2 ,subbrokers sb
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code 
and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
and c1.trader like ltrim(@tradername)+'%' 
and convert(varchar,t.sauda_date,101)=@tdate
 order by c1.short_name,t.party_code

GO
