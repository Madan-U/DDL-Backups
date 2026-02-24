-- Object: PROCEDURE dbo.SerTaxCalSp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SerTaxCalSp    Script Date: 01/04/1980 1:40:43 AM ******/



/****** Object:  Stored Procedure dbo.SerTaxCalSp    Script Date: 11/28/2001 12:23:52 PM ******/

/****** Object:  Stored Procedure dbo.SerTaxCalSp    Script Date: 29-Sep-01 8:12:07 PM ******/

/****** Object:  Stored Procedure dbo.SerTaxCalSp    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.SerTaxCalSp    Script Date: 8/7/01 6:03:53 PM ******/

/****** Object:  Stored Procedure dbo.SerTaxCalSp    Script Date: 7/8/01 3:22:51 PM ******/

/****** Object:  Stored Procedure dbo.SerTaxCalSp    Script Date: 2/17/01 3:34:18 PM ******/


/****** Object:  Stored Procedure dbo.SerTaxCalSp    Script Date: 20-Mar-01 11:43:36 PM ******/

CREATE PROCEDURE SerTaxCalSp
@tomonth as varchar(2),
@frommonth as varchar(2),
@yearpart varchar(4),
@typecount varchar(3)
 AS
 select settno=(substring(l3.narr,8,8)),l.vamt ,
 tstart_date =(select start_date
   from MSAJAG.DBO.sett_mst
  where Sett_No= (substring(l3.narr,8,7)) and sett_type=right(substring(narr,8,8),1)), 
 tend_date = l.VDT , L.CLTCODE 
 from ledger l, ledger3 l3
 where  /*substring(l.refno, 1, 7) = substring(l3.refno, 1, 7)*/
l.vtyp=l3.vtyp and l.vno =l3.vno
 and
 cltcode in('99988' ,'99990','61310') and l.vtyp='15'  AND
 DATEPART(MONTH,VDT)>=@tomonth And 
(substring(l3.narr,15,1)) = @typecount and 
 DATEPART(MONTH,VDT)<=@frommonth AND
 DATEPART(YEAR,VDT)=@yearpart
 order by tstart_date,VDT

GO
