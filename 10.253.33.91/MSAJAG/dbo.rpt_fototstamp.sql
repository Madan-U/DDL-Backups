-- Object: PROCEDURE dbo.rpt_fototstamp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_fototstamp    Script Date: 5/11/01 6:19:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fototstamp    Script Date: 5/7/2001 9:02:52 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fototstamp    Script Date: 5/5/2001 2:43:41 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fototstamp    Script Date: 5/5/2001 1:24:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fototstamp    Script Date: 4/30/01 5:50:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_fototstamp    Script Date: 10/26/00 6:04:45 PM ******/


/*
Written by : Neelambari on 13 April 2001
This query gives us the total stamp duty charges 
*/
CREATE procedure  rpt_fototstamp

@fdate varchar(12) ,
@fdate1 varchar(12)

 as
select sum(Broker_chrg ) from fosettlement where
sauda_date <= @fdate and sauda_date >=@fdate1 + ' 23:59:59'
and party_code not in (select membercode from owner)

GO
