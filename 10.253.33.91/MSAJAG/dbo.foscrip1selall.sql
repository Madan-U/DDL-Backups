-- Object: PROCEDURE dbo.foscrip1selall
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.foscrip1selall    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.foscrip1selall    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.foscrip1selall    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.foscrip1selall    Script Date: 20-Mar-01 11:38:50 PM ******/


/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/

CREATE proc foscrip1selall (@insttype  varchar(6),@symbol varchar(12))as
 /*Used in NSE FO */
 /*Control Name :FoClosing Module Name :Getresult()*/
 /*Table Used : read only :Foscrip2*/
 /*Function:This is used select data from foscrip2 table*/
 /*Written By :Ranjeet Choudhary */ 
select distinct INST_TYPE,SYMBOL
		from FOSCRIP1 WHERE
 		FOSCRIP1.INST_TYPE=@insttype 
		AND FOSCRIP1.SYMBOL=@symbol

GO
