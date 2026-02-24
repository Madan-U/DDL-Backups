-- Object: PROCEDURE dbo.foscrip2selall
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.foscrip2selall    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.foscrip2selall    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.foscrip2selall    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.foscrip2selall    Script Date: 20-Mar-01 11:38:50 PM ******/

/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/


CREATE proc foscrip2selall as
 /*Used in NSE FO */
 /*Control Name :FoClosing Module Name :Getresult()*/
 /*Table Used : read only :Foscrip2*/
 /*Function:This is used select data from foscrip2 table*/
 /*Written By :Ranjeet Choudhary */ 

select foscrip2.sec_name,foscrip2.inst_type,foscrip2.symbol,
foscrip2.expirydate,0,foscrip2.strike_price,foscrip2.option_type from FOSCRIP2 WHERE MATURITYDATE >= (select getdate())
order by expirydate

GO
