-- Object: PROCEDURE citrus_usr.PR_EOD_STATUS
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--PR_EOD_STATUS '31/05/2008'      
      
CREATE procedure  [citrus_usr].[PR_EOD_STATUS](@pa_import_date varchar(12))      
as      
begin      
--      
  create table #l_temp_table (DPM_DPID varchar(8), SOT CHAR(1), COD char(1), autocorp char(1), CLOP char(1),soh char(1),  trans char(1), ISIN char(1), settlement char(1), client char(1), bp char(1))      
          
        
        
insert into #l_temp_table        
(DPM_DPID       
)      
select distinct right(ltrim(rtrim(task_name)),8) from filetask where left(right(ltrim(rtrim(task_name)),8),2)  = 'IN'      and     convert(varchar,TASK_FILEDATE,103) =  @pa_import_date      
      
update #l_temp_table        
set    SOT = 'Y'      
from   filetask       
where  DPM_DPID = right(ltrim(rtrim(task_name)),8)      
and    left(right(ltrim(rtrim(task_name)),8),2)  = 'IN'      
and    left(ltrim(rtrim(task_name)),12) = 'DPM SOT FILE'      
and    convert(varchar,TASK_FILEDATE,103) =  @pa_import_date      
      
      
      
      
update #l_temp_table        
set    COD = 'Y'       
from   filetask       
where  DPM_DPID = right(ltrim(rtrim(task_name)),8)      
and    left(right(ltrim(rtrim(task_name)),8),2)  = 'IN'      
and    left(ltrim(rtrim(task_name)),12) = 'DPM COD FILE'      
and    convert(varchar,TASK_FILEDATE,103) =  @pa_import_date      
      
      
      
update #l_temp_table        
set    soh  = 'Y'      
from   filetask       
where  DPM_DPID = right(ltrim(rtrim(task_name)),8)      
and    left(right(ltrim(rtrim(task_name)),8),2)  = 'IN'      
and    left(ltrim(rtrim(task_name)),12) = 'DPM SOH FILE'      
and    convert(varchar,TASK_FILEDATE,103) =  @pa_import_date      
      
       
      
update #l_temp_table        
set    autocorp = 'Y'       
from   filetask       
where  DPM_DPID = right(ltrim(rtrim(task_name)),8)      
and    left(right(ltrim(rtrim(task_name)),8),2)  = 'IN'      
and    left(ltrim(rtrim(task_name)),24) = 'DPM AUTOCORPORATION FILE'      
and    convert(varchar,TASK_FILEDATE,103) =  @pa_import_date      
      
      
      
update #l_temp_table        
set    CLOP = 'Y'      
from   filetask       
where  DPM_DPID = right(ltrim(rtrim(task_name)),8)      
and    left(right(ltrim(rtrim(task_name)),8),2)  = 'IN'      
and    left(ltrim(rtrim(task_name)),17) = 'DPM CLOSING PRICE'      
and    convert(varchar,TASK_FILEDATE,103) =  @pa_import_date      
      
      
      
update #l_temp_table        
set    trans ='Y'      
from   filetask       
where  DPM_DPID = right(ltrim(rtrim(task_name)),8)      
and    left(right(ltrim(rtrim(task_name)),8),2)  = 'IN'      
and    left(ltrim(rtrim(task_name)),15) = 'DPM TRANSACTION'      
and    convert(varchar,TASK_FILEDATE,103) =  @pa_import_date      
      
      
      
update #l_temp_table        
set    bp  = 'Y'      
from   filetask       
where  left(ltrim(rtrim(task_name)),7) = 'BP MSTR'      
and    convert(varchar,TASK_FILEDATE,103) =  @pa_import_date      
      
      
      
update #l_temp_table        
set    ISIN = 'Y'      
from   filetask       
where  left(ltrim(rtrim(task_name)),9) = 'ISIN MSTR'      
and    convert(varchar,TASK_FILEDATE,103) =  @pa_import_date      
      
      
      
update #l_temp_table        
set    client  = 'Y'      
from   filetask       
where  left(ltrim(rtrim(task_name)),13) = 'CLIENT MASTER'      
and    convert(varchar,TASK_FILEDATE,103) =  @pa_import_date      
      
      
      
update #l_temp_table        
set    settlement = 'Y'       
from   filetask       
where  left(ltrim(rtrim(task_name)),15) = 'SETTLEMENT MSTR'      
and    convert(varchar,TASK_FILEDATE,103) =  @pa_import_date      
      
      
      
      
      
      
      
select DPM_DPID [DP ID]    
, isnull(SOT,'N')  [SOT FILE]    
, isnull(COD,'N') [COD FILE]    
, isnull(autocorp,'N') [AUTOCORPORATION FILE]    
, isnull(CLOP,'N') [CLOSING PRICE]    
,isnull(soh,'N') [SOH FILE]    
,  isnull(trans,'N') [DPM TRANSACTION FILE(NORMAL) ]    
, isnull(ISIN,'N') [ISIN MSTR IMPORT]    
, isnull(settlement,'N') [SETTLEMENT MSTR]    
, isnull(client,'N') [CLIENT MASTER]    
, isnull(bp,'N') [BP MSTR]    
 from #l_temp_table       
      
    
      
      
--      
end

GO
