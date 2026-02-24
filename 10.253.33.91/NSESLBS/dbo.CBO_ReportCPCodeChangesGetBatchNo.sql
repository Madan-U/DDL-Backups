-- Object: PROCEDURE dbo.CBO_ReportCPCodeChangesGetBatchNo
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE
proc  
 [dbo].[CBO_ReportCPCodeChangesGetBatchNo]  
 (  
  @statusid varchar(20),  
  @statusname varchar(50),
  @TDate Varchar(11)
 )  
  
as  
  
declare @batch_no tinyint  
  
if (len(@statusid) > 0) and (len(@statusname) > 0)  
begin  
 select  
  @batch_no = isnull(max(batch_no), 0)  
 from  
  cp_changes_batch_counter  
 where  
  currentdate like @TDate + '%'  
  
 if convert(tinyint, @batch_no) = 99  
 begin  
   delete from  
    cp_changes_batch_counter  
  where  
   currentdate like @TDate + '%'  
 select  
  @batch_no = 0
 end  
  
 if convert(tinyint, @batch_no) = 0  
 begin  
  insert into cp_changes_batch_counter  
  values(@TDate + ' 00:00:00', @batch_no + 1)  
 end  
  
 if (convert(tinyint, @batch_no) > 0) and (convert(tinyint, @batch_no) < 99)  
 begin  
  update  
   cp_changes_batch_counter  
  set  
   batch_no = @batch_no + 1  
  where  
   currentdate like @TDate + '%'  
 end  
  
 select right('00' + convert(varchar, @batch_no + 1), 2) as batch_no  
  
end  
else  
begin  
 select 'invalid login'  
end

GO
