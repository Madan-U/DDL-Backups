-- Object: PROCEDURE dbo.Confirmation
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.Confirmation    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.Confirmation    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.Confirmation    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.Confirmation    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.Confirmation    Script Date: 12/27/00 8:58:47 PM ******/

/****** Object:  Stored Procedure dbo.Confirmation    Script Date: 12/18/99 8:24:03 AM ******/
CREATE PROCEDURE Confirmation AS
select party_code,scrip_cd,scripname,trade_no,sell_buy,order_no,sdt=(convert(char,sauda_date,3)),short_name,auctionpart,
 sett_no,enddt=(convert(char,end_date,3)),startdt=(convert(char,start_date,3)),tm=convert(char,sauda_date,8),
 service_tax=isnull(service_tax,0),broker_chrg=isnull(broker_chrg,0),
 ins_chrg=isnull(ins_chrg,0),turn_tax=isnull(turn_tax,0),sebi_tax=isnull(sebi_tax,0),
 insurance_chrg,turnover_tax,sebiturn_tax,broker_note,sertax,year,exchange, off_phone1,
 pqty=isnull((case sell_buy
  when 1 then tradeqty
      end),0),
 sqty=isnull((case sell_buy
  when 2 then tradeqty
      end),0),
 prate=isnull((case sell_buy
  when 1 then marketrate
      end),0),
 srate=isnull((case sell_buy
  when 2 then marketrate
      end),0),
  pbrok=isnull((case sell_buy
  when 1 then brokapplied
      end),0),
 sbrok=isnull((case sell_buy
  when 2 then brokapplied
      end),0),
 pnetrate=isnull((case sell_buy
  when 1 then netrate
      end),0),
 snetrate=isnull((case sell_buy
  when 2 then netrate
      end),0),
 pamount=isnull((case sell_buy
  when 1 then amount
      end),0),
 samount=isnull((case sell_buy
  when 2 then amount
      end),0),
 Brokerage=isnull((tradeqty*brokapplied),0)
from confirmview
order by party_code,scripname

GO
