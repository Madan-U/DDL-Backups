-- Object: PROCEDURE dbo.Ageingcursor_NEW1_SB
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 

--exec Ageingcursor_NEW1_SB '10100000', '10100010', 'Apr  1 2004', 'Nov 19 2004','party','',0, 'A','edt','broker','broker', 6,26,90,160,161,'101', 'VALSAD'  
CREATE Procedure Ageingcursor_NEW1_SB
@fromparty varchar(10),      
@toparty varchar(10),       
@opendate varchar(11),      
@todate varchar(11),      
@Reporttype varchar(15),      
@family varchar(10),      
@amoutgtthan money,      
@ageoption varchar(1),      
@dttype varchar(3),  
@statusid varchar(10),  
@statusname varchar(25),  
@Days1 Int = 6,  
@Days2 Int = 29,  
@Days3 Int = 90,  
@Days4 Int = 180,  
@Days5 Int = 181,  
@FrSb Varchar(10) = '0',  
@ToSb Varchar(10) = 'ZZZZ'  
  
  
  
as  
  
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
    
Print 'Strated '     
Print convert(datetime,getdate(),113)    
    
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
      
select cltcode,vdt as baldate , vamt closbal, agedays=0   into  #tempageing  from Ledger where 1=2    
select cltcode,vdt as baldate , vamt closbal, agedays=0   into  #tempageing1  from Ledger where 1=2    
  
Select * into #Ledger from Ledger where 1=2  
  
Select cltcode,vtyp,vno,edt as EVdt,vamt,vamt closbal into #LedgerCursor from Ledger where 1=2  
      
if @dttype='vdt'  
begin  
 select @@openbaldt=left(convert(varchar,isnull(max(vdt),0),109),11) from Ledger where vtyp = '18' and vdt < = @opendate   
   
 if upper(@Reporttype) = 'PARTY'  
 begin  
  insert   into #tempageing1       
  select l.cltcode, baldate=@todate,       
  closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0      
  from Ledger l, msajag.dbo.client1 c1, msajag.dbo.client2 c2 where l.cltcode = c2.party_code  
  and c1.cl_code = c2.cl_code  
  and vdt >= @@openbaldt + ' 00:00:00' and vdt <= @todate + ' 23:59:59'       
  and l.cltcode >= @fromparty and l.cltcode <= @toparty and c1.branch_cd like @@branchcode+'%' and area like @@area+'%'  
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
  from Accountfo.dbo.Ledger l, nsefo.dbo.client1 c1, nsefo.dbo.client2 c2 where l.cltcode = c2.party_code  
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
  from Ledger l,  msajag.dbo.client1 c1, msajag.dbo.client2 c2 where c1.cl_code = c2.cl_code  
  and vdt >= @@openbaldt + ' 00:00:00' and vdt <= @todate + ' 23:59:59'      
  and l.cltcode = c2.party_code and c1.family >= @fromparty and c1.family <= @toparty      
  and c1.Branch_cd like @@branchcode+'%' and area like @@area+'%'  
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
  from Accountfo.dbo.Ledger l,  nsefo.dbo.client1 c1, nsefo.dbo.client2 c2 where c1.cl_code = c2.cl_code  
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
  from Ledger l, msajag.dbo.client1 c1, msajag.dbo.client2 c2 where c1.cl_code = c2.cl_code  
  and vdt >= @@openbaldt + ' 00:00:00' and vdt <= @todate + ' 23:59:59'       
  and l.cltcode >= @fromparty and l.cltcode <= @toparty   
  and c1.Branch_cd like @@branchcode+'%' and area like @@area+'%'  
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
  from Accountfo.dbo.Ledger l, nsefo.dbo.client1 c1, nsefo.dbo.client2 c2 where c1.cl_code = c2.cl_code  
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
  select * from Ledger where vdt <= @todate  + ' 23:59:59'   
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
  select * from Ledger where vdt <= @todate  + ' 23:59:59'   
  and cltcode in (select party_code from msajag.dbo.client2 c2, msajag.dbo.client1 c1 where c1.cl_code=c2.cl_code and family >= @fromparty and family <= @toparty and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb)       
/*    
  insert into #Ledger   
  select * from Accountbse.dbo.Ledger where vdt <= @todate  + ' 23:59:59'   
  and cltcode in (select party_code from bsedb.dbo.client2 c2, bsedb.dbo.client1 c1 where c1.cl_code=c2.cl_code and family >= @fromparty and family <= @toparty and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb)  
    
  insert into #Ledger   
  select * from Accountfo.dbo.Ledger where vdt <= @todate  + ' 23:59:59'  
  and cltcode in (select party_code from nsefo.dbo.client2 c2, nsefo.dbo.client1 c1 where c1.cl_code=c2.cl_code and family >= @fromparty and family <= @toparty and c1.sub_broker >= @FrSb and c1.sub_broker <= @ToSb)  */
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
 select @@openbaldt=left(convert(varchar,isnull(max(edt),0),109),11) from Ledger where vtyp = '18' and edt < = @opendate  
  
 if upper(@Reporttype) = 'PARTY'  
 begin  
  insert   into #tempageing1   
  select l.cltcode, baldate=@todate,       
  closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0      
  from Ledger l, acmast a, msajag.dbo.client1 c1 where l.cltcode = a.cltcode and l.cltcode = c1.cl_code  
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
  from Accountfo.dbo.Ledger l, accountfo.dbo.acmast a, nsefo.dbo.client1 c1 where l.cltcode = a.cltcode and l.cltcode = c1.cl_code  
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
  from Ledger l,  msajag.dbo.client1 c --msajag.dbo.clientmaster c      
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
  from Accountfo.dbo.Ledger l,  nsefo.dbo.client1 c--nsefo.dbo.clientmaster c      
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
  from Ledger l, msajag.dbo.client1 c--msajag.dbo.clientmaster c    
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
  from Accountfo.dbo.Ledger l, nsefo.dbo.client1 c--nsefo.dbo.clientmaster c      
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
  select * from Ledger where edt <= @todate  + ' 23:59:59'   
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
  select * from Ledger where edt <= @todate  + ' 23:59:59'   
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
      
      
Print 'Filled LedgerCursor'     
Print convert(datetime,getdate(),113)    
    
set @@balcur = cursor for      
select cltcode, vtyp, vno, EVdt, vamt, closbal  from #LedgerCursor order by cltcode, EVdt desc, vtyp, vno    
select cltcode,vamt balamt,0 agedays,drcr into #fintempageing from #Ledger where 1= 2      
      
print 'opening cursor'      
      
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
      
print 'cursor closed'      
Print convert(datetime,getdate(),113)    
      
select cltcode, balance=sum(balamt), agedays = @Days1, drcr into #ageinglist      
from #fintempageing   
where agedays >= 0 and agedays <= @Days1  
group by cltcode, drcr      
order by cltcode, drcr      
      
insert into #ageinglist     
select cltcode, balance=sum(balamt), agedays = @Days2, drcr       
from #fintempageing      
where agedays >= @Days1+1 and agedays <= @Days2  
group by cltcode, drcr       
order by cltcode, drcr      
      
insert into #ageinglist      
select cltcode, balance=sum(balamt), agedays = @Days3, drcr       
from #fintempageing      
where agedays >= @Days2+1 and agedays <= @Days3  
group by cltcode, drcr       
order by cltcode, drcr       
  
insert into #ageinglist      
select cltcode, balance=sum(balamt), agedays = @Days4, drcr       
from #fintempageing      
where agedays >= @Days3+1 and agedays <= @Days4  
group by cltcode, drcr       
order by cltcode, drcr       
      
insert into #ageinglist      
select cltcode, balance=sum(balamt), agedays = @Days5, drcr       
from #fintempageing      
where agedays >= @Days5  
group by cltcode, drcr       
order by cltcode, drcr       
  
print 'done'      
Print convert(datetime,getdate(),113)    
      
Select a1.cltcode, short_name = a2.Short_Name, balance, agedays, drcr, a2.branch_cd, a2.sub_broker, b.branch, s.name  
from #ageinglist a1, msajag.dbo.client1 a2, msajag.dbo.subbrokers s, msajag.dbo.branch b--msajag.dbo.clientmaster a2--account.dbo.acmast  a2       
where balance >= @amoutgtthan and       
a1.cltcode = a2.cl_code  
and a2.branch_cd = b.branch_code  
and a2.sub_broker = s.sub_broker  
order by a2.branch_cd, a2.sub_broker, a1.cltcode, a2.Short_Name  
      
drop table #tempageing      
drop table #Ledger      
drop table #LedgerCursor       
drop table #ageinglist      
drop table #fintempageing

GO
