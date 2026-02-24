-- Object: PROCEDURE dbo.albmprtdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.albmprtdate    Script Date: 3/17/01 9:55:43 PM ******/

/****** Object:  Stored Procedure dbo.albmprtdate    Script Date: 3/21/01 12:49:59 PM ******/

/****** Object:  Stored Procedure dbo.albmprtdate    Script Date: 20-Mar-01 11:38:42 PM ******/

/****** Object:  Stored Procedure dbo.albmprtdate    Script Date: 2/5/01 12:06:06 PM ******/

/****** Object:  Stored Procedure dbo.albmprtdate    Script Date: 12/27/00 8:58:42 PM ******/

/* this sp is used in albmprintctlprj contol. variable settno is used to get thestart_date ,end_date,sec_payin,secpay_out ,fundas_payin
funds_payout  from sett_mst table */
CREATE PROCEDURE  albmprtdate
@settno varchar(10)
 AS
select START_DATE = LEFT(CONVERT(VARCHAR,START_DATE ,109),11),
END_DATE = LEFT(CONVERT(VARCHAR,END_DATE ,109),11) ,  
Sec_Payin = LEFT(CONVERT(VARCHAR,SEC_PAYIN,109),11),
Sec_Payout = LEFT(CONVERT(VARCHAR,SEC_PAYOUT,109),11) ,  
FUNDS_PAYIN = LEFT(CONVERT(VARCHAR,FUNDS_PAYIN ,109),11) , 
FUNDS_PAYOUT = LEFT(CONVERT(VARCHAR,FUNDS_PAYOUT,109),11) 
from sett_mst  
where sett_no=@settno and sett_type='l'

GO
