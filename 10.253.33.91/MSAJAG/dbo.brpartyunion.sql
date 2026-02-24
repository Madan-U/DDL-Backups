-- Object: PROCEDURE dbo.brpartyunion
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brpartyunion    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brpartyunion    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brpartyunion    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brpartyunion    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brpartyunion    Script Date: 12/27/00 8:58:45 PM ******/

CREATE PROCEDURE brpartyunion
@branchcode varchar(3),
@partycode varchar(10),
@shortname varchar(21),
@trader varchar(15),
@saudadate varchar(10)
AS
select distinct t.party_code,c1.short_name,c1.Cl_Code 
from Trade t, client1 c1,client2 c2, branches b 
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code and b.short_name = c1.trader
and b.branch_cd = @branchcode and t.party_code like ltrim(@partycode)+ '%' and c1.short_name like ltrim(@shortname)+ '%' 
and c1.trader like ltrim(@trader)+'%' and convert(varchar,t.sauda_date,103)like ltrim(@saudadate)+'%'
union all 
select distinct s.party_code,c1.short_name,c1.Cl_Code 
from settlement s, client1 c1,client2 c2,branches b 
where c1.cl_code = c2.cl_code and c2.party_code = s.party_code and b.short_name = c1.trader 
and s.party_code = c2.party_code and b.branch_cd = @branchcode and s.party_code like @partycode+'%' 
and c1.short_name like ltrim(@shortname)+'%' and c1.trader like ltrim(@trader)+'%' 
and convert(varchar,s.sauda_date,103)like ltrim(@saudadate)+'%' 
order by c1.short_name,t.party_code

GO
