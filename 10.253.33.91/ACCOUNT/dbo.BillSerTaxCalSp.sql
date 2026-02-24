-- Object: PROCEDURE dbo.BillSerTaxCalSp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BillSerTaxCalSp    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.BillSerTaxCalSp    Script Date: 11/28/2001 12:23:41 PM ******/

/****** Object:  Stored Procedure dbo.BillSerTaxCalSp    Script Date: 29-Sep-01 8:12:02 PM ******/

/****** Object:  Stored Procedure dbo.BillSerTaxCalSp    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.BillSerTaxCalSp    Script Date: 8/7/01 6:03:47 PM ******/

/****** Object:  Stored Procedure dbo.BillSerTaxCalSp    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.BillSerTaxCalSp    Script Date: 2/17/01 3:34:13 PM ******/


/****** Object:  Stored Procedure dbo.BillSerTaxCalSp    Script Date: 20-Mar-01 11:43:32 PM ******/

/*
report :billwise service tax (modification of vb control)
file : printingcontroll/billwiseservicetax/Bsertaxdetails.asp
**/
CREATE PROCEDURE BillSerTaxCalSp
@settno as varchar(7),
@settype as varchar(2),
@enddate as varchar(2),
@startdate as varchar(2)
 AS
 select settno=(substring(l3.narr,8,8)),l.vamt ,
 tstart_date =(select start_date
   from MSAJAG.DBO.sett_mst
  where Sett_No= @settno and sett_type=@settype), 
 tend_date = l.VDT , L.CLTCODE 
 from ledger l, ledger3 l3
 where  substring(l.refno, 1, 7) = substring(l3.refno, 1, 7)  and
 cltcode in('99988' ,'99990','61310') and l.vtyp='15'  AND
 convert(varchar,VDT,103) >=@enddate And 
 convert(varchar,VDT,103) <=@startdate  
 order by tstart_date,VDT

GO
