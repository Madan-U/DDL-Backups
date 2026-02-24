-- Object: PROCEDURE dbo.rpt_accallpartyMarginledvoucherdisp
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

/****** Object:  Stored Procedure dbo.rpt_accallpartyMarginledvoucherdisp    Script Date: 12/27/2005 12:19:25 PM ******/

/****** Object:  Stored Procedure dbo.rpt_accallpartyledvoucherdisp    Script Date: 04/15/2004 11:47:30 AM ******/  
/****** Object:  Stored Procedure dbo.rpt_accallpartyledvoucherdisp    Script Date: 06/11/2004 14:22:56 ******/  
  
/****** Object:  Stored Procedure dbo.rpt_accallpartyledvoucherdisp    Script Date: 12/16/2003 12:59:37 PM ******/  
  
/****** Object:  Stored Procedure dbo.rpt_accallpartyledvoucherdisp    Script Date: 02/28/2003 2:39:05 PM ******/  
/****** Object:  Stored Procedure dbo.rpt_accallpartyledvoucherdisp    Script Date: 01/19/2002 12:15:11 ******/  
/****** Object:  Stored Procedure dbo.rpt_accallpartyledvoucherdisp    Script Date: 01/04/1980 5:06:24 AM ******/  
/* report : Allpartyledger   
    filename :  voucherdisp.asp  
*/  
/* displays details of a voucher for a party for a date */  
    
CREATE  Procedure rpt_accallpartyMarginledvoucherdisp  
@vtyp smallint ,  
@vno varchar (12),  
@vdt varchar(12) ,  
@booktype varchar(2),  
@branch varchar(10),  
@cltcode varchar(10)  
  
as  
if @branch = 'full' or @branch= '' or @branch = '%'  
begin  
	select vamt=amount ,l.vtyp , l.vno , l.vdt , l.drcr , cltcode=party_code,a.acname,  l.lno ,drcrflag = (case when upper(l.drcr)='D' then 'Dr' else 'Cr' end) ,   
	nar=narration, bank = isnull(bnkname,''), branch = isnull(brnname,'') , isnull(dd,'') dd  ,isnull(ddno,'') ddno,   
	dddt  =  convert(varchar,dddt,103)
	from marginledger m,ledger l ,ledger1 l1, acmast a
	where 
	l1.vtyp = m.vtyp and l1.booktype = m.booktype and l1.vno = m.vno and m.lno = l1.lno
	and l1.vtyp = l.vtyp and l1.booktype = l.booktype and l1.vno = l.vno and l.lno = l1.lno
	and m.mcltcode=a.cltcode 
	and l.vtyp=@vtyp  
	and l.vno= @vno    
	and l.vdt like  ltrim(m.vdt) + '%'  
	and l.BookType = @booktype and m.party_code = @cltcode  
	order by l.drcr desc , l.lno 
end  
else  
begin  
/*
 select  vamt=l2.camt ,l.vtyp , l2.vno , vdt , l2.drcr , l2.cltcode, a.acname, l2.lno ,   
 drcrflag = (case when upper(l2.drcr)='D' then 'Dr' else 'Cr' end),   
 nar=narration, bank = isnull(bnkname,''), branch = isnull(brnname,'') , isnull(dd,'') dd  ,isnull(ddno,'') ddno,   
 dddt  =  convert(varchar,dddt,103)    
 from account.dbo.ledger l left outer join account.dbo.ledger1 l1 on l1.vtyp = l.vtyp and l1.booktype = l.booktype and l1.vno = l.vno and l.lno = l1.lno,  
 account.dbo.ledger2 l2 left outer join account.dbo.acmast a on l2.cltcode = a.cltcode  
 where l.vtyp=@vtyp  
 and l.vno= @vno    
 and l.vdt like  ltrim(vdt) + '%'  
 and l.BookType = @booktype and l.cltcode = @cltcode  
 and l.vtyp = l2.vtype and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno  
 and costcode = (select costcode from account.dbo.costmast where costname = rtrim(@branch))  
 order by l2.drcr desc , l2.lno   
*/

select  vamt=m.amount ,l.vtyp , l2.vno , m.vdt , l2.drcr , cltcode=m.party_code, a.acname, l2.lno ,   
drcrflag = (case when upper(l2.drcr)='D' then 'Dr' else 'Cr' end),   
nar=narration, bank = isnull(bnkname,''), branch = isnull(brnname,'') , isnull(dd,'') dd  ,isnull(ddno,'') ddno,   
dddt  =  convert(varchar,dddt,103)    
from marginledger m,ledger l ,ledger1 l1,   
ledger2 l2 left outer join acmast a on l2.cltcode = a.cltcode  
where m.mcltcode=a.cltcode
and m.vtyp = l.vtyp and m.booktype = l.booktype and m.vno = l.vno and l.lno = m.lno
and l1.vtyp = l.vtyp and l1.booktype = l.booktype and l1.vno = l.vno and l.lno = l1.lno
and l.vno= @vno    
and l.vdt like  ltrim(m.vdt) + '%'  
and l.BookType = @booktype
and m.party_code = @cltcode 
and l.vtyp = l2.vtype and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno  
and costcode = (select costcode from costmast where costname = rtrim(@branch))  
order by l2.drcr desc , l2.lno   
end

GO
