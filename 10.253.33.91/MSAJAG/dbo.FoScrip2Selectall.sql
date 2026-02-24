-- Object: PROCEDURE dbo.FoScrip2Selectall
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.FoScrip2Selectall    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.FoScrip2Selectall    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.FoScrip2Selectall    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.FoScrip2Selectall    Script Date: 20-Mar-01 11:38:50 PM ******/

/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/


CREATE proc FoScrip2Selectall

 (@insttype varchar(6),
  @symbol   varchar(13),
  @expirydate smalldatetime,
  @strikeprice money,
  @optiontype varchar(2)) as

 /*Used in NSE FO */
 /*Control Name :FoScrip2 ,Module Name :CmdSave_Click()*/
 /*Table Used : Read Only : Foscrip2*/
 /*Function:this store procedure is used to check whether the record exist 
   for the above parameter*/
 /*Written By :Ranjeet Choudhary */


SELECT * FROM FOSCRIP2 
WHERE inst_type=@insttype and
      symbol=@symbol and
      expirydate=@expirydate and  
      strike_price=@strikeprice and
      option_type=@optiontype

GO
