-- Object: PROCEDURE dbo.FOclosSelectScrip
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.FOclosSelectScrip    Script Date: 5/26/01 4:17:00 PM ******/


/****** Object:  Stored Procedure dbo.FOclosSelectScrip    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.FOclosSelectScrip    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.FOclosSelectScrip    Script Date: 20-Mar-01 11:38:50 PM ******/

/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/


CREATE proc FOclosSelectScrip 
(@tdate smalldatetime) as
 /*Used in NSE FO */
 /*Control Name :FoClosing Module Name :Getresult()*/
 /*Table Used : read only :Foscrip2,FoClosing*/
 /*Function:This is used select all the scrips from foscrip2 table those are not present in foclosing table*/
 /*Written By :Ranjeet Choudhary */ 
SELECT DISTINCT 
foscrip2.sec_name,foscrip2.inst_type,foscrip2.symbol,
foscrip2.expirydate,0,foscrip2.strike_price,foscrip2.option_type
 From foscrip2 Where
 Not Exists
(SELECT * From foclosing
 WHERE foscrip2.inst_type=foclosing.inst_type
 and foscrip2.symbol=foclosing.symbol and foscrip2.expirydate=foclosing.expirydate
and foscrip2.strike_price=foclosing.strike_price and foscrip2.option_type=foclosing.option_type) 
AND FOSCRIP2.MATURITYDATE >= (SELECT GETDATE())
UNION
     select D.SEC_NAME,S.inst_type ,S.symbol,d.EXPIRYDATE,S.CL_RATE,s.strike_price,d.option_type
    from foscrip2 d, foclosing s 
   	where d.EXPIRYDATE=s.EXPIRYDATE and
	      d.inst_type=s.inst_type and
	      d.symbol=s.symbol and
                   d.strike_price=s.strike_price and d.option_type=s.option_type and
              d.maturitydate>=(SELECT GETDATE()) and
	      s.trade_date=@TDATE
	GROUP BY D.sec_name,S.inst_type ,S.symbol,S.CL_RATE,d.EXPIRYDATE,s.strike_price,d.option_type
 ORDER BY EXPIRYDATE

GO
