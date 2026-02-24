-- Object: PROCEDURE dbo.V2_ObjectListing
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc V2_ObjectListing    
    
as    
    
select b.name TableName, a.rowcnt RowCnt, cast(sum(c.used)*8192/1024  as varchar) + ' KB' SpaceUsed    
from sysindexes a, sysobjects b, sysindexes c    
where a.id = b.id    
and a.indid = 0    
and a.id = c.id    
and c.indid in (0,1,255)    
and b.xtype = 'U'    
group by b.name, a.rowcnt    
order by a.rowcnt desc

GO
