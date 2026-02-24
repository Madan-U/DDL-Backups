-- Object: PROCEDURE dbo.SpAlbmPlusBillSection
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SpAlbmPlusBillSection    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.SpAlbmPlusBillSection    Script Date: 3/21/01 12:50:31 PM ******/

/****** Object:  Stored Procedure dbo.SpAlbmPlusBillSection    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.SpAlbmPlusBillSection    Script Date: 2/5/01 12:06:28 PM ******/

/****** Object:  Stored Procedure dbo.SpAlbmPlusBillSection    Script Date: 12/27/00 8:59:04 PM ******/

CREATE proc SpAlbmPlusBillSection (@Sett_No varchar(10), @Party_code varchar(10),@Scrip_Cd varchar(12)) as
SELECT s.party_code, billno,contractno, order_no ,tm=convert(char,sauda_date,8),
 trade_no, sauda_date,s.scrip_cd,s.series,scripname='*'+s1.short_name,sdt=substring(convert(VARchar,sauda_date,109),1,11),
 sell_buy,markettype,
 service_tax = isnull(service_tax,0),
 NSertax ,  N_NetRate,
 pqty=isnull((case sell_buy
  when 1 then tradeqty end),0),
 sqty=isnull((case sell_buy
  when 2 then tradeqty end),0),
 prate=isnull((case sell_buy
  when 1 then marketrate end),0),
 srate=isnull((case sell_buy
  when 2 then marketrate end),0),
 pbrok=isnull((case sell_buy
  when 1 then brokapplied end),0),
 sbrok=isnull((case sell_buy
  when 2 then brokapplied end),0),
 pnetrate=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			s.marketrate + s.brokapplied + (nsertax/tradeqty)
		else
			s.marketrate + s.brokapplied 
		end ) 
	end),0),
 snetrate=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			s.marketrate - s.brokapplied - (nsertax/tradeqty)
		else
			s.marketrate - s.brokapplied 
		end ) 
	end),0),
 pamt=isnull((case sell_buy
  when 1 then ( case when service_chrg = 1 then 
			(s.marketrate + s.brokapplied) * tradeqty + nsertax
		else
			(s.marketrate + s.brokapplied) * tradeqty
		end ) 
	end),0),
 samt=isnull((case sell_buy
  when 2 then ( case when service_chrg = 1 then 
			(s.marketrate - s.brokapplied) * tradeqty - nsertax
		else
			(s.marketrate - s.brokapplied) * tradeqty
		end ) 
	 end),0),
 Brokerage=isnull(tradeqty*convert(numeric(9,2),brokapplied),0) ,
 NewBrokerage =isnull(tradeqty*convert(numeric(9,2),nbrokapp),0) ,
fIXMARGIN = ( case when (c2.albmdelchrg = 0 or albmdelchrg = 2 ) then (Case when order_no not like 'P%' then ISNULL(( SELECT fixmargin FROM MARGIN1 WHERE SETT_NO=S.SETT_NO AND SETT_TYPE = S.SETT_TYPE ),0)  *TRADEQTY*MARKETRATE/100 else 0 end ) else 0 end) , 
ADDMAR =  ( case when (c2.albmdelchrg = 0 or albmdelchrg = 2 ) then ISNULL((Case when order_no not like 'P%' then ISNULL(( SELECT AddMargin FROM MARGIN2 WHERE SETT_TYPE = S.SETT_TYPE AND SCRIP_CD = S.SCRIP_CD  and sett_no = S.sett_no ),0)*TRADEQTY*MARKETRATE/100 else 0 end ),0) else 0 end )
from settlement s, scrip1 s1 ,scrip2 s2, client2 c2
           where S.sett_no = ( select min(sett_no) from sett_mst where sett_no > @sett_no and sett_Type = 'N')
           and S.sett_type = 'L'
    and s.scrip_Cd = @Scrip_Cd
       and s.Party_code = @Party_code
                   and s.scrip_cd = s2.scrip_cd
                   and s.series = s2.series
                   and s1.co_code = s2.co_Code
    and s1.series = s2.series
           and TRADEQTY <> '0'
and s.party_code = c2.party_code
order by s1.short_name

GO
