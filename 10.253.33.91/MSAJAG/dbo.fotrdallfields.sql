-- Object: PROCEDURE dbo.fotrdallfields
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.fotrdallfields    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.fotrdallfields    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.fotrdallfields    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.fotrdallfields    Script Date: 20-Mar-01 11:38:50 PM ******/

/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/



CREATE proc fotrdallfields
(@tradeno varchar(10),
 @partycode varchar(10),
 @insttype varchar(6),
 @symbol  varchar(12),
@expirydate as smalldatetime,
 @strikeprice as money,
 @optiontype as varchar(2),
 @procli  int,
 @sellbuy  int) as

select * from fotrade 
where trade_no = @tradeno
and party_code = @partycode
 and inst_type=@insttype
   and symbol=@symbol
   and expirydate=@expirydate
   and strike_price=@strikeprice
   and option_type=@optiontype
   and pro_cli=@procli  
   and sell_buy = @sellbuy

GO
