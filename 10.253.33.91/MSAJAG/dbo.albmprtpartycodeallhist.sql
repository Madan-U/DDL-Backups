-- Object: PROCEDURE dbo.albmprtpartycodeallhist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.albmprtpartycodeallhist    Script Date: 3/17/01 9:55:43 PM ******/

/****** Object:  Stored Procedure dbo.albmprtpartycodeallhist    Script Date: 3/21/01 12:49:59 PM ******/

/****** Object:  Stored Procedure dbo.albmprtpartycodeallhist    Script Date: 20-Mar-01 11:38:42 PM ******/

/****** Object:  Stored Procedure dbo.albmprtpartycodeallhist    Script Date: 2/5/01 12:06:06 PM ******/

/****** Object:  Stored Procedure dbo.albmprtpartycodeallhist    Script Date: 12/27/00 8:58:42 PM ******/

/* this sp is used inalbmprintctlprj contol. variable sdateis used to get the 
all partycode from history table  and sett_type='l'   and tradeqty > 0 */
CREATE PROCEDURE albmprtpartycodeallhist
 @Sdate varchar(12)
 AS
Select Distinct Party_code From history
where  sauda_date Like  @Sdate + '%' and sett_type = 'l' and tradeqty > 0

GO
