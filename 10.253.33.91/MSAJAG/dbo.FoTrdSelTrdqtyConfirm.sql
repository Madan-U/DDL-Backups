-- Object: PROCEDURE dbo.FoTrdSelTrdqtyConfirm
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.FoTrdSelTrdqtyConfirm    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.FoTrdSelTrdqtyConfirm    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.FoTrdSelTrdqtyConfirm    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.FoTrdSelTrdqtyConfirm    Script Date: 20-Mar-01 11:38:51 PM ******/

/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/


CREATE PROC FoTrdSelTrdqtyConfirm as
  /*Used in NSE FO */ 
 /*Control Name :FoImportTrade Module Name :CmdErrCorrect_Click()*/
 /*view used :fcoconfirmview*/
 /*Function:This is used to select trdqty and amt from forconfirmview */            
 /*Written By :Ranjeet Choudhary */
 select ISNULL(sum(tradeqty),0),ISNULL(sum(tradeqty*price),0) from foconfirmview

GO
