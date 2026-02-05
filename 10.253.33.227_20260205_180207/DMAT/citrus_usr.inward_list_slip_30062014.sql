-- Object: PROCEDURE citrus_usr.inward_list_slip_30062014
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--[inward_list_slip] 'a002',4,646
create procedure  [citrus_usr].[inward_list_slip_30062014](@pa_po_no varchar(25),@pa_excsm_id numeric,@pa_trastm_id numeric )
as  
begin  
 
  declare @pa_book_no varchar(100)
create table #test(book_no bigint, slip_from bigint , slip_to bigint ,tratm_id numeric, type char(1),size_of_book numeric,series_type varchar(20),dt varchar(11))  

declare @l_no_slip_book bigint  
,@l_no_of_books bigint  
,@l_size_of_books bigint  
,@l_book_from bigint  
,@l_to_from bigint  
,@l_slip_from bigint  
,@l_book_type char(1)  
,@l_trastm_id numeric  
,@l_series_type varchar(20)
,@l_temp_size numeric
,@l_dpm_id  bigint
,@l_order_dt varchar(11)  
declare @c_cursor cursor  
  
--alter table slip_book_mstr alter column slibm_book_nameint  

if @pa_excsm_id='999'
begin 
SELECT @l_dpm_id  = '999'
end 
else 
begin
select @l_dpm_id = dpm_id from dp_mstr where default_dp = dpm_excsm_id and dpm_excsm_id = @pa_excsm_id
end

select @l_temp_size  = count(distinct slibm_id) from slip_book_mstr,order_slip 
where slibm_book_name between ors_from_no and ors_to_no 
and  ors_series_type = SLIBM_SERIES_TYPE 
and slibm_deleted_ind = 1  
AND   ors_tratm_id  =@pa_trastm_id AND SLIBM_TRATM_ID = @pa_trastm_id and ors_po_no = @pa_po_no
  print @l_temp_size
if @pa_trastm_id <> '0'
begin
--

SET @c_cursor =  CURSOR fast_forward FOR            
SELECT ors_no_of_books
,ors_size_of_books
,ors_from_no
,ors_to_no
,ors_from_slip
,'B'--ors_book_type  -- Intentionally done for MOSL for loose slip
,ors_tratm_id 
,ors_series_type , convert(varchar(11),ors_po_dt,103) 
FROM order_slip 
where ors_po_no = @pa_po_no
and   ors_dpm_id  =@l_dpm_id
and   ors_tratm_id  =@pa_trastm_id
and   ors_size_of_books <> @l_temp_size
--and   ors_from_slip not in (select SLIBM_FROM_NO from slip_book_mstr  where SLIBM_TRATM_ID = @pa_trastm_id AND SLIBM_DELETED_IND = 1)
and   ord_deleted_ind = 1
	

--
end
else
begin
--
  SET @c_cursor =  CURSOR fast_forward FOR            
  SELECT ors_no_of_books
  ,ors_size_of_books
  ,ors_from_no
  ,ors_to_no
	,ors_from_slip
	,'B'--ors_book_type -- Intentionally done for MOSL for loose slip
	,ors_tratm_id 
	,ors_series_type , convert(varchar(11),ors_po_dt,103) 
	FROM order_slip 
	where ors_po_no = @pa_po_no
	and   ors_dpm_id  =@l_dpm_id
	and   ors_size_of_books <> @l_temp_size
	-- and   ors_from_slip not in (select SLIBM_FROM_NO from slip_book_mstr  where SLIBM_TRATM_ID = @pa_trastm_id  AND SLIBM_DELETED_IND = 1)
	and   ord_deleted_ind = 1
--
end


  
  
  
OPEN @c_cursor            
FETCH NEXT FROM @c_cursor   
INTO @l_no_of_books   
,@l_size_of_books   
,@l_book_from   
,@l_to_from   
,@l_slip_from   
,@l_book_type  
,@l_trastm_id 
,@l_series_type , @l_order_dt 
  
  
WHILE @@fetch_status = 0            
BEGIN            
--   
   if @l_book_type = 'B'  
   begin  
   --  
 while  @l_book_from   <= @l_to_from  
 begin  
 --  

print @l_no_of_books   
print @l_size_of_books   
print @l_book_from   
print @l_to_from   
print @l_slip_from   
print @l_book_type  
print @l_trastm_id 
print @l_series_type 
print @l_order_dt

   insert into #test(book_no , slip_from , slip_to,tratm_id,type,size_of_book ,series_type ,dt)  
   select @l_book_from   
		     , @l_slip_from  
		     , @l_slip_from + (@l_size_of_books - 1)   
							, @l_trastm_id  
							, 'L' --@l_book_type  -- Intentionally done for MOSL for loose slip
		  					, @l_size_of_books
							, @l_series_type , @l_order_dt
   WHERE @l_slip_from not in (select SLIBM_FROM_NO from slip_book_mstr  where SLIBM_TRATM_ID = @pa_trastm_id and SLIBM_SERIES_TYPE = @l_series_type AND SLIBM_DELETED_IND = 1)
 				
   set @l_book_from     = @l_book_from + 1  
   set @l_slip_from     =  @l_slip_from + (@l_size_of_books - 1) + 1   
  
   set @l_no_slip_book  =  @l_no_slip_book   + 1   
 --  
 end  
  --  
  end  
  else  
  begin  
  --   

    while  @l_book_from   <= @l_to_from  
 begin  
 --  
      declare @l_int int  
      set @l_int = 1  

      while @l_int  <= @l_size_of_books  
      begin  
      --  
   insert into #test(book_no , slip_from , slip_to,tratm_id,type,size_of_book,series_type ,dt )  
   select @l_book_from   
     , @l_slip_from  
     , @l_slip_from   
     , @l_trastm_id  
     , 'L'--@l_book_type  -- Intentionally done for MOSL for loose slip
     , @l_size_of_books
     , @l_series_type , @l_order_dt
   WHERE @l_slip_from not in (select SLIBM_FROM_NO from slip_book_mstr  where SLIBM_TRATM_ID = @pa_trastm_id and SLIBM_SERIES_TYPE = @l_series_type  AND SLIBM_DELETED_IND = 1)			

   set @l_slip_from     =  @l_slip_from +  1   
      set @l_int = @l_int + 1   
      --  
      end  
  
   set @l_book_from     = @l_book_from + 1  
   set @l_no_slip_book  =  @l_no_slip_book   + 1   
 --  
 end  
  --  
  end   
   
  
    FETCH NEXT FROM @c_cursor   
    INTO @l_no_of_books   
								,@l_size_of_books   
								,@l_book_from   
								,@l_to_from   
								,@l_slip_from  
        ,@l_book_type  
        ,@l_trastm_id
        ,@l_series_type  , @l_order_dt
--  
END  
  
CLOSE      @c_cursor            
DEALLOCATE @c_cursor   
  
  
  
select book_no , slip_from , slip_to,tratm_id,type,size_of_book,series_type ,isnull(dt,'') dt from #test  
truncate table #test
drop table #test    
--  
end

GO
