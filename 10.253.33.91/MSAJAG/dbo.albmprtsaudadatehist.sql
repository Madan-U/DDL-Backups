-- Object: PROCEDURE dbo.albmprtsaudadatehist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.albmprtsaudadatehist    Script Date: 3/17/01 9:55:43 PM ******/

/****** Object:  Stored Procedure dbo.albmprtsaudadatehist    Script Date: 3/21/01 12:49:59 PM ******/

/****** Object:  Stored Procedure dbo.albmprtsaudadatehist    Script Date: 20-Mar-01 11:38:42 PM ******/

/****** Object:  Stored Procedure dbo.albmprtsaudadatehist    Script Date: 2/5/01 12:06:06 PM ******/

/****** Object:  Stored Procedure dbo.albmprtsaudadatehist    Script Date: 12/27/00 8:58:42 PM ******/

/* this sp is used inalbmprintctlprj contol. variable settno is used to get the 
distinct sauda_date from  history table  and sett_type='l'  left ,convert is used to get the datepart from sauda_date */ 
CREATE PROCEDURE albmprtsaudadatehist
@settno varchar(10)
 AS
 select distinct left(convert(varchar,sauda_date,109),11 )
  from History
 where sett_no=@settno  and sett_type='l'

GO
