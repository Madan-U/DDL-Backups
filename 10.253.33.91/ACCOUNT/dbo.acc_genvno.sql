-- Object: PROCEDURE dbo.acc_genvno
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROC acc_genvno    
@vdt      varchar(11),  /* dd/mm/yyyy */    
@vtyp     smallint,    
@booktype varchar(2),    
@sdtcur   varchar(11),    
@ldtcur   varchar(11)    
/* @vnoflag  int */    
as    
  
    
declare    
@@voudt  as datetime,    
@@maxvno as numeric(12,0),    
--@@maxvno as money,    
@@vnoflag as tinyint,    
@@vno as varchar(12),    
@@rcnt as int    
    
select @@vnoflag = (Select vnoflag from parameter where  sdtcur = @sdtcur and ldtcur = @ldtcur + ' 23:59:59')    
select @@voudt = (select convert(datetime,@vdt))    
    
if @@vnoflag = 0    
   begin    
      select @@maxvno = isnull(max(convert(NUMERIC,lastvno)),0) from lastvno WITH (TABLOCKX,HOLDLOCK) where vtyp = @vtyp and booktype = @booktype and vdt >= @sdtcur    
      and vdt <= @ldtcur + ' 23:59:59'  
      if @@maxvno = 0    
         begin    
           select @@vno = right(rtrim(@sdtcur),4)+'00000001'    
         end    
      else    
         begin    
           select @@vno = rtrim(convert(varchar,@@maxvno + 1))    
         end    
   end    
else if @@vnoflag = 1    
        begin    
          select @@maxvno = isnull(max(convert(NUMERIC,lastvno)),0) from lastvno WITH (TABLOCKX,HOLDLOCK) where vtyp = @vtyp and booktype = @booktype and vdt like @vdt + '%'    
          if @@maxvno = 0    
             begin    
                select @@vno = (select convert(varchar,year(@@voudt)) + right('0'+ltrim(convert(varchar,month(@@voudt))),2) + right('00'+ltrim(convert(varchar,day(@@voudt))),2))+'0001'    
             end    
          else    
             begin    
               select @@vno = rtrim(convert(varchar,@@maxvno + 1))    
             end    
        end    
    
else if @@vnoflag = 2    
        begin    
          select @@maxvno = isnull(max(convert(NUMERIC,lastvno)),0) from lastvno WITH (TABLOCKX,HOLDLOCK) where vtyp = @vtyp and booktype = @booktype and year(vdt) = year(@@voudt) and month(vdt) = month(@@voudt)    
          if @@maxvno = 0    
             begin    
                select @@vno = (select convert(varchar,year(@@voudt)) + right('0'+ltrim(convert(varchar,month(@@voudt))),2))+'000001'    
             end    
         else    
             begin    
               select @@vno = rtrim(convert(varchar,@@maxvno + 1))    
             end    
        end    
/*      
select @@rcnt = ( select count(*) from lastvno where vtyp = @vtyp and booktype = @booktype and vdt like @vdt + '%')    
if @@rcnt = 0    
   begin    
     insert into lastvno values(@vtyp,@booktype,@vdt,@@vno)    
   end    
else    
   begin    
*/    
/*     Update lastvno WITH (TABLOCKX, HOLDLOCK) set lastvno = @@Vno where vtyp = @vtyp and booktype = @booktype and vdt like @vdt+'%' */    
/*     Update lastvno set lastvno = @@Vno where vtyp = @vtyp and booktype = @booktype and vdt like @vdt+'%'     
   end    
*/    
select vno = @@vno

GO
