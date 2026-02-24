-- Object: PROCEDURE dbo.partynet
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.partynet    Script Date: 3/17/01 9:55:54 PM ******/

/****** Object:  Stored Procedure dbo.partynet    Script Date: 3/21/01 12:50:10 PM ******/

/****** Object:  Stored Procedure dbo.partynet    Script Date: 20-Mar-01 11:38:52 PM ******/

/****** Object:  Stored Procedure dbo.partynet    Script Date: 2/5/01 12:06:15 PM ******/

/****** Object:  Stored Procedure dbo.partynet    Script Date: 12/27/00 8:58:52 PM ******/

/****** Object:  Stored Procedure dbo.partynet    Script Date: 12/18/99 8:24:10 AM ******/
CREATE PROCEDURE partynet AS
select distinct c1.short_name from settlement s1,client1 c1,client2 c2
where c2.party_code = s1.party_code and c1.cl_code = c2.cl_code
union
select distinct c1.short_name from trade4432 s1,client1 c1,client2 c2 
where c2.party_code = s1.party_code and c1.cl_code = c2.cl_code
order by short_name

GO
