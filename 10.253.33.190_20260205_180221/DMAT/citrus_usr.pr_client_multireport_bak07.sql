-- Object: PROCEDURE citrus_usr.pr_client_multireport_bak07
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

/*create table tbl_select_criteria  
(id numeric identity(1,1)  
,select_desc varchar(1000)  
,ord_by numeric(10,0))  
  
create table tbl_filter_criteria  
(id numeric identity(1,1)  
,filter_desc varchar(1000)  
)*/  
  
/*  
insert into tbl_select_criteria  
values('client name', 1)  
insert into tbl_select_criteria  
values('address' ,2)  
insert into tbl_select_criteria  
values('office ph' ,3)  
insert into tbl_select_criteria  
values('mobile' ,4)  
insert into tbl_select_criteria  
values('res ph' ,5)  
insert into tbl_select_criteria  
values('pan no' ,6)  
insert into tbl_select_criteria  
values('scheme' ,7)  
insert into tbl_select_criteria  
values('bbo code' ,8)  
insert into tbl_select_criteria  
values('client code' ,9)  
insert into tbl_select_criteria  
values('second holder' ,10)  
insert into tbl_select_criteria  
values('third holder' ,11)  
insert into tbl_select_criteria  
values('nominee' ,12)  
insert into tbl_select_criteria  
values('gaurdian' ,13)  
insert into tbl_select_criteria  
values('nominee guardian' ,14)  
insert into tbl_select_criteria  
values('category' ,15)  
insert into tbl_select_criteria  
values('status' ,16)  
insert into tbl_select_criteria  
values('balance' ,17)  
insert into tbl_select_criteria  
values('email' ,18)  
insert into tbl_select_criteria  
values('activation date' ,19)  
  
  
insert into tbl_filter_criteria  
select 'none'  
insert into tbl_filter_criteria  
select 'pin code'  
insert into tbl_filter_criteria  
select 'telephone'  
insert into tbl_filter_criteria  
select 'mobile'  
insert into tbl_filter_criteria  
select 'email'  
insert into tbl_filter_criteria  
select 'pan no'  
insert into tbl_filter_criteria  
select 'state'  
  
)*/  
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
        order by       -- default boid   
  
@pa_grp_by = 'ho','br','client'  
*/  
	---0	HO|*~|HO|*~|*|~*	|*~||*~|1234567890123456|*~|1234567890123456|*~||*~||*~||*~|N|*~|14/01/2008|*~|14/09/2009|*~|ACTIVE|*~|1	1|*~|8|*~|		HO
/*
pr_client_multireport 0,'HO|*~|HO|*~|*|~*','21|*~|01_CDSL|*~||*~||*~||*~||*~||*~|N|*~|14/01/2009|*~|14/07/2009|*~|ACTIVE|*~|1','1|*~|4|*~|' ,'','BR'    
pr_client_multireport 0,'HO|*~|HO|*~|*|~*BR|*~|089|*~|*|~*','21|*~|01_CDSL|*~||*~||*~||*~||*~||*~|N|*~|apr 24 2009|*~|jun 24 2009|*~|ACTIVE|*~|20','20|*~|34|*~|' ,''  

exec pr_client_multireport 0,'HO|*~|HO|*~|*|~*','|*~||*~|1234567890123456|*~|1234567890123456|*~||*~||*~||*~|N|*~|14/01/2008|*~|14/09/2009|*~|ACTIVE|*~|1','1|*~|8|*~|','','HO'
  
begin tran
rollback

*/
--pr_client_multireport_bak07	0,'HO|*~|HO|*~|*|~*','|*~||*~||*~||*~||*~||*~||*~|N|*~|01/01/2016|*~|31/01/2016|*~|ACTIVE|*~|1','1|*~|21|*~|','',''
CREATE proc [citrus_usr].[pr_client_multireport_bak07](@pa_id numeric  
,@pa_hiercy varchar(2000)  
,@pa_main_filters_values varchar(8000)  
,@pa_select_values varchar(8000)  
,@pa_filter_values varchar(8000)  
,@pa_grp_by varchar(1000))  
as  
begin  

--  
--
--
exec pr_client_multireport_dps8 @pa_id,@pa_hiercy,@pa_main_filters_values,@pa_select_values,@pa_filter_values,@pa_grp_by
return 


set dateformat dmy 





  declare @l_sql varchar(8000)  
  ,@l_sql1 varchar(8000)  
  ,@l_sql2 varchar(8000)  
  ,@l_sql3 varchar(8000)  
  ,@l_sql4 varchar(8000)  
  ,@l_sql5 varchar(8000)  
  ,@l_filter_values varchar(2000)  
  ,@l_filter_hiercy varchar(2000)  
  ,@l_dpm_id numeric
  
  select @l_dpm_id = dpm_id from dp_mstr where default_dp = dpm_excsm_id and dpm_excsm_id = @pa_id and dpm_deleted_ind = 1

   set @l_sql = ''  
   set @l_sql1 =''  
   set @l_sql2 =''  
   set @l_sql3 = ''  
   set @l_sql4 = ''  
   set @l_sql5 = ''  
   set @l_filter_values = ''  
   set @l_filter_hiercy = ''  


select distinct convert(datetime,accp_value,103) accp_value, accp_clisba_id , accp_accpm_prop_cd 
into #account_properties from account_properties
 where accp_accpm_prop_cd = 'BILL_START_DT' 


          
   declare @l_select table(id numeric)  
   declare @l_select_special table(id varchar(10)) 
  
   declare @l_filter table(id numeric, string varchar(3000))  
   declare @l_hiercy table(cd varchar(100), shortname varchar(500),hiercy_string varchar(8000))  
   
  
   declare @l_counter numeric  
   ,@l_count numeric   
  
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

							select @l_sql1  = @l_sql1 + isnull(formula,'') + ','  from tbl_select_criteria where id in (select id from @l_select)  
					  
							set  @l_sql1 = substring( @l_sql1 + ',' ,1,len(@l_sql1)-1)  
							set @l_sql = 'select distinct '  
							set @l_sql = @l_sql + @l_sql1  
							if @pa_grp_by ='HO'  
							set @l_sql = @l_sql + ' , isnull(citrus_usr.[fn_find_relations_nm](dpam.DPAM_CRN_NO,''HO''),'''') Groupby  '   
							if @pa_grp_by ='BR'  
							set @l_sql = @l_sql + ' ,  isnull(citrus_usr.[fn_find_relations_nm](dpam.DPAM_CRN_NO,''BR''),'''')   Groupby  '   
							if @pa_grp_by ='BA'  
							set @l_sql = @l_sql + ' ,  isnull(citrus_usr.[fn_find_relations_nm](dpam.DPAM_CRN_NO,''BA''),'''')  Groupby  '   
							if @pa_grp_by ='AR'  
							set @l_sql = @l_sql + ' ,  isnull(citrus_usr.[fn_find_relations_nm](dpam.DPAM_CRN_NO,''AR''),'''')  Groupby  '   
							if @pa_grp_by ='ONW'  
							set @l_sql = @l_sql + ' ,  isnull(citrus_usr.[fn_find_relations_nm](dpam.DPAM_CRN_NO,''ONW''),'''')  Groupby  '   
							if @pa_grp_by ='RE'  
							set @l_sql = @l_sql + ' ,  isnull(citrus_usr.[fn_find_relations_nm](dpam.DPAM_CRN_NO,''RE''),'''')  Groupby  '   
							if @pa_grp_by ='REM'  
							set @l_sql = @l_sql + ' ,  isnull(citrus_usr.[fn_find_relations_nm](dpam.DPAM_CRN_NO,''REM''),'''')  Groupby  '   
							if @pa_grp_by ='CLIENT'  
							set @l_sql = @l_sql + ' , DPAM_SBA_NO Groupby  '   
					  
							set @l_sql2 = ' from #account_properties,client_mstr clim , dp_acct_mstr dpam left outer join  client_dp_brkg clidb on clidb_dpam_id = dpam_id and clidb_deleted_ind = 1 and clidb_eff_to_dt > getdate() left outer join  brokerage_mstr brom on brom_id = clidb_brom_id and brom.brom_Deleted_ind = 1 left outer join dp_holder_dtls dphd on  dpam.dpam_sba_no = dphd.dphd_dpam_sba_no and dphd.dphd_deleted_ind =1 left outer join client_bank_accts on cliba_clisba_id=dpam.dpam_id left outer join bank_mstr on cliba_banm_id=banm_id, entity_relationship entr , client_ctgry_mstr clicm , entity_type_mstr enttm , status_mstr stam ,sub_ctgry_mstr subcm'  
							set @l_sql2 = @l_sql2  + ' where dpam_dpm_id = ' + convert(varchar(16),@l_dpm_id ) + ' and clicm_id = subcm_clicm_id and dpam_subcm_cd = subcm_cd and accp_clisba_id = dpam.dpam_id and clim.clim_crn_no = dpam.dpam_crn_no  and entr.entr_sba = dpam.dpam_sba_no and dpam.dpam_enttm_cd = enttm.enttm_cd and dpam.dpam_clicm_cd = clicm.clicm_cd and dpam.dpam_stam_cd = stam.stam_cd '  
							set @l_sql2 = @l_sql2  + ' and clim.clim_deleted_ind = 1 and dpam.dpam_deleted_ind = 1 and entr.entr_deleted_ind = 1 and clicm.clicm_deleted_ind = 1 and enttm.enttm_deleted_ind = 1  and stam.stam_deleted_ind = 1 '  
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
							if citrus_usr.fn_splitval(@pa_main_filters_values ,1) <> ''   
							set @l_sql5 =  ' and clicm_cd = ''' + citrus_usr.fn_splitval(@pa_main_filters_values ,1) + ''' '  
							if citrus_usr.fn_splitval(@pa_main_filters_values ,2) <> ''   
							set @l_sql5 =  @l_sql5 +  ' and  enttm_cd = ''' + citrus_usr.fn_splitval(@pa_main_filters_values ,2) + ''' ' 
                            if citrus_usr.fn_splitval(@pa_main_filters_values ,13) <> ''   
							set @l_sql5 =  @l_sql5 +  ' and  dpam_subcm_cd = ''' + citrus_usr.fn_splitval(@pa_main_filters_values ,13) + ''' '  
							if citrus_usr.fn_splitval(@pa_main_filters_values ,3) <> ''  
							begin  
							set @l_sql5 =  @l_sql5 + ' and isnumeric(dpam_sba_no) = 1 '  
							set @l_sql5 =  @l_sql5 + ' and dpam_sba_no >= convert(numeric(16,0),' + citrus_usr.fn_splitval(@pa_main_filters_values ,3) + ') '  
							end   
							if citrus_usr.fn_splitval(@pa_main_filters_values ,4) <> ''   
							set @l_sql5 = @l_sql5 + ' and dpam_sba_no <= convert(numeric(16,0),' + citrus_usr.fn_splitval(@pa_main_filters_values ,4) + ') '  
							--if citrus_usr.fn_splitval(@pa_main_filters_values ,9) <> ''   
							--set @l_sql5 = @l_sql5 + ' and accp_value >= ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,9),103) ,109)  + ''' '  
							if citrus_usr.fn_splitval(@pa_main_filters_values ,9) <> '' AND citrus_usr.fn_splitval(@pa_main_filters_values ,10) <> ''    
							begin
								if citrus_usr.fn_splitval(@pa_main_filters_values ,11) = '05'
								begin
									set @l_sql5 = @l_sql5 + ' and  accp_value between  ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,9),103) ,109)  + ''' and '''+ convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10),103) ,109)  + ''' '  
								end
								else
								begin
									set @l_sql5 = @l_sql5 + ' and  accp_value between  ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,9),103) ,109)  + ''' and '''+ convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10),103) ,109)  + ''' '  
								end
							end	
							--if citrus_usr.fn_splitval(@pa_main_filters_values ,10) <> ''  
							--begin  
							----set @l_sql5 =  @l_sql5 + ' and dpam_lst_upd_dt <= ''' +convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10)+' 23:59:00 ',103) ,109) + ''' '  
							--  set @l_sql5 =  @l_sql5 + ' and accp_value <= ''' +convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10)+' 23:59:00 ',103) ,109) + ''' '  	
							--end   
							if citrus_usr.fn_splitval(@pa_main_filters_values ,5) <> ''   
							set @l_sql5 = @l_sql5 + ' and brom_id = ' + citrus_usr.fn_splitval(@pa_main_filters_values ,5) + ' '  
							if citrus_usr.fn_splitval(@pa_main_filters_values ,6) <> ''   
							set @l_sql5 = @l_sql5 + ' and citrus_usr.fn_ucc_accp(dpam.dpam_id,''BBO_CODE'','') = ' + citrus_usr.fn_splitval(@pa_main_filters_values ,6) + ' '  
							if citrus_usr.fn_splitval(@pa_main_filters_values ,11) <> ''   
							set @l_sql5 = @l_sql5 + ' and dpam_stam_cd = ''' + citrus_usr.fn_splitval(@pa_main_filters_values ,11) + ''' '  
							if citrus_usr.fn_splitval(@pa_main_filters_values ,7) <> ''   
							set @l_sql5 = @l_sql5 + ' and datediff(yy,clim_dob,getdate()) < 18 '  
							if @pa_grp_by ='BR'  
							set @l_sql = @l_sql + ' and isnull(citrus_usr.[fn_find_relations_nm](DPAM_CRN_NO,''BR''),'''') <> ''''  '   
							if citrus_usr.fn_splitval(@pa_main_filters_values ,12) <> ''   
							set @l_sql5 = @l_sql5 + ' order by ' + case when  @pa_grp_by ='BR'   then ' Groupby , ' else '' end + '[' + (select select_desc from tbl_select_criteria where id = citrus_usr.fn_splitval(@pa_main_filters_values ,12)) + '] '  
		  
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
          select @l_sqlA  = @l_sqlA + isnull(formula,'') + ','  from tbl_select_criteria_special where id in (select id from @l_select_special)  
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
