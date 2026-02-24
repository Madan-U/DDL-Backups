-- Object: PROCEDURE dbo.MuGetCumulativeBalBill
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.MuGetCumulativeBalBill    Script Date: 01/04/1980 1:40:38 AM ******/



/****** Object:  Stored Procedure dbo.MuGetCumulativeBalBill    Script Date: 11/28/2001 12:23:45 PM ******/

/****** Object:  Stored Procedure dbo.MuGetCumulativeBalBill    Script Date: 29-Sep-01 8:12:05 PM ******/

/****** Object:  Stored Procedure dbo.MuGetCumulativeBalBill    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.MuGetCumulativeBalBill    Script Date: 8/7/01 6:03:49 PM ******/

/****** Object:  Stored Procedure dbo.MuGetCumulativeBalBill    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.MuGetCumulativeBalBill    Script Date: 2/17/01 3:34:15 PM ******/


/****** Object:  Stored Procedure dbo.MuGetCumulativeBalBill    Script Date: 20-Mar-01 11:43:34 PM ******/

CREATE PROCEDURE  MuGetCumulativeBalBill   @tsettno  varchar(7) ,
@tsetttype as varchar(2)
AS
 select  clientdrcr  =isnull((select isnull(sum(amount),0) from MSAJAG.DBO.muaccbill s 
       where s.sett_no=     @tsettno      and sett_type=  @tsetttype       and sell_buy =1  
         and  party_code not in ('99990' ,'61310', '99985' ,'99988','100')) - 
     (select sum(amount) from MSAJAG.DBO.muaccbill s 
     where s.sett_no=      @tsettno       and sett_type= @tsetttype   and sell_buy =2
     and  party_code not in ( '99990' , '61310','99985', '99988','100')),0), 
  tenddate  = (select distinct max(end_date) from MSAJAG.DBO.muaccbill s 
       where s.sett_no=      @tsettno    and sett_type= @tsetttype ),  
  tpayout  =  (select max(payout_date) from MSAJAG.DBO.muaccbill sm 
       where sm.sett_no=         @tsettno   and sett_type=    @tsetttype   ), 
  tstartdate = (select distinct max(start_date) from MSAJAG.DBO.muaccbill s
       where s.sett_no=     @tsettno    and sett_type=    @tsetttype      )
  from MSAJAG.DBO.muaccbill s1  where s1.sett_no=     @tsettno  and s1.sett_type=  @tsetttype

GO
