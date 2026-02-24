-- Object: PROCEDURE dbo.brbranchdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brbranchdate    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.brbranchdate    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brbranchdate    Script Date: 20-Mar-01 11:38:44 PM ******/

/****** Object:  Stored Procedure dbo.brbranchdate    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.brbranchdate    Script Date: 12/27/00 8:58:43 PM ******/

/*  Report : management info
     File : topclients.asp
displays list of clients who have done till moment
*/
CREATE PROCEDURE brbranchdate
@br varchar(3),
@trader varchar(15),
@sdate varchar(10)
AS
select distinct t.party_code,c1.short_name 
from Trade4432 t, client1 c1,client2 c2,branches b 
where c1.cl_code = c2.cl_code 
and c2.party_code = t.party_code 
and b.short_name =c1.trader
and b.branch_cd =@br
and c1.trader like '%' and convert(varchar,t.sauda_date,101)=@sdate
order by c1.short_name,t.party_code

GO
