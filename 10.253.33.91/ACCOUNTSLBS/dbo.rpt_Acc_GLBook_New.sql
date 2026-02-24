-- Object: PROCEDURE dbo.rpt_Acc_GLBook_New
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_Acc_GLBook_New    Script Date: 01/12/2006 16:12:07 ******/
Create Proc rpt_Acc_GLBook_New        
--Exec rpt_Acc_GlBook_New 'Apr 26 2005', 'Apr 26 2005', '01/04/2005', '771630', '771630', 'broker', 'broker', '%'      
@fdate varchar(11),            /* As mmm dd yyyy */        
@tdate varchar(11),            /* As mmm dd yyyy */        
@sdate varchar(10),            /* As mmm dd yyyy */        
@fcode varchar(10),        
@tcode varchar(10),      
@statusId varchar(30),        
@statusname varchar(30),        
@branch varchar(10)        
        
AS        
        
declare        
@@opendate as varchar(11),        
@@RepDate as varchar(8),        
@@StartDate As Varchar(11)        
        
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
        
Delete Tbl_GLReport_New where procid = @@SPID                      
Delete Tbl_OppBalance where procid = @@SPID                       
        
Select @@StartDate = Left(Convert(Varchar, Convert(DateTime, '01/04/2005',103), 109), 11)        
        
Insert Into Tbl_OppBalance        
Select cltcode,sum(case drcr when 'C' then vamt else -vamt end) as opbal,@@SPID, convert(varchar,getdate(),112)        
 from ledger 
 where cltcode between @fcode and @tcode and vdt >= @@StartDate and vdt <  @fdate        
 Group by cltcode        
        
        
Insert Into Tbl_GLReport_New      
select l.booktype,         
  voudt=convert(varchar,l.vdt,103), effdt=convert(varchar,l.edt,103), isnull(shortdesc,'') shortdesc,                                                 
  dramt=(case when upper(l.drcr) = 'C' then vamt else 0 end),                                                  
  cramt=(case when upper(l.drcr) = 'D' then vamt else 0 end),                
  l.vno, Replace( l.narration,'"','') narration,                                   
  ddno = (case when isnull(l1.ddno,'')='0' then '' else isnull(l1.ddno,'') end),                       
  l.cltcode, a.longname,vdt, l.vtyp,                                                  
  accat, opbal=0,crosac='',a.acname,a.branchcode,@@SPID, convert(varchar,getdate(),112), LL.CltCode As MainCode      
 from ledger l 
  left join (select vtyp, booktype, vno, ddno= max(ddno) from ledger1 group by vtyp, booktype, vno) l1        
  on (l1.vtyp=l.vtyp and l1.booktype = l.booktype and l1.vno = l.vno),      
  (select vno, vtyp, booktype, cltcode,drcr from ledger where vdt between @fdate and @tdate + ' 23:59:59' and cltcode between @fcode and @tcode) LL,      
vmast v, acmast a        
where       
l.vno = ll.vno        
and l.vtyp = ll.vtyp        
and l.booktype = ll.booktype       
and l.cltcode = a.cltcode        
and l.drcr=ll.drcr      
and l.vtyp = v.vtype        
and l.vtyp <> 18      
update Tbl_GLReport_New set narration = rtrim(longname) + ' - ' + rtrim(narration) where procid = @@spid        
Update Tbl_GLReport_New set opbal = Tbl_OppBalance.oppbal,crosac=''  from Tbl_OppBalance        
where Tbl_OppBalance.cltcode = Tbl_GlReport_New.MainCode and Tbl_OppBalance.procid = @@SPID and Tbl_OppBalance.ProcId =Tbl_GLReport_New.Procid        
Delete From Tbl_GLReport_New Where cltcode Between @fcode and @tcode and procid = @@spid      
update Tbl_GLReport_New set crosac = cltcode where procid = @@spid      
update Tbl_GLReport_New set cltcode = MainCode where procid = @@spid        
update Tbl_GLReport_New set acname = a.acname from acmast a where Tbl_GLReport_New.cltcode = a.cltcode and Tbl_GLReport_New.procid = @@spid        
update Tbl_GLReport_New set DRAMT = CRAMT, CRAMT = DRAMT      
      
--select * from Tbl_OppBalance where procid = @@spid        
--select * from Tbl_GLReport where procid = @@spid        
Select booktype,voudt ,effdt ,shortdesc,dramt ,cramt ,vno,narration,ddno,cltcode,longname,vtyp,accat,opbal,crosac,acname,branchcode                    
from Tbl_GLReport_New  where procid = @@SPID                      
Order By CltCode , vdt, vtyp desc, vno

GO
