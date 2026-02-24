-- Object: PROCEDURE dbo.fotrdmaxcont
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.fotrdmaxcont    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.fotrdmaxcont    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.fotrdmaxcont    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.fotrdmaxcont    Script Date: 20-Mar-01 11:38:50 PM ******/

/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/


CREATE proc fotrdmaxcont as
/*Used in NSE FO */ 
 /*Control Name :FoImportTrade Module Name :CmdContract_Click()*/
 /*Table Used : read  only :Fosettlement*/
 /*Function:This is used to select the max of contract number form fosettlement table*/
 /*Written By :Ranjeet Choudhary */ 
select isnull(max(contractno),0)Contractno from fosettlement

GO
