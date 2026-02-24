-- Object: PROCEDURE dbo.foselmissclient
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.foselmissclient    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.foselmissclient    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.foselmissclient    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.foselmissclient    Script Date: 20-Mar-01 11:38:50 PM ******/

/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/


CREATE proc  foselmissclient as
 /*Used in NSE FO */ 
 /*Control Name :FoImportTrade Module Name :CmdMClient_Click()*/
 /*view used :foTrade*/
 /*Function:This used to missing client i.e the clients partycode prsernt in the fotrade table but not in client2 table*/            
 /*Written By :Ranjeet Choudhary */

 SELECT party_code  From fotrade Where party_code not in 
(Select distinct party_code from client2) 
group by party_code

GO
