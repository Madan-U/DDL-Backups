-- Object: PROCEDURE dbo.rpt_fotopgrossamt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fotopgrossamt    Script Date: 5/11/01 6:19:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotopgrossamt    Script Date: 5/7/2001 9:02:52 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotopgrossamt    Script Date: 5/5/2001 2:43:40 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotopgrossamt    Script Date: 5/5/2001 1:24:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotopgrossamt    Script Date: 05/04/2001 8:26:28 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotopgrossamt    Script Date: 5/4/2001 2:40:17 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotopgrossamt    Script Date: 4/30/01 5:50:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fotopgrossamt    Script Date: 10/26/00 6:04:45 PM ******/






/****** Object:  Stored Procedure dbo.rpt_fotopgrossamt    Script Date: 12/27/00 8:59:11 PM ******/
/*Modified by Amolika on 9th feb : removed sdate*/
CREATE PROCEDURE rpt_fotopgrossamt
/*@sdate varchar(12),*/
@topamt varchar(10),
@partycode varchar(10)
AS
/*select inst_type, symbol, CONVERT(varchar,expirydate,106)'expirydate', tradeqty ,amount,sell_buy ,
convert(varchar,sauda_date,106)'sauda_date'
from fosettlement s, client1 c1, client2 c2
where c1.cl_code = c2.cl_code
and c2.party_code = s.party_code
and  convert(varchar,s.expirydate,106) = @sdate
and amount > convert(money,@topamt) 
group by inst_type, symbol, expirydate, tradeqty ,amount,sell_buy ,sauda_date
order by inst_type, symbol, expirydate,sell_buy 

*/


select s.inst_type, s.symbol, CONVERT(varchar,s.expirydate,106)'expirydate', tradeqty ,amount,sell_buy ,
convert(varchar,sauda_date,106)'sauda_date'
from fosettlement s, client1 c1, client2 c2, foscrip2 s2
where c1.cl_code = c2.cl_code
and c2.party_code = s.party_code
and amount > convert(money,@topamt) 
and s.party_code = @partycode
and s.inst_type = s2.inst_type
and s.symbol = s2.symbol
and s.expirydate = s2.expirydate
and s2.Maturitydate >= (select left(convert(varchar,getdate(),109),11) )
group by s.inst_type, s.symbol, s.expirydate, tradeqty ,amount,sell_buy ,sauda_date
order by s.inst_type, s.symbol, s.expirydate,sell_buy

GO
