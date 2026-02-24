-- Object: PROCEDURE dbo.FoTrdUpdExpDt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.FoTrdUpdExpDt    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.FoTrdUpdExpDt    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.FoTrdUpdExpDt    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.FoTrdUpdExpDt    Script Date: 20-Mar-01 11:38:51 PM ******/


/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/

CREATE PROC FoTrdUpdExpDt 
   as
 /*Used in NSE FO */ 
 /*Control Name :FoImportTrade Module Name :Cmderror_Click()*/
 /*view used :foTrade*/
 /*Function:This used to update fotrade*/            
 /*Written By :Ranjeet Choudhary */


  update foTrade set
  expirydate = substring(convert(varchar,expirydate,109),1,11)+ ' ' + '23:59:00'
  where convert(varchar,expirydate,108) = '00:00:00'

GO
