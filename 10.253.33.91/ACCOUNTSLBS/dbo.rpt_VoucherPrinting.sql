-- Object: PROCEDURE dbo.rpt_VoucherPrinting
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_VoucherPrinting    Script Date: 06/10/2008 12:09:57 PM ******/

/****** Object:  Stored Procedure dbo.rpt_VoucherPrinting    Script Date: 06/24/2004 8:32:37 PM ******/  
  
/****** Object:  Stored Procedure dbo.rpt_VoucherPrinting    Script Date: 05/10/2004 5:29:41 PM ******/  
  
/****** Object:  Stored Procedure dbo.rpt_VoucherPrinting    Script Date: 04/07/2003 12:28:25 PM ******/  
  
  
CREATE  Proc rpt_VoucherPrinting  
@Vtyp    varchar(2),  
@BookType    varchar(2),  
@FromDate   Varchar(11),  
@ToDate   Varchar(11),  
@VnoFrom   Varchar(12),  
@VnoTo   Varchar(12)  
  
as  
declare  
  
 @@selectqury   as varchar(8000),  
 @@fromtables   as varchar(2000),  
 @@wherepart    as varchar(8000),  
 @@sortby       as varchar(200)  
  
  
   if @VnoFrom <> '' and @VnoTo <> ''   
    begin   
      -- select @@wherepart = " where l.Vtyp = '" + @Vtyp + "'  and l.booktype = '" + @Booktype + "'  
     select @@wherepart = " where l.Vtyp = '" + @Vtyp + "'    
      and l.vno >= '" + @VnoFrom + "'  and l.vno <= '" + @VnoTo + "'    
       and  l.vdt >= '" + @FromDate + " 00:00:00' and l.vdt <= '" + @ToDate +" 23:59:59' "  
        
    end  
   else  
    begin  
      -- select @@wherepart = " where l.Vtyp = '" + @Vtyp + "'  and l.booktype = '" + @Booktype + "'  
     select @@wherepart = " where l.Vtyp = '" + @Vtyp + "'   
       and  l.vdt >= '" + @FromDate + " 00:00:00' and l.vdt <= '" + @ToDate +" 23:59:59' "  
    end         
  
  
   if @Vtyp = '2'  or @Vtyp = '3' or @Vtyp = '5'  or @Vtyp = '16'  or @Vtyp = '17'  or @Vtyp =  '20'  or @Vtyp = '19' or  @Vtyp = '1' or  @Vtyp = '4' or  @Vtyp = '22' or  @Vtyp = '23'    
   begin  
    select @@wherepart = @@wherepart + "  and   cltcode <> '" + @Booktype + "'"   
  
   end  
   else  
   begin  
    select @@wherepart = @@wherepart + "  and l.booktype = '" + @Booktype + "'"  
   end   
  
  
   select @@selectqury = " select distinct l.vno,isnull(dd,'') dd  ,isnull(ddno,'') ddno,Vamt = isnull(l.vamt,0), l.drcr,  
   cltcode,  acname ,   
   isnull(l.Vamt,0) Vamt,  l.drcr,  l.vtyp, l.vno, l.lno , l.booktype, convert(varchar,l.vdt,103) vdt, convert(varchar,l.edt,103) edt,  
     bank = isnull(bnkname,''), branch = isnull(brnname,'') , isnull(dd,'') dd  ,isnull(ddno,'') ddno, dddt  =  convert(varchar,dddt,103)  ,  
     l.narration, cltcode2 = cltcode, acname2 = acname "  
  
   select @@fromtables = " from Ledger l left outer join ledger1 l1 on  l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno "  
  
   select @@sortby = " order by l.vdt, l.vtyp, l.booktype, l.vno, l.drcr desc, l.lno desc "  
      
print  (@@selectqury + @@fromtables + @@wherepart + @@sortby )  
exec (@@selectqury + @@fromtables + @@wherepart + @@sortby )

GO
