-- Object: PROCEDURE dbo.fotrdConfirmInst
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.fotrdConfirmInst    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.fotrdConfirmInst    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.fotrdConfirmInst    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.fotrdConfirmInst    Script Date: 20-Mar-01 11:38:50 PM ******/


/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/

CREATE proc fotrdConfirmInst as
/*Used in NSE FO */ 
 /*Control Name :FoImportTrade Module Name :CmdContract_Click()*/
 /*View Used : read  only :foconfirmview*/
 /*Function:This is used to select some fields from foconfirmview*/
 /*Written By :Ranjeet Choudhary */ 

select distinct Inst_type,Symbol,left(convert(varchar,expirydate,105),11)expirydate,
strike_price,option_type,party_code from foconfirmview order by party_code

GO
