-- Object: PROCEDURE dbo.fotrdsmfields
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.fotrdsmfields    Script Date: 5/26/01 4:17:01 PM ******/


/****** Object:  Stored Procedure dbo.fotrdsmfields    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.fotrdsmfields    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.fotrdsmfields    Script Date: 20-Mar-01 11:38:51 PM ******/


/*last updated on 12 th feb 2001*/
/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/



/*The procli part in the conditions is updated in 12th feb 2001*/
CREATE proc fotrdsmfields
(@flg int,
 @trdqty int,
 @partycode  varchar(10),
 @insttype  varchar(6),
 @symbol  varchar(12),
 @expirydate as smalldatetime,
 @strikeprice as money,
 @optiontype as varchar(2),
 @procli  int,
 @sellbuy  int)as
 
if @flg='1'
begin
select trade_no,order_no,tradeqty ,price 
from FOTRADE 
where tradeqty = @trdqty
   and party_code = @partycode
   and inst_type=@insttype
   and symbol=@symbol
    and expirydate=@expirydate
   and strike_price=@strikeprice
   and option_type=@optiontype
  /* and pro_cli=@procli  */
   and sell_buy = @sellbuy 
  
end

if @flg='2' 
begin
select trade_no,tradeqty ,price from FOTRADE 
where tradeqty > @trdqty
   and party_code = @partycode
   and inst_type=@insttype
   and symbol=@symbol
   and expirydate=@expirydate
   and strike_price=@strikeprice
   and option_type=@optiontype
/*   and pro_cli=@procli  */
   and sell_buy = @sellbuy 
end

if @flg='3'
begin
select trade_no,tradeqty from FOTRADE 
where party_code = @partycode
and inst_type=@insttype
and symbol=@symbol
and expirydate=@expirydate
and strike_price=@strikeprice
and option_type=@optiontype
/*and pro_cli =@procli*/
and sell_buy =@sellbuy 
order by tradeqty desc
end 

if @flg='4'
begin
select trade_no,tradeqty,price from FOTRADE 
where party_code = @partycode
and inst_type=@insttype
and symbol=@symbol
   and expirydate=@expirydate
   and strike_price=@strikeprice
   and option_type=@optiontype
/*and pro_cli =@procli*/
and sell_buy =@sellbuy 
order by tradeqty desc
end

GO
