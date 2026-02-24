-- Object: PROCEDURE dbo.rpt_fodutydetail
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fodutydetail    Script Date: 5/11/01 6:19:47 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fodutydetail    Script Date: 5/7/2001 9:02:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fodutydetail    Script Date: 5/5/2001 2:43:37 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fodutydetail    Script Date: 5/5/2001 1:24:12 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fodutydetail    Script Date: 4/30/01 5:50:11 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fodutydetail    Script Date: 10/26/00 6:04:42 PM ******/


/*
Written by : Neelambari on 13 April 2001
This query gives us the total stamp duty charges according to inst_type ,symbol,expirydate for each security
*/
CREATE procedure  rpt_fodutydetail
@fdate1 varchar(12) ,
@fdate varchar(12)
 as

select Broker_chrg=sum(Broker_chrg),inst_type ,symbol , expirydate ,
conexpirydate = convert(varchar,expirydate,106)  from fosettlement 
where sauda_date >= @fdate1 and
 sauda_date <= @fdate + ' 23:59:59' and 
party_code not in (select membercode from owner)
group by inst_type ,symbol,expirydate 
order by inst_type ,symbol,expirydate

GO
