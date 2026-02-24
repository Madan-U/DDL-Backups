-- Object: PROCEDURE dbo.Ageingcursor
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/****** Object:  Stored Procedure dbo.Ageingcursor    Script Date: 1/17/2004 11:39:07 PM ******/  
  
/****** Object:  Stored Procedure dbo.Ageingcursor    Script Date: 04/24/2003 5:37:46 PM ******/  
/****** Object:  Stored Procedure dbo.Ageingcursor    Script Date: 04/07/2003 11:54:17 AM ******/  
--exec Ageingcursor 'A372', 'A372', 'Apr  1 2004', 'Mar 31 2005', 'party' , '%','','963279163', 'A'  
CREATE Procedure Ageingcursor   
@fromparty varchar(10),  
@toparty varchar(10),   
@opendate varchar(11),  
@todate varchar(11),  
@Reporttype varchar(15),  
@Branch varchar(10),  
@family varchar(10),  
@sessionid varchar(30),  
@ageoption varchar(1)  
as  
declare   
@@balcur as cursor,  
@@baldate as varchar(11),  
@@openbaldt as varchar(11),  
@@balamt as money,  
@@ocltcode as varchar(10),  
@@vtyp as smallint,  
@@vno varchar(12),  
@@vdt as DATETIME,  
@@vamt as money,  
@@closbal as money,  
@@cltcode as varchar(10),  
@@Branchcode as varchar(10),  
@@drcr    as varchar(1),  
@@startdt as datetime  
Set nocount on  
/*select @@startdt = ( select left(convert(varchar,dateadd(mm,-6,convert(datetime,@todate)),109),11) )*/  
select @@startdt = @opendate  
if upper(@Branch) = 'ALL'  
begin   
   select @@branchcode = '%'  
end  
else  
begin  
   select @@branchcode = rtrim(@branch)  
end  
--if exists (select * from sysobjects where id = object_id(N'[dbo].[tempageing]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
--drop table [dbo].[tempageing]  
/*truncate table  tempageing  
truncate table  fintempageing  
*/  
delete from tempageing where rtrim(sessionid) = rtrim(@sessionid)  
delete from fintempageing where rtrim(sessionid) = rtrim(@sessionid)  
/* to Get O/p balance date */  
-- Print 'Truncated tables '  
  set @@balcur = cursor for  
  select left(convert(varchar,isnull(max(vdt),0),109),11) from ledger l  
  where vtyp = 18 and vdt < = @opendate  
  open @@balcur  
  fetch next from @@balcur into  @@openbaldt  
  close @@balcur  
  deallocate @@balcur  
select @@openbaldt  
if upper(@Reporttype) = 'PARTY'  
begin  
   insert into tempageing  
   select l.cltcode, baldate=@todate, closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0, @sessionid  
   from ledger l left outer join acmast on l.cltcode = acmast.cltcode  
   where vdt >= @@openbaldt + ' 00:00:00' and vdt <= @todate + ' 23:59:59'   
   and l.cltcode >= @fromparty and l.cltcode <= @toparty and acmast.branchcode like @@branchcode+'%' and acmast.accat = 4  
   group by l.cltcode  
   order by l.cltcode  
end  
else if upper(@Reporttype) = 'FAMILY'  
begin  
/*   select family as cltcode, baldate=@todate, closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0  
   into tempageing  
   from ledger l left outer join acmast on l.cltcode = acmast.cltcode, msajag.dbo.clientmaster c  
   where vdt >= @@openbaldt + ' 00:00:00' and vdt <= @todate + ' 23:59:59'  
   and l.cltcode = c.party_code and family >= @fromparty and family <= @toparty and acmast.accat = 4  
   and acmast.branchcode like @@branchcode+'%'     
   group by family   
   order by family  */  
   Insert into  tempageing   
   Select Family as cltcode, baldate=@todate, closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0, @sessionid  
   /* into tempageing */  
   from ledger l left outer join acmast on l.cltcode = acmast.cltcode, msajag.dbo.clientmaster c  
   where vdt >= @@openbaldt + ' 00:00:00' and vdt <= @todate + ' 23:59:59'  
   and l.cltcode = c.party_code and family >= @fromparty and family <= @toparty and acmast.accat = 4  
   and acmast.branchcode like @@branchcode+'%'     
   group by family   
   order by family   
end  
else if upper(@Reporttype) = 'FAMILYPARTY'  
begin  
   insert into tempageing  
   select l.cltcode, baldate=@todate, closbal = sum( case when drcr = 'd' then vamt else -vamt end),agedays=0, @sessionid  
   from ledger l left outer join acmast on l.cltcode = acmast.cltcode, msajag.dbo.clientmaster c  
   where vdt >= @@openbaldt + ' 00:00:00' and vdt <= @todate + ' 23:59:59'   
   and l.cltcode >= @fromparty and l.cltcode <= @toparty and acmast.branchcode like @@branchcode+'%' and acmast.accat = 4  
   and l.cltcode = c.party_code and family = @family   
   group by l.cltcode  
   order by l.cltcode  
end  
if upper(@Reporttype) = 'PARTY' or upper(@Reporttype) = 'FAMILYPARTY'  
begin  
  if upper(rtrim(@ageoption)) = 'D'  
     begin  
 set @@balcur = cursor for  
 select l.cltcode, vtyp, vno, vdt, vamt, closbal  
 from ledger l, tempageing a  
 where closbal >= 0 and drcr = ( case when closbal <= 0 then 'd' else 'c' end ) and l.cltcode = a.cltcode  
 and vdt >= @@startdt + ' 00:00:00' and vdt <= @todate  + ' 23:59:59' and a.sessionid = @sessionid  
 and vtyp <> 18  
 order by l.cltcode, vdt desc, vtyp, vno   
     end  
  else if upper(rtrim(@ageoption)) = 'C'  
     begin  
 set @@balcur = cursor for  
 select l.cltcode, vtyp, vno, vdt, vamt, closbal  
 from ledger l, tempageing a  
 where closbal < 0 and drcr = ( case when closbal <= 0 then 'd' else 'c' end ) and l.cltcode = a.cltcode  
 and vdt >= @@startdt + ' 00:00:00' and vdt <= @todate  + ' 23:59:59' and a.sessionid = @sessionid  
 and vtyp <> 18  
 order by l.cltcode, vdt desc, vtyp, vno   
     end  
  else  
     begin  
 set @@balcur = cursor for  
 select l.cltcode, vtyp, vno, vdt, vamt, closbal  
 from ledger l, tempageing a  
 where drcr = ( case when closbal <= 0 then 'd' else 'c' end ) and l.cltcode = a.cltcode  
 and vdt >= @@startdt + ' 00:00:00' and vdt <= @todate  + ' 23:59:59' and a.sessionid = @sessionid  
 and vtyp <> 18  
 order by l.cltcode, vdt desc, vtyp, vno   
     end  
end  
else  
begin  
  if upper(rtrim(@ageoption)) = 'D'   
     begin  
 set @@balcur = cursor for  
 select cltcode=family, vtyp, vno, vdt, vamt, closbal  
 from ledger l, msajag.dbo.clientmaster c left outer join tempageing a on a.cltcode = family  
 where closbal >= 0 and drcr = ( case when closbal <= 0 then 'd' else 'c' end )   
 and vdt >= @@startdt + ' 00:00:00' and vdt <= @todate  + ' 23:59:59'   
 and l.cltcode = c.party_code and family >= @fromparty and family <= @toparty   
 and a.sessionid = @sessionid  
 and vtyp <> 18  
 order by cltcode, vdt desc, vtyp, vno  
     end  
   else if upper(rtrim(@ageoption)) = 'C'  
     begin  
 set @@balcur = cursor for  
 select cltcode=family, vtyp, vno, vdt, vamt, closbal  
 from ledger l, msajag.dbo.clientmaster c left outer join tempageing a on a.cltcode = family  
 where closbal < 0 and drcr = ( case when closbal <= 0 then 'd' else 'c' end )   
 and vdt >= @@startdt + ' 00:00:00' and vdt <= @todate  + ' 23:59:59'   
 and l.cltcode = c.party_code and family >= @fromparty and family <= @toparty   
 and a.sessionid = @sessionid  
 and vtyp <> 18  
 order by cltcode, vdt desc, vtyp, vno  
     end  
   else  
     begin  
 set @@balcur = cursor for  
 select cltcode=family, vtyp, vno, vdt, vamt, closbal  
 from ledger l, msajag.dbo.clientmaster c left outer join tempageing a on a.cltcode = family  
 where drcr = ( case when closbal <= 0 then 'd' else 'c' end )   
 and vdt >= @@startdt + ' 00:00:00' and vdt <= @todate  + ' 23:59:59'   
 and l.cltcode = c.party_code and family >= @fromparty and family <= @toparty   
 and a.sessionid = @sessionid  
 and vtyp <> 18  
 order by cltcode, vdt desc, vtyp, vno  
     end  
end  
  open @@balcur  
  fetch next from @@balcur into  @@cltcode, @@vtyp, @@vno, @@vdt, @@vamt, @@closbal  
  while @@fetch_status = 0  
 begin  
--                Select @@cltcode, @@vtyp, @@vno, @@vdt, @@vamt, @@closbal    
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
      insert into fintempageing   
      select @@cltcode, @@vamt, datediff(day,@@vdt,@todate), @@drcr, @sessionid  
      select @@balamt = @@balamt - @@vamt  
     end  
    else  
     begin  
      insert into fintempageing   
      select @@cltcode, @@balamt, datediff(day,@@vdt,@todate), @@drcr, @sessionid  
      select @@balamt = @@balamt - @@vamt  
     end  
      fetch next from @@balcur into  @@cltcode, @@vtyp, @@vno, @@vdt, @@vamt, @@closbal  
                 
   end  
                if @@balamt > 0  
                   begin  
   insert into fintempageing   
   select @@ocltcode, @@balamt, 181, @@drcr, @sessionid  
   select @@balamt = @@balamt - @@vamt  
                   end  
  while @@fetch_status = 0 and @@ocltcode = @@cltcode    
  begin  
    fetch next from @@balcur into  @@cltcode, @@vtyp, @@vno, @@vdt, @@vamt, @@closbal  
  end  
 end  
  close @@balcur  
  deallocate @@balcur

GO
