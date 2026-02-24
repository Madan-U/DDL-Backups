-- Object: PROCEDURE dbo.FoSerTaxSp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.FoSerTaxSp    Script Date: 01/04/1980 1:40:37 AM ******/



/****** Object:  Stored Procedure dbo.FoSerTaxSp    Script Date: 11/28/2001 12:23:43 PM ******/

/****** Object:  Stored Procedure dbo.FoSerTaxSp    Script Date: 29-Sep-01 8:12:04 PM ******/


/* Created By vaishali on 26/06/2001 This proc is used in the control FoDateSerTax Control*/
CREATE proc FoSerTaxSp 
@StartDt varchar(12),
@EndDate varchar(12)
as
select convert(varchar,vdt,103), sum(ser) SerTax, sum(brok) Brok  from FoSerTaxView where 
vdt >= @StartDt + ' 00:00:00' and vdt <= @EndDate + ' 23:59:59' 
group by vdt
having sum(ser) <> 0 and sum(brok) <> 0
order by vdt

GO
