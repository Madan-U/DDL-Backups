-- Object: PROCEDURE dbo.albmprtpartycodehist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.albmprtpartycodehist    Script Date: 3/17/01 9:55:43 PM ******/

/****** Object:  Stored Procedure dbo.albmprtpartycodehist    Script Date: 3/21/01 12:49:59 PM ******/

/****** Object:  Stored Procedure dbo.albmprtpartycodehist    Script Date: 20-Mar-01 11:38:42 PM ******/

/****** Object:  Stored Procedure dbo.albmprtpartycodehist    Script Date: 2/5/01 12:06:06 PM ******/

/****** Object:  Stored Procedure dbo.albmprtpartycodehist    Script Date: 12/27/00 8:58:42 PM ******/

/* this sp is used inalbmprintctlprj contol. variable sdate, settno is used to get the 
distinct  partycode from history table  and sett_type='l' and tradeqty greater than zero */
CREATE PROCEDURE albmprtpartycodehist
@settno varchar(10),
 @Sdate varchar(12)
 AS
select distinct party_code from 
history where sett_no=@settno  and sett_type='l' and
 sauda_date like @Sdate + '%' and tradeqty > 0
 order by party_code

GO
