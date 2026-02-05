-- Object: PROCEDURE citrus_usr.pr_entm_migrate
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--pr_daily_migrate  
  
  
--select * from entity_mstr where entm_deleted_ind=1  
  
CREATE               PROCEDURE [citrus_usr].[pr_entm_migrate](@pa_id         varchar(8000)
																															,@pa_tab_name   varchar(50)
																															,@pa_from_dt    varchar(11) 
																															,@pa_to_dt      varchar(11)
																															,@pa_err        VARCHAR(250) OUTPUT
																															)

AS  
BEGIN  
--  
  DECLARE @c_entity_mstr          CURSOR
  DECLARE @c_branch_cd            CURSOR         
  DECLARE @entm_id                NUMERIC         
         ,@entm_name1             VARCHAR(50)  
         ,@entm_name2             VARCHAR(50)  
         ,@entm_name3             VARCHAR(50)  
         ,@entm_short_name        VARCHAR(50)   
         ,@entm_enttm_cd          VARCHAR(20)   
         ,@entm_clicm_cd          VARCHAR(20)  
         ,@entm_parent_id         NUMERIC   
         ,@entm_rmks              VARCHAR(1000)  
         ,@entm_created_by        VARCHAR(25)    
         ,@entm_created_dt        DATETIME  
         ,@entm_lst_upd_by        VARCHAR(25)  
         ,@entm_lst_upd_dt        DATETIME   
         ,@entm_deleted_ind       VARCHAR(2) 
         ,@modified               VARCHAR(2)
         ,@l_adr_1                VARCHAR(50)   
         ,@l_adr_2                VARCHAR(50)   
         ,@l_adr_city             VARCHAR(50)   
         ,@l_adr_state            VARCHAR(50)   
         ,@l_adr_country          VARCHAR(50)   
         ,@l_adr_zip              VARCHAR(50)   
         ,@l_phone1               VARCHAR(50)   
         ,@l_phone2               VARCHAR(50)  
         ,@l_fax                  VARCHAR(25)  
         ,@l_email                VARCHAR(50)  
    
         ,@l_adr_value            VARCHAR(1000)

         ,@l_contact_person       VARCHAR(50)
         ,@l_terminal_id          VARCHAR(25)
         ,@l_prefix               VARCHAR(25)
         ,@l_reg_no               VARCHAR(25)
         ,@l_registered           VARCHAR(25)
         
         ,@t_errorstr             VARCHAR(250)
         ,@l_error                NUMERIC   
         ,@l_parent_branch        VARCHAR(50)     
         ,@l_branch_cd            VARCHAR(10)
 


          SET @c_entity_mstr  = CURSOR FAST_FORWARD FOR   
          SELECT entm_id           
                ,entm_name1        
                ,entm_name2        
                ,entm_name3        
                ,entm_short_name   
                ,entm_enttm_cd     
                ,entm_clicm_cd     
                ,entm_parent_id    
                ,entm_rmks  
                ,entm_created_by    
                ,entm_created_dt    
                ,entm_lst_upd_by    
                ,entm_lst_upd_dt    
                ,entm_deleted_ind   
                ,case when entm.entm_created_dt = entm.entm_lst_upd_dt then 'N' else 'M' end modified
                
          FROM   entity_mstr      entm
          WHERE  entm_deleted_ind = 1  
          AND    entm_lst_upd_dt  BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_from_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_to_dt,103),106)+' 23:59:59' 
          AND    entm_enttm_cd    = case @pa_tab_name when 'AREA' then 'AR' when 'Branch' then 'BR' when 'Branches' then 'DE' when 'Region' then 'RG' when 'Subbrokers' then 'SB' when 'sbu_master' then 'RM'end 
          AND    convert(VARCHAR,entm.entm_id)  LIKE CASE WHEN LTRIM(RTRIM(@PA_ID))   = '' THEN '%' ELSE @PA_ID END  
             
          OPEN @c_entity_mstr   
  
          FETCH NEXT FROM  @c_entity_mstr  
          INTO @entm_id  
              ,@entm_name1  
              ,@entm_name2  
              ,@entm_name3  
              ,@entm_short_name  
              ,@entm_enttm_cd  
              ,@entm_clicm_cd  
              ,@entm_parent_id    
              ,@entm_rmks  
              ,@entm_created_by    
              ,@entm_created_dt    
              ,@entm_lst_upd_by    
              ,@entm_lst_upd_dt    
              ,@entm_deleted_ind   
              ,@modified  
               
               
          WHILE @@FETCH_STATUS = 0  
          BEGIN  
          --
            IF @entm_enttm_cd = 'RM' 
            BEGIN
            --
              SET     @c_branch_cd    = CURSOR FAST_FORWARD FOR   
		SELECT  entm_name1  from entity_mstr where entm_id in (select entm_parent_id from    entity_mstr 
		WHERE    entm_enttm_cd = 'RM' and entm_id = @entm_id)
            --  
            END 
            else IF @entm_enttm_cd = 'RG' 
            BEGIN
            --

              SET     @c_branch_cd    = CURSOR FAST_FORWARD FOR   
														SELECT  entm_name1 from entity_mstr where entm_parent_id in (select entm_id from    entity_mstr 
														where   entm_parent_id in (select entm_id from entity_mstr where entm_enttm_cd = 'RG' and entm_id = @entm_id))
            --  
            END
            ELSE IF @entm_enttm_cd = 'AR' 
            BEGIN
            --
              SET     @c_branch_cd    = CURSOR FAST_FORWARD FOR   
														SELECT  entm_name1   from entity_mstr where entm_parent_id in (select entm_id from    entity_mstr 
														WHERE   entm_enttm_cd = 'AR' and entm_id = @entm_id)
												--
												END
												ELSE IF @entm_enttm_cd = 'SB' 
												BEGIN
												--
												  SET     @c_branch_cd    = CURSOR FAST_FORWARD FOR   
														SELECT  entm_name1  from entity_mstr where entm_id in (select entm_parent_id from    entity_mstr 
														WHERE    entm_enttm_cd = 'SB' and entm_id = @entm_id)
												--
												END
												ELSE IF @entm_enttm_cd = 'DE' 
												BEGIN
												--
												  SET     @c_branch_cd    = CURSOR FAST_FORWARD FOR   
														SELECT  entm_name1  from entity_mstr where entm_id in (select entm_parent_id from entity_mstr where entm_id in (select entm_parent_id from    entity_mstr 
              WHERE    entm_enttm_cd = 'DE' and entm_id = @entm_id))
            --
            END
            ELSE
												BEGIN
												--
														SET     @c_branch_cd    = CURSOR FAST_FORWARD FOR   
              SELECT  entm_name1   from entity_mstr where entm_enttm_cd ='BR' 
												--
            END
            
            
            
            open   @c_branch_cd   
 
            FETCH NEXT FROM  @c_branch_cd
            INTO @l_branch_cd 
            
            WHILE @@FETCH_STATUS = 0  
            BEGIN
            --
              print '1'
														SELECT @l_adr_value = citrus_usr.fn_addr_value(@entm_id,'OFF_ADR1')  

														SELECT @l_adr_1        = citrus_usr.fn_splitval(@l_adr_value,1)
																				,@l_adr_2        = citrus_usr.fn_splitval(@l_adr_value,2)

																				,@l_adr_city     = citrus_usr.fn_splitval(@l_adr_value,4)
																				,@l_adr_state    = citrus_usr.fn_splitval(@l_adr_value,5)
																				,@l_adr_country  = citrus_usr.fn_splitval(@l_adr_value,6)
																				,@l_adr_zip      = citrus_usr.fn_splitval(@l_adr_value,7)

														SELECT @l_phone1  = citrus_usr.fn_conc_value(@entm_id,'OFF_PH1')
														SELECT @l_phone2  = citrus_usr.fn_conc_value(@entm_id,'OFF_PH2') 
														SELECT @l_fax     = citrus_usr.fn_conc_value(@entm_id,'FAX1')
														SELECT @l_email   = citrus_usr.fn_conc_value(@entm_id,'EMAIL1')    

														SELECT @l_contact_person  = citrus_usr.fn_ucc_entp(@entm_id,'contact_person','')
														SELECT @l_terminal_id     = citrus_usr.fn_ucc_entp(@entm_id,'terminal_id','')                         
														SELECT @l_prefix          = citrus_usr.fn_ucc_entp(@entm_id,'prefix','')                         
														SELECT @l_reg_no          = citrus_usr.fn_ucc_entp(@entm_id,'reg_no','')                         
														SELECT @l_registered      = citrus_usr.fn_ucc_entpd(@entm_id,'reg_no','registered','')                         



														/*INSERT INTO  entity_mstr_mig(entm_id              
														,entm_name1           
														,entm_name2           
														,entm_name3           
														,entm_short_name      
														,entm_enttm_cd        
														,entm_clicm_cd        
														,entm_parent_id       
														,entm_rmks            
														,adr_1                
														,adr_2                
														,adr_city             
														,adr_state            
														,adr_country          
														,adr_zip              
														,phone1               
														,phone2               
														,fax                  
														,email                
														,contact_person       
														,terminal_id          
														,prefix          
														,reg_no   
														,registered
														,entm_created_by      
														,entm_created_dt      
														,entm_lst_upd_by      
														,entm_lst_upd_dt      
														,entm_deleted_ind     
														)  
															VALUES(@entm_id  
																					,@entm_name1  
																					,@entm_name2  
																					,@entm_name3  
																					,@entm_short_name  
																					,@entm_enttm_cd  
																					,@entm_clicm_cd  
																					,@entm_parent_id    
																					,@entm_rmks  
																					,@l_adr_1          
																					,@l_adr_2          
																					,@l_adr_city       
																					,@l_adr_state      
																					,@l_adr_country    
																					,@l_adr_zip        
																					,@l_phone1    
																					,@l_phone2    
																					,@l_fax  
																					,@l_email  
																					,@l_contact_person
																					,@l_terminal_id   
																					,@l_prefix
																					,@l_reg_no
																					,@l_registered
																					,@entm_created_by    
																					,@entm_created_dt    
																					,@entm_lst_upd_by    
																					,@entm_lst_upd_dt    
																					,@entm_deleted_ind  
																					)  */
IF @pa_tab_name = 'sbu_master' AND NOT EXISTS(SELECT Sbu_Code FROM  relation_mgr WHERE Sbu_Name= @entm_name1 and migrate_yn=0)
BEGIN
--
if exists(select Sbu_Code from  relation_mgr_hst where migrate_yn in(1,3))
begin
--
set @modified = 'M'
--
end
else
begin
--
set @modified = 'N'
--
end
INSERT INTO relation_mgr(rm_id    
,Sbu_Code 
,Sbu_Name 
,Sbu_Addr1
,Sbu_Addr2
,Sbu_Addr3
,Sbu_City 
,Sbu_State
,Sbu_Zip 
,Sbu_Phone1
,Sbu_Phone2
,Sbu_Type 
,Sbu_Party_Code 
,relm_created_dt  
,relm_lst_upd_dt  
,relm_changed     
,migrate_yn     
)  
VALUES(@entm_id
,@entm_short_name
,@entm_name1
,@l_adr_1          
,@l_adr_2                
,@l_adr_city             
,@l_adr_state            
,@l_adr_country          
,@l_adr_zip              
,@l_phone1               
,@l_phone2               
,'RELMGR'
,''
,@entm_created_dt    
,@entm_lst_upd_dt                         
,@modified
,0)

SET @l_error   = @@ERROR    
--    
IF @l_error > 0    
BEGIN --#1    
--    
SET @t_errorstr = @entm_name1+' could not be migrated'

BREAK
--    
END  --#1           
ELSE
BEGIN
--
SET @t_errorstr = ''
--
END                                          
-- 
END


																else IF @pa_tab_name = 'AREA' AND NOT EXISTS(SELECT areacode FROM area WHERE areacode = @entm_name1 and branch_code = @l_branch_cd and migrate_yn=0)
																BEGIN
																--
if exists(select areacode from  area_hst where migrate_yn in(1,3))
begin
--
  set @modified = 'M'
--
end
else
begin
--
  set @modified = 'N'
--
end

                        
																		INSERT INTO area(ar_id
																																		,areacode
																																		,description
																																		,branch_code
																																		,ar_created_dt
																																		,ar_lst_upd_dt
																																		,ar_changed
																																		,migrate_yn)
																																		VALUES(@entm_id
																																								,@entm_name1
																																								,@entm_name2
																																								,@l_branch_cd
																																								,@entm_created_dt    
																																								,@entm_lst_upd_dt                         
																																								,@modified
																																								,0)

																		SET @l_error   = @@ERROR    
																		--    
																		IF @l_error > 0    
																		BEGIN --#1    
																		--    
																				SET @t_errorstr = @entm_name1+' could not be migrated'

																				BREAK
																		--    
																		END  --#1           
																		ELSE
																		BEGIN
																		--
																				SET @t_errorstr = ''
																		--
																		END                                      
																--
																END                                
																ELSE IF @pa_tab_name = 'BRANCH' AND NOT EXISTS(SELECT branch_code FROM branch WHERE branch_code = @entm_name1 and migrate_yn=0)
																BEGIN
																--
if exists(select branch_code from  branch_hst where migrate_yn in(1,3))
begin
--
  set @modified = 'M'
--
end
else
begin
--
  set @modified = 'N'
--
end
																		INSERT INTO branch(br_id    
																																				,branch_code         --ent_name1       
																																				,branch              --short_name       
																																				,long_name           --ent_name2        
																																				,address1            --adr_1  
																																				,address2            --adr_2  
																																				,city                --adr_city  
																																				,state               --adr_state  
																																				,nation              --adr_country  
																																				,zip                 --adr_zip  
																																				,phone1              --conc_value  
																																				,phone2              --conc_value  
																																				,fax                 --conc_value  
																																				,email               --conc_value  
																																				,contact_person      --entp_value  
																																				,prefix              --enttm_prefix  
																																				,br_created_dt       
																																				,br_lst_upd_dt  
																																				,br_changed
																																				,migrate_yn     
																																				)
																																			VALUES(@entm_id
																																									,@entm_name1
																																									,@entm_short_name
																																									,@entm_name2              
																																									,@l_adr_1          
																																									,@l_adr_2                
																																									,@l_adr_city             
																																									,@l_adr_state            
																																									,@l_adr_country          
																																									,@l_adr_zip              
																																									,@l_phone1               
																																									,@l_phone2               
																																									,@l_fax                  
																																									,@l_email                
																																									,@l_contact_person       
																																									,@l_prefix
																																									,@entm_created_dt    
																																									,@entm_lst_upd_dt                         
																																									,@modified
																																									,0)

																		SET @l_error   = @@ERROR    
																		--    
																		IF @l_error > 0    
																		BEGIN --#1    
																		--    
																				SET @t_errorstr = @entm_name1+' could not be migrated'

																				BREAK
																		--    
																		END  --#1           
																		ELSE
																		BEGIN
																		--
																				SET @t_errorstr = ''
																		--
																		END                                          
																-- 
																END
																ELSE IF @pa_tab_name = 'BRANCHES' AND NOT EXISTS(SELECT short_name FROM branches WHERE short_name = @entm_short_name and migrate_yn=0)
																BEGIN
																--
if exists(select short_name  from  branches_hst where migrate_yn in(1,3))
begin
--
  set @modified = 'M'
--
end
else
begin
--
  set @modified = 'N'
--
end

																	SELECT @l_parent_branch = entm_short_name from entity_mstr where entm_id in (select entm_parent_id from entity_mstr where entm_id = @entm_id)

																	INSERT INTO branches (dl_id
																																						,branch_cd
																																						,short_name          --ent_name1,short_name  
																																						,long_name           --ent_name2  
																																						,address1            --adr_1  
																																						,address2            --adr_2  
																																						,city                --adr_city  
																																						,state               --adr_state  
																																						,nation              --adr_country  
																																						,zip                 --adr_zip  
																																						,phone1              --conc_value  
																																						,phone2              --conc_value  
																																						,fax                 --conc_value  
																																						,email               --conc_value  
																																						,contact_person      --entp_value  
																																						,terminal_id         --entp_value  
																																						,dl_created_dt        
																																						,dl_lst_upd_dt
																																						,dl_changed
																																						,migrate_yn      
																																						)
																																						VALUES(@entm_id
																																												,@l_branch_cd--@l_parent_branch
																																												,@entm_name1
																																												,@entm_name2              
																																												,@l_adr_1                
																																												,@l_adr_2                
																																												,@l_adr_city             
																																												,@l_adr_state            
																																												,@l_adr_country          
																																												,@l_adr_zip              
																																												,@l_phone1               
																																												,@l_phone2               
																																												,@l_fax                  
																																												,@l_email                
																																												,@l_contact_person
																																												,@l_terminal_id          
																																												,@entm_created_dt    
																																												,@entm_lst_upd_dt                         
																																												,@modified
																																												,0)

																		SET @l_error   = @@ERROR    
																		--    
																		IF @l_error > 0    
																		BEGIN --#1    
																		--    
																				SET @t_errorstr = @entm_short_name+' could not be migrated'

																				BREAK
																		--    
																		END  --#1           
																		ELSE
																		BEGIN
																		--
																				SET @t_errorstr = ''
																		--
																		END                                

																END
																ELSE IF @pa_tab_name = 'REGION'  AND NOT EXISTS(SELECT regioncode FROM region WHERE regioncode = @entm_name1 and branch_code = @l_branch_cd and migrate_yn=0)
																BEGIN
																--
if exists(select regioncode  from  region_hst where migrate_yn in(1,3))
begin
--
  set @modified = 'M'
--
end
else
begin
--
  set @modified = 'N'
--
end

																	INSERT INTO region(re_id
																																			,regioncode   --entm_name1  
																																			,description  --entm_name2    
																																			,branch_code
																																			,re_created_dt
																																			,re_lst_upd_dt
																																			,re_changed
																																			,migrate_yn)
																																			VALUES(@entm_id
																																									,convert(varchar(20),@entm_name1)
																																									,@entm_name2
																																									,@l_branch_cd
																																									,@entm_created_dt    
																																									,@entm_lst_upd_dt                         
																																									,@modified
																																									,0)

																		SET @l_error   = @@ERROR    
																		--    
																		IF @l_error > 0    
																		BEGIN --#1    
																		--    
																				SET @t_errorstr = @entm_name1+' could not be migrated'

																				BREAK
																		--    
																		END  --#1           
																		ELSE
																		BEGIN
																		--
																				SET @t_errorstr = ''
																		--
																		END                                           


																END
																ELSE IF @pa_tab_name = 'SUBBROKERS' AND  NOT EXISTS(SELECT sub_broker FROM subbrokers WHERE sub_broker = @entm_name1 and migrate_yn=0)
																BEGIN
																--   
if exists(select sub_broker from  subbrokers_hst where migrate_yn in(1,3))
begin
--
  set @modified = 'M'
--
end
else
begin
--
  set @modified = 'N'
--
end          
																	INSERT INTO subbrokers(sb_id 
																																							,sub_broker
																																							,name  
																																							,address1
																																							,address2 
																																							,city     
																																							,state    
																																							,nation   
																																							,zip      
																																							,fax      
																																							,phone1   
																																							,phone2   
																																							,reg_no    
																																							,registered 
																																							,email
																																							,contact_person  
																																							,branch_code
																																							,sb_created_dt
																																							,sb_lst_upd_dt
																																							,sb_changed
																																							,migrate_yn)
																																							VALUES(@entm_id 
																																													,convert(varchar(10),@entm_name1)
																																													,@entm_name2
																																													,@l_adr_1
																																													,@l_adr_2
																																													,@l_adr_city
																																													,@l_adr_state
																																													,@l_adr_country
																																													,@l_adr_zip
																																													,@l_fax
																																													,@l_phone1
																																													,@l_phone2
																																													,@l_reg_no
																																													,@l_registered
																																													,@l_email
																																													,@l_contact_person
																																													,@l_branch_cd
																																													,@entm_created_dt    
																																													,@entm_lst_upd_dt                         
																																													,@modified
																																													,0)
																		SET @l_error   = @@ERROR    
																		--    
																		IF @l_error > 0    
																		BEGIN --#1    
																		--    
																				SET @t_errorstr = @entm_name1+' could not be migrated'

																				BREAK
																		--    
																		END  --#1           
																		ELSE
																		BEGIN
																		--
																				SET @t_errorstr = ''
																		--
																		END                                                   


														END
              
              FETCH NEXT FROM  @c_branch_cd
              INTO @l_branch_cd 
            --
            END
            
            CLOSE @c_branch_cd  
            DEALLOCATE @c_branch_cd  

														FETCH NEXT FROM  @c_entity_mstr  
														INTO  @entm_id  
																			,@entm_name1  
																			,@entm_name2  
																			,@entm_name3  
																			,@entm_short_name  
																			,@entm_enttm_cd  
																			,@entm_clicm_cd  
																			,@entm_parent_id    
																			,@entm_rmks  
																			,@entm_created_by    
																			,@entm_created_dt    
																			,@entm_lst_upd_by    
																			,@entm_lst_upd_dt    
																			,@entm_deleted_ind 
																			,@modified

								--  
								END  
          
        CLOSE @c_entity_mstr  
        DEALLOCATE @c_entity_mstr    
         
        SET @pa_err = @t_errorstr
          
          
--  
END  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  





set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON

GO
