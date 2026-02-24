-- Object: PROCEDURE dbo.foTrdMisScrip
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.foTrdMisScrip    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.foTrdMisScrip    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.foTrdMisScrip    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.foTrdMisScrip    Script Date: 20-Mar-01 11:38:50 PM ******/


/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/

CREATE proc foTrdMisScrip as 
 /*Used in NSE FO */ 
 /*Control Name :FoImportTrade Module Name :cmdScplist_Click()*/
 /*table used :Read only foTrade,scrip2*/
 /*Function:This used to find missing scrip from trade*/            
 /*Written By :Ranjeet Choudhary */
Select Distinct inst_type,symbol,expirydate,option_type,strike_price,sec_name 
from fotrade where expirydate not in ( select expirydate from foScrip2 where 
foscrip2.inst_type=fotrade.inst_type and
foscrip2.symbol=fotrade.symbol and
foscrip2.expirydate=fotrade.expirydate and
foscrip2.option_type = fotrade.option_type and
foscrip2.strike_price=fotrade.strike_price)

GO
