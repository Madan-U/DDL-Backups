-- Object: PROCEDURE dbo.rpt_focheckqty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_focheckqty    Script Date: 5/11/01 6:19:46 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focheckqty    Script Date: 5/7/2001 9:02:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focheckqty    Script Date: 5/5/2001 2:43:36 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focheckqty    Script Date: 5/5/2001 1:24:09 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focheckqty    Script Date: 4/30/01 5:50:08 PM ******/

/****** Object:  Stored Procedure dbo.rpt_focheckqty    Script Date: 10/26/00 6:04:41 PM ******/






/****** Object:  Stored Procedure dbo.rpt_focheckqty    Script Date: 12/27/00 8:59:09 PM ******/
create proc rpt_focheckqty (@party varchar(10),@sdate smalldatetime,@inst varchar(6),@symbol varchar(12),@expirydate smalldatetime) as
select  distinct s1.party_code,C.TRADE_DATE,s1.expirydate,s1.inst_type,s1.symbol,
totalqty=( isnull(( select sum(tradeqty) from fosettlement 
                    where sell_buy = 1 and 
                           fosettlement.inst_type=@inst and
                           fosettlement.symbol=@symbol and
                           convert(varchar,fosettlement.expirydate,106) = @expirydate and
                           left(convert(varchar,fosettlement.sauda_date,109),11)<=c.trade_date and
                           fosettlement.party_code=@party),0)
            -
               isnull(( select sum(tradeqty) from fosettlement 
                            where sell_buy = 2 and 
                    fosettlement.inst_type=@inst and
                           fosettlement.symbol=@symbol and
                           convert(varchar,fosettlement.expirydate,106) =@expirydate and
                           left(convert(varchar,fosettlement.sauda_date,109),11)<=c.trade_date and
                           fosettlement.party_code=@party),0)
      
         
         ),c.cl_rate,sp.cl_rate as finalclosingrate
from fosettlement s1,foclosing c,fofinalclosing sp
where     
         s1.inst_type=@inst and
         s1.symbol=@symbol and
         convert(varchar,s1.expirydate,106) =@expirydate and
         left(convert(varchar,s1.sauda_date,109),11)<=c.trade_date and
          s1.party_code=@party  and
       
         c.Inst_Type = @inst and
  c.Symbol = @symbol and
         convert(varchar,c.expirydate,106) =@expirydate and
         left(convert(varchar,s1.sauda_date,109),11) <=( select left(convert(varchar,@sdate,109),11)) and    
         left(convert(varchar,c.trade_date,109),11) = ( select left(convert(varchar,@sdate,109),11)) and
         sp.underlyingasset=@symbol and
         left(convert(varchar,sp.closingdate,109),11) = ( select left(convert(varchar,@sdate,109),11))    
group by s1.party_code,C.TRADE_DATE,s1.expirydate,s1.inst_type,s1.symbol,c.cl_rate,c.inst_type,c.symbol,c.expirydate,sp.cl_rate

GO
