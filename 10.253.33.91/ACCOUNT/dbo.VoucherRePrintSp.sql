-- Object: PROCEDURE dbo.VoucherRePrintSp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.VoucherRePrintSp    Script Date: 01/04/1980 1:40:44 AM ******/


CREATE PROCEDURE VoucherRePrintSp
@Vtyp varchar(2),
@BookTypeFrom varchar(2),
@BookTypeTo varchar(2),
@StartDate Varchar(11),
@EndDate Varchar(11),
@VnoFrom Varchar(12),
@VnoTo Varchar(12),
@VnoVdtFlag int

AS

If @VnoVdtFlag = 0 /* if voucher date */
Begin	
	select vtyp,vno,booktype,drcr,acname, cltcode,vamt,convert(varchar,vdt,103) vdt,
	narr = isnull((select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno),'') ,
	cnar = isnull((select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0),'') 
	From Ledger l
	where Vtyp = @Vtyp and Booktype >= @BookTypeFrom and BookType <= @BookTypeTo
	and vdt >= @StartDate + ' 00:00:00' and vdt <= @EndDate + ' 23:59:59'
	order by vtyp,booktype,vno,lno
End
	

If @VnoVdtFlag = 1 /* if voucher number */
Begin
	
	select vtyp,vno,booktype,drcr,acname, cltcode,vamt,convert(varchar,vdt,103) vdt,
	narr = isnull((select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = l.lno),'') ,
	cnar = isnull((select narr from ledger3 l3 where l3.vtyp = l.vtyp and l3.vno = l.vno and l3.naratno = 0),'') 
	From Ledger l
	where Vtyp = @Vtyp and Booktype >= @BookTypeFrom and BookType <= @BookTypeTo	
	and Vno >= @VnoFrom + ' 00:00:00'  and Vno <= @VnoTo + ' 23:59:59'
	order by vtyp,vno,booktype,lno
End

GO
