-- Object: PROCEDURE dbo.foclosscripcheck
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.foclosscripcheck    Script Date: 5/26/01 4:17:00 PM ******/


/****** Object:  Stored Procedure dbo.foclosscripcheck    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.foclosscripcheck    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.foclosscripcheck    Script Date: 20-Mar-01 11:38:49 PM ******/


/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/

CREATE proc foclosscripcheck as
 /*Used in NSE FO */
 /*Control Name :FoClosing Module Name :Getresult()*/
 /*Table Used : read only :Foscrip2,FoClosing*/
 /*Function:This is used select all the scrips from foscrip2 table those are not present in foclosing table*/
 /*Written By :Ranjeet Choudhary */ 
SELECT DISTINCT inst_type,symbol,EXPIRYDATE
 From foscrip2 Where
 Not Exists
(SELECT * From foclosing
 WHERE foscrip2.inst_type=foclosing.inst_type 
               and foscrip2.symbol=foclosing.symbol and 
               foscrip2.option_type=foclosing.option_type and  foscrip2.strike_price=foclosing.strike_price and
               foscrip2.expirydate=foclosing.expirydate) 
AND FOSCRIP2.MATURITYDATE > (SELECT GETDATE())

GO
