-- Object: PROCEDURE dbo.rpt_accallpartyledvoucherdisp_HIS
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Procedure rpt_accallpartyledvoucherdisp_HIS
@vtyp smallint ,  
@vno varchar (12),  
@vdt varchar(12) ,  
@booktype varchar(2),  
@branch varchar(10),  
@cltcode varchar(10)  
  
as  
if @branch = 'full' or @branch= '' or @branch = '%'  
begin  
 select  vamt ,l.vtyp , l.vno , l.vdt , l.drcr , cltcode,acname,  l.lno ,drcrflag = (case when upper(l.drcr)='D' then 'Dr' else 'Cr' end) ,   
 nar=narration, bank = isnull(bnkname,''), branch = isnull(brnname,'') , isnull(dd,'') dd  ,isnull(ddno,'') ddno,   
 dddt  =  convert(varchar,dddt,103)    
 from account.dbo.ledger_HIS l left outer join account.dbo.ledger1_HIS l1 on l1.vtyp = l.vtyp and l1.booktype = l.booktype and l1.vno = l.vno and l.lno = l1.lno  
 where l.vtyp=@vtyp  
 and l.vno= @vno    
 and l.vdt like  ltrim(vdt) + '%'  
 and l.BookType = @booktype  
 order by l.drcr desc , l.lno   
end  
else  
begin  
 select  vamt=l2.camt ,l.vtyp , l2.vno , vdt , l2.drcr , l2.cltcode, a.acname, l2.lno ,   
 drcrflag = (case when upper(l2.drcr)='D' then 'Dr' else 'Cr' end),   
 nar=narration, bank = isnull(bnkname,''), branch = isnull(brnname,'') , isnull(dd,'') dd  ,isnull(ddno,'') ddno,   
 dddt  =  convert(varchar,dddt,103)    
 from account.dbo.ledger_HIS l left outer join account.dbo.ledger1_HIS l1 on l1.vtyp = l.vtyp and l1.booktype = l.booktype and l1.vno = l.vno and l.lno = l1.lno,  
 account.dbo.ledger2_HIS l2 left outer join account.dbo.acmast a on l2.cltcode = a.cltcode  
 where l.vtyp=@vtyp  
 and l.vno= @vno    
 and l.vdt like  ltrim(vdt) + '%'  
 and l.BookType = @booktype  
 and l.vtyp = l2.vtype and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno  
        and costcode = (select costcode from account.dbo.costmast where costname = rtrim(@branch))  
 order by l2.drcr desc , l2.lno   
end

GO
