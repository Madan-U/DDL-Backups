-- Object: PROCEDURE dbo.bfoGetCumulativeBalBill
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.bfoGetCumulativeBalBill    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.bfoGetCumulativeBalBill    Script Date: 11/28/2001 12:23:40 PM ******/

/****** Object:  Stored Procedure dbo.bfoGetCumulativeBalBill    Script Date: 29-Sep-01 8:12:02 PM ******/

/****** Object:  Stored Procedure dbo.bfoGetCumulativeBalBill    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.bfoGetCumulativeBalBill    Script Date: 8/7/01 6:03:47 PM ******/

/****** Object:  Stored Procedure dbo.bfoGetCumulativeBalBill    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.bfoGetCumulativeBalBill    Script Date: 2/17/01 3:34:13 PM ******/


/****** Object:  Stored Procedure dbo.bfoGetCumulativeBalBill    Script Date: 20-Mar-01 11:43:32 PM ******/



CREATE PROCEDURE  bfoGetCumulativeBalBill   @tsettno  varchar(7) ,
@tsetttype as varchar(2),@bdate as varchar(11)
AS

 select  clientdrcr  =isnull((select isnull(sum(amount),0) from bsedb.dbo.bfoaccbill s 
 			   where s.sett_no=     @tsettno      and sett_type=  @tsetttype   and left(convert(varchar,billdate,109),11)=@bdate    and sell_buy =1  
		   	   and  party_code not in ('99690' ,'99685' ,'99688','400')) - 
			  (select sum(amount) from bsedb.dbo.bfoaccbill s 
			  where s.sett_no=      @tsettno       and sett_type= @tsetttype   and left(convert(varchar,billdate,109),11)=@bdate  and sell_buy =2
			  and  party_code not in ('99690' ,'99685' ,'99688','400')),0), 
	 tenddate  = (select distinct billdate from bsedb.dbo.bfoaccbill s 
		     where s.sett_no=      @tsettno    and sett_type= @tsetttype and left(convert(varchar,billdate,109),11)=@bdate   ),  
	 tpayout  =  (select  max(payout_date) from bsedb.dbo.bfoaccbill sm 
		     where sm.sett_no=         @tsettno   and sett_type=    @tsetttype and left(convert(varchar,billdate,109),11)=@bdate     ), 
	 tstartdate = (select distinct max(start_date) from bsedb.dbo.bfosett_mst s
		     where s.sett_no=     @tsettno    and sett_type=    @tsetttype  and left(convert(varchar,billdate,109),11)=@bdate      )
  from bsedb.dbo.bfoaccbill s1  where s1.sett_no=     @tsettno  and s1.sett_type=  @tsetttype and left(convert(varchar,billdate,109),11)=@bdate

GO
