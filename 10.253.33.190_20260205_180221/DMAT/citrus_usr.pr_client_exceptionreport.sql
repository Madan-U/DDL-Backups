-- Object: PROCEDURE citrus_usr.pr_client_exceptionreport
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--pr_client_exceptionreport	0,'HO|*~|HO|*~|*|~*','21|*~|01_CDSL|*~||*~||*~||*~||*~||*~|N|*~|01/04/2010|*~|27/07/2010|*~|CI|*~|110|*~|012101','110|*~|70|*~|71|*~|72|*~|','','HO','Ldg_Debit_Greater','100',4
--pr_client_exceptionreport	0,'HO|*~|HO|*~|*|~*','|*~||*~||*~||*~||*~||*~||*~|N|*~|01/04/2010|*~|26/07/2010|*~|ACTIVE|*~|70','70|*~|75|*~|','','HO','No_Entr_Ldg','','3'
CREATE proc [citrus_usr].[pr_client_exceptionreport](@pa_id varchar(10)  
,@pa_hiercy varchar(2000)  
,@pa_main_filters_values varchar(8000)  
,@pa_select_values varchar(8000)  
,@pa_filter_values varchar(8000)  
,@pa_grp_by varchar(1000)
,@pa_search_crt	varchar(50)
,@pa_value varchar(10)
,@pa_fin_id numeric)
as  
begin  
--  


  declare @l_sql varchar(8000)  
  ,@l_sql1 varchar(8000)  
  ,@l_sql2 varchar(8000)  
  ,@l_sql3 varchar(8000)  
  ,@l_sql4 varchar(8000)  
  ,@l_sql5 varchar(8000)  
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
					  
							set @l_sql2 = ' from client_mstr clim , dp_acct_mstr dpam 
											left outer join client_dp_brkg clidb on dpam.dpam_id = clidb.clidb_dpam_id and clidb_deleted_ind = 1 and clidb_eff_to_dt > getdate() 
											left outer join client_bank_accts on cliba_clisba_id=clidb.clidb_dpam_id 
											left outer join bank_mstr on cliba_banm_id=banm_id, dp_holder_dtls dphd , 
											entity_relationship entr,brokerage_mstr brom, 
											client_ctgry_mstr clicm ,sub_ctgry_mstr subcm , entity_type_mstr enttm , status_mstr stam '  
							set @l_sql2 = @l_sql2  + ' where clim.clim_crn_no = dpam.dpam_crn_no and dpam.dpam_sba_no = dphd.dphd_dpam_sba_no and entr.entr_sba = dpam.dpam_sba_no and dpam.dpam_enttm_cd = enttm.enttm_cd and dpam.dpam_clicm_cd = clicm.clicm_cd and dpam.dpam_stam_cd = stam.stam_cd and  dpam_subcm_cd = subcm.subcm_cd and clidb.clidb_brom_id = brom.brom_id '  
							set @l_sql2 = @l_sql2  + ' and clim.clim_deleted_ind = 1 and dpam.dpam_deleted_ind = 1 and entr.entr_deleted_ind = 1 and clicm.clicm_deleted_ind = 1 and enttm.enttm_deleted_ind = 1 and dphd.dphd_deleted_ind =1 and stam.stam_deleted_ind = 1 and brom.brom_Deleted_ind = 1 '  
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
--							if citrus_usr.fn_splitval(@pa_main_filters_values ,9) <> ''   
--							set @l_sql5 = @l_sql5 + ' and dpam_created_dt >= ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,9),103) ,109)  + ''' '  
--							if citrus_usr.fn_splitval(@pa_main_filters_values ,10) <> ''  
--							begin  
--							--set @l_sql5 =  @l_sql5 + ' and dpam_lst_upd_dt <= ''' +convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10)+' 23:59:00 ',103) ,109) + ''' '  
--							  set @l_sql5 =  @l_sql5 + ' and dpam_created_dt <= ''' +convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10)+' 23:59:00 ',103) ,109) + ''' '  	
--							end   
							if citrus_usr.fn_splitval(@pa_main_filters_values ,5) <> ''   
							set @l_sql5 = @l_sql5 + ' and brom_id = ' + citrus_usr.fn_splitval(@pa_main_filters_values ,5) + ' '  
--							if citrus_usr.fn_splitval(@pa_main_filters_values ,6) <> ''   
--							set @l_sql5 = @l_sql5 + ' and citrus_usr.fn_ucc_entp(clim_crn_no,''BBO_CODE'','') = ' + citrus_usr.fn_splitval(@pa_main_filters_values ,6) + ' '  
							if citrus_usr.fn_splitval(@pa_main_filters_values ,11) <> ''   
							set @l_sql5 = @l_sql5 + ' and dpam_stam_cd = ''' + citrus_usr.fn_splitval(@pa_main_filters_values ,11) + ''' '  
							if citrus_usr.fn_splitval(@pa_main_filters_values ,7) <> ''   
							set @l_sql5 = @l_sql5 + ' and datediff(yy,clim_dob,getdate()) < 18 ' 
							 
							IF @pa_search_crt = 'Missing_Pan'
							BEGIN

								set @l_sql5 = @l_sql5 + ' AND  isnull(citrus_usr.fn_ucc_entp(clim.clim_crn_no,''PAN_GIR_NO'',''''),'''') = ''''
														  AND  dpam_created_dt >= ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,9),103) ,109)  + '''
														  AND  dpam_created_dt <= ''' +convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10),103) ,109) + ' 23:59:00 '''	

							END

							ELSE IF @pa_search_crt = 'Without_Email'
							BEGIN

								set @l_sql5 = @l_sql5 + ' AND  isnull(citrus_usr.[fn_conc_value](clim.clim_crn_no,''EMAIL1''),'''') = ''''
														  AND  dpam_created_dt >= ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,9),103) ,109)  + '''
														  AND  dpam_created_dt <= ''' +convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10),103) ,109) + ' 23:59:00 '''	

							END

							ELSE IF @pa_search_crt = 'Without_Mobile'
							BEGIN

								set @l_sql5 = @l_sql5 + ' AND  isnull(citrus_usr.[fn_conc_value](clim.clim_crn_no,''MOBILE1''),'''') = ''''
														  AND  dpam_created_dt >= ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,9),103) ,109)  + '''
														  AND  dpam_created_dt <= ''' +convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10),103) ,109) + ' 23:59:00 '''	

							END 

							ELSE IF @pa_search_crt = 'Without_BBO'
							BEGIN

								set @l_sql5 = @l_sql5 + ' AND  isnull(citrus_usr.[fn_ucc_entp](clim.clim_crn_no,''BBO_CODE'',''''),'''') = ''''
														  AND  dpam_created_dt >= ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,9),103) ,109)  + '''
														  AND  dpam_created_dt <= ''' +convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10),103) ,109) + ' 23:59:00 '''	

							END

							ELSE IF @pa_search_crt = 'No_Nominee'
							BEGIN

								set @l_sql5 = @l_sql5 + ' AND  not exists(select DPHD_NOM_FNAME from dp_holder_dtls where dphd_dpam_id = dpam_id and DPHD_NOM_FNAME <> '''' )
														  AND  dpam_created_dt >= ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,9),103) ,109)  + '''
														  AND  dpam_created_dt <= ''' +convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10),103) ,109) + ' 23:59:00 '' '	

							END

							ELSE IF @pa_search_crt = 'Without_POA'
							BEGIN

								set @l_sql5 = @l_sql5 + ' AND  not exists(select DPPD_HLD from dp_poa_dtls where dppd_dpam_id = dpam_id and DPPD_HLD <> '''' )
														  AND  dpam_created_dt >= ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,9),103) ,109)  + '''
														  AND  dpam_created_dt <= ''' +convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10),103) ,109) + ' 23:59:00 '' '	

							END

							ELSE IF @pa_search_crt = 'With_POA'
							BEGIN

								set @l_sql5 = @l_sql5 + ' AND  exists(select DPPD_HLD from dp_poa_dtls where dppd_dpam_id = dpam_id and DPPD_HLD <> '''' )
														  AND  dpam_created_dt >= ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,9),103) ,109)  + '''
														  AND  dpam_created_dt <= ''' +convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10),103) ,109) + ' 23:59:00 '' '	

							END

							ELSE IF @pa_search_crt = 'No_Tariff'
							BEGIN

								set @l_sql5 = @l_sql5 + ' AND  not exists(select clidb_dpam_id from client_dp_brkg where clidb_dpam_id = dpam_id and CLIDB_BROM_ID <> 0 )
														  AND  dpam_created_dt >= ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,9),103) ,109)  + '''
														  AND  dpam_created_dt <= ''' +convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10),103) ,109) + ' 23:59:00 '' '

							END

							ELSE IF @pa_search_crt = 'No_Holding' OR @pa_search_crt = 'No_Hldg_ldg_outstd'
							BEGIN 
								IF @pa_id = 'CDSL'
								BEGIN 
									set @l_sql5 = @l_sql5 + ' AND not exists(select DPHMCD_DPAM_ID from dp_daily_hldg_cdsl 
																			  WHERE DPHMCD_DPAM_ID = dpam_id and DPHMCD_CURR_QTY <> 0
																			  AND  DPHMCD_HOLDING_DT >= ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,9),103) ,109)  + '''
																			  AND  DPHMCD_HOLDING_DT <= ''' + convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10),103) ,109) + ' 23:59:00 '' ) '
								END
								ELSE
								BEGIN
									set @l_sql5 = @l_sql5 + ' AND not exists(select DPDHMD_DPAM_ID from dp_daily_hldg_nsdl
																		  WHERE DPDHMD_DPAM_ID = dpam_id and DPDHMD_QTY <> 0 
																		  AND  DPDHMD_HOLDING_DT >= ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,9),103) ,109)  + '''
																		  AND  DPDHMD_HOLDING_DT <= ''' +convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10),103) ,109) + ' 23:59:00 '' ) '
								END
							END
						
							ELSE IF @pa_search_crt = 'No_Tras_Btw_dt_range'  
							BEGIN 
								IF @pa_id = 'CDSL'
								BEGIN 
									set @l_sql5 = @l_sql5 + ' AND not exists (select CDSHM_BEN_ACCT_NO from cdsl_holding_dtls 
																			  WHERE CDSHM_TRAS_DT >= ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,9),103) ,109)  + '''
																			  AND  CDSHM_TRAS_DT <= ''' +convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10),103) ,109) + ' 23:59:00 '' )' 
								END
								ELSE
								BEGIN
									set @l_sql5 = @l_sql5 + ' AND not exists (select NSDHM_BEN_ACCT_NO from nsdl_holding_dtls 
																			  WHERE NSDHM_TRANSACTION_DT >= ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,9),103) ,109)  + '''
																			  AND  NSDHM_TRANSACTION_DT <= ''' +convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10),103) ,109) + ' 23:59:00 '' )' 
								END
							END

							ELSE IF @pa_search_crt = 'No_Entr_Ldg'
							BEGIN 
								set @l_sql5 = @l_sql5 + ' AND not exists(select ldg_account_id from ledger' +convert(varchar,@pa_fin_id)+ ' 
																		  WHERE ldg_account_id = dpam_id and ldg_amount <> 0
																		  AND  LDG_VOUCHER_DT >= ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,9),103) ,109)  + '''
																		  AND  LDG_VOUCHER_DT <= ''' +convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10),103) ,109) + ' 23:59:00 '' ) '	
							END
	
							ELSE IF @pa_search_crt = 'Ldg_Debit_Greater'
							BEGIN 
								set @l_sql5 = @l_sql5 + ' AND exists (select ldg_account_id from ledger' +convert(varchar,@pa_fin_id)+ '  where ldg_account_id = dpam_id and ldg_amount < 0 and abs(ldg_amount) > '+@pa_value+' 
																										  AND  LDG_VOUCHER_DT >= ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,9),103) ,109)  + '''
																										  AND  LDG_VOUCHER_DT <= ''' +convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10),103) ,109) + ' 23:59:00 '' ) '	
							END
							
							ELSE IF @pa_search_crt = 'Ldg_Credit_Greater'
							BEGIN 
								set @l_sql5 = @l_sql5 + ' AND exists (select ldg_account_id from ledger' +convert(varchar,@pa_fin_id)+ '  where ldg_account_id = dpam_id and ldg_amount > '+@pa_value+'
																										  AND  LDG_VOUCHER_DT >= ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,9),103) ,109)  + '''
																										  AND  LDG_VOUCHER_DT <= ''' +convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10),103) ,109) + ' 23:59:00 '' ) '	
							END
	
							ELSE IF @pa_search_crt = 'No_Hldg_ldg_outstd' 
							BEGIN 
								set @l_sql5 = @l_sql5 + ' AND not exists (select ldg_account_id,sum(ldg_amount) from ledger' +convert(varchar,@pa_fin_id)+ '   
																		  WHERE LDG_VOUCHER_DT >= ''' +  convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,9),103) ,109)  + '''
																		  AND  LDG_VOUCHER_DT <= ''' +convert(varchar(11),convert(datetime,citrus_usr.fn_splitval(@pa_main_filters_values ,10),103) ,109) + ' 23:59:00 ''
																		  group by ldg_account_id
																		  having sum(ldg_amount)> '+@pa_value+'	)'	
							END

								
							if @pa_grp_by ='BR'  
							set @l_sql = @l_sql + ' and isnull(citrus_usr.[fn_find_relations_Acctlvl](DPAM_ID,''BR''),'''') <> ''''  '   
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
