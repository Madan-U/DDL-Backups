-- Object: PROCEDURE dbo.fotrdsumtrdqty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.fotrdsumtrdqty    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.fotrdsumtrdqty    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.fotrdsumtrdqty    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.fotrdsumtrdqty    Script Date: 20-Mar-01 11:38:51 PM ******/

/*Last updated on 12th efeb 2001*/
/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/


CREATE proc fotrdsumtrdqty
(@sellbuy as int,
 @procli as int,
 @partycode as varchar(10),
 @insttype as varchar(6),
 @symbol as varchar(12),
 @expirydate as smalldatetime,
 @strikeprice as money,
 @optiontype as varchar(2))
as
/*select  sum(tradeqty)tradeqty from FOTRADE
where sell_buy = @sellbuy  and pro_cli=@procli  
and inst_type=@insttype
and symbol=@symbol
and party_code = @partycode
and expirydate=@expirydate
and strike_price=@strikeprice
and option_type=@optiontype*/

/*this part is updated on 12feb 2001*/

select  sum(tradeqty)tradeqty from FOTRADE
where sell_buy = @sellbuy  
/*and pro_cli=@procli  */
and inst_type=@insttype
and symbol=@symbol
and party_code = @partycode
and expirydate=@expirydate
and strike_price=@strikeprice
and option_type=@optiontype

GO
