-- Object: PROCEDURE dbo.foGetCumulativeBalBill
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.foGetCumulativeBalBill    Script Date: 01/04/1980 1:40:37 AM ******/



/****** Object:  Stored Procedure dbo.foGetCumulativeBalBill    Script Date: 11/28/2001 12:23:43 PM ******/

/****** Object:  Stored Procedure dbo.foGetCumulativeBalBill    Script Date: 29-Sep-01 8:12:04 PM ******/


/****** Object:  Stored Procedure dbo.foGetCumulativeBalBill    Script Date: 9/7/2001 6:05:53 PM ******/


/****** Object:  Stored Procedure dbo.foGetCumulativeBalBill    Script Date: 8/29/2001 12:23:51 PM ******/


/****** Object:  Stored Procedure dbo.foGetCumulativeBalBill    Script Date: 7/25/01 10:08:13 PM ******/

/****** Object:  Stored Procedure dbo.foGetCumulativeBalBill    Script Date: 7/1/01 2:19:42 PM ******/

/****** Object:  Stored Procedure dbo.foGetCumulativeBalBill    Script Date: 6/30/01 12:21:09 PM ******/

/****** Object:  Stored Procedure dbo.foGetCumulativeBalBill    Script Date: 5/5/01 2:55:30 PM ******/

/****** Object:  Stored Procedure dbo.foGetCumulativeBalBill    Script Date: 20-Mar-01 11:43:33 PM ******/

/*Final sql - 07 feb 2001 */
/*Ranjeet Choudhary*/
/*used in nsefo segment*/

CREATE PROCEDURE  foGetCumulativeBalBill   @tsettno  varchar(7) ,
@tsetttype as varchar(2),@bdate as varchar(11)
AS

 select  distinct clientdrcr  =isnull((select isnull(sum(amount),0) from msajag.dbo.foaccbill s 
 			   where  sett_type=  @tsetttype   and left(convert(varchar,billdate,109),11)=@bdate    and sell_buy =1  
		   	   and  party_code not in ('99890' , '99885' ,'99888','200')) - 
			  (select sum(amount) from msajag.dbo.foaccbill s 
			  where  sett_type= @tsetttype   and left(convert(varchar,billdate,109),11)=@bdate  and sell_buy =2
			  and  party_code not in ( '99890' ,'99885', '99888','200')),0), 
	 tenddate  = (select distinct billdate from msajag.dbo.foaccbill s 
		     where sett_type= @tsetttype and left(convert(varchar,billdate,109),11)=@bdate   ),  
	 tpayout  =  (select  max(payout_date) from msajag.dbo.foaccbill sm 
		     where sett_type=    @tsetttype and left(convert(varchar,billdate,109),11)=@bdate  and sell_buy = 1   ), 
	 tstartdate = (select distinct max(start_date) from msajag.dbo.fosett_mst s
		     where sett_type=    @tsetttype  and left(convert(varchar,billdate,109),11)=@bdate      ),
	 tpayoutCr  =  (select  max(payout_date) from msajag.dbo.foaccbill sm 
		     where sett_type=    @tsetttype and left(convert(varchar,billdate,109),11)=@bdate  and sell_buy = 2  )

  from msajag.dbo.foaccbill s1  where s1.sett_type=  @tsetttype and left(convert(varchar,billdate,109),11)=@bdate

GO
