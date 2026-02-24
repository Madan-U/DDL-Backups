-- Object: PROCEDURE dbo.bfoaccbilldrcrproc1
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.bfoaccbilldrcrproc1    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.bfoaccbilldrcrproc1    Script Date: 11/28/2001 12:23:40 PM ******/

/****** Object:  Stored Procedure dbo.bfoaccbilldrcrproc1    Script Date: 29-Sep-01 8:12:02 PM ******/

/****** Object:  Stored Procedure dbo.bfoaccbilldrcrproc1    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.bfoaccbilldrcrproc1    Script Date: 8/7/01 6:03:47 PM ******/

/****** Object:  Stored Procedure dbo.bfoaccbilldrcrproc1    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.bfoaccbilldrcrproc1    Script Date: 2/17/01 3:34:13 PM ******/


/****** Object:  Stored Procedure dbo.bfoaccbilldrcrproc1    Script Date: 20-Mar-01 11:43:32 PM ******/



CREATE proc bfoaccbilldrcrproc1
(@settno varchar(10),@setttype varchar(2),@bdate as varchar(11)) as 

select sett_no ,sett_type,sell_buy,totalamount=sum(abs(amount))  from bsedb.dbo.bfoaccbill 
where sett_no =@settno
and sett_type =@setttype 
and left(convert(varchar,billdate,109),11)=@bdate 
group by sett_no ,sett_type,sell_buy 
order by sell_buy

GO
