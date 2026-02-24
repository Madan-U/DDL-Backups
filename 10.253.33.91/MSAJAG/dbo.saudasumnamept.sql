-- Object: PROCEDURE dbo.saudasumnamept
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.saudasumnamept    Script Date: 3/17/01 9:56:05 PM ******/

/****** Object:  Stored Procedure dbo.saudasumnamept    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.saudasumnamept    Script Date: 20-Mar-01 11:39:04 PM ******/

/* USED FOR SAUDABOOK AND SAUDA SUMMARY*/
/* CREATED BY AMIT FOR PRINTING*/
CREATE PROCEDURE saudasumnamept 
@partycode varchar(10)
as
 select c1.short_name,c1.family from client1 c1, client2 c2 where c2.party_code =@partycode
and c2.cl_code= c1.cl_code

GO
