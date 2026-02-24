-- Object: PROCEDURE dbo.GetCumulativeBalBillins
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.GetCumulativeBalBillins    Script Date: 01/04/1980 1:40:37 AM ******/



/****** Object:  Stored Procedure dbo.GetCumulativeBalBillins    Script Date: 11/28/2001 12:23:44 PM ******/

/****** Object:  Stored Procedure dbo.GetCumulativeBalBillins    Script Date: 29-Sep-01 8:12:04 PM ******/

/****** Object:  Stored Procedure dbo.GetCumulativeBalBillins    Script Date: 8/8/01 1:37:30 PM ******/

/****** Object:  Stored Procedure dbo.GetCumulativeBalBillins    Script Date: 8/7/01 6:03:49 PM ******/

/****** Object:  Stored Procedure dbo.GetCumulativeBalBillins    Script Date: 7/8/01 3:22:49 PM ******/

/****** Object:  Stored Procedure dbo.GetCumulativeBalBillins    Script Date: 2/17/01 3:34:15 PM ******/


/****** Object:  Stored Procedure dbo.GetCumulativeBalBillins    Script Date: 20-Mar-01 11:43:33 PM ******/

/*created by sheetal on  22/10/2000 
 gets the cumulative balance amount of all the parties of the selected settlement  .  used in transferbill project      
used for the institutional Bill posting */
CREATE PROCEDURE  GetCumulativeBalBillins   @tsettno  varchar(7) ,
@tsetttype as varchar(2)
AS


select  clientdrcr  =isnull((select isnull(sum(amount),0) from MSAJAG.DBO.iaccbill s 
       where s.sett_no=     @tsettno      and sett_type=  @tsetttype       and sell_buy =1  
         and  party_code not in (select cltcode from acmast where accat <> 4)) - 
     (select sum(amount) from MSAJAG.DBO.iaccbill s 
     where s.sett_no=      @tsettno       and sett_type= @tsetttype   and sell_buy =2
     and  party_code not in (select cltcode from acmast where accat <> 4)),0), 
  tenddate  = (select distinct max(end_date) from MSAJAG.DBO.iaccbill s 
       where s.sett_no=      @tsettno    and sett_type= @tsetttype ),  
  tpayout  =  (select max(payout_date) from MSAJAG.DBO.iaccbill sm 
       where sm.sett_no=         @tsettno   and sett_type=    @tsetttype   ), 
  tstartdate = (select distinct max(start_date) from MSAJAG.DBO.sett_mst s
       where s.sett_no=     @tsettno    and sett_type=    @tsetttype      )

 /*select  clientdrcr  =isnull((select isnull(sum(amount),0) from MSAJAG.DBO.iaccbill s 
       where s.sett_no=     @tsettno      and sett_type=  @tsetttype       and sell_buy =1  
         and  party_code not in ('99990' ,'61310', '99985' ,'99988','100')) - 
     (select sum(amount) from MSAJAG.DBO.iaccbill s 
     where s.sett_no=      @tsettno       and sett_type= @tsetttype   and sell_buy =2
     and  party_code not in ( '99990' , '61310','99985', '99988','100')),0), 
  tenddate  = (select distinct max(end_date) from MSAJAG.DBO.iaccbill s 
       where s.sett_no=      @tsettno    and sett_type= @tsetttype ),  
  tpayout  =  (select max(payout_date) from MSAJAG.DBO.iaccbill sm 
       where sm.sett_no=         @tsettno   and sett_type=    @tsetttype   ), 
  tstartdate = (select distinct max(start_date) from MSAJAG.DBO.sett_mst s
       where s.sett_no=     @tsettno    and sett_type=    @tsetttype      )*/
/*  from MSAJAG.DBO.iaccbill s1  where s1.sett_no=     @tsettno  and s1.sett_type=  @tsetttype*/

GO
