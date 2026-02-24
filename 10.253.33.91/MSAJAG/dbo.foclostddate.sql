-- Object: PROCEDURE dbo.foclostddate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.foclostddate    Script Date: 5/26/01 4:17:00 PM ******/


/****** Object:  Stored Procedure dbo.foclostddate    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.foclostddate    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.foclostddate    Script Date: 20-Mar-01 11:38:50 PM ******/


/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/

CREATE proc foclostddate as

 /*Used in NSE FO */
 /*Control Name :FoClosing Module Name :Getresult()*/
 /*Table Used : read only :Foclosing (Fo Closing)*/
 /*Function:This is used to find max date of TRADE date from foclosing table */
 /*Written By :Ranjeet Choudhary */ 


select Trade_Date=max(Trade_date) from FOCLOSING

GO
