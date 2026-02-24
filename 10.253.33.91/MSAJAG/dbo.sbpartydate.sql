-- Object: PROCEDURE dbo.sbpartydate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbpartydate    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbpartydate    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbpartydate    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbpartydate    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbpartydate    Script Date: 12/27/00 8:59:01 PM ******/

CREATE PROCEDURE sbpartydate
@trader varchar(15),
@sdate varchar(12)
AS
select distinct t.party_code,c1.short_name 
from Trade4432 t, client1 c1,client2 c2
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code 
and c1.trader like ltrim(@trader)+'%'
and convert(varchar,t.sauda_date,101)=@sdate
order by c1.short_name,t.party_code

GO
