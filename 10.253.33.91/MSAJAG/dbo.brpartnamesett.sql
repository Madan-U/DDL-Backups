-- Object: PROCEDURE dbo.brpartnamesett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brpartnamesett    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brpartnamesett    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brpartnamesett    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brpartnamesett    Script Date: 2/5/01 12:06:08 PM ******/

/****** Object:  Stored Procedure dbo.brpartnamesett    Script Date: 12/27/00 8:58:45 PM ******/

CREATE PROCEDURE brpartnamesett
@br varchar(3),
@partycode varchar(10),
@shortname varchar(21),
@settno varchar(7),
@setttype varchar(3),
@scripcd varchar(10)
AS
select distinct s.party_code,c1.short_Name,s.sett_no,s.sett_type
from settlement s,client1 c1, client2 c2,branches b  
where s.party_code = c2.party_code and c1.Cl_code= c2.cl_code 
and b.short_name = c1.trader
and b.branch_cd = @br
and s.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@shortname)+'%' 
and s.sett_no= @settno and s.sett_type= @setttype
and s.scrip_cd like ltrim(@scripcd)+'%' 
order by c1.short_name,s.party_code,s.sett_no,s.sett_type

GO
