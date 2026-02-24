-- Object: PROCEDURE dbo.Ageingcursor_NEW1_SB_angel
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE Procedure Ageingcursor_NEW1_SB_angel      
@fromparty varchar(10),            
@toparty varchar(10),             
@opendate varchar(11),            
@todate varchar(11),            
@Reporttype varchar(15),            
@family varchar(10),            
@amoutgtthan money,            
@ageoption varchar(1),            
@dttype varchar(3),        
@statusid varchar(10) ,        
@statusname varchar(25),        
@Days1 Int = 29,        
@Days2 Int = 60,        
@Days3 Int = 90,        
@Days4 Int = 180,        
@Days5 Int = 360,        
@FrSb Varchar(10) = '0',        
@ToSb Varchar(10) = 'ZZZZ'        
        
        
        
as        
      
------------------------------------------------      
/*      
declare      
@fromparty varchar(10),            
@toparty varchar(10),             
@opendate varchar(11),            
@todate varchar(11),            
@Reporttype varchar(15),            
@family varchar(10),            
@amoutgtthan money,            
@ageoption varchar(1),            
@dttype varchar(3),        
@statusid varchar(10) ,        
@statusname varchar(25),        
@Days1 Int,        
@Days2 Int,        
@Days3 Int,        
@Days4 Int,        
@Days5 Int,        
@FrSb Varchar(10),        
@ToSb Varchar(10)      
      
set @fromparty ='K9550'      
set @toparty ='K9550'      
set @opendate='Apr  1 2006'      
set @todate = 'Mar 31 2007'      
set @Reporttype ='party'      
set @family =''      
set @amoutgtthan =0      
set @ageoption='D'      
set @dttype ='vdt'      
set @statusid= 'broker'      
set @statusname = 'broker'      
set @Days1=29      
set @Days2=60      
set @Days3=90      
set @Days4=180      
set @Days5=360      
set @FrSb ='0'      
set @ToSb  = 'ZZZZ'      
      
*/      
      
        
declare        
@@balcur as cursor,            
@@baldate as varchar(11),            
@@openbaldt as varchar(11),            
@@balamt as money,            
@@ocltcode as varchar(10),            
@@vtyp as smallint,            
@@vno varchar(12),            
@@EVdt as DATETIME,            
@@vamt as money,            
@@closbal as money,            
@@cltcode as varchar(10),            
@@Branchcode as varchar(25),            
@@area as varchar(25),        
@@drcr    as varchar(1),            
@@startdt as datetime        
          
      
--PRINT 'Strated '           
--PRINT convert(datetime,getdate(),113)          
          
Set nocount on            
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED           
          
Select @@startdt = ( select left(convert(varchar,dateadd(mm,-12,convert(datetime,@todate)),109),11) )            
            
            
if upper(@statusid) = 'BROKER'            
begin             
 select @@branchcode = '%'             
 select @@area = '%'             
end            
else if upper(@statusid) = 'BRANCH'            
begin            
 select @@branchcode = rtrim(@statusname)            
 select @@area = '%'             
end         
else if upper(@statusid) = 'AREA'            
begin            
 select @@branchcode = '%'        
 select @@area = rtrim(@statusname)        
end         
            
select cltcode,vdt as baldate , vamt closbal, agedays=0   into  #tempageing  from intranet.risk.dbo.nse_ledger where 1=2          
select cltcode,vdt as baldate , vamt closbal, agedays=0   into  #tempageing1  from intranet.risk.dbo.nse_ledger where 1=2          
        
Select * into #Ledger from intranet.risk.dbo.nse_ledger where 1=2        
        
Select cltcode,vtyp,vno,edt as EVdt,vamt,vamt closbal into #LedgerCursor from intranet.risk.dbo.nse_ledger where 1=2        
            
if @dttype='vdt'        
begin        
 select @@openbaldt=left(convert(varchar,isnull(max(vdt),0),109),11) from intranet.risk.dbo.nse_ledger where vtyp = '18' and vdt < = @opendate         
         
 if upper(@Reporttype) = 'PARTY'        
 begin        
  insert   into #tempageing1             
  select l.cltcode, baldate=@todate,             
  closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0            
  from intranet.risk.dbo.nse_ledger l, msajag.dbo.client1 c1, msajag.dbo.client2 c2 where l.cltcode = c2.party_code        
  and c1.cl_code = c2.cl_code        
  and vdt >= @@openbaldt + ' 00:00:00' and vdt <= @todate + ' 23:59:59'             
  and l.cltcode >= @fromparty and l.cltcode <= @toparty and c1.branch_cd like @@branchcode+'%' --and area like @@area+'%'        
  and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb        
  group by l.cltcode            
order by l.cltcode             
/*          
  insert   into #tempageing1             
  select l.cltcode, baldate=@todate,             
  closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0            
  from Accountbse.dbo.Ledger l, bsedb.dbo.client1 c1, bsedb.dbo.client2 c2 where l.cltcode = c2.party_code        
  and c1.cl_code = c2.cl_code        
  and vdt >= @@openbaldt + ' 00:00:00' and vdt <= @todate + ' 23:59:59'             
  and l.cltcode >= @fromparty and l.cltcode <= @toparty and c1.branch_cd like @@branchcode+'%' and area like @@area+'%'        
  and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb        
  group by l.cltcode            
  order by l.cltcode             
          
  insert   into #tempageing1             
  select l.cltcode, baldate=@todate,       
  closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0            
  from Accountfo.dbo.Ledger l, msajag.dbo.client1 c1, msajag.dbo.client2 c2 where l.cltcode = c2.party_code        
  and c1.cl_code = c2.cl_code        
  and vdt >= @@openbaldt + ' 00:00:00' and vdt <= @todate + ' 23:59:59'             
  and l.cltcode >= @fromparty and l.cltcode <= @toparty and c1.branch_cd like @@branchcode+'%' and area like @@area+'%'        
  and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb        
  group by l.cltcode            
  order by l.cltcode             
*/          
          
  insert   into #tempageing          
  select cltcode, baldate=@todate,             
  closbal = sum(closbal),agedays=0            
  from #tempageing1            
  group by cltcode            
  order by cltcode             
 end        
        
 else if upper(@Reporttype) = 'FAMILY'        
 begin        
  insert   into #tempageing1            
  Select Family as cltcode, baldate=@todate,             
  closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0            
  from intranet.risk.dbo.nse_ledger l,  msajag.dbo.client1 c1, msajag.dbo.client2 c2 where c1.cl_code = c2.cl_code        
  and vdt >= @@openbaldt + ' 00:00:00' and vdt <= @todate + ' 23:59:59'            
  and l.cltcode = c2.party_code and c1.family >= @fromparty and c1.family <= @toparty            
  and c1.Branch_cd like @@branchcode+'%' --and area like @@area+'%'        
  and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb        
  group by family             
  order by family        
/*          
  insert   into #tempageing1            
  Select Family as cltcode, baldate=@todate,             
  closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0            
  from Accountbse.dbo.Ledger l,  bsedb.dbo.client1 c1, bsedb.dbo.client2 c2 where c1.cl_code = c2.cl_code        
  and vdt >= @@openbaldt + ' 00:00:00' and vdt <= @todate + ' 23:59:59'            
  and l.cltcode = c2.party_code and c1.family >= @fromparty and c1.family <= @toparty            
  and c1.Branch_cd like @@branchcode+'%' and area like @@area+'%'        
  and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb        
  group by family             
  order by family        
          
  insert   into #tempageing1            
  Select Family as cltcode, baldate=@todate,             
  closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0            
  from Accountfo.dbo.Ledger l,  msajag.dbo.client1 c1, msajag.dbo.client2 c2 where c1.cl_code = c2.cl_code        
  and vdt >= @@openbaldt + ' 00:00:00' and vdt <= @todate + ' 23:59:59'            
  and l.cltcode = c2.party_code and c1.family >= @fromparty and c1.family <= @toparty            
  and c1.Branch_cd like @@branchcode+'%' and area like @@area+'%'        
  and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb        
  group by family             
  order by family        
*/          
  insert   into #tempageing          
  select cltcode, baldate=@todate,             
   closbal = sum(closbal),agedays=0            
  from #tempageing1            
  group by cltcode             
  order by cltcode        
          
 end        
        
 else if upper(@Reporttype) = 'FAMILYPARTY'        
 begin        
  insert   into #tempageing1        
  select l.cltcode, baldate=@todate,             
  closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0            
  from intranet.risk.dbo.nse_ledger l, msajag.dbo.client1 c1, msajag.dbo.client2 c2 where c1.cl_code = c2.cl_code        
  and vdt >= @@openbaldt + ' 00:00:00' and vdt <= @todate + ' 23:59:59'             
  and l.cltcode >= @fromparty and l.cltcode <= @toparty         
  and c1.Branch_cd like @@branchcode+'%' --and area like @@area+'%'        
  and l.cltcode = c2.party_code and c1.family = @family        
  and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb        
  group by l.cltcode            
  order by l.cltcode            
/*          
  insert   into #tempageing1        
  select l.cltcode, baldate=@todate,             
  closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0            
  from Accountbse.dbo.Ledger l, bsedb.dbo.client1 c1, bsedb.dbo.client2 c2 where c1.cl_code = c2.cl_code        
  and vdt >= @@openbaldt + ' 00:00:00' and vdt <= @todate + ' 23:59:59'             
  and l.cltcode >= @fromparty and l.cltcode <= @toparty         
  and c1.Branch_cd like @@branchcode+'%' and area like @@area+'%'        
  and l.cltcode = c2.party_code and c1.family = @family        
  and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb        
  group by l.cltcode            
  order by l.cltcode            
          
  insert   into #tempageing1        
  select l.cltcode, baldate=@todate,             
  closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0            
  from Accountfo.dbo.Ledger l, msajag.dbo.client1 c1, msajag.dbo.client2 c2 where c1.cl_code = c2.cl_code        
  and vdt >= @@openbaldt + ' 00:00:00' and vdt <= @todate + ' 23:59:59'             
  and l.cltcode >= @fromparty and l.cltcode <= @toparty         
  and c1.Branch_cd like @@branchcode+'%' and area like @@area+'%'        
  and l.cltcode = c2.party_code and c1.family = @family        
  and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb        
  group by l.cltcode            
  order by l.cltcode            
*/          
  insert   into #tempageing          
  select cltcode, baldate=@todate,             
   closbal = sum(closbal),agedays=0            
  from #tempageing1            
  group by cltcode            
  order by cltcode            
          
 end        
        
 if upper(@Reporttype) = 'PARTY' or upper(@Reporttype) = 'FAMILYPARTY'            
 BEGIN            
  insert into #Ledger         
  select * from intranet.risk.dbo.nse_ledger where vdt <= @todate  + ' 23:59:59'         
  and cltcode in (Select distinct cltcode from #tempageing)             
/*          
  insert into #Ledger         
  select * from Accountbse.dbo.Ledger where vdt <= @todate  + ' 23:59:59'         
  and cltcode in (Select distinct cltcode from #tempageing)             
          
  insert into #Ledger         
  select * from Accountfo.dbo.Ledger where vdt <= @todate  + ' 23:59:59'         
  and cltcode in (Select distinct cltcode from #tempageing)       */      
 END            
        
 else            
 BEGIN            
  insert into #Ledger         
  select * from intranet.risk.dbo.nse_ledger where vdt <= @todate  + ' 23:59:59'         
  and cltcode in (select party_code from msajag.dbo.client2 c2, msajag.dbo.client1 c1 where c1.cl_code=c2.cl_code and family >= @fromparty and family <= @toparty and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb)             
/*          
  insert into #Ledger         
  select * from Accountbse.dbo.Ledger where vdt <= @todate  + ' 23:59:59'         
  and cltcode in (select party_code from bsedb.dbo.client2 c2, bsedb.dbo.client1 c1 where c1.cl_code=c2.cl_code and family >= @fromparty and family <= @toparty and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb)        
          
  insert into #Ledger         
  select * from Accountfo.dbo.Ledger where vdt <= @todate  + ' 23:59:59'        
  and cltcode in (select party_code from msajag.dbo.client2 c2, msajag.dbo.client1 c1 where c1.cl_code=c2.cl_code and family >= @fromparty and family <= @toparty and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb)  */      
 END            
         
 if upper(@Reporttype) = 'PARTY' or upper(@Reporttype) = 'FAMILYPARTY'            
 begin            
  if upper(rtrim(@ageoption)) = 'D'             
  begin     
   insert into #LedgerCursor           
   select l.cltcode, vtyp, vno, vdt, vamt, closbal            
   from #Ledger l, #tempageing a            
   where closbal >= 0 and drcr = ( case when closbal >= 0 then 'd' else 'c' end )             
   and l.cltcode = a.cltcode           
   and vdt <= @todate  + ' 23:59:59'             
   --        
   --and vtyp <> '18'            
   order by l.cltcode, vdt desc, vtyp, vno        
  end        
         
  else if upper(rtrim(@ageoption)) = 'C'        
  begin        
   insert into #LedgerCursor           
   select l.cltcode, vtyp, vno, vdt, vamt, closbal            
   from #Ledger l, #tempageing a            
   where closbal < 0 and drcr = ( case when closbal >= 0 then 'd' else 'c' end )             
   and l.cltcode = a.cltcode            
   and vdt <= @todate  + ' 23:59:59'            
   --        
   --and vtyp <> '18'          
   order by l.cltcode, vdt desc, vtyp, vno             
  end        
         
  else        
  begin        
   insert into #LedgerCursor           
   select l.cltcode, vtyp, vno, vdt, vamt, closbal            
   from #Ledger l, #tempageing a        
   where drcr = ( case when closbal >= 0 then 'd' else 'c' end )             
   and l.cltcode = a.cltcode            
   and vdt <= @todate  + ' 23:59:59'            
   --        
   --and vtyp <> '18'         
   order by l.cltcode, vdt desc, vtyp, vno             
  end        
 end        
         
 else            
 begin            
  if upper(rtrim(@ageoption)) = 'D'             
  begin        
   insert into #LedgerCursor           
   select cltcode=family, vtyp, vno, vdt, vamt, closbal            
   from #Ledger l, msajag.dbo.clientmaster c,  #tempageing a where a.cltcode = family            
   and closbal >= 0 and drcr = ( case when closbal >= 0 then 'd' else 'c' end )             
   and vdt <= @todate  + ' 23:59:59'             
   and l.cltcode = c.party_code and family >= @fromparty and family <= @toparty             
   --        
   --and vtyp <> '18'            
   order by cltcode, vdt desc, vtyp, vno            
  end        
         
  else if upper(rtrim(@ageoption)) = 'C'        
  begin        
   insert into #LedgerCursor           
   select cltcode=family, vtyp, vno, vdt, vamt, closbal         
   from #Ledger l, msajag.dbo.clientmaster c, #tempageing a where  a.cltcode = family            
   and closbal < 0 and drcr = ( case when closbal >= 0 then 'd' else 'c' end )             
   and vdt <= @todate  + ' 23:59:59'             
   and l.cltcode = c.party_code and family >= @fromparty and family <= @toparty             
   --        
   --and vtyp <> '18'            
   order by cltcode, vdt desc, vtyp, vno            
  end        
         
  else        
  begin        
   insert into #LedgerCursor           
   select cltcode=family, vtyp, vno, vdt, vamt, closbal            
   from #Ledger l, msajag.dbo.clientmaster c, #tempageing a where a.cltcode = family            
   and drcr = ( case when closbal >= 0 then 'd' else 'c' end )             
   and vdt <= @todate  + ' 23:59:59'             
   and l.cltcode = c.party_code and family >= @fromparty and family <= @toparty             
   --        
   --and vtyp <> '18'            
   order by cltcode, vdt desc, vtyp, vno            
  end        
 end        
        
end        
        
else        
begin        
 select @@openbaldt=left(convert(varchar,isnull(max(edt),0),109),11) from intranet.risk.dbo.nse_ledger where vtyp = '18' and edt < = @opendate        
        
 if upper(@Reporttype) = 'PARTY'        
 begin        
  insert   into #tempageing1         
  select l.cltcode, baldate=@todate,             
  closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0            
  from intranet.risk.dbo.nse_ledger l, acmast a, msajag.dbo.client1 c1 where l.cltcode = a.cltcode and l.cltcode = c1.cl_code        
  and edt >= @@openbaldt + ' 00:00:00' and edt <= @todate + ' 23:59:59'             
  and l.cltcode >= @fromparty and l.cltcode <= @toparty and a.branchcode like @@branchcode+'%'             
  and a.accat = 4        
  and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb        
  group by l.cltcode            
  order by l.cltcode        
/*             
  insert   into #tempageing1             
  select l.cltcode, baldate=@todate,             
  closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0            
  from Accountbse.dbo.Ledger l, accountbse.dbo.acmast a, bsedb.dbo.client1 c1 where l.cltcode = a.cltcode and l.cltcode = c1.cl_code        
  and edt >= @@openbaldt + ' 00:00:00' and edt <= @todate + ' 23:59:59'             
  and l.cltcode >= @fromparty and l.cltcode <= @toparty and a.branchcode like @@branchcode+'%'             
  and a.accat = 4        
  and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb        
  group by l.cltcode            
  order by l.cltcode        
          
  insert   into #tempageing1             
  select l.cltcode, baldate=@todate,             
  closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0            
  from Accountfo.dbo.Ledger l, accountfo.dbo.acmast a, msajag.dbo.client1 c1 where l.cltcode = a.cltcode and l.cltcode = c1.cl_code        
  and edt >= @@openbaldt + ' 00:00:00' and edt <= @todate + ' 23:59:59'             
  and l.cltcode >= @fromparty and l.cltcode <= @toparty and a.branchcode like @@branchcode+'%'             
  and a.accat = 4        
  and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb        
  group by l.cltcode            
  order by l.cltcode        
*/          
  insert   into #tempageing          
  select cltcode, baldate=@todate,             
  closbal = sum(closbal),agedays=0            
  from #tempageing1            
  group by cltcode            
  order by cltcode         
          
 end        
        
 else if upper(@Reporttype) = 'FAMILY'        
 begin        
  insert   into #tempageing1            
  Select Family as cltcode, baldate=@todate,             
  closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0            
  from intranet.risk.dbo.nse_ledger l,  msajag.dbo.client1 c --msajag.dbo.clientmaster c            
  where edt >= @@openbaldt + ' 00:00:00' and edt <= @todate + ' 23:59:59'            
  and l.cltcode = c.cl_code and c.family >= @fromparty and c.family <= @toparty            
  and c.Branch_cd like @@branchcode+'%'         
  and c.sub_broker >= @FrSb and c.sub_broker <= @ToSb        
  group by family             
  order by family        
/*          
  insert   into #tempageing1            
  Select Family as cltcode, baldate=@todate,             
  closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0            
  from Accountbse.dbo.Ledger l,  bsedb.dbo.client1 c--bsedb.dbo.clientmaster c            
  where edt >= @@openbaldt + ' 00:00:00' and edt <= @todate + ' 23:59:59'            
  and l.cltcode = c.cl_code and c.family >= @fromparty and c.family <= @toparty            
  and c.Branch_cd like @@branchcode+'%'         
  and c.sub_broker >= @FrSb and c.sub_broker <= @ToSb        
  group by family             
  order by family        
          
  insert   into #tempageing1            
  Select Family as cltcode, baldate=@todate,             
  closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0            
  from Accountfo.dbo.Ledger l,  msajag.dbo.client1 c--msajag.dbo.clientmaster c            
  where edt >= @@openbaldt + ' 00:00:00' and edt <= @todate + ' 23:59:59'            
  and l.cltcode = c.cl_code and c.family >= @fromparty and c.family <= @toparty            
  and c.Branch_cd like @@branchcode+'%'         
  and c.sub_broker >= @FrSb and c.sub_broker <= @ToSb        
  group by family             
  order by family        
*/          
          
  insert   into #tempageing          
  select cltcode, baldate=@todate,             
  closbal = sum(closbal),agedays=0            
  from #tempageing1            
  group by cltcode            
  order by cltcode         
          
 end        
         
 else if upper(@Reporttype) = 'FAMILYPARTY'        
 begin        
  insert into #tempageing1        
  select l.cltcode, baldate=@todate,             
  closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0            
  from intranet.risk.dbo.nse_ledger l, msajag.dbo.client1 c--msajag.dbo.clientmaster c          
  where edt >= @@openbaldt + ' 00:00:00' and edt <= @todate + ' 23:59:59'        
  and l.cltcode >= @fromparty and l.cltcode <= @toparty         
  and c.Branch_cd like @@branchcode+'%'        
  and l.cltcode = c.cl_code and c.family = @family             
  and c.sub_broker >= @FrSb and c.sub_broker <= @ToSb        
  group by l.cltcode            
  order by l.cltcode            
/*          
  insert into #tempageing1        
  select l.cltcode, baldate=@todate,             
  closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0            
  from Accountbse.dbo.Ledger l, bsedb.dbo.client1 c--bsedb.dbo.clientmaster c            
  where edt >= @@openbaldt + ' 00:00:00' and edt <= @todate + ' 23:59:59'             
  and l.cltcode >= @fromparty and l.cltcode <= @toparty         
  and c.Branch_cd like @@branchcode+'%'        
  and l.cltcode = c.cl_code and c.family = @family             
  and c.sub_broker >= @FrSb and c.sub_broker <= @ToSb        
  group by l.cltcode            
  order by l.cltcode                 
          
  insert into #tempageing1        
  select l.cltcode, baldate=@todate,             
  closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0            
  from Accountfo.dbo.Ledger l, msajag.dbo.client1 c--msajag.dbo.clientmaster c            
  where edt >= @@openbaldt + ' 00:00:00' and edt <= @todate + ' 23:59:59'             
  and l.cltcode >= @fromparty and l.cltcode <= @toparty         
  and c.Branch_cd like @@branchcode+'%'        
  and l.cltcode = c.cl_code and c.family = @family             
  and c.sub_broker >= @FrSb and c.sub_broker <= @ToSb        
  group by l.cltcode            
  order by l.cltcode        
*/          
  insert   into #tempageing          
  select cltcode, baldate=@todate,             
  closbal = sum(closbal),agedays=0            
  from #tempageing1            
  group by cltcode            
  order by cltcode         
         
 end        
         
 if upper(@Reporttype) = 'PARTY' or upper(@Reporttype) = 'FAMILYPARTY'            
 BEGIN            
  insert into #Ledger         
  select * from intranet.risk.dbo.nse_ledger where edt <= @todate  + ' 23:59:59'         
  and cltcode in (Select distinct cltcode from #tempageing)            
/*          
  insert into #Ledger         
  select * from Accountbse.dbo.Ledger where edt <= @todate  + ' 23:59:59'         
  and cltcode in (Select distinct cltcode from #tempageing)            
          
  insert into #Ledger         
  select * from Accountfo.dbo.Ledger where edt <= @todate  + ' 23:59:59'         
  and cltcode in (Select distinct cltcode from #tempageing)     */      
 END        
             
 else            
 BEGIN            
  insert into #Ledger         
  select * from intranet.risk.dbo.nse_ledger where edt <= @todate  + ' 23:59:59'         
  and cltcode in (select party_code from msajag.dbo.client2 c2, msajag.dbo.client1 c1 where c1.cl_code=c2.cl_code and family >= @fromparty and family <= @toparty and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb)        
/*          
  insert into #Ledger         
  select * from Accountbse.dbo.Ledger where edt <= @todate  + ' 23:59:59'         
  and cltcode in (select party_code from msajag.dbo.client2 c2, msajag.dbo.client1 c1 where c1.cl_code=c2.cl_code and family >= @fromparty and family <= @toparty and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb)        
          
  insert into #Ledger         
  select * from Accountfo.dbo.Ledger where edt <= @todate  + ' 23:59:59'         
  and cltcode in (select party_code from msajag.dbo.client2 c2, msajag.dbo.client1 c1 where c1.cl_code=c2.cl_code and family >= @fromparty and family <= @toparty and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb)  */      
 END            
         
 if upper(@Reporttype) = 'PARTY' or upper(@Reporttype) = 'FAMILYPARTY'            
 begin            
  if upper(rtrim(@ageoption)) = 'D'        
  begin        
   insert into #LedgerCursor           
   select l.cltcode, vtyp, vno, edt, vamt, closbal            
   from #Ledger l, #tempageing a            
   where closbal >= 0 and drcr = ( case when closbal >= 0 then 'd' else 'c' end )             
   and l.cltcode = a.cltcode           
   and edt <= @todate  + ' 23:59:59'             
   --        
   --and vtyp <> '18'            
   order by l.cltcode, edt desc, vtyp, vno            
  end        
         
  else if upper(rtrim(@ageoption)) = 'C'        
  begin        
   insert into #LedgerCursor             
   select l.cltcode, vtyp, vno, edt, vamt, closbal            
   from #Ledgeredt l, #tempageing a            
   where closbal < 0 and drcr = ( case when closbal >= 0 then 'd' else 'c' end )             
   and l.cltcode = a.cltcode            
   and edt <= @todate  + ' 23:59:59'            
   --        
   --and vtyp <> '18'            
   order by l.cltcode, edt desc, vtyp, vno          
  end        
         
  else        
  begin        
   insert into #LedgerCursor           
   select l.cltcode, vtyp, vno, edt, vamt, closbal            
   from #Ledger l, #tempageing a            
   where drcr = ( case when closbal >= 0 then 'd' else 'c' end )             
   and l.cltcode = a.cltcode            
   and edt <= @todate  + ' 23:59:59'            
   --         
   --and vtyp <> '18'            
   order by l.cltcode, edt desc, vtyp, vno         
  end        
 end        
         
 else            
 begin            
  if upper(rtrim(@ageoption)) = 'D'             
  begin        
   insert into #LedgerCursor           
   select cltcode=family, vtyp, vno, edt, vamt, closbal            
   from #Ledger l, msajag.dbo.clientmaster c,  #tempageing a where a.cltcode = family            
   and closbal >= 0 and drcr = ( case when closbal >= 0 then 'd' else 'c' end )             
   and edt <= @todate  + ' 23:59:59'             
   and l.cltcode = c.party_code and family >= @fromparty and family <= @toparty             
   --        
   --and vtyp <> '18'            
   order by cltcode, edt desc, vtyp, vno            
  end        
         
  else if upper(rtrim(@ageoption)) = 'C'        
  begin        
   insert into #LedgerCursor           
   select cltcode=family, vtyp, vno, edt, vamt, closbal         
   from #Ledger l, msajag.dbo.clientmaster c, #tempageing a where  a.cltcode = family            
   and closbal < 0 and drcr = ( case when closbal >= 0 then 'd' else 'c' end )             
   and edt <= @todate  + ' 23:59:59'             
   and l.cltcode = c.party_code and family >= @fromparty and family <= @toparty             
   --        
   --and vtyp <> '18'            
   order by cltcode, edt desc, vtyp, vno            
  end        
         
  else        
  begin        
   insert into #LedgerCursor           
   select cltcode=family, vtyp, vno, edt, vamt, closbal            
   from #Ledger l, msajag.dbo.clientmaster c, #tempageing a where a.cltcode = family            
   and drcr = ( case when closbal >= 0 then 'd' else 'c' end )             
   and edt <= @todate  + ' 23:59:59'             
   and l.cltcode = c.party_code and family >= @fromparty and family <= @toparty             
   --        
   --and vtyp <> '18'            
   order by cltcode, edt desc, vtyp, vno            
  end        
 end        
end        
            
            
--PRINT 'Filled LedgerCursor'           
--PRINT convert(datetime,getdate(),113)          
          
set @@balcur = cursor for            
select cltcode, vtyp, vno, EVdt, vamt, closbal  from #LedgerCursor order by cltcode, EVdt desc, vtyp, vno          
select cltcode,vamt balamt,0 agedays,drcr into #fintempageing from #Ledger where 1= 2            
            
--PRINT 'opening cursor'            
            
open @@balcur        
fetch next from @@balcur into  @@cltcode, @@vtyp, @@vno, @@EVdt, @@vamt, @@closbal             
        
while @@fetch_status = 0           
begin             
 select @@ocltcode = @@cltcode             
  select @@balamt = abs(@@closbal)            
 if @@closbal >= 0             
 begin            
  select @@drcr = 'd'            
 end         
     else            
 begin            
       select @@drcr = 'c'            
 end        
        
 while @@fetch_status = 0 and @@ocltcode = @@cltcode  and @@balamt > 0            
 begin            
  if @@balamt >= @@vamt             
  begin          
   insert into #fintempageing            
   select @@cltcode, @@vamt, datediff(day,@@EVdt,@todate), @@drcr             
   select @@balamt = @@balamt - @@vamt           
  end            
        
  else            
  begin            
   insert into #fintempageing            
   select @@cltcode, @@balamt, datediff(day,@@EVdt,@todate), @@drcr             
   select @@balamt = @@balamt - @@vamt             
  end            
        
  fetch next from @@balcur into  @@cltcode, @@vtyp, @@vno, @@EVdt, @@vamt, @@closbal             
 end            
        
 if @@balamt > 0            
 begin          
   insert into #fintempageing            
   select @@ocltcode, @@balamt, 181, @@drcr             
   select @@balamt = @@balamt - @@vamt            
 end            
        
 while @@fetch_status = 0 and @@ocltcode = @@cltcode        
 begin          
     fetch next from @@balcur into  @@cltcode, @@vtyp, @@vno, @@EVdt, @@vamt, @@closbal            
 end            
end        
            
close @@balcur            
deallocate @@balcur            
            
--PRINT 'cursor closed'            
--PRINT convert(datetime,getdate(),113)          
            
      
      
select cltcode, balance=sum(balamt), agedays = @Days1, drcr into #ageinglist            
from #fintempageing         
where agedays >= 0 and agedays <= @Days1        
group by cltcode, drcr            
--order by cltcode, drcr            
            
insert into #ageinglist           
select cltcode, balance=sum(balamt), agedays = @Days2, drcr             
from #fintempageing            
where agedays >= @Days1+1 and agedays <= @Days2        
group by cltcode, drcr             
--order by cltcode, drcr            
            
insert into #ageinglist            
select cltcode, balance=sum(balamt), agedays = @Days3, drcr             
from #fintempageing            
where agedays >= @Days2+1 and agedays <= @Days3        
group by cltcode, drcr             
--order by cltcode, drcr             
        
insert into #ageinglist            
select cltcode, balance=sum(balamt), agedays = @Days4, drcr             
from #fintempageing            
where agedays >= @Days3+1 and agedays <= @Days4        
group by cltcode, drcr             
--order by cltcode, drcr             
            
      
insert into #ageinglist            
select cltcode, balance=sum(balamt), agedays = @Days5, drcr             
from #fintempageing            
--where agedays >= @Days5        
where agedays >= @Days4+1 and agedays <= @Days5        
group by cltcode, drcr             
--order by cltcode, drcr             
      
        
--PRINT 'done'            
--PRINT convert(datetime,getdate(),113)          
      
      
Select a1.cltcode, short_name = a2.Short_Name, balance, agedays, drcr, a2.branch_cd, a2.sub_broker, branch=' ', name=' '        
into #filex      
from #ageinglist a1, msajag.dbo.client1 a2      
--, msajag.dbo.subbrokers s, msajag.dbo.branch b--msajag.dbo.clientmaster a2--account.dbo.acmast  a2             
where balance >= @amoutgtthan and             
a1.cltcode = a2.cl_code        
--and a2.branch_cd = b.branch_code        
--and a2.sub_broker = s.sub_broker        
--order by a2.branch_cd, a2.sub_broker, a1.cltcode, a2.Short_Name        
      
--truncate table Angel_Ageing            
--insert into Angel_Ageing            
      
select party_code=a.cltcode,a.baldate,a.closbal,b.* into #AgeFinal       
from (select * from #tempageing where closbal <> 0 )a left outer join #filex b on a.cltcode=b.cltcode           
      
select PARTY_cODE,branch_cd,branch,sub_Broker,name,cltcode,short_name,balDate,ClosBal,      
Day_30=sum(case       
when agedays=29 and drcr='d' then balance       
when agedays=29 and drcr='c' then -balance       
else 0 end),      
Day_60=sum(case      
when agedays=60 and drcr='d' then balance       
when agedays=60 and drcr='c' then -balance       
else 0 end),      
Day_90=sum(case      
when agedays=90 and drcr='d' then balance       
when agedays=90 and drcr='c' then -balance       
else 0 end),      
Day_180=sum(case       
when agedays=180 and drcr='d' then balance       
when agedays=180 and drcr='c' then -balance       
else 0 end),      
Day_360=sum(case       
when agedays=360 and drcr='d' then balance       
when agedays=360 and drcr='c' then -balance       
else 0 end)      
into #fINAL      
from #AgeFinal       
group by PARTY_cODE,branch_cd,branch,sub_Broker,name,cltcode,short_name,balDate,ClosBal      
--order by cltcode      
    
 select a.*,last_trade_date=convert(varchar(11),vdt) into #fINAL1 from #fINAL a    
left outer join    
(  
--select cltcode,vdt=max(vdt) from ledger (nolock) group by cltcode  
select cltcode,vdt=max(vdt) from intranet.risk.dbo.nse_ledger (nolock)   
 where vdt >= @@openbaldt + ' 00:00:00' and vdt <= @todate + ' 23:59:59' and vtyp=15              
 group by cltcode  
  
) b    
on a.party_code=b.cltcode         
      
update #fINAL1 set branch_cd=b.branch_Cd,sub_Broker=b.sub_broker from       
(select party_code,branch_cd,sub_broker from msajag.dbo.client1 a, msajag.dbo.client2 b where a.cl_code=b.cl_code) b      
where #fINAL1.party_code=b.party_code      
      
      
SELECT *, DAYS_361_PLUS=ClosBal-ISNULL(DAY_30,0)-ISNULL(DAY_60,0)-ISNULL(DAY_90,0)-ISNULL(DAY_180,0)-ISNULL(DAY_360,0) FROM #fINAL1      
order by cltcode      
      
drop table #tempageing            
drop table #tempageing1            
drop table #Ledger            
drop table #LedgerCursor             
drop table #ageinglist            
drop table #fintempageing

GO
