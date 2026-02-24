-- Object: PROCEDURE dbo.rpt_Acc_CashBook
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

CREATE  Proc rpt_Acc_CashBook        
@sdate varchar(11),            /* As mmm dd yyyy */                                  
@edate varchar(11),            /* As mmm dd yyyy */                                  
@fdate varchar(11),            /* As mmm dd yyyy */                                  
@tdate varchar(11),            /* As mmm dd yyyy */                                  
@fcode varchar(10),                                  
@tcode varchar(10),                                  
@statusId varchar(30),                                  
@statusname varchar(30),                                  
@branch varchar(10),                                  
@selectionby varchar(3),                                  
@GroupBy varchar(10),                                  
@Sortby varchar(50),                                  
@reportname varchar(30),                                  
@reportopt varchar(10)                                  
                                  
AS                                  
                                  
declare                                   
@@opendate as varchar(11),                
@@RepDate as varchar(8)                                  
                
                             
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                                  
/*        
Exec rpt_Acc_GlReport_uk '01/04/2005', '31/03/2006', 'Apr  1 2005', 'Apr  5 2005', '99985', '99985', 'broker', 'broker', '%','vdt', 'Account', 'VDT', 'GL',''               
	
        
*/        
                
              
                
Select @@RepDate= convert(varchar,getdate(),112)                                  
Select @@opendate = convert(varchar(11),max(vdt),109) from ledger where vtyp='18'  and vdt <= @fdate                                               
              
Delete Tbl_GLReport where procid = @@SPID        
Delete Tbl_OppBalance where procid = @@SPID         
                
                         
if @selectionby = 'vdt'                                  
BEGIN                                  
 if rtrim(@branch) = '' or rtrim(@branch) = '%'                                   
  BEGIN                                      
     Insert into Tbl_OppBalance                              
     Select cltcode,sum(case drcr when 'D' then vamt else -vamt end) as opbal,@@SPID,@@RepDate                                  
     from ledger    with(index(lededtind))                                    
     where cltcode between @fcode and @tcode and vdt between @@opendate and @fdate                                 
     Group by cltcode                             
                                     
     Insert into Tbl_GLReport                                  
      Select l.booktype, voudt=convert(varchar,l.vdt,103), effdt=convert(varchar,l.edt,103), isnull(shortdesc,'') shortdesc,                                  
      dramt=(case when upper(l.drcr) = 'D' then vamt else 0 end),                                    
      cramt=(case when upper(l.drcr) = 'C' then vamt else 0 end),                                   
       l.vno, Replace( l.narration,'"','') narration,                                  
      ddno = (case when isnull(l1.ddno,'')='0' then '' else isnull(l1.ddno,'') end),         
      l.cltcode , a.longname,vdt, l.vtyp,                                  
      accat,opbal=0,crosac='',   a.acname,a.branchcode,@@SPID,@@RepDate                                  
      from Ledger l with(index(lededtind))    
      left outer join (select vtyp, booktype, vno, ddno= max(ddno) from ledger1 group by vtyp, booktype, vno) l1    
      on (l1.vtyp=l.vtyp and l1.booktype = l.booktype and l1.vno = l.vno),     
       Acmast a with(index(acmastind)) ,Vmast v                                                        
      Where l.cltcode between @fcode and @tcode        
      and l.cltcode = a.cltcode          
      and l.vdt between @fdate and @tdate + ' 23:59:59'             
      and l.vtyp <> '18'           
      And l.vtyp = v.vtype         
      and a.accat =  '1'    
                         
  END                                  
ELSE                                  
  BEGIN                                  
        
       insert into Tbl_OppBalance                           
     Select l2.cltcode,sum(case l2.drcr when 'D' then camt else -camt end) as opbal,@@SPID,@@RepDate         
     from ledger2 l2, ledger l with(index(PartyVdt)), costmast c with(index(cstinx))                                  
     where vdt between @@opendate and @fdate                   
     and l.vno=l2.vno and l.lno=l2.lno                                  
     and l.vtyp=l2.vtype         
     and l.booktype=l2.booktype         
     and costname = rtrim(@branch)                                   
     and l2.costcode = c.costcode                                  
     and l2.cltcode between @fcode and @tcode         
     Group by l2.cltcode                                  
                               
   insert into Tbl_GLReport                                  
     Select l.booktype, voudt=convert(varchar,l.vdt,103), effdt=convert(varchar,l.edt,103), isnull(shortdesc,'') shortdesc,                                   
     dramt=(case when upper(l2.drcr) = 'D' then camt else 0 end),                                    
     cramt=(case when upper(l2.drcr) = 'C' then camt else 0 end),                                   
     l.vno, Replace( l.narration,'"','') narration,                     
      ddno = (case when isnull(l1.ddno,'')='0' then '' else isnull(l1.ddno,'') end),         
     l2.cltcode , a.longname,vdt, l.vtyp,                                  
     accat,  opbal=0,crosac='',a.acname,a.branchcode ,@@SPID,@@RepDate                
     from ledger l with(index(PartyVdt))     
  left outer join (select vtyp, booktype, vno, ddno= max(ddno) from ledger1 group by vtyp, booktype, vno) l1    
     on (l1.vtyp=l.vtyp and l1.booktype = l.booktype and l1.vno = l.vno),     
  vmast v, ledger2 l2 with(index(TypeNo)), acmast a with(index(acmastind)),  costmast c with(index(cstinx))                                     
      Where  l.vdt between @fdate and @tdate + ' 23:59:59'        
   and  l.vno = l2.vno          
   and l.vtyp = l2.vtype         
   and l.vtyp = v.vtype         
   and l.booktype = l2.booktype         
   and l.lno = l2.lno         
      and l2.cltcode between @fcode and  @tcode          
   and l2.cltcode=a.cltcode          
   and a.accat <> '4'                                   
      and costname = rtrim(@branch)                                   
      and l2.costcode = c.costcode          
   and  l2.vtype <> 18                              
   END                                  
END                                  
ELSE                                  
BEGIN                                  
  if rtrim(@branch) = '' or rtrim(@branch) = '%'                                   
   BEGIN                                      
     insert into Tbl_OppBalance                               
     Select cltcode, sum(opbal) opbal,@@SPID,@@RepDate  from                                  
      (                              
       Select Cltcode,sum(case drcr when 'D' then vamt else -vamt end) as opbal from ledger  with(index(lededtind))                                 
       where Cltcode between @fcode and @tcode and vdt between @@opendate and @fdate                                  
       Group by Cltcode                                  
       union                                  
      Select cltcode,sum(case drcr when 'C' then vamt else -vamt end) as opbal from ledger   with(index(lededtind))                                 
      Where cltcode between  @fcode and  @tcode and vdt < @@opendate and edt >= @@opendate                                  
      Group by cltcode) t                                
      Group by cltcode                
        
        
        
    insert into Tbl_GLReport                                  
      Select l.booktype, voudt=convert(varchar,l.vdt,103), effdt=convert(varchar,l.edt,103), isnull(shortdesc,'') shortdesc,                                  
      dramt=(case when upper(l.drcr) = 'D' then vamt else 0 end),                                    
      cramt=(case when upper(l.drcr) = 'C' then vamt else 0 end), l.vno,                                   
      Replace( l.narration,'"','') narration,                                  
      ddno = (case when isnull(l1.ddno,'')='0' then '' else isnull(l1.ddno,'') end),         
       l.cltcode , a.longname,vdt, l.vtyp,                                  
      accat,opbal=0,crosac='',  a.acname,a.branchcode,@@SPID,@@RepDate                
      from Ledger l with(index(lededtind))    
  left outer join (select vtyp, booktype, vno, ddno= max(ddno) from ledger1 group by vtyp, booktype, vno) l1    
     on (l1.vtyp=l.vtyp and l1.booktype = l.booktype and l1.vno = l.vno),     
    Acmast a with(index(acmastind)) ,Vmast v                                                        
      Where l.cltcode between @fcode and @tcode        
      and l.cltcode = a.cltcode          
      and l.edt between @fdate and @tdate + ' 23:59:59'             
      and l.vtyp <> '18'           
      And l.vtyp = v.vtype         
      and a.accat =  '1'    
        
   END                                  
  ELSE                                  
   BEGIN                                      
     insert into Tbl_OppBalance                               
     Select cltcode, sum(opbal) opbal,@@SPID,@@RepDate  from                                  
      (                              
      Select l2.cltcode,sum(case l2.drcr when 'D' then camt else -camt end) as opbal         
       from ledger2 l2, ledger l with(index(PartyVdt)), costmast c with(index(cstinx))                                  
       where vdt between @@opendate and @fdate                   
       and l.vno=l2.vno and l.lno=l2.lno                                  
       and l.vtyp=l2.vtype         
       and l.booktype=l2.booktype         
       and costname = rtrim(@branch)                                   
       and l2.costcode = c.costcode                                  
       and l2.cltcode between @fcode and @tcode         
       Group by l2.cltcode                                  
       union                                  
                                  
       Select l2.cltcode,sum(case l2.drcr when 'C' then camt else -camt end) as opbal         
       from ledger2 l2, ledger l with(index(PartyVdt)), costmast c with(index(cstinx))                                  
       where vdt < @@opendate and edt >= @@opendate         
       and l.vno=l2.vno         
       and l.vtyp=l2.vtype         
       and l.booktype=l2.booktype         
       and l.lno=l2.lno                   
       and costname = rtrim(@branch)                                   
       and l2.costcode = c.costcode                                  
       and l2.cltcode between @fcode and @tcode         
       Group by l2.cltcode) t        
       Group by cltcode                                  
        
        
        
    insert into Tbl_GLReport                                  
     Select l.booktype, voudt=convert(varchar,l.vdt,103), effdt=convert(varchar,l.edt,103), isnull(shortdesc,'') shortdesc,                                   
     dramt=(case when upper(l2.drcr) = 'D' then camt else 0 end),                                    
     cramt=(case when upper(l2.drcr) = 'C' then camt else 0 end),                                   
     l.vno, Replace( l.narration,'"','') narration,                     
      ddno = (case when isnull(l1.ddno,'')='0' then '' else isnull(l1.ddno,'') end),         
     l2.cltcode , a.longname,vdt, l.vtyp,                                    
     accat,   opbal=0,crosac='',a.acname,a.branchcode,@@SPID,@@RepDate                
      from ledger l with(index(PartyVdt))    
  left outer join (select vtyp, booktype, vno, ddno= max(ddno) from ledger1 group by vtyp, booktype, vno) l1    
     on (l1.vtyp=l.vtyp and l1.booktype = l.booktype and l1.vno = l.vno),     
  vmast v, ledger2 l2 with(index(TypeNo)), acmast a with(index(acmastind)),  costmast c with(index(cstinx))                                     
       Where  l.edt between @fdate and @tdate + ' 23:59:59'        
    and  l.vno = l2.vno          
    and l.vtyp = l2.vtype         
    and l.vtyp = v.vtype         
    and l.booktype = l2.booktype         
    and l.lno = l2.lno         
       and l2.cltcode between @fcode and  @tcode          
    and l2.cltcode=a.cltcode          
    and a.accat <> '4'                                   
       and costname = rtrim(@branch)                                   
       and l2.costcode = c.costcode          
    and  l2.vtype <> '18'        
   END                                  
END                                  
          
                              
Update Tbl_GLReport set opbal = Tbl_OppBalance.oppbal,crosac=''  from Tbl_OppBalance             
where Tbl_GLReport.cltcode = Tbl_OppBalance.cltcode  and Tbl_OppBalance.procid = @@SPID and Tbl_OppBalance.ProcId =Tbl_GLReport.Procid            
            
                                  
Update Tbl_GLReport         
set crosac = l.cltcode          
from ledger l  with(index(partyvdt))                        
where         
Tbl_GLReport.vno = l.vno                         
and Tbl_GLReport.vtyp = l.vtyp                         
and Tbl_GLReport.vtyp  in ('3','2')                         
and Tbl_GLReport.booktype = l.booktype                         
and Tbl_GLReport.cltcode <> l.cltcode                                   
and procid = @@SPID                      
                           
          
                
Select booktype,voudt vdt ,effdt edt ,shortdesc,dramt Debit,cramt Credit,vno,narration,ddno,cltcode,longname,vtyp,accat,opbal,crosac,acname,branchcode      
from Tbl_GLReport  where procid = @@SPID        
Order By CltCode , year(vdt),month(vdt),day(vdt), vtyp desc, vno

GO
