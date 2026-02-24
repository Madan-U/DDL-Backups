-- Object: FUNCTION citrus_usr.fn_get_singlerecord_from_range
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--select * from MiscRptTbl
--select * from slip_issue_mstr,citrus_usr.fn_get_singlerecord_from_range
--select * from citrus_usr.fn_get_singlerecord_from_range (400000126,400000126,'2014-08-20 16:21:40.760')
CREATE function fn_get_singlerecord_from_range(@pa_from_no numeric(18), @pa_to_no numeric(18),@pa_dt datetime)
returns  @l_table  TABLE (from_num numeric(18),to_num numeric(18))              
as
begin 


 
 
 while @pa_from_no < = @pa_to_no
 begin 
 
 
 insert into @l_table
 select @pa_from_no,@pa_from_no
 
 set @pa_from_no = @pa_from_no + 1 
 
 end 
 
 return
 
end

GO
