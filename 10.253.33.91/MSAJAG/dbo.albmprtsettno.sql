-- Object: PROCEDURE dbo.albmprtsettno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.albmprtsettno    Script Date: 3/17/01 9:55:43 PM ******/

/****** Object:  Stored Procedure dbo.albmprtsettno    Script Date: 3/21/01 12:49:59 PM ******/

/****** Object:  Stored Procedure dbo.albmprtsettno    Script Date: 20-Mar-01 11:38:42 PM ******/

/****** Object:  Stored Procedure dbo.albmprtsettno    Script Date: 2/5/01 12:06:06 PM ******/

/****** Object:  Stored Procedure dbo.albmprtsettno    Script Date: 12/27/00 8:58:42 PM ******/

/* this sp is used inalbmprintctlprj contol. sp is  used to get the 
distinct sauda_date from history and settlement table  and sett_type='l'*/ 
CREATE PROCEDURE albmprtsettno AS
  select distinct sett_no
  from Settlement where sett_type ='l' 
  union
  select distinct sett_no 
  from history
  where sett_type ='l' 
  Order By sett_no

GO
