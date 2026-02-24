-- Object: PROCEDURE dbo.CalculatePL
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE Proc [dbo].[CalculatePL]   
@fromdate varchar(11),  
@todate varchar(11),  
@branchcd varchar(20),  
@showZero varchar(1) = 'N'  
As  
Begin  
 set nocount on  
 begin transaction  
 delete from PLgroup_mstr   
 /*for group details*/  
 insert into PLgroup_mstr(Group_Code,Group_Name,Main_group,Amount,Type)   
 select Group_Code=ltrim(rtrim(Grpcode)),Group_Name=ltrim(rtrim(Grpname)),  
 Main_group=case when ltrim(rtrim(Grpcode)) = GrpMain then '' else ltrim(rtrim(GrpMain)) end,Amount=0,type='G'  
 from grpmast where (GrpMain like 'X%' or GrpMain like 'N%')  
 /*for group details*/  
  
 /*for account details*/  
 if ltrim(rtrim(@branchcd)) = ''  
 begin  
  -- For HO  
  insert into PLgroup_mstr(Group_Code,Group_Name,Main_group,Amount,type)   
  select Group_Code=ltrim(rtrim(l.Cltcode)),Group_Name=ltrim(rtrim(l.Acname)),Main_group=ltrim(rtrim(grpcode)),  
  Amount= sum(case when drcr = 'C' then Vamt * -1 else Vamt end),type='A'  
  from ledger l left outer join acmast a on l.Cltcode = a.Cltcode  
  where exists(select group_code from PLgroup_mstr m where m.group_code = a.grpcode)   
  and l.vdt >= Convert(datetime,@fromdate + ' 00:00:00')  and l.vdt <= Convert(datetime,@todate + ' 23:59:59')  
  group by l.Cltcode,l.Acname,grpcode  
 end  
 else  
 begin  
  -- For branches  
  insert into PLgroup_mstr(Group_Code,Group_Name,Main_group,Amount,type)   
  select Group_Code=ltrim(rtrim(l.Cltcode)),Group_Name=ltrim(rtrim(a.Acname)),Main_group=ltrim(rtrim(a.grpcode)),  
  Amount= sum(case when l.drcr = 'C' then Camt * -1 else Camt end),type='A'  
  from ledger2 l   
  left outer join ledger l1 on l1.Vtyp = l.Vtype and l1.Booktype = l.Booktype and l1.Vno = l.Vno and l1.Lno = l.Lno and l1.cltcode = l.Cltcode  
  left outer join acmast a on l.Cltcode = a.Cltcode  
  left outer join costmast m on l.costcode = m.costcode  
  where exists(select group_code from PLgroup_mstr m  where m.group_code = a.grpcode)   
  and l1.vdt >= Convert(datetime,@fromdate + ' 00:00:00')  and l1.vdt <= Convert(datetime,@todate + ' 23:59:59')  
  and m.costname = @branchcd  
  group by l.Cltcode,a.Acname,a.grpcode  
 end  
  
  
 select *,Reclevel = dbo.GetGrouplevels(Group_Code)   
 into #tmppl   
 from PLgroup_mstr  
 order by Reclevel,group_code  
  
 Commit transaction  
 declare @@Groupcode varchar(20),  
 @@Reclevel int  
  
 declare rscursor  cursor for  
 select distinct Group_code,Reclevel  
 from #tmppl   
 WHERE TYPE = 'G'  
 order by Reclevel desc  
 open rscursor    
 fetch next from rscursor into @@Groupcode,@@Reclevel   
 while @@fetch_status = 0  
 begin  
  update #tmppl set amount = isnull((select sum(amount) from #tmppl t1 where  t1.main_group = @@Groupcode),0)  
  from #tmppl t where type = 'G' and group_code = @@Groupcode  
 fetch next from rscursor into @@Groupcode,@@Reclevel   
 end  
   
 close rscursor  
 deallocate rscursor  
  
 if @showZero = 'Y'  
  begin  
   select Group_Code=Group_Code,Group_Name= case when type = 'A' then 'A/C :' + Group_Name else Group_Name end,  
   Main_group,Amount,type,Reclevel   
   from #tmppl order by Reclevel asc   
  end  
 else  
  begin  
   select Group_Code=Group_Code,Group_Name= case when type = 'A' then 'A/C :' + Group_Name else Group_Name end,  
   Main_group,Amount,type,Reclevel   
   from #tmppl WHERE amount <> 0 order by Reclevel asc   
  end  
  
  
 drop table #tmppl   
  
  
end

GO
