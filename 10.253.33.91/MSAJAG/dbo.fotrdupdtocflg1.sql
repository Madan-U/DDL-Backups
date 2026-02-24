-- Object: PROCEDURE dbo.fotrdupdtocflg1
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.fotrdupdtocflg1    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.fotrdupdtocflg1    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.fotrdupdtocflg1    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.fotrdupdtocflg1    Script Date: 20-Mar-01 11:38:51 PM ******/

/*Last updated on 12 feb 2001*/
/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/


CREATE proc fotrdupdtocflg1 
(@party_code varchar(10),
 @tradeno varchar(10),
 @insttype varchar(6),
 @symbol  varchar(12),
 @expirydate as smalldatetime,
 @strikeprice as money,
 @optiontype as varchar(2),
 @procli  int,
 @settflag int,
 @sellbuy  int,
 @tradeqty int) as

 update FOTRADE set settflag = @settflag,tradeqty=@tradeqty
   from FOTRADE
   where  party_code = @party_code
   and trade_no=@tradeno
   and inst_type=@insttype
   and symbol=@symbol
/*    and pro_cli=@procli  */
   and sell_buy = @sellbuy
   and option_type = @optiontype
   and strike_price = @strikeprice

GO
