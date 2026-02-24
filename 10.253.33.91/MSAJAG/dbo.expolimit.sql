-- Object: PROCEDURE dbo.expolimit
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.expolimit    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.expolimit    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.expolimit    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.expolimit    Script Date: 2/5/01 12:06:12 PM ******/

/****** Object:  Stored Procedure dbo.expolimit    Script Date: 12/27/00 8:58:49 PM ******/

CREATE PROCEDURE expolimit
 AS
select c2.party_code, c1.short_name , c2.exposure_lim  from client2 c2, client1 c1 
where c2.exposure_lim <> 0 and c2.cl_code=c1.cl_code
order by c1.short_name

GO
