-- Object: PROCEDURE citrus_usr.pr_get_stringbinary_errorroot
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--pr_get_stringbinary_errorroot 'table','String_binary_error_source','String_binary_error_destination'
CREATE proc pr_get_stringbinary_errorroot (@pa_source_type varchar(10),@pa_source_string varchar(8000),@pa_destination_table varchar(100))
as
begin 

	SELECT identity(numeric,1,1) id, 
		c.name 'Column Name',
		t.Name 'Data type',
		c.max_length 'Max Length' into #destinationstructure
	FROM    
		sys.columns c
	INNER JOIN 
		sys.types t ON c.user_type_id = t.user_type_id
	LEFT OUTER JOIN 
		sys.index_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
	LEFT OUTER JOIN 
		sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
	WHERE
		c.object_id = OBJECT_ID(@pa_destination_table)
		
	
		
	SELECT identity(numeric,1,1) id, 
		c.name 'Column Name',
		t.Name 'Data type',
		c.max_length 'Max Length' into #sourcestructure
	FROM    
		sys.columns c
	INNER JOIN 
		sys.types t ON c.user_type_id = t.user_type_id
	LEFT OUTER JOIN 
		sys.index_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
	LEFT OUTER JOIN 
		sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
	WHERE
		c.object_id = OBJECT_ID(@pa_source_string)
    
    declare @l_count numeric
    declare @l_counter numeric
    declare @l_columnname varchar(100)
    declare @l_maxlength numeric
    declare @l_valuelength numeric
    declare @l_string varchar(1000)
    DECLARE @Results TABLE(result numeric)

    set @l_counter  = 1 
    select @l_count = count(1) from #sourcestructure
    
    while @l_count >  = @l_counter 
    begin 
    
    select @l_columnname = [Column Name] from #sourcestructure  where id = @l_counter
    select @l_maxlength  = [Max Length] from #destinationstructure where id = @l_counter
--    select @l_valuelength  = [Max Length] from #sourcestructure where  [Column Name]  = @l_columnname 





INSERT @Results(result)
EXEC('select max(len('+@l_columnname+')) from ' +@pa_source_string    )




if @l_maxlength < (select top 1 result from @Results )
select @l_columnname 

delete from @Results
    
    set @l_counter = @l_counter + 1 
    
    end 
    
    
    
    
    
end

GO
