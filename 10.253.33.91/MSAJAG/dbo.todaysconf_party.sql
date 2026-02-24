-- Object: PROCEDURE dbo.todaysconf_party
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.todaysconf_party    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.todaysconf_party    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.todaysconf_party    Script Date: 20-Mar-01 11:39:11 PM ******/

/****** Object:  Stored Procedure dbo.todaysconf_party    Script Date: 2/5/01 12:06:30 PM ******/

/****** Object:  Stored Procedure dbo.todaysconf_party    Script Date: 12/27/00 8:59:04 PM ******/

CREATE procedure todaysconf_party ( @Trader varchar(20), @sdate varchar(10)) as
select c.Party_Code,c.short_name,c1.Cl_Code
from Confirmview c,client1 c1,client2 c2  
where c.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and trader like @trader 
and convert(varchar,c.sauda_date,1) like @sdate
group by c.short_name,c.Party_Code,c1.Cl_Code
union
select s.Party_Code,c1.short_name,c1.Cl_Code
from settlement s, client1 c1, client2 c2, taxes t, globals g
where s.party_code = c2.party_code 
and c2.cl_code = c1.Cl_code  
and t.Exchange ='NSE' and t.Trans_cat = 'TRD'
and g.Exchange ='NSE' 
and trader like @trader 
and convert(varchar,s.sauda_date,1) like @sdate
group by c1.short_name,s.Party_Code,c1.Cl_Code
order by  c.short_name,c.Party_Code

GO
