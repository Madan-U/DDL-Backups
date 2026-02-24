-- Object: PROCEDURE dbo.FotrdSeldate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.FotrdSeldate    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.FotrdSeldate    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.FotrdSeldate    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.FotrdSeldate    Script Date: 20-Mar-01 11:38:50 PM ******/


/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/

CREATE proc FotrdSeldate as 
 /*Used in NSE FO */ 
 /*Control Name :FoImportTrade Module Name :CmdContract_Click()*/
 /*Table Used : read  only :Fotrade*/
 /*Function:This is used to select the activity date from fotrade*/
 /*Written By :Ranjeet Choudhary */ 

select distinct left(convert(varchar,activitytime,105),11) from fotrade

GO
