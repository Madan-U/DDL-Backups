-- Object: PROCEDURE dbo.SpAlbmHistOppBillSection
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SpAlbmHistOppBillSection    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.SpAlbmHistOppBillSection    Script Date: 3/21/01 12:50:31 PM ******/

/****** Object:  Stored Procedure dbo.SpAlbmHistOppBillSection    Script Date: 20-Mar-01 11:39:09 PM ******/

/****** Object:  Stored Procedure dbo.SpAlbmHistOppBillSection    Script Date: 2/5/01 12:06:28 PM ******/

/****** Object:  Stored Procedure dbo.SpAlbmHistOppBillSection    Script Date: 12/27/00 8:59:03 PM ******/

CREATE proc SpAlbmHistOppBillSection (@Sett_No varchar(10), @Party_code varchar(10),@Scrip_Cd varchar(12)) as
SELECT s.party_code,billno,contractno, order_no ,tm = convert(char,sauda_date,8),
 trade_no,sauda_date,S.scrip_cd,S.series,scripname='~'+s1.short_name,sdt=substring(convert(VARchar,sauda_date,109),1,11),
 sell_buy,markettype,Rate,
 service_tax = isnull(service_tax,0),
 NSertax,N_NetRate,
 pqty=isnull((case sell_buy
  when 2 then tradeqty end),0),
 sqty=isnull((case sell_buy
  when 1 then tradeqty end),0),
 prate=isnull((case sell_buy
  when 2 then Rate end),0),
 srate=isnull((case sell_buy
  when 1 then Rate end),0),
 pbrok=0,
 sbrok=0,
 pnetrate=isnull((case sell_buy
  when 2 then Rate end),0),
 snetrate=isnull((case sell_buy
  when 1 then Rate end),0),
 pamt=isnull((case sell_buy
  when 2 then Rate*TradeQty end),0),
 samt=isnull((case sell_buy
  when 1 then Rate*TradeQty end),0),
 Brokerage = 0  ,
 NewBrokerage = 0,
fIXMARGIN = ( case when (c2.albmdelchrg = 0 or albmdelchrg = 2 ) then (Case when order_no not like 'P%' then ISNULL(( SELECT fixmargin FROM MARGIN1 WHERE SETT_NO=S.SETT_NO AND SETT_TYPE = S.SETT_TYPE ),0)  *TRADEQTY*MARKETRATE/100 else 0 end ) else 0 end) , 
ADDMAR =  ( case when (c2.albmdelchrg = 0 or albmdelchrg = 2 ) then ISNULL((Case when order_no not like 'P%' then ISNULL(( SELECT AddMargin FROM MARGIN2 WHERE SETT_TYPE = S.SETT_TYPE AND SCRIP_CD = S.SCRIP_CD  and sett_no = S.sett_no ),0)*TRADEQTY*MARKETRATE/100 else 0 end ),0) else 0 end )
from HISTORY s, AlbmRate A , scrip1 s1, scrip2 s2, client2 c2
           where s.sett_no = @sett_no
           and s.sett_type = 'L'
    and s.scrip_Cd = @Scrip_Cd
       and s.Party_code = @Party_code
    and s.sett_no = a.sett_no
    and s.sett_type = a.sett_type
    and s.scrip_cd = a.scrip_cd
    and s.series = a.series
    and s.scrip_cd = s2.scrip_cd
    and s.series = s2.series
                and s1.co_Code = s2.co_code
    AND S1.SERIES = S2.SERIES
           and TRADEQTY <> '0'
and s.party_code = c2.party_code
order by s1.short_name

GO
