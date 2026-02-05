-- Object: PROCEDURE citrus_usr.pr_client_multivoucher_report_24072010
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--pr_client_multivoucher_report	0,'HO|*~|HO|*~|*|~*','1|*~|2|*~|3|*~|6|*~|7|*~|*|~*','|*~||*~|0|*~|100|*~|25/09/2008|*~|25/09/2009|*~|ACTIVE|*~|1','1|*~|7|*~|6|*~|','','HO'
--pr_client_multireport	0,'HO|*~|HO|*~|*|~*','|*~||*~||*~||*~||*~||*~||*~|N|*~|25/09/2008|*~|25/09/2009|*~|ACTIVE|*~|1','1|*~|21|*~|','','HO'
CREATE proc [citrus_usr].[pr_client_multivoucher_report_24072010](@pa_id numeric  
,@pa_hiercy varchar(2000) 
,@pa_acctype_values varchar(8000)  
,@pa_main_filters_values varchar(8000) 
,@pa_select_values varchar(8000)  
,@pa_filter_values varchar(8000)   
,@pa_grp_by varchar(1000)
,@pa_fin_id char(1)
)  
as  
begin  
--  
  declare @l_sql varchar(8000)  
  ,@l_sql1 varchar(8000)  
  ,@l_sql2 varchar(8000)  
  ,@l_sql3 varchar(8000)  
  ,@l_sql4 varchar(8000)  
  ,@l_sql5 varchar(8000)  
  ,@l_sql6 varchar(8000)
  ,@l_filter_values varchar(2000)  
  ,@l_filter_hiercy varchar(2000)  

   set @l_sql = ''  
   set @l_sql1 =''  
   set @l_sql2 =''  
   set @l_sql3 = ''  
   set @l_sql4 = ''  
   set @l_sql5 = ''  
   set @l_filter_values = ''  
   set @l_filter_hiercy = ''  
          
   declare @l_select table(id numeric)  
   declare @l_select_special table(id varchar(10)) 
   create table  #temp (id numeric)
--tbl_select_criteria_voucher
   create table #tblselect  
   (
		id			numeric(18,0),
		select_desc	varchar(1000),
		ord_by		numeric(10,0),
		formula		varchar(3000)
   )
  
   declare @l_filter table(id numeric, string varchar(3000))  
   declare @l_hiercy table(cd varchar(100), shortname varchar(500),hiercy_string varchar(8000))  
   
  
   declare	@l_counter numeric  
		   ,@l_count numeric   
  
	set @l_counter  = 1  
	set @l_count = citrus_usr.ufn_countstring(@pa_acctype_values ,'|*~|')  

	while @l_count >= @l_counter  
	begin   
  
		if isnumeric(citrus_usr.fn_splitval(@pa_acctype_values,@l_counter)) = 1
		begin 
				insert into #temp select citrus_usr.fn_splitval(@pa_acctype_values,@l_counter)  
		end 
				set @l_counter= @l_counter +1 
	end

  
	set @l_counter  = 1  
	set @l_count = citrus_usr.ufn_countstring(@pa_select_values ,'|*~|')

	while @l_count >= @l_counter  
	begin   
  
		if isnumeric(citrus_usr.fn_splitval(@pa_select_values,@l_counter)) = 1
		begin 
				insert into @l_select select citrus_usr.fn_splitval(@pa_select_values,@l_counter)  
		end 
		else
		begin 
				insert into @l_select_special select citrus_usr.fn_splitval(@pa_select_values,@l_counter)  
		end 

		if exists(select * from @l_select_special)
		delete from  @l_select

		set @l_counter= @l_counter +1
   
	end   
		  
    

    if exists(select * from @l_select)
    begin
			insert into #tblselect
			(
				id,			
				select_desc,	
				ord_by,		
				formula						
			)
			select  id,			
					select_desc,	
					ord_by,		
					case when id = 8 then '(SELECT DISTINCT FINA_ACC_CODE FROM FIN_ACCOUNT_MSTR L  , LEDGER' + @pa_fin_id + ' B WHERE FINA_ACC_ID = B.LDG_ACCOUNT_ID   AND  ldg.LDG_VOUCHER_NO = B.LDG_VOUCHER_NO   AND ldg.LDG_VOUCHER_TYPE = B.LDG_VOUCHER_TYPE AND LDG.LDG_SR_NO <> B.LDG_SR_NO AND B.LDG_ACCOUNT_TYPE <> ''P'' AND B.LDG_DELETED_IND = 1  )[Bnk Cd.]' 
						 when id = 9 then '(SELECT DISTINCT FINA_ACC_NAME FROM FIN_ACCOUNT_MSTR L  , LEDGER' + @pa_fin_id + ' B WHERE FINA_ACC_ID = B.LDG_ACCOUNT_ID   AND  ldg.LDG_VOUCHER_NO = B.LDG_VOUCHER_NO   AND ldg.LDG_VOUCHER_TYPE = B.LDG_VOUCHER_TYPE AND LDG.LDG_SR_NO <> B.LDG_SR_NO AND B.LDG_ACCOUNT_TYPE <> ''P'' AND B.LDG_DELETED_IND = 1  )[Bnk NM.]' 
					else formula end
			from tbl_select_criteria_voucher a
			where id in (select id from @l_select)
			
							select @l_sql1  = @l_sql1 + isnull(formula,'') + ','  from #tblselect where formula <> ''
	print @l_sql1				  

							set  @l_sql1 = substring( @l_sql1 + ',' ,1,len(@l_sql1)-1)  
							set @l_sql = 'select distinct '  
							set @l_sql = @l_sql + @l_sql1  
							if @pa_grp_by ='HO'  
							set @l_sql = @l_sql + ' , citrus_usr.[fn_find_relations_Acctlvl](DPAM_ID,''HO'') Groupby  '   
							if @pa_grp_by ='BR'  
							set @l_sql = @l_sql + ' , citrus_usr.[fn_find_relations_Acctlvl](DPAM_ID,''BR'')  Groupby  '   
							if @pa_grp_by ='CLIENT'  
							set @l_sql = @l_sql + ' , DPAM_SBA_NO Groupby  '   
					  
							set @l_sql2 = ' ,CASE WHEN LDG_VOUCHER_TYPE = 1 THEN ''Payment'' 
												  WHEN LDG_VOUCHER_TYPE = 2 THEN ''Receipt'' 
												  WHEN LDG_VOUCHER_TYPE = 3 THEN ''Journal'' 
												  WHEN LDG_VOUCHER_TYPE = 6 THEN ''Credit Note'' 
												  WHEN LDG_VOUCHER_TYPE = 7 THEN ''Debit Note'' 
											 END AS TYPE
								from dp_acct_mstr dpam,ledger' + @pa_fin_id + ' ldg --, fin_account_mstr fina
							 , entity_relationship entr'  
							set @l_sql2 = @l_sql2  + ' where dpam.dpam_id = ldg.ldg_account_id 
							and dpam_dpm_id = ldg.ldg_dpm_id and entr.ENTR_SBA = dpam.dpam_sba_no 
							and ldg_narration <> ''Opening Balance'' and ldg.ldg_deleted_ind = 1 
							--and fina.fina_deleted_ind = 1 
							and entr.entr_deleted_ind = 1 ' 
							set @l_sql = @l_sql + @l_sql2 + case when  @pa_filter_values <> '' then ' and ' else '' end   
					    
	
			  
		    
							set @l_counter  = 1  
							set @l_count = citrus_usr.ufn_countstring(@pa_filter_values ,'*|~*')  
					  
							while @l_count >= @l_counter  
							begin   
							set @l_filter_values =  citrus_usr.fn_splitval_row(@pa_filter_values,@l_counter)  
							insert into @l_filter select citrus_usr.fn_splitval(@l_filter_values,1) , citrus_usr.fn_splitval(@l_filter_values,2)  
					  
							set @l_counter= @l_counter +1   
							end   
					  
							update tmp set string = formula + ' = ' + '''' + string + '''' +' and '  
							from tbl_filter_criteria main, @l_filter tmp where tmp.id = main.id   
					  
							select  @l_sql3 = @l_sql3 + string from @l_filter  
							if len(@l_sql3) > 1  
							set @l_sql3  = substring( @l_sql3 + ',' ,1,len(@l_sql3)-4)  
							set @l_sql = @l_sql + @l_sql3  
					    
		  
							set @l_counter  = 1  
							set @l_count = citrus_usr.ufn_countstring(@pa_hiercy ,'*|~*')  
					  
							while @l_count >= @l_counter  
							begin   
			  				set @l_filter_hiercy =  citrus_usr.fn_splitval_row(@pa_hiercy,@l_counter)  
								insert into @l_hiercy select citrus_usr.fn_splitval(@l_filter_hiercy,1) , citrus_usr.fn_splitval(@l_filter_hiercy,2),''  
								set @l_counter= @l_counter +1   
							end   
		  
							update tmp  
							set  tmp.hiercy_string = '' + ENTEM_ENTR_COL_NAME +''+ ' = ' + convert(varchar,entm_id)   
							from @l_hiercy  tmp , enttm_entr_mapping , entity_mstr entm where ENTEM_ENTTM_CD = cd and entm_short_name = shortname  
		    
							select @l_sql4 = @l_sql4 + hiercy_string + ' and ' from @l_hiercy   
							
							if len(@l_sql4) > 1  
							set @l_sql4  = substring( @l_sql4 + ',' ,1,len(@l_sql4)-4)  
		  

							--  if citrus_usr.fn_splitval(@pa_main_filters_values ,1) <> '' 
							--if citrus_usr.fn_splitval(@pa_acctype_values ,1) <> ''   
							set @l_sql5 =  ' and LDG_VOUCHER_TYPE in(select id from #temp) '  
							
							if citrus_usr.fn_splitval(@pa_main_filters_values ,1) <> ''  
							begin  
							set @l_sql5 =  @l_sql5 + ' and isnumeric(dpam_sba_no) = 1 '  
							set @l_sql5 =  @l_sql5 + ' and dpam_sba_no >= convert(numeric(16,0),''' + citrus_usr.fn_splitval(@pa_main_filters_values ,1) + ''') '  
							end   

							if citrus_usr.fn_splitval(@pa_main_filters_values ,2) <> ''   
							set @l_sql5 = @l_sql5 + ' and dpam_sba_no <= convert(numeric(16,0),''' + citrus_usr.fn_splitval(@pa_main_filters_values ,2) + ''') '  

							if citrus_usr.fn_splitval(@pa_main_filters_values ,3) <> ''   
							set @l_sql5 = @l_sql5 + ' and ldg_amount >= convert(numeric(18,4),' + citrus_usr.fn_splitval(@pa_main_filters_values ,3) + ') '  

							if citrus_usr.fn_splitval(@pa_main_filters_values ,4) <> ''   
							set @l_sql5 = @l_sql5 + ' and ldg_amount <= convert(numeric(18,4),' + citrus_usr.fn_splitval(@pa_main_filters_values ,4) + ') '  

							if citrus_usr.fn_splitval(@pa_main_filters_values ,5) <> ''   
							set @l_sql5 = @l_sql5 + ' and dpam_created_dt >= ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,5),103) ,109)  + ''' '  

							if citrus_usr.fn_splitval(@pa_main_filters_values ,6) <> ''  
							begin  
							  set @l_sql5 =  @l_sql5 + ' and dpam_created_dt <= ''' +convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,6)+' 23:59:00 ',103) ,109) + ''' '  	
							end   
							
							if citrus_usr.fn_splitval(@pa_main_filters_values ,7) <> ''   
							set @l_sql5 = @l_sql5 + ' and dpam_stam_cd = ''' + citrus_usr.fn_splitval(@pa_main_filters_values ,7) + ''' '  
							
							if @pa_grp_by ='BR'  
							set @l_sql = @l_sql + ' and isnull(citrus_usr.[fn_find_relations_Acctlvl](DPAM_ID,''BR''),'''') <> ''''  '   
							if citrus_usr.fn_splitval(@pa_main_filters_values ,8) <> ''   
							set @l_sql5 = @l_sql5 + ' order by ' + case when  @pa_grp_by ='BR'   then ' Groupby , ' else '' end + '[' + (select select_desc from tbl_select_criteria_voucher where id = citrus_usr.fn_splitval(@pa_main_filters_values ,8)) + '] '  
		  
		/*1.@pa_hiercy like 'HO|*~|HO|*~|*|~*BR|*~|2|*~|*|~*......'  
				2.@pa_main_filter_values like category -- if not then blank --varchar  
										client type -- if not then blank --varchar  
										client id from -- if not then blank --numeric  
										client id to   -- if not then blank --numeric  
										sheme          -- if not then blank --varchar  
										back office code --if not then blank --varchar  
										minor          -- if not then blank --varchar   
										account freeze -- Y or N  
										from dt        -- Account freeze from dt      
										to dt          -- Account freeze from dt    
										status         -- if not then blank --varchar   
										order by       -- default boid */  
		  
		  
										set @l_sql = @l_sql + case when  @pa_hiercy <> '' then ' and ' else '' end  + @l_sql4   
										print @l_sql   
										while right(ltrim(rtrim(@l_sql)),3) = 'AND'   
										begin  
										set @l_sql = case when right(ltrim(rtrim(@l_sql)),3) = 'AND' then substring(ltrim(rtrim(@l_sql)),1,len(ltrim(rtrim(@l_sql)))-3) end  
										end   
										  
										set @l_sql  = @l_sql  + @l_sql5    
							END 	
       ELSE IF exists(select * from @l_select_special)		  
       BEGIN 

				declare @l_sqlA varchar(8000), 
						@l_sqlB varchar(8000)

			set @l_sqlA =''
			set @l_sqlB =''

			select @l_sqlA  = @l_sqlA + isnull(formula,'') + ','  from tbl_select_criteria_voucher_special where id in (select id from @l_select_special)  
            set @l_sqlA = substring(@l_sqlA,1,len(@l_sqlA )-1)  
			set @l_sqlB = 'select distinct ' + @l_sqlA
			set @l_sqlB = @l_sqlB + ' , '''' groupby from entity_mstr entm where entm_enttm_cd = ''BR'' and entm_deleted_ind = 1' 
      
			set @l_sql =  @l_sqlB
		END
  
  
print @l_sql   
exec(@l_sql)  
    
--  
end

GO
