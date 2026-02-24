-- Object: PROCEDURE dbo.foClosSelClrt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------






CREATE proc foClosSelClrt
( @insttype varchar(6),
  @symbol   varchar(13),
  @expirydate varchar(12),
@strikeprice money,
@optiontype varchar(5),
@tradedate varchar(12)) as

 /*Used in NSE FO */ 
 /*Control Name :FoImportTrade Module Name :CmdContract_Click()*/
 /*table Used : read  only :foclosing*/
 /*Function:This is used to closing rate from foclosing table*/
 /*Written By :Ranjeet Choudhary */ 

  SELECT CL_RATE = isnull(( select distinct isnull(s1.cl_rate,0) from foclosing s1
         where s1.inst_type=@insttype AND 
               s1.symbol=@symbol AND 
               left(convert(varchar,s1.expirydate,105),11)=@expirydate and 
        s1.strike_price=@strikeprice and    
s1.option_type=@optiontype and
   left(convert(varchar,trade_date,105),11)=@tradedate),0)

GO
