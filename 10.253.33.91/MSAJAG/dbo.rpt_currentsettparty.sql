-- Object: PROCEDURE dbo.rpt_currentsettparty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_currentsettparty    Script Date: 04/27/2001 4:32:38 PM ******/

/****** Object:  Stored Procedure dbo.rpt_currentsettparty    Script Date: 3/21/01 12:50:14 PM ******/

/****** Object:  Stored Procedure dbo.rpt_currentsettparty    Script Date: 20-Mar-01 11:38:55 PM ******/
/* created on 23/02/2001
    report : netposition
    file: nsedelcurrentscrip
*/
/* finds  total of sell and buy for all scrips of a particular client for a particular series and settlement
    It also finds whether that client has deposited any shares with us in advance */
CREATE PROCEDURE rpt_currentsettparty

@settno varchar(7),
@settype varchar(3),
@partycode  varchar(10)

AS


select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,
Qty=Sum(d.tradeQty),d.sell_buy, demat_date=isnull(s1.demat_date,getdate()+2),
recqty=isnull((select sum(qty) from certinfo c where c.party_code=d.party_code and c.sett_no=d.sett_no
and c.sett_type=d.sett_type and c.scrip_cd=d.scrip_cd and c.series=d.series and targetparty=1
group by c.sett_no,c.sett_type,c.series,c.scrip_cd),0 )
 from settlement d,scrip1 s1,scrip2 s2,client1 c1,client2 c2
 where s1.co_code = s2.co_code and s1.series = s2.series
 and s2.scrip_cd = d.scrip_cd  and s2.series =d.series
 and d.party_code = c2.party_code and c1.cl_code =c2.cl_code
 and d.sett_no =@settno and d.sett_type =@settype  and d.party_code = @partycode
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code,s1.demat_date,d.sell_buy
 order by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code,s1.demat_date,d.sell_buy

GO
