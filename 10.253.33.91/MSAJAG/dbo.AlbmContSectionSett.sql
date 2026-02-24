-- Object: PROCEDURE dbo.AlbmContSectionSett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.AlbmContSectionSett    Script Date: 3/17/01 9:55:43 PM ******/

/****** Object:  Stored Procedure dbo.AlbmContSectionSett    Script Date: 3/21/01 12:49:59 PM ******/

/****** Object:  Stored Procedure dbo.AlbmContSectionSett    Script Date: 20-Mar-01 11:38:41 PM ******/

/****** Object:  Stored Procedure dbo.AlbmContSectionSett    Script Date: 2/5/01 12:06:06 PM ******/

/****** Object:  Stored Procedure dbo.AlbmContSectionSett    Script Date: 12/27/00 8:58:42 PM ******/

/*control name albmprintctl*/
/* table used settlement scrip1,scrip2,albmrate*/
CREATE Procedure AlbmContSectionSett (@SDate Varchar(12),@Party_Code Varchar(10)) As
select Trade_no,tm=left(convert(varchar,sauda_date,108),8),party_code,Scripname=short_name,
Tradeqty,NetRate,sell_buy,BrokApplied=(brokapplied*Tradeqty),marketrate,
Amount = ( Case When Sell_Buy = 1 Then
  (tradeqty*MarketRate)  + (brokapplied*Tradeqty) /*  added brokapplied*Tradeqty*/
    Else
  (tradeqty*MarketRate) - (brokapplied*Tradeqty)  /* added  brokapplied*Tradeqty*/
    End ),sauda_date,rate,
Fees = ( Case When Sell_Buy = 2 Then
  abs(rate - MarketRate)*Tradeqty 
                 Else
  abs(MarketRate - rate)*Tradeqty  /*   replased nettrate*/
    End )
 from Settlement s,scrip1 s1,scrip2 s2,albmrate a
where s.sett_type='l' and sauda_date like @Sdate + '%' and a.sett_no = s.sett_no and a.sett_type = s.sett_Type and a.scrip_cd = s.scrip_cd and a.series = s.series
and party_code Like @Party_Code and s.scrip_Cd = s2.scrip_Cd and s.series = s2.series and s1.co_code = s2.co_code and s1.series = s2.series
order by short_name

GO
