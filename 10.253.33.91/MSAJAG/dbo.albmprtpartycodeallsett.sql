-- Object: PROCEDURE dbo.albmprtpartycodeallsett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.albmprtpartycodeallsett    Script Date: 3/17/01 9:55:43 PM ******/

/****** Object:  Stored Procedure dbo.albmprtpartycodeallsett    Script Date: 3/21/01 12:49:59 PM ******/

/****** Object:  Stored Procedure dbo.albmprtpartycodeallsett    Script Date: 20-Mar-01 11:38:42 PM ******/

/****** Object:  Stored Procedure dbo.albmprtpartycodeallsett    Script Date: 2/5/01 12:06:06 PM ******/

/****** Object:  Stored Procedure dbo.albmprtpartycodeallsett    Script Date: 12/27/00 8:58:42 PM ******/

/* this sp is used inalbmprintctlprj contol. variable sdate is used to get the 
all partycode from settlement table  and sett_type='l' */
CREATE PROCEDURE albmprtpartycodeallsett
 @Sdate varchar(12)
 AS
Select Distinct Party_code From Settlement 
where  sauda_date Like  @Sdate + '%' and sett_type = 'l' and tradeqty > 0

GO
