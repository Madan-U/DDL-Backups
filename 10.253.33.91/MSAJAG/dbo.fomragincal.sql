-- Object: PROCEDURE dbo.fomragincal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





/****** Object:  Stored Procedure dbo.fomragincal    Script Date: 5/26/01 4:17:00 PM ******/


/****** Object:  Stored Procedure dbo.fomragincal    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.fomragincal    Script Date: 3/21/01 12:50:08 PM ******/

/****** Object:  Stored Procedure dbo.fomragincal    Script Date: 20-Mar-01 11:38:50 PM ******/

/****** Object:  Stored Procedure dbo.fomragincal    Script Date: 2/5/01 12:06:13 PM ******/

/****** Object:  Stored Procedure dbo.fomragincal    Script Date: 12/27/00 8:58:50 PM ******/




create proc fomragincal as
select  distinct s1.party_code,s1.expirydate,s1.inst_type,s1.symbol,
Pqty = isnull(( select sum(tradeqty) from fosettlement 
         where sell_buy = 1 and 
               fosettlement.inst_type=s1.inst_type and 
               fosettlement.symbol=s1.symbol and 
               fosettlement.expirydate=s1.expirydate
               and (s1.party_code = fosettlement.party_code)),0),
SQty = isnull(( select sum(tradeqty) from fosettlement 
          where sell_buy = 2 and 
                fosettlement.inst_type=s1.inst_type and 
  fosettlement.symbol=s1.symbol and 
  fosettlement.expirydate=s1.expirydate and  
  (s1.party_code = fosettlement.party_code)),0),
totalqty=(isnull(( select sum(tradeqty) from fosettlement 
         where sell_buy = 1 and 
               fosettlement.inst_type=s1.inst_type and 
               fosettlement.symbol=s1.symbol and 
               fosettlement.expirydate=s1.expirydate 
               and (s1.party_code = fosettlement.party_code)),0)-isnull(( select sum(tradeqty) from fosettlement 
          where sell_buy = 2 and 
                fosettlement.inst_type=s1.inst_type and 
  fosettlement.symbol=s1.symbol and 
  fosettlement.expirydate=s1.expirydate and  
  (s1.party_code = fosettlement.party_code)),0)
         ),
c.cl_rate
from fosettlement s1,foclosing c
where left(convert(varchar,s1.sauda_date,105),11) between '01-08-2000' and '31-08-2000'  and
 c.Inst_Type = s1.inst_type and
  c.Symbol = s1.symbol and
         c.expirydate=s1.expirydate and
  left(convert(varchar,c.trade_date,109),11) = ( select left(convert(varchar,max(sauda_date),109),11) from fosettlement)

GO
