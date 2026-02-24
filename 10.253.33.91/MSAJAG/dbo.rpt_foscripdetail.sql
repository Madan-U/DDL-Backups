-- Object: PROCEDURE dbo.rpt_foscripdetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_foscripdetail    Script Date: 5/11/01 6:19:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foscripdetail    Script Date: 5/7/2001 9:02:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foscripdetail    Script Date: 5/5/2001 2:43:39 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foscripdetail    Script Date: 5/5/2001 1:24:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foscripdetail    Script Date: 4/30/01 5:50:16 PM ******/

/****** Object:  Stored Procedure dbo.rpt_foscripdetail    Script Date: 10/26/00 6:04:44 PM ******/


/*
written by neelambari on 13 April  2001
*/
CREATE procedure  rpt_foscripdetail
@fdate1 varchar(12) ,
@fdate varchar(12),
@symbol varchar(12),
@insttype varchar(6),
@expirydate varchar(12)
 as
select Broker_chrg,sell_buy,tradeqty , price,
convert(varchar ,sauda_date,106) as sauda_date
from fosettlement 
where sauda_date >=@fdate1
and sauda_date <=@fdate + ' 23:59:59'
and party_code not in (select membercode from owner)
and symbol = @symbol
and convert(varchar,expirydate,106)=@expirydate
and inst_type =@insttype
order by sauda_date

GO
