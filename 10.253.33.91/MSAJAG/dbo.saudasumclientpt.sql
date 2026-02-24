-- Object: PROCEDURE dbo.saudasumclientpt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.saudasumclientpt    Script Date: 3/17/01 9:56:05 PM ******/

/****** Object:  Stored Procedure dbo.saudasumclientpt    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.saudasumclientpt    Script Date: 20-Mar-01 11:39:04 PM ******/

/* USED FOR SAUDABOOK AND SAUDA SUMMARY*/
/* CREATED BY AMIT FOR PRINTING*/
CREATE PROCEDURE saudasumclientpt  AS
select c2.party_code from client1 c1,client2 c2  where c1.Cl_Code= c2.cl_code order by c2.Party_code

GO
