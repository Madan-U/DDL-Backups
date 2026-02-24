-- Object: PROCEDURE dbo.FoImpTrdSelParty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.FoImpTrdSelParty    Script Date: 5/26/01 4:17:00 PM ******/


/****** Object:  Stored Procedure dbo.FoImpTrdSelParty    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.FoImpTrdSelParty    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.FoImpTrdSelParty    Script Date: 20-Mar-01 11:38:50 PM ******/


/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/

CREATE proc FoImpTrdSelParty
 /*Used in NSE FO */ 
 /*Control Name :FoImportTrade Module Name :cmdCltlist_Click()*/
 /*Table Used : read  only :Fotrade,Client2*/
 /*Function:This is used records from fotrade table which are not present in client2 talbe*/
 /*Written By :Ranjeet Choudhary */ 
as

 Select Distinct Party_code from fotrade where party_code not in 
  ( select party_code from Client2 )

GO
