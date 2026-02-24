-- Object: PROCEDURE dbo.foImpTrdSpChg
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.foImpTrdSpChg    Script Date: 5/26/01 4:17:00 PM ******/


/****** Object:  Stored Procedure dbo.foImpTrdSpChg    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.foImpTrdSpChg    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.foImpTrdSpChg    Script Date: 20-Mar-01 11:38:50 PM ******/


/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/

CREATE proc  foImpTrdSpChg 
 (@partycode varchar(7),
  @userid int
  )

 as
 /*Used in NSE FO */ 
 /*Control Name :FoImportTrade Module Name :CmdPSave_Click()*/
 /*table used :write only foTrade*/
 /*Function:This used to missing client i.e the clients partycode prsernt in the fotrade table but not in client2 table*/            
 /*Written By :Ranjeet Choudhary */

 update fotrade set party_code = @partycode
 where user_id =@userid

GO
