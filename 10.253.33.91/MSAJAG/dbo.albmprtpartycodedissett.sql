-- Object: PROCEDURE dbo.albmprtpartycodedissett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.albmprtpartycodedissett    Script Date: 3/17/01 9:55:43 PM ******/

/****** Object:  Stored Procedure dbo.albmprtpartycodedissett    Script Date: 3/21/01 12:49:59 PM ******/

/****** Object:  Stored Procedure dbo.albmprtpartycodedissett    Script Date: 20-Mar-01 11:38:42 PM ******/

/****** Object:  Stored Procedure dbo.albmprtpartycodedissett    Script Date: 2/5/01 12:06:05 PM ******/

/****** Object:  Stored Procedure dbo.albmprtpartycodedissett    Script Date: 12/27/00 8:58:42 PM ******/

/* this sp is used in  albmprintctlprj contol. variable sdate, partycode is used to get the 
distinct  partycode from  settlement table  and sett_type='l' and tradeqty greater than zero */
/*partycod to added bt amit as on 19/10/2000*/
CREATE PROCEDURE albmprtpartycodedissett
@Sdate varchar(12),
@partycode varchar(10),
@partycodeto varchar(10)
 AS
Select Distinct Party_code From Settlement
 where Sauda_date Like @Sdate + '%' and sett_type = 'l' 
and party_code > =@partycode and party_code < =@partycodeto and tradeqty > 0

GO
