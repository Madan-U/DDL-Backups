-- Object: PROCEDURE citrus_usr.pr_select_client_details_27022015_bak
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

create PROCEDURE [citrus_usr].[pr_select_client_details_27022015_bak] (@pa_id          NUMERIC  = 0                      
                                         ,@pa_clicm_id    NUMERIC  = 0                      
                                         ,@pa_enttm_id    NUMERIC  = 0                      
                                         ,@pa_crn_no      NUMERIC  = 0                      
                                         ,@pa_acct_no     VARCHAR(20)                      
                                         ,@pa_tab         VARCHAR(20)                      
                                         ,@pa_value       VARCHAR(8000)                      
                                         ,@pa_chk_yn      NUMERIC                   
                                         ,@pa_roles       VARCHAR(8000)                  
                                         ,@pa_scr_id      NUMERIC                     
                                         ,@rowdelimiter   VARCHAR(4)  = '*|~*'                      
                                         ,@coldelimiter   VARCHAR(4)  = '|*~|'                      
                                         ,@pa_ref_cur     VARCHAR(8000) OUTPUT)                      
AS                      
/*                      
*********************************************************************************                      
 SYSTEM         : CITRUS                      
 MODULE NAME    : pr_select_client_details                      
 DESCRIPTION    : This procedure will select data related to client                      
 COPYRIGHT(C)   : Marketplacetechnologies pvt ltd                      
 VERSION HISTORY:                      
 VERS.  AUTHOR             DATE        REASON                      
 -----  -------------      ----------  -----------------------------------------------                      
 1.0    TUSHAR             04-MAY-2007 INITIAL VERSION.                      
--------------------------------------------------------------------------------------*/                      
BEGIN                      
--                      
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                                                                        
  --                      
  DECLARE @L_EXISTS INT                    
  DECLARE @I        INT                    
  IF @pa_chk_yn = 0 OR @pa_chk_yn = 2                      
  BEGIN--@pa_chk_yn = 0 OR @pa_chk_yn = 2                      
  --                      
    DECLARE @values1            VARCHAR(8000)                      
          , @values2            VARCHAR(8000)                      
          , @@c_access_cursor   CURSOR                      
                                                   --**PR_INS_SELECT_CLID**                      
    IF @pa_tab = 'CLID'                      
    BEGIN--CLID                      
    --                      
                             
       /*SELECT DISTINCT excsm.excsm_exch_cd          excsm_exch_cd                        
            , excsm.excsm_seg_cd                    excsm_seg_cd                        
            , prom.prom_id                          prom_id                        
            , ISNULL(prom.prom_desc,'')             prom_desc                      
            , ISNULL(clid.clid_doc_path,'')         clid_doc_path                        
            , ISNULL(clid.clid_remarks,'')          clid_remarks                          
            , docm.docm_doc_id                      docm_doc_id                        
            , ISNULL(docm.docm_desc,'')             docm_desc                        
            , docm.docm_clicm_id                    docm_clicm_id                        
            , CASE docm.docm_mdty WHEN 1 THEN 'M' ELSE 'N' END docm_mdty                        
            , CASE excsm_exch_cd  WHEN 'BSE'THEN CONVERT(VARCHAR,1) WHEN 'NSE'THEN CONVERT(VARCHAR,2) ELSE CONVERT(VARCHAR,3) END  ORD1                      
            , ISNULL(clid.clid_valid_yn,0)          clid_valid_yn                      
        FROM  document_mstr         docm     WITH(NOLOCK)                        
            , exch_seg_mstr         excsm    WITH(NOLOCK)                        
            , excsm_prod_mstr    excpm    WITH(NOLOCK)                        
            , product_mstr          prom     WITH(NOLOCK)            
            , client_documents      clid     WITH(NOLOCK)                     
        WHERE docm.docm_doc_id          *= clid.clid_docm_doc_id                        
        AND   docm.docm_excpm_id                   = excpm.excpm_id                     
        AND   prom.prom_id                         = excpm.excpm_prom_id                        
        AND   excpm.excpm_excsm_id                 = excsm.excsm_id                        
        AND   excpm.excpm_deleted_ind              = 1                        
        AND   ISNULL(clid_deleted_ind, 1)          = 1                      
        AND   prom.prom_deleted_ind                = 1                        
        AND   excsm.excsm_deleted_ind              = 1                        
        AND   docm.docm_deleted_ind                = 1                        
        AND   docm.docm_clicm_id                   = @pa_clicm_id                      
        AND   docm.docm_enttm_id                   = @pa_enttm_id                      
        AND   ISNULL(clid.clid_crn_no, @pa_crn_no) = @pa_crn_no                      
        ORDER BY  ORD1                      
                , excsm_exch_cd                      
                , prom_id  */                    
        SELECT DISTINCT excsm.excsm_exch_cd          excsm_exch_cd                        
            , excsm.excsm_seg_cd                    excsm_seg_cd                        
            , prom.prom_id                          prom_id                        
            , ISNULL(prom.prom_desc,'')             prom_desc                      
            , ISNULL(clid.clid_doc_path,'')         clid_doc_path                        
            , ISNULL(clid.clid_remarks,'')          clid_remarks                          
            , docm.docm_doc_id                      docm_doc_id                        
            , ISNULL(docm.docm_desc,'')             docm_desc                        
            , docm.docm_clicm_id                    docm_clicm_id                        
            , CASE docm.docm_mdty WHEN 1 THEN 'M' ELSE 'N' END docm_mdty                        
            , CASE excsm_exch_cd  WHEN 'BSE'THEN CONVERT(VARCHAR,1) WHEN 'NSE'THEN CONVERT(VARCHAR,2) ELSE CONVERT(VARCHAR,3) END  ORD1                      
            , ISNULL(clid.clid_valid_yn,0)          clid_valid_yn                      
        FROM  document_mstr         docm     WITH(NOLOCK)                    
              left outer join                     
              client_documents      clid     WITH(NOLOCK) on docm.docm_doc_id = clid.clid_docm_doc_id   and   ISNULL(clid.clid_crn_no, @pa_crn_no) = @pa_crn_no                       
              right outer join                     
              client_sub_accts      clisba   WITH(NOLOCK) on clisba.clisba_excpm_id = docm.docm_excpm_id   and     ISNULL(clisba.clisba_crn_no, @pa_crn_no) = @pa_crn_no                       
            , exch_seg_mstr         excsm    WITH(NOLOCK)                        
            , excsm_prod_mstr       excpm    WITH(NOLOCK)                        
            , product_mstr          prom     WITH(NOLOCK)                        
            , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
        WHERE docm.docm_excpm_id                   = excpm.excpm_id                        
        AND   prom.prom_id                         = excpm.excpm_prom_id                        
        AND   excpm.excpm_excsm_id                 = excsm.excsm_id                        
        AND   excsm.excsm_id                       = excsm_list.excsm_id                   
        AND   excpm.excpm_deleted_ind = 1                        
        AND   ISNULL(clid_deleted_ind, 1)          = 1                      
        AND   ISNULL(clisba_deleted_ind, 1)        = 1                      
        AND   prom.prom_deleted_ind                = 1                        
        AND   excsm.excsm_deleted_ind              = 1                        
        AND   docm.docm_deleted_ind                = 1                        
  AND   docm.docm_clicm_id                   = @pa_clicm_id                      
        AND   docm.docm_enttm_id                   = @pa_enttm_id                      
                            
        ORDER BY  ORD1                      
                , excsm_exch_cd                      
                , prom_id                             
    --                                
    END--CLID                      
    --                      
    ELSE IF @pa_tab = 'ENTD'                      
    BEGIN--ENTD                      
    --                      
      SELECT DISTINCT docm.docm_doc_id               docm_doc_id                      
           , docm.docm_desc                          docm_desc                      
           , clid.clid_doc_path                      clid_doc_path                      
           , clid.clid_remarks                       clid_remarks                      
           , CASE  docm.docm_mdty WHEN 1 THEN 'M' ELSE 'N' END  docm_mdty                      
           , ISNULL(clid.clid_valid_yn,0)            clid_valid_yn                      
      FROM   client_documents               clid  WITH (NOLOCK)                      
           right outer join document_mstr                  docm  WITH (NOLOCK)                      
      on  docm.docm_doc_id       = clid.clid_docm_doc_id                      
      where    ISNULL(clid.clid_deleted_ind, 1)      = 1                      
      AND    docm.docm_deleted_ind                 = 1                      
      AND    ISNULL(clid.clid_crn_no, @pa_crn_no)  = @pa_crn_no                      
      AND    docm.docm_clicm_id                    = @pa_clicm_id                      
      AND    docm.docm_enttm_id                    = @pa_enttm_id                      
      ORDER BY docm.docm_desc                      
    --                      
    END--ENTD                      
    --                      
                                                   --**PR_SELECT_CLIM**                      
    --                      
    ELSE IF @pa_tab = 'CLIM'                      
    BEGIN--CLIM                      
    --                      
      SELECT clim.clim_name1                    clim_name1                      
           , ISNULL(clim.clim_name2, '')        clim_name2                      
           , ISNULL(clim.clim_name3, '')        clim_name3                      
 , clim.clim_short_name               clim_short_name                      
           , clim.clim_gender                   clim_gender                      
           , case when convert(varchar,ISNULL(clim.clim_dob,''),103) = '01/01/1900' then '' else CONVERT(VARCHAR,ISNULL(clim.clim_dob,''),103)  end clim_dob                      
           , enttm.enttm_cd                     enttm_cd                      
           , enttm.enttm_desc                   enttm_desc                      
           , clim.clim_stam_cd                  clim_stam_cd                      
           , clicm.clicm_cd                     clicm_cd                      
           , clicm.clicm_desc                   clicm_desc                       
           , isnull(clim.clim_rmks,'')          clim_rmks                      
           , isnull(clim.clim_sbum_id,0)        clim_sbum_id                      
           , isnull(sbum.sbum_desc,'')          sbum_desc                      
      FROM   client_mstr                        clim   WITH (NOLOCK)                      
             left outer join                       
             dp_acct_mstr                       dpam   WITH (NOLOCK)                       
             on clim.clim_crn_no = dpam.dpam_crn_no                        
           , entity_type_mstr                   enttm  WITH (NOLOCK)                      
           , client_ctgry_mstr                  clicm  WITH (NOLOCK)                      
           , sbu_mstr                           sbum   WITH (NOLOCK)                      
      WHERE  enttm_cd                         = isnull(clim.clim_enttm_cd,'CLIENT')                      
      AND    clicm.clicm_cd                   = isnull(clim.clim_clicm_cd,'NOR')                      
      AND    clim.clim_sbum_id                = sbum.sbum_id                      
      AND    clim.clim_crn_no                 = @pa_crn_no                      
      AND    clim.clim_deleted_ind            = 1                      
      AND    enttm.enttm_deleted_ind          = 1                      
      AND    clicm.clicm_deleted_ind          = 1                      
                            
      /*UNION                      
                            
      SELECT clim.clim_name1                    clim_name1                      
           , ISNULL(clim.clim_name2, '')        clim_name2                      
           , ISNULL(clim.clim_name3, '')        clim_name3                      
           , clim.clim_short_name               clim_short_name                      
           , clim.clim_gender                   clim_gender                      
           , CONVERT(VARCHAR,clim.clim_dob,103) clim_dob                      
           , enttm.enttm_cd                     enttm_cd                      
           , enttm.enttm_desc                   enttm_desc                      
           , clim.clim_stam_cd                  clim_stam_cd                      
           , clicm.clicm_cd                     clicm_cd                     
           , clicm.clicm_desc                   clicm_desc                       
           , isnull(clim.clim_rmks,'')          clim_rmks                      
           , isnull(clim.clim_sbum_id,0)        clim_sbum_id                      
           , isnull(sbum.sbum_desc,'')          sbum_desc                      
      FROM   client_mstr                        clim   WITH (NOLOCK)                      
          , dp_Acct_mstr                       dpam   WITH (NOLOCK)                            
           , entity_type_mstr                   enttm  WITH (NOLOCK)                      
           , client_ctgry_mstr                  clicm  WITH (NOLOCK)                      
           , sbu_mstr                           sbum   WITH (NOLOCK)                      
      WHERE  dpam.dpam_enttm_cd               = enttm.enttm_cd                      
      and    dpam.dpam_crn_no                 = clim.clim_crn_no                      
      AND    dpam.dpam_clicm_cd               = clicm.clicm_cd                      
      AND    clim.clim_sbum_id                = sbum.sbum_id                      
      AND    clim.clim_crn_no                 = @pa_crn_no                      
      AND    clim.clim_deleted_ind            = 1                      
      AND    enttm.enttm_deleted_ind         = 1                      
      AND    clicm.clicm_deleted_ind          = 1                      
      AND    clim.clim_sbum_id                <> 0  */                    
                      
    --                      
    END--CLIM                      
                      
    ELSE IF @pa_tab = 'ENTR'                      
    BEGIN--ENTR                      
    --                      
      SELECT TOP 7 id_num = identity(INT, 1, 1)                      
      INTO   #ROWNUM                      
      FROM   SYSOBJECTS                      
      --                      
      SELECT ISNULL(a.entr_id, 0)                   entr_id                      
           , ISNULL(enttm.enttm_cd, ' ')            entr_cd                      
           , ISNULL(enttm.enttm_desc, ' ')          enttm_desc                      
           , ISNULL(entm.entm_short_name, ' ')      entm_short_name         
           , ISNULL(entm.entm_parent_id, 0) parent_id                      
           , ISNULL(enttm.enttm_parent_cd, ' ')     enttm_parent_cd                      
      FROM   entity_type_mstr  enttm                WITH (NOLOCK)                      
           ,(SELECT  (CASE WHEN R =  1   THEN entr.entr_ho                      
                      ELSE CASE WHEN R=2 THEN entr.entr_rg                      
 ELSE CASE WHEN R=3 THEN entr.entr_ar                      
                      ELSE CASE WHEN R=4 THEN entr.entr_br                      
                      ELSE CASE WHEN R=5 THEN entr.entr_sub                      
                      ELSE CASE WHEN R=6 THEN entr.entr_dl                      
                      ELSE CASE WHEN R=7 THEN entr.entr_rm                      
                      ELSE ENTR.ENTR_RM END END END END END END END )  entr_id                      
                     ,( CASE WHEN R =  1 THEN 'HO'                      
                        ELSE CASE WHEN R=2 THEN 'RE'                      
                        ELSE CASE WHEN R=3 THEN 'AR'                      
                        ELSE CASE WHEN R=4 THEN 'BR'                      
                        ELSE CASE WHEN R=5 THEN 'SB'                      
                        ELSE CASE WHEN R=6 THEN 'DL'                      
                   ELSE CASE WHEN R=7 THEN 'RM'                      
                        END END END END END END END)                    entr_cd                      
                     ,entr.entr_crn_no                                  client_id                      
               FROM   entity_relationship   entr  WITH (NOLOCK)                      
                     ,(SELECT id_num r  FROM #ROWNUM WHERE id_num <= 7) #aa                      
                       WHERE  entr.entr_crn_no = @pa_crn_no) a                      
                       RIGHT OUTER JOIN                      
                       entity_mstr entm WITH (NOLOCK)                      
               ON    entm.entm_id=a.entr_id                      
               WHERE a.entr_cd                  = enttm.enttm_cd                      
               AND   1 & enttm.enttm_cli_yn     > 0                      
               AND   enttm.enttm_deleted_ind    = 1                      
               ORDER BY CASE WHEN enttm.enttm_cd = 'HO' THEN 1                      
               ELSE  CASE WHEN  enttm.enttm_cd = 'RE' THEN  2                      
               ELSE  CASE WHEN  enttm.enttm_cd = 'AR' THEN  3                      
               ELSE  CASE WHEN  enttm.enttm_cd = 'BR' THEN  4                      
               ELSE  CASE WHEN  enttm.enttm_cd = 'SB' THEN  5                      
               ELSE  CASE WHEN  enttm.enttm_cd = 'DL' THEN  6                      
               ELSE  CASE WHEN  enttm.enttm_cd = 'RM' THEN  7                      
               END END END END END END END                    
    --                      
    END--ENTR                      
    --                      
    ELSE IF @PA_TAB = 'ADDR'                      
    BEGIN--ADDR                      
    --                      
      SELECT TOP 1 @I =  bitrm_bit_location FROM bitmap_ref_mstr WHERE bitrm_parent_cd = 'BUS_' + @pa_value  AND bitrm_deleted_ind = 1                    

			if exists (select 1 from client_mstr where clim_crn_no =   @pa_crn_no  and clim_deleted_ind = 1 )                      
			begin 
				  SELECT  concm.concm_cd                   concm_cd                      
						, concm.concm_desc                 concm_desc                      
						, ISNULL(a.adr_1,'')               adr_1                          
						, ISNULL(a.value, ' ')             value                      
				   FROM  (SELECT entac.entac_concm_id      concm_id                      
							   , adr.adr_1                 adr_1                      
							   , adr.adr_city              adr_city                      
							   , adr.adr_state             adr_state                      
							   , adr.adr_country   adr_country                      
							   , adr.adr_zip               adr_zip                      
							   , entac.entac_concm_cd+'|*~|'+adr.adr_1+'|*~|'+isnull(adr.adr_2,'')+'|*~|'+isnull(adr.adr_3,'')+'|*~|'+isnull(adr.adr_city,'')+'|*~|'+isnull(adr.adr_state,'')+'|*~|'+isnull(adr.adr_country,'')+'|*~|'+isnull(adr.adr_zip,'') value       

						  FROM   addresses                 adr    WITH (NOLOCK)                      
				   , entity_adr_conc           entac  WITH (NOLOCK)                      
						  WHERE  entac.entac_adr_conc_id = adr.adr_id                      
						  AND    entac.entac_ent_id      = @pa_crn_no                      
						  AND    adr.adr_deleted_ind     = 1                      
						  AND    entac.entac_deleted_ind = 1                      
						 ) a                      
						  RIGHT OUTER JOIN                      
						  conc_code_mstr                   concm  WITH (NOLOCK)                      
						  ON concm.concm_id              = a.concm_id                      
				   WHERE  concm.concm_deleted_ind        = 1                      
				   AND    1 & concm.concm_cli_yn         = 1                      
				   AND    2 & concm.concm_cli_yn         = 0                      
				   AND    power(2,@I-1) & concm.concm_cli_yn  > 0                     
				   ORDER  BY concm.concm_desc  

			end    
			else if exists (select 1 from entity_mstr where entm_id =   @pa_crn_no  and entm_deleted_ind = 1 )                      
			begin 
				  SELECT  concm.concm_cd                   concm_cd                      
						, concm.concm_desc                 concm_desc                      
						, case when concm.concm_cd ='OFF_ADR1' then isnull(citrus_usr.fn_get_br_add_fromview(@pa_crn_no ,'1','adr'),'') else ISNULL(a.adr_1,'') end                adr_1                          
						, case when concm.concm_cd ='OFF_ADR1' then isnull(citrus_usr.fn_get_br_add_fromview(@pa_crn_no ,'2','adr'),'') else isnull(a.value,'')  end             value                      
				   FROM  (SELECT entac.entac_concm_id      concm_id                      
							   , adr.adr_1                 adr_1                      
							   , adr.adr_city              adr_city                      
							   , adr.adr_state             adr_state                      
							   , adr.adr_country   adr_country                      
							   , adr.adr_zip               adr_zip                      
							   , entac.entac_concm_cd+'|*~|'+adr.adr_1+'|*~|'+isnull(adr.adr_2,'')+'|*~|'+isnull(adr.adr_3,'')+'|*~|'+isnull(adr.adr_city,'')+'|*~|'+isnull(adr.adr_state,'')+'|*~|'+isnull(adr.adr_country,'')+'|*~|'+isnull(adr.adr_zip,'') value       

						  FROM   addresses                 adr    WITH (NOLOCK)                      
				   , entity_adr_conc           entac  WITH (NOLOCK)                      
						  WHERE  entac.entac_adr_conc_id = adr.adr_id                      
						  AND    entac.entac_ent_id      = @pa_crn_no                      
						  AND    adr.adr_deleted_ind     = 1                      
						  AND    entac.entac_deleted_ind = 1                      
						 ) a                      
						  RIGHT OUTER JOIN                      
						  conc_code_mstr                   concm  WITH (NOLOCK)                      
						  ON concm.concm_id              = a.concm_id                      
				   WHERE  concm.concm_deleted_ind        = 1                      
				   AND    1 & concm.concm_cli_yn         = 1                      
				   AND    2 & concm.concm_cli_yn         = 0                      
				   AND    power(2,@I-1) & concm.concm_cli_yn  > 0                     
				   ORDER  BY concm.concm_desc  

			end   
			else 
			begin 
			SELECT  concm.concm_cd                   concm_cd                      
									, concm.concm_desc                 concm_desc                      
									, ISNULL(a.adr_1,'')               adr_1                          
									, ISNULL(a.value, ' ')             value                      
							   FROM  (SELECT entac.entac_concm_id      concm_id                      
										   , adr.adr_1                 adr_1                      
										   , adr.adr_city              adr_city                      
										   , adr.adr_state             adr_state                      
										   , adr.adr_country   adr_country                      
										   , adr.adr_zip               adr_zip                      
										   , entac.entac_concm_cd+'|*~|'+adr.adr_1+'|*~|'+isnull(adr.adr_2,'')+'|*~|'+isnull(adr.adr_3,'')+'|*~|'+isnull(adr.adr_city,'')+'|*~|'+isnull(adr.adr_state,'')+'|*~|'+isnull(adr.adr_country,'')+'|*~|'+isnull(adr.adr_zip,'') value       

									  FROM   addresses                 adr    WITH (NOLOCK)                      
							   , entity_adr_conc           entac  WITH (NOLOCK)                      
									  WHERE  entac.entac_adr_conc_id = adr.adr_id                      
									  AND    entac.entac_ent_id      = @pa_crn_no                      
									  AND    adr.adr_deleted_ind     = 1                      
									  AND    entac.entac_deleted_ind = 1                      
									 ) a                      
									  RIGHT OUTER JOIN                      
									  conc_code_mstr                   concm  WITH (NOLOCK)                      
									  ON concm.concm_id              = a.concm_id                      
							   WHERE  concm.concm_deleted_ind        = 1                      
							   AND    1 & concm.concm_cli_yn         = 1                      
							   AND    2 & concm.concm_cli_yn         = 0                      
							   AND    power(2,@I-1) & concm.concm_cli_yn  > 0                     
							   ORDER  BY concm.concm_desc  
			end                    
    --                      
    END--ADDR                      
    --                      
    ELSE IF @pa_tab = 'CONC'                      
    BEGIN--CONC                      
    --                    
                          
  SELECT TOP 1 @I = bitrm_bit_location FROM bitmap_ref_mstr WHERE bitrm_parent_cd = 'BUS_' + @pa_value  AND bitrm_deleted_ind = 1                    
                 
			if exists(select 1 from client_mstr where clim_crn_no =  @pa_crn_no)
			begin          
				  SELECT concm.concm_cd                   concm_cd                      
					   , concm.concm_desc                 concm_desc                      
					   , isnull(a.conc_value, ' ')        value                
					   , convert(int,concm.concm_rmks)                  
				  FROM  (SELECT entac.entac_concm_id      concm_id                      
							  , conc.conc_value           conc_value                      
						 FROM   contact_channels          conc  WITH (NOLOCK)                      
							  , entity_adr_conc           entac WITH (NOLOCK)                      
						 WHERE  entac.entac_adr_conc_id = conc.conc_id                      
						 AND    entac.entac_ent_id      = @pa_crn_no                      
						 AND    conc.conc_deleted_ind   = 1                      
						 AND    entac.entac_deleted_ind = 1                      
						) a                      
						 RIGHT OUTER JOIN                      
						 conc_code_mstr                     concm  WITH (NOLOCK)                      
						 ON concm.concm_id=a.concm_id                      
				  WHERE  concm.concm_deleted_ind        = 1                      
				  AND    1 & concm.concm_cli_yn         = 1                      
				  AND    2 & CONCM.CONCM_CLI_YN         = 2                      
				  AND    power(2,@I-1) & concm.concm_cli_yn  > 0                     
				  ORDER  BY case when isnumeric(concm.concm_rmks)= 1 then  convert(int ,concm.concm_rmks) else 0 end , CONCM.CONCM_DESC                    
			end 
			else if  exists(select 1 from entity_mstr where entm_id =  @pa_crn_no)
			begin 
				SELECT concm.concm_cd                   concm_cd                      
					   , concm.concm_desc                 concm_desc                      
					   , case when concm.concm_cd ='email2' then citrus_usr.fn_get_br_add_fromview(@pa_crn_no,'1','conc') 
								when concm.concm_cd ='fax1' then citrus_usr.fn_get_br_add_fromview(@pa_crn_no,'1','1200') else isnull(a.conc_value, ' ') end        value                
					   , convert(int,concm.concm_rmks)                  
				  FROM  (SELECT entac.entac_concm_id      concm_id                      
							  , conc.conc_value           conc_value                      
						 FROM   contact_channels          conc  WITH (NOLOCK)                      
							  , entity_adr_conc           entac WITH (NOLOCK)                      
						 WHERE  entac.entac_adr_conc_id = conc.conc_id                      
						 AND    entac.entac_ent_id      = @pa_crn_no                      
						 AND    conc.conc_deleted_ind   = 1                      
						 AND    entac.entac_deleted_ind = 1                      
						) a                      
						 RIGHT OUTER JOIN                      
						 conc_code_mstr                     concm  WITH (NOLOCK)                      
						 ON concm.concm_id=a.concm_id                      
				  WHERE  concm.concm_deleted_ind        = 1                      
				  AND    1 & concm.concm_cli_yn         = 1                      
				  AND    2 & CONCM.CONCM_CLI_YN         = 2                      
				  AND    power(2,@I-1) & concm.concm_cli_yn  > 0                     
				  ORDER  BY case when isnumeric(concm.concm_rmks)= 1 then  convert(int ,concm.concm_rmks) else 0 end , CONCM.CONCM_DESC                    	
			end 
			else 
			begin 

				SELECT concm.concm_cd                   concm_cd                      
					   , concm.concm_desc                 concm_desc                      
					   , isnull(a.conc_value, ' ')        value                
					   , convert(int,concm.concm_rmks)                  
				  FROM  (SELECT entac.entac_concm_id      concm_id                      
							  , conc.conc_value           conc_value                      
						 FROM   contact_channels          conc  WITH (NOLOCK)                      
							  , entity_adr_conc           entac WITH (NOLOCK)                      
						 WHERE  entac.entac_adr_conc_id = conc.conc_id                      
						 AND    entac.entac_ent_id      = @pa_crn_no                      
						 AND    conc.conc_deleted_ind   = 1                      
						 AND    entac.entac_deleted_ind = 1                      
						) a                      
						 RIGHT OUTER JOIN                      
						 conc_code_mstr                     concm  WITH (NOLOCK)                      
						 ON concm.concm_id=a.concm_id                      
				  WHERE  concm.concm_deleted_ind        = 1                      
				  AND    1 & concm.concm_cli_yn         = 1                      
				  AND    2 & CONCM.CONCM_CLI_YN         = 2                      
				  AND    power(2,@I-1) & concm.concm_cli_yn  > 0                     
				  ORDER  BY case when isnumeric(concm.concm_rmks)= 1 then  convert(int ,concm.concm_rmks) else 0 end , CONCM.CONCM_DESC                    
	
			end 
    --                      
    END--CONC                      
    --                      
    ELSE IF @PA_TAB = 'CLIA'                      
    BEGIN--CLIA                      
    --                      
      SELECT DISTINCT a.clia_acct_no          acct_no                      
           , compm.compm_id                   compm_id                      
           , compm.compm_short_name           compm_short_name                      
           , a.excsm_exch_cd                  excsm_exch_cd                      
     , a.excsm_seg_cd                   excsm_seg_cd                      
           , a.excsm_id                       excsm_id                      
      FROM  (SELECT clia.clia_acct_no         clia_acct_no                      
                  , excsm.excsm_compm_id      compm_id                      
                  , excsm.excsm_exch_cd       excsm_exch_cd                      
                  , excsm.excsm_seg_cd        excsm_seg_cd                      
                  , excsm.excsm_id            excsm_id                      
                  , citrus_usr.fn_get_single_access  (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc) access1                      
             FROM   client_accounts           clia   WITH (NOLOCK)                      
                 , exch_seg_mstr             excsm  WITH (NOLOCK)                      
                  , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
             WHERE  clia.clia_crn_no        = @pa_crn_no                      
             AND    clia.clia_deleted_ind   = 1                      
             AND    excsm.excsm_deleted_ind = 1                      
             AND    excsm.excsm_id          = excsm_list.excsm_id                    
            ) A                      
           , company_mstr                     compm    WITH (NOLOCK)                      
      WHERE  a.compm_id                     = compm.compm_id                      
      AND    compm.compm_deleted_ind        = 1                      
      AND    ISNULL(CONVERT(NUMERIC, access1), 0)              <> 0                      
    --                      
    END--CLIA                      
    --                      
    ELSE IF @pa_tab = 'CLIBA'                      
    BEGIN                      
    --                      
      SELECT clia.clia_acct_no                    acct_no                      
           , clisba.clisba_no                     clisba_no                      
           , cliba.cliba_ac_name                  cliba_ac_name                      
           , cliba.cliba_banm_id               cliba_banm_id                      
           , ISNULL(banm.banm_name,'')+'-'+ISNULL(banm.banm_branch,'')+'-'+CONVERT(VARCHAR,ISNULL(BANM_MICR,0))  banm_name                      
           , cliba.cliba_ac_type                  cliba_ac_type                      
           , cliba.cliba_ac_no                    cliba_ac_no                      
           , cliba.cliba_flg & 2                  poa_flg                      
           , cliba.cliba_flg & 1                  def_flg                      
          --, cliba.cliba_flg                      cliba_flg                      
           , compm.compm_id                       compm_id                      
           , compm.compm_short_name               compm_short_name                      
  , excsm.excsm_exch_cd                  excsm_exch_cd                      
           , excsm.excsm_seg_cd                   excsm_seg_cd                      
           , excsm.excsm_id                       excsm_id                      
           , clisba.clisba_excpm_id               clisba_excpm_id                      
           , clisba.clisba_id                     clisba_id                       
      FROM   client_accounts                      clia     WITH (NOLOCK)                      
           , client_bank_accts                    cliba    WITH (NOLOCK)                      
           , client_sub_accts                     clisba   WITH (NOLOCK)                      
           , bank_mstr                            banm     WITH (NOLOCK)                      
           , exch_seg_mstr                        excsm    WITH (NOLOCK)                      
   , company_mstr                         compm    WITH (NOLOCK)                      
           , excsm_prod_mstr                      excpm    WITH (NOLOCK)                      
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list            
      WHERE  compm.compm_id                       = excsm.excsm_compm_id                      
      AND    clisba.clisba_crn_no                 = clia.clia_crn_no                      
      AND    clisba.clisba_acct_no                = clia.clia_acct_no                      
      AND    cliba.cliba_clisba_id                = clisba.clisba_id                      
      AND    clisba.clisba_excpm_id               = excpm.excpm_id                      
      AND    excsm.excsm_id                       = excpm.excpm_excsm_id                      
      AND    excsm.excsm_id                       = excsm_list.excsm_id                    
      AND    banm.banm_id                 = cliba.cliba_banm_id                      
      AND    clia.clia_deleted_ind                = 1                      
      AND    ISNULL(clisba.clisba_deleted_ind, 1) = 1                      
      AND    cliba.cliba_deleted_ind              = 1                      
      AND    banm.banm_deleted_ind                = 1                      
      AND    excsm.excsm_deleted_ind              = 1                      
      AND    compm.compm_deleted_ind              = 1                      
      AND    citrus_usr.fn_get_single_access(clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc) > 0                      
      AND    clia.clia_crn_no                     = @pa_crn_no                      
    --                      
    END                      
    ELSE IF @pa_tab = 'CLIDPA'                      
    BEGIN                      
    --                      
      SELECT clidpa.clidpa_dpm_id                clidpa_dpm_id                      
           , dpm.dpm_name                        dpm_name                      
           , dpm.dpm_dpid                        dpm_dpid                      
           , clidpa.clidpa_dp_id                 clidpa_dp_id                      
           , clidpa.clidpa_name                  clidpa_name                      
           , clidpa.clidpa_flg & 1               poa_flg                      
           , clidpa.clidpa_flg & 2               def_flg                      
           , clidpa.clidpa_poa_type              clidpa_poa_type                      
           , compm.compm_id                      compm_id                      
           , compm.compm_short_name              compm_short_name                      
           , excsm.excsm_exch_cd            excsm_exch_cd                      
           , excsm.excsm_seg_cd                  excsm_seg_cd                      
           , clia.clia_acct_no                   acct_no                      
           , clisba.clisba_no                    clisba_no                      
           , excsm.excsm_id                      excsm_id                      
           , excm.excm_cd                        dpm_type                      
           , clisba.clisba_excpm_id              clisba_excpm_id                      
           , clisba.clisba_id                    clisba_id                       
      FROM   client_accounts                     clia     WITH (NOLOCK)                      
           , client_dp_accts                     clidpa   WITH (NOLOCK)                      
           , client_sub_accts                    clisba   WITH (NOLOCK)                      
           , dp_mstr                             dpm      WITH (NOLOCK)                    
           , exchange_mstr                       excm     WITH (NOLOCK)                    
           , exch_seg_mstr                       excsm    WITH (NOLOCK)                      
           , company_mstr                        compm    WITH (NOLOCK)                      
           , excsm_prod_mstr                     excpm    WITH (NOLOCK)                      
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
      WHERE  compm.compm_id                    = excsm.excsm_compm_id                      
      AND    clisba.clisba_crn_no              = clia.clia_crn_no                      
      AND    clisba.clisba_acct_no             = clia.clia_acct_no                      
      AND    clisba.clisba_excpm_id            = excpm.excpm_id                      
      AND    excsm.excsm_id                    = excpm.excpm_excsm_id                      
      AND    clidpa.clidpa_clisba_id           = clisba.clisba_id                      
      AND    dpm.dpm_id                        = clidpa.clidpa_dpm_id                      
      --AND    dpm.dpm_excsm_id                  = excsm.excsm_id                    
      AND    excsm.excsm_exch_cd               = excm.excm_cd                     
      AND    excsm_list.excsm_id               = excsm.excsm_id                  
      AND    CLIA.CLIA_DELETED_IND             = 1                      
      AND    ISNULL(clisba.clisba_deleted_ind, 1) = 1           
      AND    clidpa.clidpa_deleted_ind         = 1                      
      AND    dpm.dpm_deleted_ind               = 1                      
      AND    excsm.excsm_deleted_ind           = 1                      
      AND    compm.compm_deleted_ind           = 1                    
      AND    excm.excm_deleted_ind                = 1                     
      AND    citrus_usr.FN_GET_SINGLE_ACCESS( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc) <> 0                      
      AND    clia.clia_crn_no                  = @pa_crn_no                      
    --                      
    END                      
    --                      
    ELSE IF @PA_TAB = 'ENTM'                      
    BEGIN                      
    --                      
       IF @PA_ACCT_NO = 'HO'                      
       BEGIN                      
       --                      
         SELECT entm.entm_name1          entm_name1                    
              , entm.entm_name2          entm_name2                      
              , entm.entm_name3          entm_name3                      
              , entm.entm_short_name 
              , enttm.enttm_desc         enttm_desc                      
              , entm.entm_parent_id      parent_id                      
              , ''                       parent_name1   --entm.entm_name1          parent_name1                      
              , ''                       parent_type_cd--enttm.enttm_cd           parent_type_cd                      
              , enttm.enttm_cd           enttm_cd                                 
, clicm.clicm_cd           clicm_cd                      
              , clicm.clicm_desc         clicm_desc                      
              , isnull(entm.entm_rmks,'')           entm_rmks  
			 , entm_preapproval_flg		preappflg                      
         FROM  entity_mstr   entm   WITH (NOLOCK)                      
              ,entity_type_mstr          enttm  WITH (NOLOCK)                      
              ,client_ctgry_mstr         clicm  WITH (NOLOCK)                      
         WHERE enttm.enttm_cd          = entm.entm_enttm_cd                      
         AND   entm.entm_clicm_cd      = clicm.clicm_cd                      
         AND   entm.entm_id            = @pa_crn_no                      
         AND   entm.entm_deleted_ind   = 1                      
         AND   enttm.enttm_deleted_ind = 1                      
         AND   clicm.clicm_deleted_ind = 1                      
       --                      
       END                      
       ELSE                      
       BEGIN                      
       --                      
                              
                      
         SELECT @l_exists               = ISNULL(entm_parent_id,0)                               
         FROM   entity_mstr               entm   WITH (NOLOCK)                      
         WHERE  entm.entm_id       = @pa_crn_no                      
         AND    entm.entm_deleted_ind   = 1                      
                      
         IF @L_EXISTS<>0                      
         BEGIN                      
--                       
           SELECT a.entm_name1                     entm_name1                      
                , a.entm_name2                     entm_name2                      
                , a.entm_name3                     entm_name3                      
                , a.entm_short_name 
                , a.enttm_desc                     enttm_desc                      
                , a.clicm_cd                       clicm_cd                      
                , a.clicm_desc                     clicm_desc                      
                , a.parent_id                      parent_id                      
                --, entm.entm_name1                  parent_name1                      
                , entm.entm_short_name             parent_name1                        
                , enttm.enttm_cd                   parent_type_cd                      
                , a.enttm_cd                       enttm_cd                           
                , isnull(a.entm_rmks,'')                      entm_rmks      
				,a.preappflg						preappflg                
           FROM  (SELECT entm.entm_name1           entm_name1                      
                       , entm.entm_name2           entm_name2                      
                       , entm.entm_name3           entm_name3                      
                       , entm.entm_short_name      entm_short_name                      
                       , enttm.enttm_desc          enttm_desc                      
                       , entm.entm_parent_id       parent_id                      
                       , clicm.clicm_cd            clicm_cd                      
                       , clicm.clicm_desc          clicm_desc                      
                       , enttm.enttm_cd           enttm_cd                      
                       , entm.entm_rmks            entm_rmks    
					   , entm_preapproval_flg		preappflg                     
                  FROM   entity_mstr               entm  WITH (NOLOCK)                      
                       , entity_type_mstr          enttm  WITH (NOLOCK)                      
                       , client_ctgry_mstr         clicm  WITH (NOLOCK)                      
                  WHERE  enttm.enttm_cd          = entm.entm_enttm_cd                      
                  AND    entm.entm_clicm_cd      = clicm.clicm_cd                      
                  AND    entm.entm_id            = @pa_crn_no                      
                  AND    entm.entm_deleted_ind   = 1                      
                  AND    enttm.enttm_deleted_ind = 1                      
                  AND    clicm.clicm_deleted_ind = 1                      
                 )                                 a                      
                ,  entity_mstr                     entm   WITH (NOLOCK)                      
                ,  entity_type_mstr                enttm  WITH (NOLOCK)                      
           WHERE   a.parent_id                   = entm.entm_id                      
           AND enttm.enttm_cd                = entm.entm_enttm_cd                      
           AND     enttm.enttm_deleted_ind       = 1                      
        --                      
        END                      
        ELSE                      
        BEGIN                      
        --                      
          SELECT entm.entm_name1 entm_name1                                   
               , entm.entm_name2                   entm_name2                                   
               , entm.entm_name3                   entm_name3                                   
               , entm.entm_short_name 
               , enttm.enttm_desc                  enttm_desc                                   
               , clicm.clicm_cd                    clicm_cd                                     
               , clicm.clicm_desc   clicm_desc                                   
               , isnull(entm.entm_parent_id,0)     parent_id                                    
               , ''                                parent_name1                                 
             , ''                                parent_type_cd                      
               , enttm.enttm_cd                    enttm_cd                        
               , isnull(entm.entm_rmks,'')                    entm_rmks    
			    , entm_preapproval_flg		preappflg                    
          FROM   entity_mstr                       entm    WITH (NOLOCK)                                       
               , entity_type_mstr                  enttm   WITH (NOLOCK)                      
             , client_ctgry_mstr                 clicm   WITH (NOLOCK)                      
          WHERE  enttm.enttm_cd                 = entm.entm_enttm_cd                      
          AND    entm.entm_clicm_cd             = clicm.clicm_cd                      
          AND    entm.entm_id                   = @pa_crn_no                      
          AND   entm.entm_deleted_ind          = 1                      
          AND    enttm.enttm_deleted_ind        = 1                      
          AND    clicm.clicm_deleted_ind        = 1                      
        --                      
        END                      
       END                      
       --                      
    END-- END OF ENTM                      
    --                      
    /*IF @PA_TAB = 'PROM'  -- PRODUCT MAPPING                      
    BEGIN                      
   --                      
       SELECT PROM.PROM_ID                       PROM_ID                      
            , PROM.PROM_CD                       PROM_CD                      
            , PROM.PROM_DESC                     PROM_DESC                      
            , EXCPM.EXCPM_EXCSM_ID               EXCPM_EXCSM_ID                      
       FROM   EXCSM_PROD_MSTR                    EXCPM   WITH (NOLOCK)                      
            , PRODUCT_MSTR                       PROM    WITH (NOLOCK)                      
       WHERE  PROM.PROM_ID                     = EXCPM.EXCPM_PROM_ID                      
       AND    EXCPM.EXCPM_DELETED_IND          = 1                      
       AND    PROM.PROM_DELETED_IND            = 1                      
     --                      
    END*/                      
                      
    ELSE IF @PA_TAB = 'CLISBA'                      
    BEGIN                      
    --                      
      /*SELECT compm.compm_id                      compm_id                        
           , compm.compm_short_name              compm_short_name                        
           , excsm.excsm_id                      excsm_id                        
           , excsm.excsm_exch_cd                 excsm_exch_cd                        
           , excsm.excsm_seg_cd                  excsm_seg_cd                        
           , clia.clia_acct_no                   acct_no                        
           , excpm.excpm_prom_id                 excpm_prom_id                        
           , prom.prom_desc                      prom_desc                        
           , isnull(clisba.clisba_no, 0)         clisba_no                        
           , isnull(clisba.clisba_name, 0)       clisba_name                       
           , brokm.brom_desc                     brom_desc                      
           , stam.stam_desc                      stam_desc                      
           , CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,excsm.excsm_id)+'|*~|'+clia.clia_acct_no+'|*~|'+ISNULL(clisba.clisba_no, 0)+'|*~|'+ISNULL(clisba.clisba_name, 0)+'|*~|'+CONVERT(VARCHAR,excpm.excpm_prom_id)+'|*~|'+ISNULL(stam.stam_cd,''
  
    
      
        
           
           
              
                
                  
)                    
+'|*~|'+convert(varchar, isnull(Brokm.brom_id,''))+'|*~|Q' value  --*|~*                        
      FROM client_sub_accts             clisba   WITH (NOLOCK)                        
           , client_accounts              clia     WITH (NOLOCK)                        
           , excsm_prod_mstr              excpm    WITH (NOLOCK)                        
           , exch_seg_mstr                excsm    WITH (NOLOCK)                        
           , product_mstr                 prom   WITH (NOLOCK)                        
           , company_mstr                 compm    WITH (NOLOCK)                        
           , client_brokerage             combrkg  WITH (NOLOCK)                        
           , Brokerage_mstr               Brokm    WITH (NOLOCK)                      
           , status_mstr                  stam     WITH (NOLOCK)            
      WHERE  clisba.clisba_crn_no               = clia.clia_crn_no                        
      AND    clisba.clisba_acct_no              = clia.clia_acct_no                        
      AND    clisba.clisba_excpm_id             = excpm.excpm_id --(+)                        
      AND    excsm.excsm_id                     = excpm.excpm_excsm_id                        
      AND    compm.compm_id                     = excsm.excsm_compm_id                        
      AND    prom.prom_id                       = excpm.excpm_prom_id                        
      and    combrkg.CLIB_CLISBA_ID             = clisba.clisba_id                      
      and    combrkg.CLIB_Brom_ID               = Brokm.Brom_Id                      
                            
      and    stam.stam_id                       = clisba.CLISBA_access2                      
      AND    ISNULL( citrus_usr.FN_GET_SINGLE_ACCESS( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc), 0) > 0                        
      AND    clisba.clisba_deleted_ind          = 1                        
      AND    clia.clia_deleted_ind              = 1                        
      AND    excpm.excpm_deleted_ind            = 1                        
      AND    excsm.excsm_deleted_ind            = 1                        
      AND    prom.prom_deleted_ind              = 1                        
      AND    compm.compm_deleted_ind            = 1                        
      AND    clia.clia_crn_no                   = @PA_CRN_NO*/                      
      SELECT DISTINCT compm.compm_id                      compm_id                        
           , compm.compm_short_name              compm_short_name                        
           , excsm.excsm_id                      excsm_id                        
           , excsm.excsm_exch_cd                 excsm_exch_cd                        
           , excsm.excsm_seg_cd                  excsm_seg_cd                        
           , clia.clia_acct_no                   acct_no                        
           , excpm.excpm_prom_id                 excpm_prom_id                        
           , prom.prom_desc                      prom_desc                        
           , clisba.clisba_id                    clisba_id                       
           , isnull(clisba.clisba_no, 0)         clisba_no                        
           , isnull(clisba.clisba_name, 0)       clisba_name                       
           , isnull(brokm.brom_desc ,'')         brom_desc                      
           , stam.stam_desc                      stam_desc                      
           , CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,excsm.excsm_id)+'|*~|'+convert(varchar,clia.clia_acct_no)+'|*~|'+convert(varchar,ISNULL(clisba.clisba_no, 0))+'|*~|'+ISNULL(clisba.clisba_name, '0')+'|*~|'+CONVERT(VARCHAR,excpm.excpm_id
   
    
      
       
          
             
             
)                
+'|*~|'+ISNULL(stam.stam_cd,'')+'|*~|'+convert(varchar, isnull(combrkg.clib_brom_id,0))+'|*~|Q' value  --                       
      FROM   client_accounts              clia     WITH (NOLOCK)                        
           , excsm_prod_mstr              excpm    WITH (NOLOCK)    
           , exch_seg_mstr                excsm    WITH (NOLOCK)                        
           , product_mstr                 prom     WITH (NOLOCK)                        
           , company_mstr                 compm    WITH (NOLOCK)                        
           , status_mstr                  stam     WITH (NOLOCK)                      
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
           ,client_sub_accts             clisba                         
            left outer join                       
            client_brokerage             combrkg   on clisba_id = combrkg.clib_clisba_id AND clisba.clisba_crn_no = @PA_CRN_NO                       
            left outer join                      
            Brokerage_mstr               Brokm     on combrkg.CLIB_Brom_ID  = Brokm.Brom_Id                      
                      
      WHERE  clisba.clisba_crn_no               = clia.clia_crn_no                        
      AND    clisba.clisba_acct_no              = clia.clia_acct_no                        
      AND    clisba.clisba_excpm_id             = excpm.excpm_id --(+)                        
      AND    excsm.excsm_id                     = excpm.excpm_excsm_id                        
      AND    compm.compm_id            = excsm.excsm_compm_id                        
      AND    prom.prom_id                       = excpm.excpm_prom_id                      
      AND    excsm.excsm_id                     = excsm_list.excsm_id                    
      AND    clisba.clisba_excpm_id             = isnull(brokm.brom_excpm_id,clisba.clisba_excpm_id)                    
      AND    stam.stam_id                       = clisba.CLISBA_access2                      
      AND    ISNULL( citrus_usr.FN_GET_SINGLE_ACCESS( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc), 0) > 0                        
      AND    clisba.clisba_deleted_ind          = 1                        
      AND    clia.clia_deleted_ind              = 1                        
      AND    excpm.excpm_deleted_ind            = 1                        
      AND    excsm.excsm_deleted_ind            = 1                        
      AND    prom.prom_deleted_ind              = 1                        
      AND    compm.compm_deleted_ind            = 1                        
      AND    clia.clia_crn_no                   = @PA_CRN_NO                      
    --                      
    END                      
    --                      
    ELSE IF @PA_TAB = 'CLISBAENTR'                      
    BEGIN                      
    --                      
      SELECT compm.compm_short_name+' - '+excsm.excsm_exch_cd+' - '+excsm.excsm_seg_cd+' - '+clia.clia_acct_no+' - '+isnull(clisba.clisba_no, 0)  sba_val                      
           --, CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,Excsm.excsm_id)+'|*~|'+clia.clia_acct_no+'|*~|'+ISNULL(clisba.clisba_no, 0)+'|*~|'+CONVERT(VARCHAR,CONVERT(DATETIME,entr.entr_from_dt,103))+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_HO',entr.entr_ho),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_ho),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RE',entr.entr_re),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_re),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_AR',entr.entr_ar),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_ar),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_BR',entr.entr_br),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_br),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_SB',entr.entr_sb),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_sb),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DL',entr.entr_dl),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_dl),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RM',entr.entr_rm),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_rm),'')+'|*~|Q' rel_value                        
           , CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,Excsm.excsm_id)+'|*~|'+clia.clia_acct_no+'|*~|'+ISNULL(clisba.clisba_no, 0)+'|*~|'+CONVERT(VARCHAR,CONVERT(DATETIME,entr.entr_from_dt,103))+'|*~|'                      
           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_HO',entr.entr_ho),'')+'|*~|'                      
           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_ho),'')+'|*~|'                      
           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RE',entr.entr_re),'')+'|*~|'                      
           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_re),'')+'|*~|'                      
           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_AR',entr.entr_ar),'')+'|*~|'                      
           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_ar),'')+'|*~|'                      
           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_BR',entr.entr_br),'')+'|*~|'                      
           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_br),'')+'|*~|'                      
           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_SB',entr.entr_sb),'')+'|*~|'                      
           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_sb),'')+'|*~|'                      
           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DL',entr.entr_dl),'')+'|*~|'                      
           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_dl),'')+'|*~|'                      
           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RM',entr.entr_rm),'')+'|*~|'                      
           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_rm),'')+'|*~|'                      
           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY1',entr.ENTR_DUMMY1),'')+'|*~|'                      
           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY1),'')+'|*~|'                   
           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY2',entr.ENTR_DUMMY2),'')+'|*~|'                      
           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY2),'')+'|*~|'                      
    +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY3',entr.ENTR_DUMMY3),'')+'|*~|'                      
           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY3),'')+'|*~|'                      
           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY4',entr.ENTR_DUMMY4),'')+'|*~|'                      
           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY4),'')+'|*~|'                      
           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY5',entr.ENTR_DUMMY5),'')+'|*~|'                      
           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY5),'')+'|*~|'                      
           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY6',entr.ENTR_DUMMY6),'')+'|*~|'                      
           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY6),'')+'|*~|'                      
           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY7',entr.ENTR_DUMMY7),'')+'|*~|'                      
           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY7),'')+'|*~|'                      
           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY8',entr.ENTR_DUMMY8),'')+'|*~|'                      
           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY8),'')+'|*~|'                      
           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY9',entr.ENTR_DUMMY9),'')+'|*~|'                      
           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY9),'')+'|*~|'                      
           +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY10',entr.ENTR_DUMMY10),'')+'|*~|'                      
           +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY10),'')+'|*~|Q' rel_value                       
           , CONVERT(varchar,entr.entr_from_dt,103)   entr_from_dt                      
      FROM   entity_relationship         entr     WITH (NOLOCK)                      
           , client_sub_accts            clisba   WITH (NOLOCK)                      
           , client_accounts             clia     WITH (NOLOCK)                      
           , exch_seg_mstr               excsm    WITH (NOLOCK)       
           , company_mstr                compm    WITH (NOLOCK)                      
           , excsm_prod_mstr             excpm    WITH (NOLOCK)                  
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                      
      WHERE  entr.entr_crn_no                   = clisba.clisba_crn_no                      
      AND    entr.entr_acct_no                  = clisba.clisba_acct_no                      
      AND    entr.entr_sba                      = clisba.clisba_no                      
      AND    clisba.clisba_crn_no               = clia.clia_crn_no                      
      AND    clisba.clisba_acct_no              = clia.clia_acct_no                      
      AND    compm.compm_id                     = excsm.excsm_compm_id                      
      AND    clisba.clisba_excpm_id             = excpm.excpm_id                     
      AND    excsm_list.excsm_id                = excsm.excsm_id                      
      AND    excpm.excpm_excsm_id               = excsm.excsm_id                      
      AND    entr.entr_excpm_id                 = clisba.clisba_excpm_id                      
      AND    isnull( citrus_usr.fn_get_single_access( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc), 0) > 0                      
      AND    entr.entr_deleted_ind              = 1                       
      AND    clisba.clisba_deleted_ind          = 1                      
 AND    clia.clia_deleted_ind              = 1                      
      AND    excsm.excsm_deleted_ind            = 1                      
      AND    compm.compm_deleted_ind            = 1                      
      AND    excpm.excpm_deleted_ind            = 1                      
      AND    clia.clia_crn_no                   = @PA_CRN_NO                      
      ORDER  BY clisba_no, entr_from_dt DESC                      
                      
                      
                      
                      
  /* commented by vishal & added query sent by tushar on june 07 2007                      
    SELECT compm.compm_short_name+' - '+excsm.excsm_exch_cd+' - '+excsm.excsm_seg_cd+' - '+clia.clia_acct_no+' - '+isnull(clisba.clisba_no, 0)  sba_val                      
           , CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,Excsm.excsm_id)+'|*~|'+clia.clia_acct_no+'|*~|'+ISNULL(clisba.clisba_no, 0)+'|*~|'+CONVERT(VARCHAR,CONVERT(DATETIME,entr.entr_from_dt,103))+'|*~|'+'HO|*~|'+ ISNULL(citrus_usr.FN_SELECT_E
   
    
      
        
          
           
              
N                
                  
                    
TM(entr.entr_ho),'')+'|*~|RE|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_re),'')+'|*~|AR|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_ar),'')+'|*~|BR|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_br),'')+'|*~|SB|*~|'+ ISNULL(citrus_usr.FN_SELE
  
    
      
        
          
            
              
                
                  
                    
CT_ENTM(entr.entr_sb),'')+'|*~|DL|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_dl),'')+'|*~|RM|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_rm),'')+'|*~|Q' rel_value                        
           , CONVERT(varchar,entr.entr_from_dt,103)   entr_from_dt                      
      FROM   entity_relationship         entr     WITH (NOLOCK)                      
           , client_sub_accts            clisba   WITH (NOLOCK)                      
           , client_accounts             clia     WITH (NOLOCK)                      
           , exch_seg_mstr               excsm    WITH (NOLOCK)                      
           , company_mstr                compm    WITH (NOLOCK)                      
    , excsm_prod_mstr             excpm    WITH (NOLOCK)                      
      WHERE  entr.entr_crn_no                   = clisba.clisba_crn_no                      
      AND    entr.entr_acct_no                  = clisba.clisba_acct_no                      
      AND    entr.entr_sba                      = clisba.clisba_no                    
      AND    clisba.clisba_crn_no               = clia.clia_crn_no                      
      AND    clisba.clisba_acct_no              = clia.clia_acct_no                      
      AND    compm.compm_id                     = excsm.excsm_compm_id                      
      aND    clisba.clisba_excpm_id       = excpm.excpm_id                       
      and    excpm.excpm_excsm_id               = excsm.excsm_id                      
      AND    isnull( citrus_usr.fn_get_single_access( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc), 0) > 0                      
                      
      AND    entr.entr_deleted_ind              = 1                       
      AND    clisba.clisba_deleted_ind          = 1                      
      AND    clia.clia_deleted_ind              = 1                      
      AND    excsm.excsm_deleted_ind            = 1                      
      AND    compm.compm_deleted_ind            = 1                      
      AND    clia.clia_crn_no                   = @pa_crn_no                      
      ORDER  BY clisba_no                      
              , entr_from_dt DESC                      
  commented by vishal & added query sent by tushar on june 07 2007 */                      
    --                      
    END                      
    --                                               --**PR_INS_SELECT_CLIM**                      
    ELSE IF @PA_TAB = 'ENTMSTR'                      
    BEGIN                      
    --                      
      SELECT entm.entm_id        entity_id                  
           , enttm.enttm_cd                       entity_type                      
           , enttm.enttm_id                       enttm_id                      
           , enttm.enttm_desc                     entity_type_desc                      
           , enttm.enttm_parent_cd                entity_type_parent_cd                      
           , entm.entm_name1                      entity_name1                      
           , entm.entm_name2                      entity_name2                      
           , entm.entm_name3                      entity_name3                      
           , entm.entm_short_name                 entity_short_name                      
           , entm.entm_parent_id                  entity_parent_id                      
           , clicm.clicm_cd                       clicm_cd                      
           , clicm.clicm_desc                     clicm_desc                      
      FROM   entity_mstr                          entm   WITH (NOLOCK)                      
           , entity_type_mstr                     enttm  WITH (NOLOCK)                      
           , client_ctgry_mstr                    clicm  WITH (NOLOCK)                      
      WHERE  entm.entm_enttm_cd                 = enttm.enttm_cd                      
      AND    entm.entm_clicm_cd                 = clicm.clicm_cd                      
      AND    1 & enttm.enttm_cli_yn             = 1                      
      AND    entm.entm_deleted_ind              = 1                      
      AND    clicm.clicm_deleted_ind            = 1                      
      AND    enttm.enttm_deleted_ind            = 1       
    --                      
    END                      
    --                      
    ELSE IF @pa_tab = 'ENTTM1'                      
    BEGIN                  
    --                      
      SELECT enttm.enttm_id                       enttm_id                      
           , enttm.enttm_cd                       enttm_cd                      
           , enttm.enttm_desc                     enttm_desc                      
           , enttm.enttm_parent_cd                enttm_parent_cd                      
      FROM   entity_type_mstr                     enttm WITH (NOLOCK)                      
      WHERE  1 & enttm.enttm_cli_yn             = 1                      
      AND    enttm.enttm_deleted_ind            = 1   
      ORDER BY enttm_rmks                      
    --                      
    END                      
    --                      
    ELSE IF @pa_tab = 'ADDREF'                      
        BEGIN                      
        --                      
            SELECT coum.coum_name       country_name                      
                    , statem.statem_name   state_name                      
                      , citm.citm_name       city_name                      
                      , zipm.zipm_area_name  zip_zrea_name                       
                      , zipm.zipm_cd         zip_cd                      
            FROM   country_mstr coum                      
                          left outer join                       
                          state_mstr statem on coum.coum_id = statem.statem_coum_id                      
                          left outer join                       
              city_mstr  citm on citm.citm_statem = statem.statem_id                      
             left outer join                       
             zip_mstr  zipm on zipm.zipm_citm_id  = citm.citm_id                      
        --                      
    END                      
    --                      
    ELSE IF @pa_tab = 'ENTTM2'                      
    BEGIN                      
    --                      
      SELECT enttm.enttm_cd                        enttm_cd                      
           , enttm.enttm_desc                      enttm_desc                      
           , enttm.enttm_parent_cd                 enttm_parent_cd                      
           , enttm.enttm_id                        enttm_id                    
           , ISNULL(citrus_usr.fn_get_enttm_bit(enttm.enttm_id,2,0),'')  busm_dtls                    
                               
      FROM   entity_type_mstr                      enttm WITH (NOLOCK)                      
      WHERE  2 & enttm.enttm_cli_yn              = 2                      
      AND    enttm_deleted_ind                   = 1  
      --and ISNULL(citrus_usr.fn_get_enttm_bit(enttm.enttm_id,2,0),'')='NSDL DEPOSITORY'                         
      ORDER BY enttm_desc           desc                     
    --                      
    END                      
    --                      
    ELSE IF @pa_tab = 'ENTTM3'                      
    BEGIN                      
    --                      
      SELECT enttm.enttm_cd    enttm_cd      
           , enttm.enttm_desc                      enttm_desc      
           , enttm.enttm_id                        enttm_id      
           , enttm.enttm_parent_cd                 enttm_parent_cd      
           , case when enttm.enttm_cli_yn & power(2,2-1) <> 0  then 1 else 0 end client_type    
           , case when enttm.enttm_cli_yn & power(2,1-1) <> 0  then 1 else 0 end entity_type    
           , case when enttm.enttm_cli_yn & power(2,3-1)<> 0  then 1 else 0 end others    
      FROM   entity_type_mstr                      enttm WITH (NOLOCK)      
      WHERE  enttm_deleted_ind                   = 1      
      ORDER BY enttm_rmks                    
    --                      
    END                      
    --                      
    ELSE IF @pa_tab = 'CLICM'               
    BEGIN                      
    --                      
      SELECT enttm.enttm_id                   enttm_id                      
           , enttm.enttm_cd                   enttm_cd                      
           , enttm.enttm_desc                 enttm_desc                      
           , clicm.clicm_cd                   category_cd                      
           , clicm.clicm_desc                 category_desc                      
           , clicm.clicm_id                   clicm_id                      
           , CASE 1 & enttm.enttm_cli_yn  when 1 then 1 else 0 end              enttm_ent_yn                    
           , CASE 2 & enttm.enttm_cli_yn  when 2 then 1 else 0 end              enttm_cli_yn                    
           , CASE 4 & enttm.enttm_cli_yn  when 4 then 1 else 0 end              enttm_oth_yn                    
, ISNULL(citrus_usr.fn_get_clicm_bit(clicm.clicm_id,2,0),'')  busm_dtls                      
      FROM   entity_type_mstr                 enttm  WITH (NOLOCK)                      
             LEFT OUTER JOIN                      
             enttm_clicm_mapping              entcm  WITH (NOLOCK)                      
      ON     (enttm.enttm_id = entcm.entcm_enttm_id)                      
             LEFT OUTER JOIN                      
             client_ctgry_mstr    clicm                    
      ON     (clicm.clicm_id = entcm.entcm_clicm_id)                             
      WHERE  ISNULL(clicm.clicm_deleted_ind, 1)   = 1                      
      AND    enttm.enttm_deleted_ind              = 1                      
AND    ISNULL(entcm.entcm_deleted_ind, 1)   = 1                     
      AND    ISNULL(clicm.clicm_cd,'')               <> ''                    
      ORDER  BY enttm_cd, category_cd                      
    --                      
    END                      
    --                    
    ELSE IF @pa_tab = 'SUBCM'                      
    BEGIN                      
    --                      
      SELECT clicm.clicm_cd                   category_cd                      
           , clicm.clicm_desc                 category_desc                      
           , clicm.clicm_id                   clicm_id                      
           , subcm.subcm_cd            sub_category_cd                      
           , subcm.subcm_desc                 sub_category_desc                     
           , subcm.subcm_id                   subcm_id                     
      FROM   client_ctgry_mstr    clicm                    
             LEFT OUTER JOIN                      
             sub_ctgry_mstr       subcm                    
      ON     (clicm.clicm_id = subcm.subcm_clicm_id)                      
      WHERE  ISNULL(clicm.clicm_deleted_ind, 1)   = 1                      
      AND    clicm.clicm_cd                       = @pa_value                      
      AND    ISNULL(clicm.clicm_cd,'')               <> ''                    
      AND    ISNULL(subcm.subcm_cd,'')               <> ''                    
      ORDER  BY sub_category_cd    asc                      
    --                      
    END                     
    ELSE IF @pa_tab = 'CONCM'                      
    BEGIN                      
    --                      
      SELECT concm.concm_cd                   code                      
           , concm.concm_desc                 description                      
           , 1 & concm.concm_cli_yn           clientmstryn                      
           , ISNULL(citrus_usr.fn_get_concm_bit(concm.concm_id,2,0),'')  busm_dtls                    
           , case when isnumeric(concm.concm_rmks)= 1 then  convert(int ,concm.concm_rmks) else 0 end          
      FROM   conc_code_mstr                   concm WITH (NOLOCK)                      
      WHERE  2 & concm.concm_cli_yn         = 2                      
      AND    concm.concm_deleted_ind        = 1                      
      ORDER  BY  case when isnumeric(concm.concm_rmks)= 1 then  convert(int ,concm.concm_rmks) else 0 end  ,concm.concm_desc;                      
    --                      
    END                      
    --                      
    ELSE IF @pa_tab = 'ADDRMSTR'                      
    BEGIN                      
    --                      
      SELECT concm.concm_cd                   code                      
           , concm.concm_desc                 description                      
           , 1 & concm.concm_cli_yn           clientmstryn                    
           , ISNULL(citrus_usr.fn_get_concm_bit(concm.concm_id,2,0),'')  busm_dtls                    
      FROM   conc_code_mstr                   concm WITH (NOLOCK)                    
      WHERE  2 & concm.concm_cli_yn         = 0                      
      AND concm.concm_deleted_ind        = 1                      
      ORDER  BY concm.concm_desc;                      
    --                      
    END                      
    --                      
    ----**CHANGED ON 20/03/2007 ENTP TO ENTPMSTR**----                      
    ELSE IF @pa_tab = 'ENTPMSTR'                      
    BEGIN                      
    --                      
      SELECT entpm.entpm_cd                  property_code                      
           , entpm.entpm_desc                property_desc                      
           , entpm.entpm_cli_yn              property_mdtry_yn                      
           , entdm.entdm_cd                  details_code                      
           , entdm.entdm_desc                details_desc                      
           , 1 & entpm.entpm_cli_yn          clientmstryn                      
           , entpm.entpm_datatype            entpm_datatype                      
           , entdm.entdm_datatype            entdm_datatype                        
      FROM   entity_property_mstr            entpm WITH (NOLOCK)                      
             LEFT OUTER JOIN                       
             entpm_dtls_mstr                 entdm WITH (NOLOCK)                      
      ON     entpm.entpm_prop_id           = entdm.entdm_entpm_prop_id                      
      WHERE  entpm.entpm_deleted_ind       = 1                      
      AND    entdm.entdm_deleted_ind       = 1                        
    --                      
    END                      
    --                      
    ELSE IF @pa_tab = 'DOCM'                      
    BEGIN                      
    --                      
      SELECT DISTINCT excsm.excsm_exch_cd   excsm_exch_cd                      
           , excsm.excsm_seg_cd             excsm_seg_cd                      
           , prom.prom_id                   prom_id                      
           , prom.prom_desc                 prom_desc                      
           , enttm.enttm_id                 enttm_id                      
           , enttm.enttm_desc               enttm_desc                      
           , clicm.clicm_id                 clicm_id                      
           , clicm.clicm_desc            clicm_desc                      
           , docm.docm_doc_id               docm_doc_id                      
           , docm.docm_desc                 docm_desc                      
           , CASE docm.docm_mdty WHEN 1 THEN 'M' ELSE 'N'END   docm_mdty                      
      FROM   document_mstr                  docm   WITH (NOLOCK)                      
           , exch_seg_mstr                  excsm  WITH (NOLOCK)                      
           , client_ctgry_mstr              clicm  WITH (NOLOCK)                      
           , entity_type_mstr               enttm  WITH (NOLOCK)                      
           , excsm_prod_mstr                excpm  WITH (NOLOCK)                      
           , product_mstr                   prom   WITH (NOLOCK)                      
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
      WHERE  docm.docm_excpm_id           = excpm.excpm_id                      
      AND    docm.docm_clicm_id           = clicm.clicm_id                      
      AND    docm.docm_enttm_id      = enttm.enttm_id                      
      AND    prom.prom_id                 = excpm.excpm_prom_id                      
      AND    excpm.excpm_excsm_id         = excsm.excsm_id                    
      AND    excsm.excsm_id               = excsm_list.excsm_id                    
      AND    clicm.clicm_deleted_ind      = 1                      
      AND    enttm.enttm_deleted_ind      = 1                      
      AND    excpm.excpm_deleted_ind      = 1                      
      AND    prom.prom_deleted_ind        = 1                      
      AND    excsm.excsm_deleted_ind      = 1                      
      AND    docm.docm_deleted_ind        = 1                      
    --                      
    END                      
    --                      
    ELSE IF @pa_tab = 'STAM'                      
    BEGIN                      
    --                      
      SELECT stam.stam_cd                   code                      
           , ltrim(rtrim(stam.stam_desc ))                description             
      FROM   status_mstr                    stam WITH (NOLOCK)                      
      WHERE  stam.stam_deleted_ind        = 1            
      order by  description                 
    --                      
    END                      
    --                     
    ELSE IF @pa_tab = 'DPM'                      
    BEGIN                      
    --                      
      SELECT dpm.dpm_name                   dpm_name                      
           , dpm.dpm_dpid            dpm_dpid                      
 , dpm.dpm_id                     dpm_id                      
           , excm.excm_cd                   dpm_type                    
           , dpm.dpm_short_name             dpm_short_name                                 
      FROM   dp_mstr                        dpm   WITH (NOLOCK)                      
           , exchange_mstr                  excm  WITH (NOLOCK)                      
           , exch_seg_mstr                  excsm WITH (NOLOCK)                      
      WHERE  dpm.dpm_deleted_ind          = 1                      
      AND    excsm.excsm_id               = dpm.dpm_excsm_id                    
      AND    excsm.excsm_exch_cd          = excm.excm_cd                    
    --                      
    END                      
    --                      
    ELSE IF @pa_tab = 'BANM'                      
    BEGIN                      
    --                      
      SELECT banm.banm_name                 banm_name                      
           , banm.banm_id                   banm_id                      
           , banm.banm_branch               banm_branch                      
           , banm.banm_micr                 banm_micr                      
      FROM   bank_mstr                      banm WITH (NOLOCK)                      
      WHERE  banm.banm_deleted_ind        = 1         
      order by banm_name,banm_branch                    
    --                      
    END                      
    --                      
    /*ELSE IF @PA_TAB = 'CLICM'                      
    BEGIN                      
    --                      
      SELECT CLICM.CLICM_CD                 CATEGORY_CD                      
           , CLICM.CLICM_DESC            CATEGORY_DESC                      
           , CLICM.CLICM_ID                 CLICM_ID                      
      FROM   CLIENT_CTGRY_MSTR              CLICM WITH (NOLOCK)                      
      WHERE  CLICM.CLICM_DELETED_IND      = 1                      
    --                      
    END*/                      
    --                      
    ELSE IF @pa_tab = 'COMPM'                      
    BEGIN                      
    --                      
      SELECT compm.compm_short_name +'-'+ excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd + '-' + dpm_dpid  comp_name                      
           , excsm.excsm_id               id                      
           , CONVERT(VARCHAR,COMPM.COMPM_ID) +'|*~|'+ CONVERT(VARCHAR,EXCSM.EXCSM_ID)     COMPEXCHANGE_ID                      
      FROM   exch_seg_mstr                excsm  WITH (NOLOCK)                      
           , company_mstr                 compm  WITH (NOLOCK)
           ,dp_mstr     WITH (NOLOCK)                
      WHERE  excsm.excsm_compm_id         = compm.compm_id                      
      AND    excsm.excsm_deleted_ind      = 1                      
      AND    compm.compm_deleted_ind      = 1       
      and    excsm.excsm_id = dpm_excsm_id and default_dp=dpm_excsm_id and dpm_Deleted_ind=1                          
    --                      
    END                      
    --        
    ELSE IF @pa_tab = 'COMPM_MOSL'                      
    BEGIN                      
    --                      
      SELECT compm.compm_short_name + '-' + dpm_dpid  +'-'+ excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd  comp_name                      
           , excsm.excsm_id               id                      
           , CONVERT(VARCHAR,COMPM.COMPM_ID) +'|*~|'+ CONVERT(VARCHAR,EXCSM.EXCSM_ID)     COMPEXCHANGE_ID                      
      FROM   exch_seg_mstr                excsm  WITH (NOLOCK)                      
           , company_mstr                 compm  WITH (NOLOCK)
           ,dp_mstr     WITH (NOLOCK)                
      WHERE  excsm.excsm_compm_id         = compm.compm_id                      
      AND    excsm.excsm_deleted_ind      = 1                      
      AND    compm.compm_deleted_ind      = 1       
      and    excsm.excsm_id = dpm_excsm_id and default_dp=dpm_excsm_id and dpm_Deleted_ind=1                         
    --                      
    END                      
    --                           
    ELSE IF @pa_tab = 'COMPM_ROLWISE'                  
    BEGIN                  
    --                  
--      SELECT compm.compm_short_name +'-'+ excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd+'-'+dpm_dpid comp_name                  
--           , excsm.excsm_id               id                  
--           , CONVERT(VARCHAR,COMPM.COMPM_ID) +'|*~|'+ CONVERT(VARCHAR,EXCSM.EXCSM_ID)     COMPEXCHANGE_ID                  
--      FROM   exch_seg_mstr                excsm  WITH (NOLOCK)                  
--           , company_mstr                 compm  WITH (NOLOCK)                
--           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                
--		   , dp_mstr   
--      WHERE  dpm_excsm_id = excsm.excsm_id 
--      and    default_dp = dpm_excsm_id 
--      and    excsm.excsm_compm_id         = compm.compm_id                  
--      AND    excsm_list.excsm_id          = excsm.excsm_id                
--      AND    excsm.excsm_deleted_ind      = 1                  
--      AND    compm.compm_deleted_ind      = 1     

      SELECT compm.compm_short_name  +'-'+ excsm.excsm_exch_cd+'-'+excsm.excsm_seg_cd + '-' + dpm_dpid comp_name                      
           , excsm.excsm_id               id                      
           , CONVERT(VARCHAR,COMPM.COMPM_ID) +'|*~|'+ CONVERT(VARCHAR,EXCSM.EXCSM_ID)     COMPEXCHANGE_ID                      
      FROM   exch_seg_mstr                excsm  WITH (NOLOCK)                      
           , company_mstr                 compm  WITH (NOLOCK)
           ,dp_mstr     WITH (NOLOCK)                
      WHERE  excsm.excsm_compm_id         = compm.compm_id                      
      AND    excsm.excsm_deleted_ind      = 1                      
      AND    compm.compm_deleted_ind      = 1       
      and    excsm.excsm_id = dpm_excsm_id and default_dp=dpm_excsm_id and dpm_Deleted_ind=1  
 
    --                  
    END                      
    ELSE IF @pa_tab = 'PROM'  -- PRODUCT MAPPING                      
    BEGIN                      
    --                      
      SELECT prom.prom_id                 prom_id                      
           , prom.prom_cd                 prom_cd                      
           , prom.prom_desc             prom_desc                      
           , excpm.excpm_excsm_id         excpm_excsm_id                      
 , excpm.excpm_id               excpm_id                      
      FROM   excsm_prod_mstr              excpm  WITH (NOLOCK)                      
           , product_mstr                 prom   WITH (NOLOCK)                      
      WHERE  prom.prom_id               = excpm.excpm_prom_id                      
      AND    excpm.excpm_deleted_ind    = 1                      
      AND    prom.prom_deleted_ind      = 1                      
    --                      
    END                      
    --                                               --**PR_INS_SELECT_DOCM**                      
    /*ELSE IF @PA_TAB = 'NO TAB'                                                 
    BEGIN                      
    --                      
      SELECT DISTINCT EXCSM.EXCSM_EXCH_CD        EXCSM_EXCH_CD                      
           , EXCSM.EXCSM_SEG_CD                  EXCSM_SEG_CD                      
           , PROM.PROM_ID                        PROM_ID                      
           , PROM.PROM_DESC                      PROM_DESC                      
           , ENTTM.ENTTM_ID                      ENTTM_ID          
           , ENTTM.ENTTM_DESC                    ENTTM_DESC                      
           , CLICM.CLICM_ID                      CLICM_ID                      
           , CLICM.CLICM_DESC                    CLICM_DESC                      
           , CASE DOCM.DOCM_MDTY WHEN 1 THEN 'M' ELSE 'N' END DOCM_MDTY                      
           , DOCM_DESC                           DOCDESC                      
           , DOCM.DOCM_DOC_ID                    DOC_ID                      
      FROM   DOCUMENT_MSTR                       DOCM   WITH (NOLOCK)                      
           , EXCH_SEG_MSTR     EXCSM  WITH (NOLOCK)                      
           , CLIENT_CTGRY_MSTR                   CLICM  WITH (NOLOCK)                      
       , ENTITY_TYPE_MSTR                    ENTTM  WITH (NOLOCK)                      
           , EXCSM_PROD_MSTR                     EXCPM  WITH (NOLOCK)                      
           , PRODUCT_MSTR                        PROM   WITH (NOLOCK)                      
      WHERE  DOCM.DOCM_EXCPM_ID                = EXCPM.EXCPM_ID                      
      AND    DOCM.DOCM_CLICM_ID                = CLICM.CLICM_ID                      
      AND    DOCM.DOCM_ENTTM_ID                = ENTTM.ENTTM_ID                      
      AND    PROM.PROM_ID                      = EXCPM.EXCPM_PROM_ID                      
      AND    EXCPM.EXCPM_EXCSM_ID  = EXCSM.EXCSM_ID                      
      AND    CLICM.CLICM_DELETED_IND           = 1                      
      AND    ENTTM.ENTTM_DELETED_IND           = 1                      
      AND    EXCPM.EXCPM_DELETED_IND           = 1                      
      AND    PROM.PROM_DELETED_IND             = 1                      
      AND    EXCSM.EXCSM_DELETED_IND           = 1                      
AND    DOCM.DOCM_DELETED_IND             = 1                      
      AND    DOCM.DOCM_CLICM_ID                = @PA_CLICM_ID                      
      AND    DOCM.DOCM_ENTTM_ID                = @PA_ENTTM_ID                    
    --                        
    END*/ --CHANGED BY TUSHAR --28/03/07                      
    --, CASE WHEN entp_entpm_cd = 'INDRODUCER' THEN ISNULL(entp.entp_value,'DIRECT') ELSE ISNULL(entp_value,'') END entp_value                      
    --                                               --**PR_INS_SELECT_ENTP**                      
    ELSE IF @pa_tab = 'CLIP'                      
    BEGIN                      
    --                      
      SELECT  x.excsm_exch_cd   excsm_exch_cd                      
           , x.excsm_seg_cd                 excsm_seg_cd                         
           , x.prom_id                      prom_id                       
           , x.prom_desc                    prom_desc                      
           , x.entpm_prop_id                entpm_prop_id                      
           --, x.entpm_clicm_id      entpm_clicm_id                      
           --, x.entp_id             entp_id                      
           --, x.entpm_enttm_id      entpm_enttm_id                      
           --, x.entpm_id            entpm_id                      
           , x.entpm_cd                     entpm_cd                      
           , isnull(x.entpm_desc,'')        entpm_desc                      
           , isnull(x.entp_value,'')        entp_value                      
           , isnull(y.entdm_id,0)           entdm_id                      
           , y.entdm_cd                     entdm_cd                      
           , isnull(y.entpd_value,'')       entpd_value                      
           , y.entdm_desc                   entdm_desc                      
           , x.entpm_mdty                   entpm_mdty                      
           , y.entdm_mdty                   entdm_mdty                       
           , RTRIM(LTRIM(x.entpm_datatype)) entpm_datatype                      
           , y.entdm_datatype               entdm_datatype                      
           , x.ord1                         ord1                       
        FROM (SELECT DISTINCT excsm.excsm_exch_cd        excsm_exch_cd                          
                   , excsm.excsm_seg_cd                  excsm_seg_cd                          
                   , prom.prom_id                        prom_id                       
                   , entpm.entpm_enttm_id                entpm_enttm_id                      
                   , isnull(prom.prom_desc,'')           prom_desc                       
                   , CASE WHEN entpm.entpm_cd  = 'INTRODUCER' THEN ISNULL(entp.entp_value,'DIRECT') ELSE ISNULL(entp.entp_value,'') END  entp_value                      
                   --, isnull(entp.entp_value,'')          entp_value                      
                   , entpm.entpm_prop_id                 entpm_prop_id                      
                   , entpm.entpm_cd                      entpm_cd                      
                   , isnull(entpm.entpm_desc,'')         entpm_desc                          
                   , entpm.entpm_clicm_id                entpm_clicm_id                          
                   , entp.entp_id                        entp_id                      
                   , entpm.entpm_id                      entpm_id                      
                   , entp.entp_ent_id                    entp_ent_id                      
                   , CASE entpm.entpm_mdty  WHEN 1 THEN 'M' ELSE 'N' END entpm_mdty                      
                   , CASE excsm_exch_cd     WHEN 'BSE'THEN CONVERT(VARCHAR,1) WHEN 'NSE'THEN CONVERT(VARCHAR,2) ELSE CONVERT(VARCHAR,3) END  ord1                        
               , ISNULL(entpm.entpm_datatype,'')     entpm_datatype                      
        FROM  entity_property_mstr          entpm   WITH(NOLOCK)                          
              left outer join                              
              entity_properties          entp    WITH (NOLOCK)                      
        ON    entpm.entpm_prop_id         = entp.entp_entpm_prop_id                       
        AND   ISNULL(entp_ent_id, 0)      = @pa_crn_no                       
        AND   ISNULL(entp_deleted_ind, 1) = 1                      
        AND   ISNULL(entp_deleted_ind, 1) = 1                        
                      right outer join                       
                      client_sub_accts              clisba  WITH(NOLOCK)                        
                ON    clisba.clisba_excpm_id      = entpm.entpm_excpm_id                      
        AND   clisba.clisba_crn_no        = @pa_crn_no                      
            , exch_seg_mstr                 excsm   WITH(NOLOCK)         
            , excsm_prod_mstr               excpm   WITH(NOLOCK)                          
            , product_mstr                  prom    WITH(NOLOCK)                       
            , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                           
        WHERE entpm.entpm_excpm_id        = excpm.excpm_id                          
        AND   prom.prom_id                = excpm.excpm_prom_id                          
        AND   excpm.excpm_excsm_id        = excsm.excsm_id                    
        AND   excsm.excsm_id              = excsm_list.excsm_id                        
        AND   excpm.excpm_deleted_ind     = 1                          
                              
        AND   prom.prom_deleted_ind       = 1                          
        AND   excsm.excsm_deleted_ind     = 1                          
        AND   entpm.entpm_deleted_ind     = 1                          
        AND   entpm_clicm_id              = @pa_clicm_id                      
        AND   entpm_enttm_id              = @pa_enttm_id                      
       ) X                      
        LEFT OUTER JOIN                      
       (SELECT a.entdm_entpm_prop_id       entdm_entpm_id                      
             , b.entpd_entp_id             entpd_entp_id                      
             , a.entdm_cd                  entdm_cd                      
             , a.entdm_id                  entdm_id                      
             , b.entpd_value         entpd_value                      
             , a.entdm_desc                entdm_desc                      
             , a.entdm_entpm_prop_id       entdm_entpm_prop_id                      
             , ISNULL(a.entdm_datatype,'') entdm_datatype                       
             , CASE a.entdm_mdty  WHEN 1 THEN 'M' ELSE 'N' END entdm_mdty                      
        FROM   entpm_dtls_mstr a         WITH (NOLOCK)                      
               left outer join                      
               entity_property_dtls b    WITH (NOLOCK)                      
                      
        ON  (a.entdm_id     = b.entpd_entdm_id)                     
        AND entpd_entp_id IN (SELECT entp_id FROM entity_properties  WITH (NOLOCK) WHERE ENTP_ENT_ID = @PA_CRN_NO AND ENTP_DELETED_IND = 1)                       
        AND   ISNULL(b.entpd_deleted_ind,1)= 1                      
        WHERE a.entdm_deleted_ind = 1                       
                              
       ) y                      
       ON (x.entpm_prop_id = y.entdm_entpm_prop_id)                      
       ORDER BY x.ord1                        
              , x.excsm_exch_cd                      
              , x.excsm_seg_cd                        
              , x.prom_id                        
              , x.entpm_desc                       
    --                      
    END                      
    --                      
    ELSE IF @pa_tab = 'ENTP'                      
    BEGIN                      
    --                      
      /*SELECT DISTINCT x.entpm_prop_id                 entpm_prop_id                      
           --, x.entpm_clicm_id                         entpm_clicm_id                      
           --, x.entp_id                                entp_id                      
           --, x.entpm_enttm_id                         entpm_enttm_id                      
           --, x.entpm_cd                               entpm_cd                      
           , isnull(x.entpm_desc,'')                  entpm_desc                      
           , isnull(x.entp_value,'')     entp_value                      
           , isnull(entdm.entdm_id,0)                entdm_id                      
           --, entdm.entdm_cd                           entdm_cd                      
           , isnull(entpd.entpd_value,'')             entpd_value             
           , isnull(entdm.entdm_desc,'')              entdm_desc                      
           , x.entpm_mdty                             entpm_mdty                      
           , x.entpm_datatype                      entpm_datatype                       
           , entdm.entdm_datatype                     entdm_datatype                      
      FROM (SELECT DISTINCT entpm.entpm_enttm_id      entpm_enttm_id                      
                , entpm.entpm_prop_id                 entpm_prop_id                      
                , isnull(entp.entp_value,'')          entp_value                      
                , entpm.entpm_cd                      entpm_cd                      
                , isnull(entpm.entpm_desc,'')         entpm_desc                          
                , entpm.entpm_clicm_id                entpm_clicm_id                          
                , entp.entp_id                        entp_id                      
                , entp.entp_ent_id                    entp_ent_id                      
                , CASE entpm.entpm_mdty WHEN 1 THEN 'M' ELSE 'N' END entpm_mdty                      
                , entpm.entpm_datatype            entpm_datatype                       
          FROM  entity_property_mstr    entpm   WITH(NOLOCK)                          
                left outer join                       
                entity_properties       entp    WITH(NOLOCK)                       
          --ON    entpm.entpm_prop_id                  = entp.entp_entpm_prop_id AND ISNULL(entp_ent_id, 0) =@pa_crn_no                      
          ON   entpm.entpm_cd                  = entp.entp_entpm_cd AND ISNULL(entp_ent_id, 0) =@pa_crn_no                 
          WHERE isnull(entp_deleted_ind, 1)          = 1                        
          AND   entpm.entpm_deleted_ind              = 1                          
          AND   entpm_clicm_id                       = @pa_clicm_id                      
          AND   entpm_enttm_id                       = @pa_enttm_id)  x                      
          LEFT OUTER JOIN                      
          entpm_dtls_mstr entdm                  WITH(NOLOCK)                        
          ON x.entpm_prop_id   = entdm.entdm_entpm_prop_id --AND  ISNULL(x.entp_ent_id,0) = @pa_crn_no                      
          LEFT OUTER JOIN                      
          entity_property_dtls entpd             WITH(NOLOCK)                         
          ON entdm.entdm_id = entpd.entpd_entdm_id                       
          WHERE  ISNULL(entdm_deleted_ind,1)             = 1                        
          AND    ISNULL(entpd.entpd_deleted_ind, 1)      = 1                       
          ORDER BY x.entpm_desc*/                      
                                
          SELECT  x.entpm_prop_id             entpm_prop_id                      
               --, x.entpm_clicm_id                        entpm_clicm_id                      
               --, x.entp_id                                entp_id                      
               --, x.entpm_enttm_id                         entpm_enttm_id                      
               , x.entpm_cd   entpm_cd                      
               , isnull(x.entpm_desc,'')              entpm_desc                      
               , isnull(x.entp_value,'')              entp_value                      
               , isnull(Y.entdm_id,0)                 entdm_id                      
               , Y.entdm_cd                           entdm_cd                      
               , isnull(Y.entpd_value,'')             entpd_value                      
               , isnull(Y.entdm_desc,'')              entdm_desc                      
               , x.entpm_mdty                         entpm_mdty                      
               , y.entdm_mdty                         entdm_mdty                      
               , LTRIM(RTRIM(x.entpm_datatype))       entpm_datatype                       
               , LTRIM(RTRIM(Y.entdm_datatype))       entdm_datatype                      
          FROM (SELECT DISTINCT entpm.entpm_enttm_id      entpm_enttm_id                      
                    , entpm.entpm_prop_id                 entpm_prop_id                      
   --, isnull(entp.entp_value,'')          entp_value                      
                    , CASE WHEN entpm.entpm_cd = 'INTRODUCER' THEN ISNULL(entp.entp_value,'DIRECT') ELSE ISNULL(entp.entp_value,'') END entp_value         
                    , entpm.entpm_cd                      entpm_cd                      
                    , isnull(entpm.entpm_desc,'')         entpm_desc                          
, entpm.entpm_clicm_id                entpm_clicm_id                          
                    , entp.entp_id                        entp_id                      
                    , entp.entp_ent_id                    entp_ent_id                      
                    , CASE entpm.entpm_mdty WHEN 1 THEN 'M' ELSE 'N' END entpm_mdty                      
            , ISNULL(entpm.entpm_datatype,'')     entpm_datatype                       
                FROM  entity_property_mstr    entpm   WITH(NOLOCK)                          
                      left outer join                       
                      entity_properties       entp    WITH(NOLOCK)                       
                --ON    entpm.entpm_prop_id                  = entp.entp_entpm_prop_id AND ISNULL(entp_ent_id, 0) =@pa_crn_no                      
                ON    entpm.entpm_cd                  = entp.entp_entpm_cd AND ISNULL(entp_ent_id, 0) =@pa_crn_no                      
                AND   isnull(entp_deleted_ind, 1)          = 1                       
                WHERE entpm.entpm_deleted_ind              = 1                          
                AND   entpm_clicm_id                 = @pa_clicm_id                      
                AND   entpm_enttm_id           = @pa_enttm_id)  x                      
                LEFT OUTER JOIN                      
                (SELECT entdm.entdm_id                   entdm_id                      
                       ,entpd.entpd_value                entpd_value                       
                       ,entdm.entdm_desc                 entdm_desc                      
                       ,ISNULL(entdm.entdm_datatype,'')  entdm_datatype                       
                       ,entdm_entpm_prop_id              entdm_entpm_prop_id                      
                       ,entdm.entdm_cd                   entdm_cd                          
                       ,CASE entdm.entdm_mdty WHEN 1 THEN 'M' ELSE 'N' END entdm_mdty                      
                FROM  entpm_dtls_mstr entdm              WITH(NOLOCK)                        
                LEFT OUTER JOIN                      
                entity_property_dtls entpd             WITH(NOLOCK)                         
                ON entdm.entdm_id = entpd.entpd_entdm_id AND entpd_entp_id IN (SELECT entp_id FROM entity_properties  WITH (NOLOCK) WHERE ENTP_ENT_ID = @pa_crn_no AND ENTP_DELETED_IND = 1)                      
                AND    ISNULL(entpd.entpd_deleted_ind, 1)   = 1                      
                WHERE  ISNULL(entdm_deleted_ind,1)             = 1                        
                 ) Y                      
            ON (x.entpm_prop_id  = y.entdm_entpm_prop_id)                      
            ORDER BY x.entpm_desc                      
                                                              
                      
                                
    --                      
    END                      
    --                                                 --**PR_SELECT_ADDR**                      
    ELSE IF @pa_tab = 'BANM_DPM_ADDR'                  --CHANGED BY TUSHAR --28/03/07                      
    BEGIN                      
    --                      
       SET @values1      = ''                      
       SET @values2      = ''                      
       SET @rowdelimiter = '*|~*'                      
       SET @coldelimiter = '|*~|'                      
       --                      
       SET @@c_access_cursor          = CURSOR FAST_FORWARD FOR                      
       SELECT isnull(entac.entac_concm_cd+@coldelimiter+isnull(adr.adr_1,'')+@coldelimiter+isnull(adr.adr_2,'')+@coldelimiter+isnull(adr.adr_3,'')+@coldelimiter+isnull(adr.adr_city,'')+@coldelimiter+isnull(adr.adr_state,'')+@coldelimiter+isnull(adr.adr_country,'')+@coldelimiter+isnull(adr.adr_zip,'')+@coldelimiter+@rowdelimiter, ' ') value                      
       FROM   addresses       adr     WITH (NOLOCK)                    
           ,  entity_adr_conc entac   WITH (NOLOCK)                      
       WHERE  entac.entac_adr_conc_id = adr.adr_id                      
       AND    entac.entac_ent_id      = @pa_id                      
       AND    adr.adr_deleted_ind     = 1                      
       AND    entac.entac_deleted_ind = 1                      
       --                      
       OPEN @@C_ACCESS_CURSOR                      
       FETCH NEXT FROM @@C_ACCESS_CURSOR INTO @VALUES1                      
       --                      
       WHILE @@FETCH_STATUS = 0                      
       BEGIN                      
       --                      
        SET @VALUES2 = @VALUES1 +@VALUES2                      
        FETCH NEXT FROM @@C_ACCESS_CURSOR INTO @VALUES1                      
       --                      
       END                      
       --                      
  CLOSE @@C_ACCESS_CURSOR                      
       DEALLOCATE @@C_ACCESS_CURSOR                      
       --                      
       SELECT @VALUES2 value                      
    --                        
    END                      
    --                      
            --**PA_SELECT_CONC**                      
    ELSE IF @pa_tab = 'BANM_DPM_CONC'              --CHANGED BY TUSHAR --28/03/07                      
    BEGIN                      
    --                      
      SET @values1          = ''                      
      SET @values2       = ''                      
      SET @rowdelimiter     = '*|~*'                      
      SET @coldelimiter     = '|*~|'                      
      SET @@c_access_cursor = CURSOR FAST_FORWARD FOR                      
      --                      
      SELECT isnull(entac.entac_concm_cd+@coldelimiter+conc.conc_value+@coldelimiter+@rowdelimiter,'') value                      
      FROM   contact_channels   conc   WITH (NOLOCK)                      
            ,entity_adr_conc    entac  WITH (NOLOCK)                      
      WHERE  entac.entac_adr_conc_id = conc.conc_id                      
      AND    entac.entac_ent_id      = @pa_id                      
      AND    conc.conc_deleted_ind   = 1                      
      AND    entac.entac_deleted_ind = 1                      
      --                      
      OPEN @@c_access_cursor                      
      FETCH NEXT FROM @@c_access_cursor INTO @values1                      
      --                      
      WHILE @@fetch_status = 0                      
   BEGIN                      
      --                      
         SET @values2 = @values1 +@values2                      
         FETCH NEXT FROM @@c_access_cursor INTO @values1                      
      --                      
      END                      
      --                      
      CLOSE @@c_access_cursor                      
      DEALLOCATE @@c_access_cursor                      
      SELECT @values2 value                      
    --                    
    END                      
    ELSE IF @pa_tab = 'CLIM_SHORT_NAME'              --CHANGED BY TUSHAR --28/05/07                      
    BEGIN                      
    --     
      select 0                 
--      IF ISNULL(@PA_CRN_NO,0) = 0                      
--      BEGIN                      
--      --                          
--        SELECT count(clim_short_name) cnt                       
--        FROM   client_mstr                       
--        WHERE  clim_short_name  = @pa_value                      
--        AND    clim_deleted_ind = 1                      
--        union
--        SELECT count(clim_short_name) cnt                       
--        FROM   client_mstr_mak
--        WHERE  clim_short_name  = @pa_value                      
--        AND    clim_deleted_ind in (0,4,6,8)
--      --                      
--      END                      
--      ELSE                      
--      BEGIN                      
--      --                        
--        SELECT count(clim_short_name) cnt                       
--        FROM   client_mstr                       
--        WHERE  clim_short_name   = @pa_value                      
--        AND    clim_crn_no       <> @pa_crn_no                      
--        AND    clim_deleted_ind  = 1                      
--        union
--        SELECT count(clim_short_name) cnt                       
--        FROM   client_mstr_mak                       
--        WHERE  clim_short_name   = @pa_value                      
--        AND    clim_crn_no       <> @pa_crn_no                      
--        AND    clim_deleted_ind in (0,4,6,8)    
--     --                      
--     END                      
    --                        
    END                      
    ELSE IF @pa_tab = 'ENTM_SHORT_NAME'              --CHANGED BY TUSHAR --28/05/07                      
    BEGIN                      
    --                      
      IF ISNULL(@PA_CRN_NO,0) = 0        
      BEGIN                      
      --                          
        SELECT count(entm_short_name) cnt                       
        FROM   entity_mstr                       
        WHERE  entm_short_name  = @pa_value                      
        AND    entm_deleted_ind = 1                      
      --                      
      END                      
      ELSE                      
      BEGIN                      
      --                        
        SELECT count(entm_short_name) cnt                       
        FROM   entity_mstr                       
        WHERE  entm_short_name   = @pa_value                      
        AND    entm_id           <> @pa_crn_no                      
        AND    entm_deleted_ind  = 1                      
     --                      
     END                      
    --                        
    END                      
    ELSE IF @pa_tab = 'SBA_APP_SELECT'              --CHANGED BY TUSHAR --06/08/07                   
    BEGIN                      
    --                      
        --exec pr_select_clisba_app @pa_crn_no ,''                      
      SELECT DISTINCT compm.compm_id             compm_id                      
           , compm.compm_short_name              compm_short_name                      
           , excsm.excsm_id                      excsm_id                      
           , excsm.excsm_exch_cd                 excsm_exch_cd                      
           , excsm.excsm_seg_cd                  excsm_seg_cd                      
           , cliam.clia_acct_no                  acct_no                      
           , excpm.excpm_prom_id                 excpm_prom_id                      
           , prom.prom_desc                      prom_desc                      
           --, stam.stam_desc                      stam_desc                      
           --, brom.brom_desc                      brom_desc                        
           , clisbam.clisba_id                   clisba_id                      
           , isnull(clisbam.clisba_no, 0)        clisba_no                      
           , isnull(clisbam.clisba_name, 0)      clisba_name                    
           --, CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,excsm.excsm_id)+'|*~|'+cliam.clia_acct_no+'|*~|'+ISNULL(clisbam.clisba_no, 0)+'|*~|'+ISNULL(clisbam.clisba_name, 0)+'|*~|'+CONVERT(VARCHAR,excpm.excpm_prom_id)+'|*~|'+ISNULL(stam.stam_cd,'')+'|*~|Q' value  --*|~*                      
           --, CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,excsm.excsm_id)+'|*~|'+cliam.clia_acct_no+'|*~|'+ISNULL(clisbam.clisba_no, 0)+'|*~|'+ISNULL(clisbam.clisba_name, 0)+'|*~|'+CONVERT(VARCHAR,excpm.excpm_prom_id)+'|*~|Q' value  --*|~*    
  
    
      
        
          
            
              
                
                  
           , CASE clil.clim_ins_upd_del  WHEN 'I' THEN 'ADD'                      
                                         WHEN 'E' THEN 'EDIT'                      
                                         WHEN 'D' THEN 'DELETE'                                 
             END     Status                        
FROM   client_sub_accts_mak                clisbam  WITH (NOLOCK)                      
           , client_accounts_mak                 cliam    WITH (NOLOCK)                      
           , excsm_prod_mstr                     excpm    WITH (NOLOCK)                      
           , exch_seg_mstr                       excsm    WITH (NOLOCK)                      
           , product_mstr                        prom     WITH (NOLOCK)                      
           , company_mstr                        compm    WITH (NOLOCK)                      
          -- , status_mstr                         stam     WITH (NOLOCK)                      
          -- , brokerage_mstr                      brom     WITH (NOLOCK)                      
           , client_list                         clil     WITH (NOLOCK)                      
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                    
      WHERE  clisbam.clisba_crn_no              = cliam.clia_crn_no                      
      AND    clisbam.clisba_acct_no             = cliam.clia_acct_no                      
      AND    clisbam.clisba_excpm_id            = excpm.excpm_id                       
      AND    excsm.excsm_id                     = excpm.excpm_excsm_id                      
      AND    compm.compm_id                     = excsm.excsm_compm_id                      
      AND    excsm.excsm_id                     = excsm_list.excsm_id                  
      AND    prom.prom_id                       = excpm.excpm_prom_id                      
      --AND    clisbam.clisba_access2             = stam.stam_id                      
      --AND    clisbam.clisba_brom                = brom.brom_id                      
      AND    clisbam.clisba_id                  = clil.clisba_no                      
      AND    clisbam.clisba_crn_no              = clil.clim_crn_no                      
      --AND    ISNULL( citrus_usr.FN_GET_SINGLE_ACCESS( cliam.clia_crn_no, cliam.clia_acct_no, excsm.excsm_desc), 0) > 0                      
      AND    clisbam.clisba_deleted_ind         IN(0,4,8)                      
      AND    cliam.clia_deleted_ind             IN(0,8)                      
      AND    excpm.excpm_deleted_ind            = 1                      
      AND    excsm.excsm_deleted_ind            = 1                      
      AND    prom.prom_deleted_ind              = 1                      
      AND    compm.compm_deleted_ind            = 1                      
      AND    cliam.clia_crn_no                  = @pa_crn_no                      
      AND    clil.clim_status                   = 0                      
      AND    clil.clim_deleted_ind              = 1                       
                      
      UNION                      
                      
      SELECT DISTINCT compm.compm_id                  compm_id                      
           , compm.compm_short_name              compm_short_name                      
           , excsm.excsm_id                      excsm_id                      
           , excsm.excsm_exch_cd                 excsm_exch_cd                      
           , excsm.excsm_seg_cd                  excsm_seg_cd                      
           , clia.clia_acct_no                   acct_no                      
           , excpm.excpm_prom_id                 excpm_prom_id                      
           , prom.prom_desc                      prom_desc                      
           --, stam.stam_desc                      stam_desc                      
           --, brom.brom_desc                     brom_desc                       
           , clisbam.clisba_id                   clisba_id                                 
           , isnull(clisbam.clisba_no, 0)        clisba_no                      
           , isnull(clisbam.clisba_name, 0)      clisba_name                      
           --, CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,excsm.excsm_id)+'|*~|'+clia.clia_acct_no+'|*~|'+ISNULL(clisbam.clisba_no, 0)+'|*~|'+ISNULL(clisbam.clisba_name, 0)+'|*~|'+CONVERT(VARCHAR,excpm.excpm_prom_id)+'|*~|'+ISNULL(stam.stam_cd,'')+'|*~|Q' value  --*|~*                      
           , CASE clil.clim_ins_upd_del  WHEN 'I' THEN 'ADD'             
                                         WHEN 'E' THEN 'EDIT'                      
                                         WHEN 'D' THEN 'DELETE'                                 
                          END     Status                      
      FROM   client_sub_accts_mak                clisbam  WITH (NOLOCK)                      
           , client_accounts                     clia     WITH (NOLOCK)                      
           , excsm_prod_mstr                     excpm    WITH (NOLOCK)                    
           , exch_seg_mstr                       excsm    WITH (NOLOCK)                      
           , product_mstr       prom     WITH (NOLOCK)                      
           , company_mstr                        compm    WITH (NOLOCK)                      
           --, status_mstr                         stam     WITH (NOLOCK)                      
           --, brokerage_mstr                      brom     WITH (NOLOCK)                      
           , client_list                         clil     WITH (NOLOCK)                   
          , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                       
      WHERE  clisbam.clisba_crn_no              = clia.clia_crn_no                      
      AND    clisbam.clisba_acct_no             = clia.clia_acct_no                      
      AND    clisbam.clisba_excpm_id            = excpm.excpm_id                       
      AND    excsm.excsm_id                     = excpm.excpm_excsm_id                      
      AND    excsm.excsm_id                     = excsm_list.excsm_id                  
      AND    compm.compm_id                     = excsm.excsm_compm_id                      
      AND    prom.prom_id                       = excpm.excpm_prom_id                      
      --AND    clisbam.clisba_access2             = stam.stam_id         
      --AND    clisbam.clisba_brom                = brom.brom_id                      
      AND    clisbam.clisba_id                  = clil.clisba_no                      
      AND    clisbam.clisba_crn_no              = clil.clim_crn_no                      
      AND    ISNULL( citrus_usr.FN_GET_SINGLE_ACCESS( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc), 0) > 0                      
      AND    clisbam.clisba_deleted_ind         IN(0,4,8)                      
      AND    clia.clia_deleted_ind              = 1                      
      AND    excpm.excpm_deleted_ind            = 1                      
      AND    excsm.excsm_deleted_ind            = 1                      
      AND    prom.prom_deleted_ind              = 1                   
      AND    compm.compm_deleted_ind            = 1                      
      AND    clia.clia_crn_no                   = @pa_crn_no                      
      AND    clil.clim_status     = 0                      
      AND    clil.clim_deleted_ind              = 1                      
                      
                      
      UNION                      
                      
      SELECT DISTINCT compm.compm_id               compm_id                      
           , compm.compm_short_name       compm_short_name                      
           , excsm.excsm_id               excsm_id                      
           , excsm.excsm_exch_cd          excsm_exch_cd                      
           , excsm.excsm_seg_cd           excsm_seg_cd                      
           , clia.clia_acct_no            acct_no                      
           , excpm.excpm_prom_id          excpm_prom_id                      
           , prom.prom_desc          prom_desc                      
           --, stam.stam_desc               stam_desc                      
           --, brom.brom_desc               brom_desc                        
           , clisba.clisba_id             clisba_id                      
           , ISNULL(clisba.clisba_no, 0)  clisba_no                      
           , ISNULL(clisba.clisba_name, 0)clisba_name                      
           --, CONVERT(VARCHAR,compm.compm_id)+'|*~|'+ CONVERT(VARCHAR,excsm.excsm_id)+'|*~|'+clia.clia_acct_no+'|*~|'+ISNULL(clisba.clisba_no, 0)+'|*~|'+ISNULL(clisba.clisba_name, 0)+'|*~|'+ CONVERT(VARCHAR,excpm.excpm_prom_id)+'|*~|'+ISNULL(stam.stam_cd,'')+'|*~|Q' value                          
         , CASE clil.clim_ins_upd_del  WHEN 'I' THEN 'ADD'                      
                                         WHEN 'E' THEN 'EDIT'                      
                                         WHEN 'D' THEN 'DELETE'                                 
                                         END  Status                      
      FROM   client_accounts             clia    WITH (NOLOCK)                      
           , excsm_prod_mstr             excpm   WITH (NOLOCK)                      
           , exch_seg_mstr               excsm   WITH (NOLOCK)                      
           , product_mstr                prom    WITH (NOLOCK)                      
           , company_mstr                compm   WITH (NOLOCK)                      
           , status_mstr                 stam    WITH (NOLOCK)                      
           , client_list                 clil     WITH (NOLOCK)                      
           , client_sub_accts   clisba  WITH (NOLOCK)                    
    ,  citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                     
            -- left outer join                                    
            -- client_brokerage            clib    WITH (NOLOCK) on clisba_id          = clib_clisba_id                      
            -- left outer join                                    
            -- brokerage_mstr              brom    WITH (NOLOCK) on clib.clib_brom_id  = brom.brom_id                      
      WHERE  clisba.clisba_crn_no      = clia.clia_crn_no                      
      AND    clisba.clisba_acct_no   = clia.clia_acct_no                      
      AND    clisba.clisba_excpm_id  = excpm.excpm_id                       
      AND    excsm.excsm_id            = excpm.excpm_excsm_id                      
      AND    compm.compm_id            = excsm.excsm_compm_id                      
      AND    prom.prom_id              = excpm.excpm_prom_id                     
      AND    excsm.excsm_id            = excsm_list.excsm_id                   
      --AND    clisba.clisba_access2     = stam.stam_id                      
      AND    clisba.clisba_id          = clil.clisba_no                      
      AND    clisba.clisba_crn_no      = clil.clim_crn_no                      
      AND    ISNULL(citrus_usr.fn_get_single_access( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc), 0) > 0                      
      AND    clia.clia_deleted_ind     = 1                      
      AND    ISNULL(excsm.excsm_deleted_ind, 0) = 1                      
      AND    clisba.clisba_deleted_ind = 1                      
      AND    excpm.excpm_deleted_ind   = 1                      
      AND    prom.prom_deleted_ind     = 1                      
      AND    compm.compm_deleted_ind   = 1                      
      AND    clia.clia_crn_no          = @pa_crn_no                      
      AND    clisba.clisba_crn_no NOT IN ( SELECT clisbam.clisba_id clisba_id                      
                                           FROM   client_sub_accts_mak          clisbam                      
                                           WHERE  clisbam.clisba_deleted_ind IN (0, 4, 8)                      
                                           AND    clisbam.clisba_crn_no       = @pa_crn_no                      
                                       )                      
      AND    clil.clim_status                   = 0                      
      AND    clil.clim_deleted_ind              = 1                      
    --                        
    END                      
    IF @pa_tab = 'DPAM_FRMNO_CHK'          
    BEGIN          
		  IF ISNULL(@PA_CRN_NO,0) = 0          
		  BEGIN
			 select sum(cnt)
			 from(          
			 SELECT COUNT(DPAM_ACCT_NO) cnt FROM DP_ACCT_MSTR_MAK  , dp_mstr        
			 WHERE DPAM_DELETED_IND IN (0,8)        
			 AND DPAM_ACCT_NO = @PA_VALUE        
			 and  dpam_dpm_id = dpm_id
			 and  DPM_DPID = @pa_ACCT_NO

			 union 
		     
			 SELECT COUNT(DPAM_ACCT_NO) cnt FROM DP_ACCT_MSTR  , dp_mstr       
			 WHERE DPAM_DELETED_IND = 1
			 AND DPAM_ACCT_NO = @PA_VALUE
			 and  dpam_dpm_id = dpm_id
			 and  DPM_DPID = @pa_ACCT_NO) t
		  END        
		  ELSE
		  BEGIN
			 select sum(cnt)
			 from(          
			 SELECT COUNT(DPAM_ACCT_NO) cnt FROM DP_ACCT_MSTR_MAK  , dp_mstr        
			 WHERE DPAM_DELETED_IND IN (0,8)        
			 AND DPAM_ACCT_NO = @PA_VALUE        
			 and  dpam_dpm_id = dpm_id
			 and dpam_crn_no <> @pa_crn_no
			 and  DPM_DPID = @pa_ACCT_NO

			 union 
		     
			 SELECT COUNT(DPAM_ACCT_NO) cnt FROM DP_ACCT_MSTR  , dp_mstr       
			 WHERE DPAM_DELETED_IND = 1
			 AND DPAM_ACCT_NO = @PA_VALUE
			 and  dpam_dpm_id = dpm_id
			 and  dpam_crn_no <> @pa_crn_no
			 and  DPM_DPID = @pa_ACCT_NO) t
		  END        

      
    END                        
  --                      
  END                      
  ELSE IF @pa_chk_yn = 1                      
  BEGIN                      
  --                         
  IF @pa_tab = 'CLIM'                      
    BEGIN--CLIM                      
    --                      
      SELECT climm.clim_name1                   clim_name1                      
           , ISNULL(climm.clim_name2, '')       clim_name2                      
           , ISNULL(climm.clim_name3, '')       clim_name3              
           , climm.clim_short_name              clim_short_name                      
           , climm.clim_gender                  clim_gender                      
           , CASE WHEN CONVERT(VARCHAR,ISNULL(climm.clim_dob,''),103) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR,ISNULL(climm.clim_dob,''),103) END  clim_dob                      
           , enttm.enttm_cd                     enttm_cd                      
           , enttm.enttm_desc                   enttm_desc                      
           , climm.clim_stam_cd                 clim_stam_cd                      
           , clicm.clicm_cd                     clicm_cd                      
           , clicm.clicm_desc                   clicm_desc                       
           , ISNUll(climm.clim_rmks,'')         clim_rmks                      
           , isnull(climm.clim_sbum_id,0)       clim_sbum_id                        
           , isnull(sbum.sbum_desc,'')          sbum_desc                      
      FROM   client_mstr_mak                    climm   WITH (NOLOCK)                      
           , entity_type_mstr                   enttm  WITH (NOLOCK)                      
           , client_ctgry_mstr                  clicm  WITH (NOLOCK)                      
           , sbu_mstr                           sbum                      
      WHERE  isnull(climm.clim_enttm_cd,'CLIENT')              = enttm_cd                      
      AND    ISNULL(climm.clim_clicm_cd,'NOR')              = clicm.clicm_cd                      
      AND    climm.clim_sbum_id               = sbum.sbum_id                      
      AND    climm.clim_crn_no                = @pa_crn_no                      
      AND    climm.clim_deleted_ind           IN (0,8)                       
      AND    enttm.enttm_deleted_ind          = 1                      
      AND    clicm.clicm_deleted_ind          = 1                      
UNION                        
      SELECT clim.clim_name1                    clim_name1                      
           , ISNULL(clim.clim_name2, '')        clim_name2                      
           , ISNULL(clim.clim_name3, '')        clim_name3                      
           , clim.clim_short_name               clim_short_name       
           , clim.clim_gender                   clim_gender                      
           , CASE WHEN CONVERT(VARCHAR,ISNULL(clim.clim_dob,''),103) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR,ISNULL(clim.clim_dob,''),103) END clim_dob                      
           , enttm.enttm_cd                     enttm_cd                      
           , enttm.enttm_desc                   enttm_desc                      
           , clim.clim_stam_cd                  clim_stam_cd                      
           , clicm.clicm_cd                     clicm_cd                      
           , clicm.clicm_desc                   clicm_desc                       
           , ISNUll(clim.clim_rmks,'')  clim_rmks                      
           , isnull(clim.clim_sbum_id ,0)       clim_sbum_id                      
           , isnull(sbum.sbum_desc,'')          sbum_desc                      
      FROM   client_mstr                        clim   WITH (NOLOCK)                      
           , entity_type_mstr                   enttm  WITH (NOLOCK)                      
           , client_ctgry_mstr                  clicm  WITH (NOLOCK)                      
           , sbu_mstr                           sbum                      
      WHERE  ISNULL(clim.clim_enttm_cd,'CLIENT')               = enttm_cd                      
      AND    ISNULL(clim.clim_clicm_cd,'NOR')               = clicm.clicm_cd                      
      AND    clim.clim_sbum_id                = sbum.sbum_id                      
      AND    clim.clim_crn_no                 = @pa_crn_no                      
      AND    clim.clim_crn_no                 NOT IN (SELECT climm.clim_crn_no                       
                                                      FROM   client_mstr_mak          climm                      
                                                      WHERE  climm.clim_crn_no      = @pa_crn_no                       
                                                      AND    climm.clim_deleted_ind IN(0,4,8))                 
      AND    clim.clim_deleted_ind            = 1                      
      AND    enttm.enttm_deleted_ind          = 1                      
      AND    clicm.clicm_deleted_ind          = 1                      
                            
    --                      
    END--CLIM                      
    ELSE IF @pa_tab='ADDR'                      
    BEGIN                      
    --                 
      SELECT TOP 1 @I =  bitrm_bit_location FROM bitmap_ref_mstr WHERE bitrm_parent_cd = 'BUS_' + @pa_value  AND bitrm_deleted_ind = 1                    
                    
      SELECT concm.concm_cd               concm_cd                      
           , concm.concm_desc             concm_desc                      
           , ISNULL(addrm.adr_1, ' ')     adr_1                      
           , ISNULL(addrm.adr_concm_cd+@coldelimiter+isnull(addrm.adr_1,'')+@coldelimiter+isnull(addrm.adr_2,'')+@coldelimiter+isnull(addrm.adr_3,'')+@coldelimiter+isnull(addrm.adr_city,'')+@coldelimiter+isnull(addrm.adr_state,'')+@coldelimiter+isnull(addrm.adr_country,'')+@coldelimiter+isnull(addrm.adr_zip,''), ' ') value                      
       FROM   addresses_mak                addrm                      
             right OUTER JOIN                      
             conc_code_mstr               concm                       
      ON     concm.concm_id               = addrm.adr_concm_id       
      AND  addrm.adr_ent_id               = @pa_crn_no                      
      WHERE  concm.concm_deleted_ind      = 1                      
      AND    1 & concm.concm_cli_yn       = 1                      
      AND   2 & concm.concm_cli_yn        = 0                      
      AND    addrm.adr_deleted_ind        IN (0, 8)                       
      AND    power(2,@I-1) & concm.concm_cli_yn  > 0                   
                                  
      UNION                      
                            
      SELECT concm.concm_cd                   concm_cd                      
           , concm.concm_desc                 concm_desc            
           , ISNULL(a.adr_1, ' ')             adr_1                      
           , ISNULL(a.value, ' ')             value                      
      FROM  (SELECT entac.entac_concm_id      concm_id                      
                  , adr.adr_1                 adr_1                      
                  , entac.entac_concm_cd+@coldelimiter+adr.adr_1+@coldelimiter+adr.adr_2+@coldelimiter+adr.adr_3+@coldelimiter+adr.adr_city+@coldelimiter+adr.adr_state+@coldelimiter+adr.adr_country+@coldelimiter+adr.adr_zip   value                      
             FROM   addresses                 adr                      
                  , entity_adr_conc           entac                      
             WHERE  entac.entac_adr_conc_id = adr.adr_id                      
             AND    entac.entac_ent_id      = @pa_crn_no                      
 AND    adr.adr_deleted_ind     = 1                      
             AND    entac.entac_deleted_ind = 1                      
            ) a                      
            RIGHT OUTER JOIN                      
            conc_code_mstr                    concm  WITH (NOLOCK)                      
            ON concm.concm_id               = a.concm_id     
                               
      WHERE  concm.concm_deleted_ind        = 1                      
      AND    (concm.concm_cli_yn & 1)       = 1                      
      AND    (concm.concm_cli_yn & 2)       = 0                 
      AND    power(2,@I-1) & concm.concm_cli_yn  > 0                   
      AND    concm.concm_id NOT IN ( SELECT addrm.adr_concm_id       adr_concm_id                      
          FROM   addresses_mak            addrm                      
          WHERE  addrm.adr_ent_id       = @pa_crn_no                      
          AND    addrm.adr_deleted_ind IN (0, 4, 8)                      
                                    )                 
      ORDER BY concm_desc                      
                            
                            
                            
    --                      
    END                      
    ELSE IF @pa_tab = 'CONC'                      
    BEGIN                      
    --                    
                  
      SELECT TOP 1 @I = bitrm_bit_location FROM bitmap_ref_mstr WHERE bitrm_parent_cd = 'BUS_' + @pa_value  AND bitrm_deleted_ind = 1                    
                    
      SELECT concm.concm_cd                  concm_cd                      
, concm.concm_desc                concm_desc                      
           , ISNULL(concmak.conc_value, ' ') value               
           , case when isnumeric(concm.concm_rmks)= 1 then  convert(int ,concm.concm_rmks) else 0 end          
      FROM   contact_channels_mak            concmak                      
             RIGHT OUTER JOIN                      
             conc_code_mstr                   concm  WITH (NOLOCK)                      
             ON concm.concm_id=CONCMAK.CONC_concm_id AND concmak.conc_ent_id = @pa_crn_no                     
      WHERE  concm.concm_deleted_ind      = 1                      
      AND    1 & concm.concm_cli_yn         = 1                      
      AND    2 & concm.concm_cli_yn         = 2                      
      AND    power(2,@I-1) & concm.concm_cli_yn  > 0               
      AND    concmak.conc_deleted_ind  IN (0, 8)                       
                            
      UNION                      
      SELECT concm.concm_cd             concm_cd                      
           , concm.concm_desc                 concm_desc                      
           , ISNULL(a.conc_value, ' ')        value             
           ,case when isnumeric(concm.concm_rmks)= 1 then  convert(int ,concm.concm_rmks) else 0 end                   
      FROM  (SELECT entac.entac_concm_id      concm_id                      
                  , conc.conc_value           conc_value                      
             FROM   contact_channels          conc  WITH (NOLOCK)                      
                  , entity_adr_conc           entac WITH (NOLOCK)                      
             WHERE  entac.entac_adr_conc_id = conc.conc_id                      
             AND    entac.entac_ent_id      = @pa_crn_no                      
             AND    conc.conc_deleted_ind   = 1                      
             AND    entac.entac_deleted_ind = 1                      
             ) a                      
             RIGHT OUTER JOIN                      
             conc_code_mstr                   concm  WITH (NOLOCK)                      
             ON concm.concm_id=a.concm_id                      
                 
      WHERE  concm.concm_deleted_ind        = 1                      
      AND    1 & concm.concm_cli_yn         = 1                      
      AND    2 & concm.concm_cli_yn         = 2               
      AND    power(2,@I-1) & concm.concm_cli_yn  > 0               
      AND    concm.concm_id NOT IN ( SELECT concmak.conc_concm_id    conc_concm_id                      
          FROM   contact_channels_mak     concmak                      
          WHERE  concmak.conc_ent_id      = @pa_crn_no                      
          AND    concmak.conc_deleted_ind IN (0, 4, 8)                      
         )               
      ORDER  BY case when isnumeric(concm.concm_rmks)= 1 then  convert(int ,concm.concm_rmks) else 0 end , CONCM.CONCM_DESC                             
    --                      
    END                      
    ELSE IF @pa_tab = 'CLID'                      
    BEGIN--CLID                      
    --                      
      SELECT DISTINCT excsm.excsm_exch_cd          excsm_exch_cd                        
           , excsm.excsm_seg_cd                    excsm_seg_cd                        
           , prom.prom_id                          prom_id                        
           , ISNULL(prom.prom_desc,'')             prom_desc                      
           , ISNULL(clidm.clid_doc_path,'')         clid_doc_path                        
           , ISNULL(clidm.clid_remarks,'')          clid_remarks                          
           , docm.docm_doc_id                      docm_doc_id                        
           , ISNULL(docm.docm_desc,'')             docm_desc                        
 , docm.docm_clicm_id                    docm_clicm_id                        
           , CASE docm.docm_mdty WHEN 1 THEN 'M' ELSE 'N' END docm_mdty                        
           , CASE excsm_exch_cd  WHEN 'BSE'THEN CONVERT(VARCHAR,1) WHEN 'NSE'THEN CONVERT(VARCHAR,2) ELSE CONVERT(VARCHAR,3) END  ORD1                      
           , ISNULL(clidm.clid_valid_yn,0)          clid_valid_yn                      
   FROM  document_mstr         docm     WITH(NOLOCK)                        
             LEFT OUTER JOIN                       
             client_documents_mak  clidm                       
       ON    docm.docm_doc_id    = clidm.clid_docm_doc_id                      
       AND   clidm.clid_crn_no                    = @pa_crn_no                      
       AND   clidm.clid_deleted_ind               IN (0, 8)                        
             right outer join                     
             client_sub_accts_mak      clisba   WITH(NOLOCK) on clisba.clisba_excpm_id = docm.docm_excpm_id   and     ISNULL(clisba.clisba_crn_no, @pa_crn_no) = @pa_crn_no                       
           , exch_seg_mstr         excsm    WITH(NOLOCK)                        
           , excsm_prod_mstr       excpm    WITH(NOLOCK)                        
           , product_mstr          prom     WITH(NOLOCK)                   
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                       
      WHERE  docm.docm_excpm_id                   = excpm.excpm_id                        
      AND    prom.prom_id                         = excpm.excpm_prom_id                        
      AND    excpm.excpm_excsm_id                 = excsm.excsm_id                        
      AND    excsm_list.excsm_id                 = excsm.excsm_id                   
      AND    excpm.excpm_deleted_ind              = 1                        
      AND    prom.prom_deleted_ind                = 1                        
      AND    excsm.excsm_deleted_ind              = 1                        
      AND    docm.docm_deleted_ind                = 1                        
      AND    docm.docm_clicm_id                   = @pa_clicm_id                      
      AND    docm.docm_enttm_id                   = @pa_enttm_id                      
      AND    clidm.clid_docm_doc_id   NOT IN (SELECT clid_docm_doc_id FROM client_documents WHERE clid_crn_no = @pa_crn_no AND clid_deleted_ind = 1 )     
                            
      UNION                              
                      
      SELECT DISTINCT excsm.excsm_exch_cd          excsm_exch_cd                        
           , excsm.excsm_seg_cd                    excsm_seg_cd                        
           , prom.prom_id                          prom_id                        
           , ISNULL(prom.prom_desc,'')             prom_desc                      
           , ISNULL(clid.clid_doc_path,'')         clid_doc_path                        
           , ISNULL(clid.clid_remarks,'')          clid_remarks                          
           , docm.docm_doc_id                      docm_doc_id                        
           , ISNULL(docm.docm_desc,'')             docm_desc                        
           , docm.docm_clicm_id                    docm_clicm_id                        
           , CASE docm.docm_mdty WHEN 1 THEN 'M' ELSE 'N' END docm_mdty                        
           , CASE excsm_exch_cd  WHEN 'BSE'THEN CONVERT(VARCHAR,1) WHEN 'NSE'THEN CONVERT(VARCHAR,2) ELSE CONVERT(VARCHAR,3) END  ORD1                      
           , ISNULL(clid.clid_valid_yn,0)          clid_valid_yn                      
       FROM  document_mstr         docm     WITH(NOLOCK)                        
             left outer join                       
             client_documents      clid                       
       ON    docm.docm_doc_id = clid.clid_docm_doc_id                       
             right outer join                     
             (select  clisba_excpm_id   ,    clisba_crn_no   from client_sub_accts   union    
               select  clisba_excpm_id   ,    clisba_crn_no   from client_sub_accts_mak) clisba 
             on clisba.clisba_excpm_id = docm.docm_excpm_id   and     ISNULL(clisba.clisba_crn_no, @pa_crn_no) = @pa_crn_no                               
           , exch_seg_mstr         excsm    WITH(NOLOCK)                        
           , excsm_prod_mstr       excpm    WITH(NOLOCK)                        
           , product_mstr          prom     WITH(NOLOCK)                        
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
       WHERE docm.docm_excpm_id                   = excpm.excpm_id                        
       AND   prom.prom_id                         = excpm.excpm_prom_id                        
       AND   excpm.excpm_excsm_id                 = excsm.excsm_id                    
       AND    excsm_list.excsm_id                 = excsm.excsm_id                       
       AND   excpm.excpm_deleted_ind              = 1                        
       AND   ISNULL(clid_deleted_ind, 1)          = 1                      
       AND   prom.prom_deleted_ind                = 1                        
       AND   excsm.excsm_deleted_ind              = 1                        
       AND   docm.docm_deleted_ind                = 1                        
       AND   docm.docm_clicm_id                   = @pa_clicm_id                      
       AND   docm.docm_enttm_id                   = @pa_enttm_id                      
       AND   ISNULL(clid.clid_crn_no, 0) = @pa_crn_no                       
  AND   ISNULL(clid.clid_crn_no, 0) NOT IN ( SELECT clidm.clid_crn_no      clid_crn_no       
                                                           FROM   client_documents_mak      clidm                      
                                                           WHERE  clidm.clid_crn_no      =  @pa_crn_no                      
             AND    clidm.clid_deleted_ind IN (0, 4, 8))                      
       ORDER BY   ord1                      
           , excsm.excsm_seg_cd                      
           , prom_id                      
    --                                
    END--CLID                      
    ELSE IF @PA_TAB = 'CLIA'                      
    BEGIN--CLIA                      
    --                      
      SELECT DISTINCT a.clia_acct_no          acct_no                      
           , compm.compm_id                   compm_id                      
           , compm.compm_short_name           compm_short_name                      
           , a.excsm_exch_cd                  excsm_exch_cd                      
           , a.excsm_seg_cd                   excsm_seg_cd                      
           , a.excsm_id                       excsm_id                      
      FROM  (SELECT cliam.clia_acct_no        clia_acct_no                      
                  , excsm.excsm_compm_id      compm_id                      
                  , excsm.excsm_exch_cd       excsm_exch_cd                      
                  , excsm.excsm_seg_cd        excsm_seg_cd                      
                  , excsm.excsm_id            excsm_id                      
                  , citrus_usr.FN_GET_SINGLE_ACCESS (cliam.clia_crn_no, cliam.clia_acct_no,excsm.excsm_desc) access1                      
             FROM   client_accounts_mak       cliam  WITH (NOLOCK)                      
                  , exch_seg_mstr             excsm  WITH (NOLOCK)                      
                  , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
                                        
             WHERE  cliam.clia_crn_no       = @pa_crn_no                       
             AND    cliam.clia_excsm_id     =excsm.excsm_id                      
             AND    excsm_list.excsm_id                 = excsm.excsm_id                   
             AND    cliam.clia_deleted_ind  IN(0,8)                      
             AND    excsm.excsm_deleted_ind = 1                      
            ) A                      
           , company_mstr                     compm    WITH (NOLOCK)                      
      WHERE  a.compm_id                     = compm.compm_id                      
      AND    compm.compm_deleted_ind        = 1                      
      --AND    ISNULL(CONVERT(NUMERIC, access1), 0)              > 0                      
      UNION                         
      SELECT DISTINCT a.clia_acct_no          acct_no                      
           , compm.compm_id                   compm_id                      
           , compm.compm_short_name           compm_short_name                      
           , a.excsm_exch_cd                  excsm_exch_cd                      
           , a.excsm_seg_cd                   excsm_seg_cd                      
           , a.excsm_id                       excsm_id                      
      FROM  (SELECT clia.clia_acct_no         clia_acct_no                      
                  , excsm.excsm_compm_id      compm_id                      
                  , excsm.excsm_exch_cd       excsm_exch_cd                      
                  , excsm.excsm_seg_cd        excsm_seg_cd                      
                  , excsm.excsm_id            excsm_id                      
                  , citrus_usr.fn_get_single_access (clia.clia_crn_no, clia.clia_acct_no,excsm.excsm_desc) access1                      
             FROM   client_accounts           clia   WITH (NOLOCK)                      
                  , exch_seg_mstr             excsm  WITH (NOLOCK)               
                  , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
             WHERE  clia.clia_crn_no        = @pa_crn_no                                                       
             AND    excsm_list.excsm_id         = excsm.excsm_id                   
             AND    clia.clia_deleted_ind   = 1                      
             AND    excsm.excsm_deleted_ind = 1                      
            ) A                      
     , company_mstr                     compm    WITH (NOLOCK)                      
      WHERE  a.compm_id                     = compm.compm_id                      
      AND    compm.compm_deleted_ind        = 1                      
      AND    a.excsm_id                     NOT IN (SELECT cliam.clia_excsm_id       clia_excsm_id                      
                                                    FROM   client_accounts_mak       cliam                      
                                                    WHERE  cliam.clia_deleted_ind    IN (0, 4, 8)                      
                                                    AND    cliam.clia_crn_no       = @pa_crn_no)                      
      AND    ISNULL(CONVERT(NUMERIC, access1), 0)              > 0                      
                            
    --                      
    END--CLIA                        
    ELSE IF @PA_TAB = 'ENTM'                      
    BEGIN                      
    --                      
      SELECT @l_exists               = ISNULL(entm_parent_id,0)                               
      FROM   entity_mstr_mak           entmak   WITH (NOLOCK)                      
      WHERE  entmak.entm_id          = @pa_crn_no                      
      AND    entmak.entm_deleted_ind in (0,4,8)                      
                            
      IF ISNULL(@l_exists,0)=0                      
      BEGIN                      
      --                      
        SELECT @l_exists               = ISNULL(entm_parent_id,0)                               
        FROM   entity_mstr             entm    WITH (NOLOCK)                      
        WHERE  entm.entm_id          = @pa_crn_no                      
        AND    entm.entm_deleted_ind = 1                      
      --                      
      END                      
                            
      IF @L_EXISTS<>0                      
      BEGIN                      
      --                       
        SELECT a.entm_name1                     entm_name1                      
             , a.entm_name2                     entm_name2                      
             , a.entm_name3                     entm_name3                      
             , a.entm_short_name                           
             , a.enttm_desc                     enttm_desc                      
             , a.clicm_cd                       clicm_cd                      
             , a.clicm_desc                     clicm_desc                      
             , a.parent_id                      parent_id                      
             --, entm.entm_name1                  parent_name1                      
             , entm.entm_short_name             parent_name1                      
             , enttm.enttm_cd                   parent_type_cd                      
             , a.enttm_cd                       enttm_cd                           
             , ISNULL(a.entm_rmks,'')                      entm_rmks                      
        FROM  (SELECT entmak.entm_name1         entm_name1                      
                    , entmak.entm_name2         entm_name2                      
                    , entmak.entm_name3         entm_name3                      
                    , entmak.entm_short_name    entm_short_name                      
                    , enttm.enttm_desc          enttm_desc                      
                    , entmak.entm_parent_id     parent_id                      
     , clicm.clicm_cd            clicm_cd                      
                    , clicm.clicm_desc          clicm_desc                      
                    , enttm.enttm_cd            enttm_cd                      
             , entmak.entm_rmks          entm_rmks       
               FROM   entity_mstr_mak           entmak WITH (NOLOCK)                      
                    , entity_type_mstr          enttm  WITH (NOLOCK)                      
                    , client_ctgry_mstr         clicm  WITH (NOLOCK)                      
               WHERE  enttm.enttm_cd          = entmak.entm_enttm_cd                      
               AND    entmak.entm_clicm_cd    = clicm.clicm_cd                      
               AND    entmak.entm_id          = @pa_crn_no                      
               AND    entmak.entm_deleted_ind IN(0,8)                       
               AND    enttm.enttm_deleted_ind = 1                      
               AND    clicm.clicm_deleted_ind = 1                      
              )                                 a                      
             --,  entity_mstr_mak                 entmak WITH (NOLOCK)                      
             ,  entity_mstr                     entm   WITH (NOLOCK)               ,  entity_type_mstr                enttm  WITH (NOLOCK)                      
        WHERE   a.parent_id                   = entm.entm_id                      
        AND     enttm.enttm_cd                = entm.entm_enttm_cd                      
        AND     enttm.enttm_deleted_ind       = 1                      
        UNION                      
        SELECT a.entm_name1                     entm_name1                      
             , a.entm_name2                     entm_name2                   
             , a.entm_name3                     entm_name3                      
             , a.entm_short_name                       
             , a.enttm_desc                     enttm_desc                      
             , a.clicm_cd                       clicm_cd                      
             , a.clicm_desc                     clicm_desc                      
             , a.parent_id                      parent_id                      
             --, entm.entm_name1                parent_name1                      
             , entm.entm_short_name             parent_name1                      
             , enttm.enttm_cd   parent_type_cd                      
             , a.enttm_cd                       enttm_cd                           
             , ISNULL(a.entm_rmks,'')           entm_rmks                      
        FROM  (SELECT entm.entm_name1           entm_name1                      
                    , entm.entm_name2           entm_name2                      
                    , entm.entm_name3           entm_name3                      
                    , entm.entm_short_name      entm_short_name                      
                    , enttm.enttm_desc          enttm_desc                      
                    , entm.entm_parent_id       parent_id                      
                    , clicm.clicm_cd            clicm_cd                      
                    , clicm.clicm_desc          clicm_desc                      
                    , enttm.enttm_cd            enttm_cd                      
                    , entm.entm_rmks            entm_rmks                       
               FROM   entity_mstr               entm WITH (NOLOCK)                      
                    , entity_type_mstr          enttm  WITH (NOLOCK)                      
                    , client_ctgry_mstr         clicm  WITH (NOLOCK)                      
               WHERE  enttm.enttm_cd          = entm.entm_enttm_cd                      
               AND    entm.entm_clicm_cd      = clicm.clicm_cd                      
               AND    entm.entm_id            NOT IN (SELECT entmak.entm_id            entm_id                        
                                                      FROM   entity_mstr_mak           entmak                      
                                                      WHERE  entmak.entm_deleted_ind IN(0,4,8)                      
                         AND    entmak.entm_id          = @pa_crn_no                      
                              )                       
               AND    entm.entm_id            = @pa_crn_no                                                            
               AND    entm.entm_deleted_ind   = 1                      
               AND    enttm.enttm_deleted_ind = 1                      
               AND    clicm.clicm_deleted_ind = 1                      
              )                                 a                      
             ,  entity_mstr                     entm   WITH (NOLOCK)                      
             ,  entity_type_mstr                enttm  WITH (NOLOCK)                      
        WHERE   a.parent_id                   = entm.entm_id                      
        AND     enttm.enttm_cd                = entm.entm_enttm_cd                      
        AND     enttm.enttm_deleted_ind       = 1                      
                              
      --                      
      END                      
      ELSE                      
      BEGIN                      
      --                      
        SELECT entmak.entm_name1                 entm_name1                                   
             , entmak.entm_name2                 entm_name2                                   
             , entmak.entm_name3                 entm_name3                                   
             , entmak.entm_short_name 
             , enttm.enttm_desc                  enttm_desc                                   
             , clicm.clicm_cd                    clicm_cd                                     
             , clicm.clicm_desc                  clicm_desc                                   
             , isnull(entmak.entm_parent_id,0)   parent_id                                    
             --, entmak.entm_name1                 parent_name1                                 
             , ''                                parent_name1                                 
             , ''                                parent_type_cd                      
             , enttm.enttm_cd                    enttm_cd                       
             , ISNULL(entmak.entm_rmks,'')                 entm_rmks                      
        FROM   entity_mstr_mak                   entmak    WITH (NOLOCK)                                       
             , entity_type_mstr                  enttm   WITH (NOLOCK)                      
             , client_ctgry_mstr                 clicm   WITH (NOLOCK)                      
        WHERE  enttm.enttm_cd                  = entmak.entm_enttm_cd                      
        AND    entmak.entm_clicm_cd            = clicm.clicm_cd                      
        AND    entmak.entm_id                  = @pa_crn_no                      
        AND    entmak.entm_deleted_ind         IN (0,8)                      
        AND    enttm.enttm_deleted_ind         = 1                      
        AND    clicm.clicm_deleted_ind         = 1                      
        UNION                      
        SELECT entm.entm_name1                  entm_name1                                   
             , entm.entm_name2                  entm_name2                                   
             , entm.entm_name3                  entm_name3                                   
             , entm.entm_short_name 
             , enttm.enttm_desc                 enttm_desc                                   
             , clicm.clicm_cd                   clicm_cd                                     
             , clicm.clicm_desc                 clicm_desc                                   
             , isnull(entm.entm_parent_id,0)    parent_id                                    
             --, entm.entm_name1                  parent_name1                                 
, ''                               parent_name1                                 
             , ''                               parent_type_cd                      
             , enttm.enttm_cd                   enttm_cd                        
             , ISNULL(entm.entm_rmks,'')                   entm_rmks                      
      FROM   entity_mstr                      entm    WITH (NOLOCK)                                       
             , entity_type_mstr                 enttm   WITH (NOLOCK)                      
             , client_ctgry_mstr                clicm   WITH (NOLOCK)                      
        WHERE  enttm.enttm_cd                 = entm.entm_enttm_cd                      
        AND    entm.entm_clicm_cd             = clicm.clicm_cd                      
        AND    entm.entm_id                   NOT IN (SELECT entmak.entm_id            entm_id                        
                                                      FROM   entity_mstr_mak           entmak                      
                                                      WHERE  entmak.entm_deleted_ind IN(0,4,8)                      
                                                      AND    entmak.entm_id          = @pa_crn_no)                      
        AND    entm.entm_id                   = @pa_crn_no                                                                             
        AND    entm.entm_deleted_ind          = 1                      
        AND    enttm.enttm_deleted_ind        = 1                      
        AND    clicm.clicm_deleted_ind        = 1                      
                              
      --                      
      END                      
    --                      
    END                      
    IF @pa_tab = 'CLIBA'                      
    BEGIN                      
    --                      
      DECLARE @t_bank_accts   TABLE(acct_no    VARCHAR(25)                      
                          ,clisba_no        VARCHAR(25)                      
                                   ,cliba_ac_name    VARCHAR(50)                      
                                   ,cliba_banm_id    NUMERIC                      
                                   ,banm_name        VARCHAR(50)                      
                                   ,cliba_ac_type    VARCHAR(50)                      
    ,cliba_ac_no      VARCHAR(25)                      
                                   --,cliba_flg        CHAR(1)                      
                                   ,poa_flg          NUMERIC                        
                                   ,def_flg          NUMERIC                        
                                   ,compm_id         NUMERIC                      
                                   ,compm_short_name VARCHAR(25)                      
                                   ,excsm_exch_cd    VARCHAR(25)                      
                                   ,excsm_seg_cd     VARCHAR(25)                      
                                   ,excsm_id         NUMERIC)                      
                            
      INSERT INTO @t_bank_accts                       
      (acct_no                               
      ,clisba_no                             
      ,cliba_ac_name                         
      ,cliba_banm_id                         
      ,banm_name                             
      ,cliba_ac_type                         
      ,cliba_ac_no                           
      --,cliba_flg                             
      ,poa_flg                      
      ,def_flg                      
      ,compm_id                              
    ,compm_short_name                      
      ,excsm_exch_cd                         
      ,excsm_seg_cd                          
      ,excsm_id)                      
      SELECT cliam.clia_acct_no                  acct_no                      
           , clisbam.clisba_no                   clisba_no                      
           , clibam.cliba_ac_name                cliba_ac_name                      
           , clibam.cliba_banm_id                cliba_banm_id                      
           , ISNULL(banm.banm_name,'')+'-'+ISNULL(banm.banm_branch,'')+'-'+CONVERT(VARCHAR,ISNULL(BANM_MICR,0))  banm_name                      
           , clibam.cliba_ac_type                cliba_ac_type                      
           , clibam.cliba_ac_no                  cliba_ac_no                      
           --, clibam.cliba_flg                    cliba_flg                      
           , clibam.cliba_flg & 2             poa_flg                      
           , clibam.cliba_flg & 1                def_flg                      
           , compm.compm_id                      compm_id                      
    , compm.compm_short_name              compm_short_name                      
           , excsm.excsm_exch_cd                 excsm_exch_cd                      
           , excsm.excsm_seg_cd                  excsm_seg_cd                      
           , excsm.excsm_id                      excsm_id                      
      FROM   client_accounts_mak                 cliam    WITH (NOLOCK)                      
           , client_bank_accts_mak               clibam   WITH (NOLOCK)                      
           , client_sub_accts_mak                clisbam  WITH (NOLOCK)                      
           , bank_mstr                           banm     WITH (NOLOCK)                      
           , exch_seg_mstr                       excsm    WITH (NOLOCK)                      
           , company_mstr                        compm    WITH (NOLOCK)                      
           , excsm_prod_mstr                      excpm    WITH (NOLOCK)                     
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                   
      WHERE  compm.compm_id                      = excsm.excsm_compm_id                      
      AND    cliam.clia_excsm_id                 = excsm.excsm_id                      
      AND    excsm_list.excsm_id                 = excsm.excsm_id                   
      AND    clisbam.clisba_crn_no               = cliam.clia_crn_no                      
      AND    clisbam.clisba_acct_no              = cliam.clia_acct_no                      
      AND    clibam.cliba_clisba_id              = clisbam.clisba_id                      
      AND    banm.banm_id                        = clibam.cliba_banm_id                      
      AND    clisbam.clisba_excpm_id             = excpm.excpm_id                      
     AND    excsm.excsm_id                      = excpm.excpm_excsm_id                      
      AND    cliam.clia_deleted_ind              IN(0,8)                       
      AND    ISNULL(clisbam.clisba_deleted_ind, 0) IN (0,8)                      
      AND    clibam.cliba_deleted_ind            IN (0,8)                      
      AND    banm.banm_deleted_ind               = 1                      
      AND    excsm.excsm_deleted_ind             = 1                      
      AND    compm.compm_deleted_ind             = 1                      
      --AND    citrus_usr.FN_GET_SINGLE_ACCESS(clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc) <> 0                      
      AND    cliam.clia_crn_no             = @pa_crn_no                      
                            
      UNION                      
                            
      SELECT clia.clia_acct_no                   acct_no                      
           , clisbam.clisba_no                   clisba_no                      
           , clibam.cliba_ac_name                cliba_ac_name                      
           , clibam.cliba_banm_id                cliba_banm_id                      
           , ISNULL(banm.banm_name,'')+'-'+ISNULL(banm.banm_branch,'')+'-'+CONVERT(VARCHAR,ISNULL(BANM_MICR,0))  banm_name                      
           , clibam.cliba_ac_type                cliba_ac_type                      
           , clibam.cliba_ac_no          cliba_ac_no                      
           --, clibam.cliba_flg                    cliba_flg                      
           , clibam.cliba_flg & 2                poa_flg                      
           , clibam.cliba_flg & 1                def_flg                      
           , compm.compm_id                      compm_id                      
           , compm.compm_short_name              compm_short_name                      
           , excsm.excsm_exch_cd                 excsm_exch_cd                      
           , excsm.excsm_seg_cd                  excsm_seg_cd                      
           , excsm.excsm_id                      excsm_id                      
      FROM   client_accounts                     clia     WITH (NOLOCK)                      
           , client_bank_accts_mak               clibam   WITH (NOLOCK)                      
           , client_sub_accts_mak                clisbam  WITH (NOLOCK)                      
           , bank_mstr                           banm     WITH (NOLOCK)                      
           , exch_seg_mstr                     excsm    WITH (NOLOCK)                     
           , company_mstr                        compm    WITH (NOLOCK)                      
           , excsm_prod_mstr                     excpm    WITH (NOLOCK)                      
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
      WHERE  compm.compm_id                      = excsm.excsm_compm_id                      
      AND    clisbam.clisba_crn_no               = clia.clia_crn_no                      
      AND    excsm_list.excsm_id                 = excsm.excsm_id                   
      AND    clisbam.clisba_acct_no              = clia.clia_acct_no                      
      AND    clibam.cliba_clisba_id              = clisbam.clisba_id                      
      AND    banm.banm_id                        = clibam.cliba_banm_id                      
      AND    clisbam.clisba_excpm_id             = excpm.excpm_id                      
      AND    excsm.excsm_id                      = excpm.excpm_excsm_id                      
      AND    clia.clia_deleted_ind               = 1                      
      AND    ISNULL(clisbam.clisba_deleted_ind, 0) IN (0,8)                      
      AND    clibam.cliba_deleted_ind            IN (0,8)                      
      AND    banm.banm_deleted_ind               = 1                      
      AND    excsm.excsm_deleted_ind             = 1                      
      AND    compm.compm_deleted_ind             = 1                      
      AND    citrus_usr.FN_GET_SINGLE_ACCESS(clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc) > 0                      
      AND    clia.clia_crn_no                  = @pa_crn_no                      
                                  
      UNION                      
                                
      SELECT clia.clia_acct_no                   acct_no                      
           , clisba.clisba_no                    clisba_no                      
           , clibam.cliba_ac_name                cliba_ac_name                      
           , clibam.cliba_banm_id                cliba_banm_id                      
           , ISNULL(banm.banm_name,'')+'-'+ISNULL(banm.banm_branch,'')+'-'+CONVERT(VARCHAR,ISNULL(BANM_MICR,0))  banm_name                      
           , clibam.cliba_ac_type                cliba_ac_type                      
           , clibam.cliba_ac_no                  cliba_ac_no                      
           --, clibam.cliba_flg                     cliba_flg                      
           , clibam.cliba_flg & 2                poa_flg                      
           , clibam.cliba_flg & 1                def_flg                      
           , compm.compm_id                      compm_id                      
           , compm.compm_short_name              compm_short_name                      
           , excsm.excsm_exch_cd  excsm_exch_cd                      
           , excsm.excsm_seg_cd                  excsm_seg_cd                      
           , excsm.excsm_id                      excsm_id                      
      FROM   client_accounts                     clia     WITH (NOLOCK)                      
           , client_bank_accts_mak               clibam   WITH (NOLOCK)                      
           , client_sub_accts                    clisba   WITH (NOLOCK)                      
           , bank_mstr                   banm     WITH (NOLOCK)                      
  , exch_seg_mstr                       excsm    WITH (NOLOCK)                      
           , company_mstr                        compm    WITH (NOLOCK)                      
           , excsm_prod_mstr                     excpm    WITH (NOLOCK)                      
, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
      WHERE  compm.compm_id                      = excsm.excsm_compm_id                      
      AND    clisba.clisba_crn_no                = clia.clia_crn_no                      
      AND    clisba.clisba_acct_no               = clia.clia_acct_no                      
      AND    excsm_list.excsm_id                 = excsm.excsm_id                   
      AND    clibam.cliba_clisba_id              = clisba.clisba_id                      
      AND    banm.banm_id                = clibam.cliba_banm_id                      
      AND    clisba.clisba_excpm_id              = excpm.excpm_id                      
      AND    excsm.excsm_id                      = excpm.excpm_excsm_id                      
      AND    clia.clia_deleted_ind               = 1                      
      AND    ISNULL(clisba.clisba_deleted_ind, 1)= 1                      
      AND    clibam.cliba_deleted_ind            IN (0,8)                      
      AND    banm.banm_deleted_ind               = 1                      
      AND    excsm.excsm_deleted_ind             = 1                      
      AND    compm.compm_deleted_ind             = 1                      
      AND    citrus_usr.FN_GET_SINGLE_ACCESS(clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc) <> 0                      
      AND    clia.clia_crn_no                    = @pa_crn_no                      
      --                      
                            
      SELECT acct_no                               
             ,clisba_no                             
             ,cliba_ac_name                         
             ,cliba_banm_id                         
             ,banm_name                             
             ,cliba_ac_type                         
             ,cliba_ac_no                           
             --,cliba_flg                             
    ,poa_flg                      
             ,def_flg                      
             ,compm_id                              
             ,compm_short_name                      
     ,excsm_exch_cd                         
             ,excsm_seg_cd                          
             ,excsm_id                              
      FROM @t_bank_accts                      
                             
      UNION                      
                                  
      SELECT clia.clia_acct_no                   acct_no                      
           , clisba.clisba_no                    clisba_no                      
           , cliba.cliba_ac_name                 cliba_ac_name                      
           , cliba.cliba_banm_id                 cliba_banm_id                      
           , ISNULL(banm.banm_name,'')+'-'+ISNULL(banm.banm_branch,'')+'-'+CONVERT(VARCHAR,ISNULL(BANM_MICR,0))  banm_name                      
           , cliba.cliba_ac_type             cliba_ac_type                      
           , cliba.cliba_ac_no                   cliba_ac_no                      
           --, cliba.cliba_flg                     cliba_flg                      
           , cliba.cliba_flg & 2                 poa_flg                 
           , cliba.cliba_flg & 1                 def_flg                      
           , compm.compm_id                      compm_id                      
           , compm.compm_short_name              compm_short_name                      
           , excsm.excsm_exch_cd                 excsm_exch_cd                      
           , excsm.excsm_seg_cd                  excsm_seg_cd                      
           , excsm.excsm_id                      excsm_id                      
      FROM   client_accounts                     clia     WITH (NOLOCK)                      
           , client_bank_accts                   cliba    WITH (NOLOCK)                      
           , client_sub_accts                    clisba   WITH (NOLOCK)                      
           , bank_mstr                           banm     WITH (NOLOCK)                      
           , exch_seg_mstr                       excsm    WITH (NOLOCK)                      
           , company_mstr                        compm    WITH (NOLOCK)                      
           , excsm_prod_mstr                     excpm    WITH (NOLOCK)                      
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
      WHERE  compm.compm_id                    = excsm.excsm_compm_id                      
      AND    clisba.clisba_crn_no              = clia.clia_crn_no                      
      AND    clisba.clisba_acct_no             = clia.clia_acct_no                      
      AND    excsm_list.excsm_id                 = excsm.excsm_id                   
      AND    cliba.cliba_clisba_id             = clisba.clisba_id                      
      AND    banm.banm_id     = cliba.cliba_banm_id              
      AND    clisba.clisba_excpm_id            = excpm.excpm_id                      
      AND    excsm.excsm_id                    = excpm.excpm_excsm_id                      
      AND    clia.clia_deleted_ind             = 1                      
      AND    ISNULL(clisba.clisba_deleted_ind, 1) = 1                      
      AND    cliba.cliba_deleted_ind       =1                      
      AND    banm.banm_deleted_ind             = 1                      
      AND    excsm.excsm_deleted_ind           = 1                      
      AND    compm.compm_deleted_ind           = 1                      
      AND    clia.clia_crn_no                  = @pa_crn_no                      
      AND    citrus_usr.FN_GET_SINGLE_ACCESS(clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc) <> 0                      
      /*AND    clia.clia_crn_no                  NOT IN(SELECT clibam.cliba_deleted_ind  cliba_deleted_ind                       
                                                      FROM   client_bank_accts_mak     clibam                      
                                                            ,client_sub_accts          clisba                        
                                                      WHERE  clibam.cliba_clisba_id   =clisba.clisba_id                      
                                                      AND    clisba.clisba_crn_no     =@pa_crn_no                      
                                                      AND    clibam.cliba_deleted_ind IN (0,4,8))*/                      
      AND    NOT EXISTS (SELECT cliba_banm_id, cliba_compm_id, cliba_ac_no, cliba_clisba_id                      
                         FROM   client_bank_accts_mak    clibam                      
                              , client_sub_accts         clisba2                      
                         WHERE  clisba2.clisba_id      = clibam.cliba_clisba_id                      
                         AND    clibam.cliba_banm_id   = cliba.cliba_banm_id                      
                         AND    clibam.cliba_compm_id  = compm.compm_id                      
                         AND    clibam.cliba_ac_no     = cliba.cliba_ac_no                      
                         AND    clibam.cliba_clisba_id = cliba.cliba_clisba_id                      
                         AND    clibam.cliba_deleted_ind IN (0, 4, 8)                      
                   AND    clisba2.clisba_crn_no     = @pa_crn_no)                      
    --                      
    END                      
    ELSE IF @pa_tab = 'ENTD'                      
    BEGIN--ENTD                      
    --                      
      SELECT DISTINCT docm.docm_doc_id            docm_doc_id                      
           , docm.docm_desc                       docm_desc                      
           , clidm.clid_doc_path                   clid_doc_path                      
           , clidm.clid_remarks                    clid_remarks                      
           , CASE  docm.docm_mdty WHEN 1 THEN 'M' ELSE 'N' END  docm_mdty                      
           , ISNULL(clidm.clid_valid_yn,0)          clid_valid_yn                      
      FROM   client_documents_mak           clidm  WITH (NOLOCK)                      
             left outer join                      
             document_mstr                  docm  WITH (NOLOCK)                      
      ON     docm.docm_doc_id                     = clidm.clid_docm_doc_id                      
      WHERE  clidm.clid_deleted_ind               IN(0,8)                       
      AND    docm.docm_deleted_ind                = 1                      
      AND    ISNULL(clidm.clid_crn_no, @pa_crn_no)= @pa_crn_no                      
      AND    docm.docm_clicm_id                   = @pa_clicm_id                      
      AND    docm.docm_enttm_id                   = @pa_enttm_id                      
      UNION                      
      SELECT DISTINCT docm.docm_doc_id             docm_doc_id                      
           , docm.docm_desc                        docm_desc                      
           , clid.clid_doc_path                    clid_doc_path                      
           , clid.clid_remarks                     clid_remarks                      
           ,CASE  docm.docm_mdty WHEN 1 THEN 'M'  ELSE 'N' END  docm_mdty                      
           , ISNULL(clid.clid_valid_yn,0)          clid_valid_yn                      
      FROM   client_documents               clid   WITH (NOLOCK)                      
             left outer join                      
             document_mstr                  docm   WITH (NOLOCK)                      
      ON     docm.docm_doc_id                      = clid.clid_docm_doc_id                      
      WHERE  clid.clid_deleted_ind                 = 1                      
      AND    docm.docm_deleted_ind                 = 1                      
      AND    ISNULL(clid.clid_crn_no, @pa_crn_no)  NOT IN (SELECT clidm.clid_crn_no        clid_crn_no                       
                                                           FROM   client_documents_mak      clidm                      
                                                           WHERE  clidm.clid_deleted_ind   IN (0,4,8)                      
                                                           AND    clidm.clid_crn_no        = @pa_crn_no)                      
    AND    docm.docm_clicm_id                    = @pa_clicm_id                      
      AND    docm.docm_enttm_id                    = @pa_enttm_id                      
      AND    ISNULL(clid.clid_crn_no, @pa_crn_no)  = @pa_crn_no                      
      ORDER BY docm.docm_desc                      
    --                      
    END--ENTD                      
    ELSE IF @pa_tab = 'CLIDPA'                      
    BEGIN                      
    --                      
      DECLARE @t_dp_accts   TABLE(clidpa_dpm_id    NUMERIC                      
                                 ,dpm_name         VARCHAR(25)               
                                 ,dpm_dpid         VARCHAR(20)                      
                                 ,clidpa_dp_id     VARCHAR(20)                      
      ,clidpa_name      VARCHAR(25)                      
                                 ,poa_flg     CHAR(4)                      
                                 ,def_flg          CHAR(4)                      
                                 ,clidpa_poa_type  VARCHAR(25)                      
                                 ,compm_id         NUMERIC                      
                                 ,compm_short_name VARCHAR(25)                      
                                 ,excsm_exch_cd    VARCHAR(25)                      
                                 ,excsm_seg_cd     VARCHAR(25)                      
                                 ,acct_no          VARCHAR(25)                      
                                 ,clisba_no        VARCHAR(25)                       
 ,excsm_id         NUMERIC                      
                                 ,dpm_type         VARCHAR(25)                      
                                 ,clisba_excpm_id  numeric                      
                                 ,clisba_id        numeric)                      
                      
                      
      INSERT INTO @t_dp_accts                       
      (clidpa_dpm_id                         
      ,dpm_name                              
      ,dpm_dpid                              
      ,clidpa_dp_id                      
      ,clidpa_name                       
      ,poa_flg                               
      ,def_flg                               
      ,clidpa_poa_type                       
      ,compm_id                              
      ,compm_short_name                      
      ,excsm_exch_cd                         
      ,excsm_seg_cd                          
      ,acct_no                               
      ,clisba_no                             
      ,excsm_id                              
      ,dpm_type                      
      ,clisba_excpm_id                      
      ,clisba_id)                      
      SELECT clidpam.clidpa_dpm_id    clidpa_dpm_id                      
           , dpm.dpm_name                        dpm_name                      
           , dpm.dpm_dpid                        dpm_dpid                      
           , clidpam.clidpa_dp_id                clidpa_dp_id                      
           , clidpam.clidpa_name                 clidpa_name                      
           , clidpam.clidpa_flg & 1 poa_flg                      
           , clidpam.clidpa_flg & 2              def_flg                      
           , clidpam.clidpa_poa_type             clidpa_poa_type                      
           , compm.compm_id                      compm_id                      
           , compm.compm_short_name              compm_short_name                      
           , excsm.excsm_exch_cd                 excsm_exch_cd                      
           , excsm.excsm_seg_cd                  excsm_seg_cd                      
           , cliam.clia_acct_no                  acct_no                      
           , clisbam.clisba_no                   clisba_no                      
           , excsm.excsm_id                      excsm_id                      
           , excm.excm_cd                        dpm_type                      
           , clisbam.clisba_excpm_id             clisba_excpm_id                      
           , clisbam.clisba_id                   clisba_id                       
      FROM   client_accounts_mak        cliam     WITH (NOLOCK)                      
           , client_dp_accts_mak                 clidpam  WITH (NOLOCK)                      
           , client_sub_accts_mak                clisbam  WITH (NOLOCK)                      
           , dp_mstr                             dpm      WITH (NOLOCK)                     
           , exchange_mstr                       excm     WITH (NOLOCK)                     
           , exch_seg_mstr                       excsm    WITH (NOLOCK)                      
           , company_mstr            compm    WITH (NOLOCK)                      
           , excsm_prod_mstr                     excpm    WITH (NOLOCK)                      
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
      WHERE  compm.compm_id  = excsm.excsm_compm_id                      
      AND    clisbam.clisba_crn_no             = cliam.clia_crn_no                      
      AND    clisbam.clisba_acct_no            = cliam.clia_acct_no                      
      AND    cliam.clia_excsm_id               = excsm.excsm_id                      
      AND    excsm_list.excsm_id                 = excsm.excsm_id                   
      AND    clidpam.clidpa_clisba_id          = clisbam.clisba_id                      
      AND    dpm.dpm_id                        = clidpam.clidpa_dpm_id                      
      AND    clisbam.clisba_excpm_id           = excpm.excpm_id     
      AND    excsm.excsm_id                    = excpm.excpm_excsm_id                      
      --AND    excsm.excsm_id                    = dpm.dpm_excsm_id                     
      AND    excm.excm_cd                      = excsm.excsm_exch_cd                    
      AND    cliam.clia_deleted_ind             IN(0,8)                      
      AND    ISNULL(clisbam.clisba_deleted_ind,0) in (0,8)                       
      AND    clidpam.clidpa_deleted_ind        IN (0,8)                      
      AND    dpm.dpm_deleted_ind               = 1                      
      AND    excsm.excsm_deleted_ind           = 1                      
      AND    compm.compm_deleted_ind           = 1                    
      AND    excm.excm_deleted_ind             = 1                    
      --AND    citrus_usr.FN_GET_SINGLE_ACCESS( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc) <> 0                      
      AND    cliam.clia_crn_no                  = @pa_crn_no                      
                      
                      
      UNION                      
                      
      SELECT clidpam.clidpa_dpm_id               clidpa_dpm_id                      
           , dpm.dpm_name                        dpm_name                      
           , dpm.dpm_dpid                        dpm_dpid                      
           , clidpam.clidpa_dp_id                clidpa_dp_id                      
           , clidpam.clidpa_name                 clidpa_name                      
           , clidpam.clidpa_flg & 1              poa_flg                      
           , clidpam.clidpa_flg & 2              def_flg                      
           , clidpam.clidpa_poa_type             clidpa_poa_type                      
           , compm.compm_id                      compm_id               
           , compm.compm_short_name              compm_short_name                      
           , excsm.excsm_exch_cd                 excsm_exch_cd                      
           , excsm.excsm_seg_cd                  excsm_seg_cd                      
           , clia.clia_acct_no                   acct_no                      
           , clisbam.clisba_no                   clisba_no                      
           , excsm.excsm_id                      excsm_id                      
           , excm.excm_cd                        dpm_type                      
           , clisbam.clisba_excpm_id              clisba_excpm_id                      
           , clisbam.clisba_id                    clisba_id                       
      FROM   client_accounts                     clia     WITH (NOLOCK)                      
           , client_dp_accts_mak                 clidpam  WITH (NOLOCK)                      
           , client_sub_accts_mak                clisbam  WITH (NOLOCK)                      
           , dp_mstr                             dpm      WITH (NOLOCK)                      
           , exchange_mstr                       excm     WITH (NOLOCK)                    
           , exch_seg_mstr                       excsm    WITH (NOLOCK)                     
           , company_mstr                        compm    WITH (NOLOCK)                      
           , excsm_prod_mstr                     excpm    WITH (NOLOCK)                      
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
      WHERE  compm.compm_id                    = excsm.excsm_compm_id                      
      AND    clisbam.clisba_crn_no             = clia.clia_crn_no                      
      AND    clisbam.clisba_acct_no            = clia.clia_acct_no                      
      AND    clidpam.clidpa_clisba_id          = clisbam.clisba_id                      
      AND    dpm.dpm_id          = clidpam.clidpa_dpm_id                      
      AND    clisbam.clisba_excpm_id           = excpm.excpm_id                      
      AND    excsm.excsm_id                    = excpm.excpm_excsm_id                      
  --    AND    excsm.excsm_id                    = dpm.dpm_excsm_id                    
      AND    excsm_list.excsm_id                 = excsm.excsm_id                   
      AND    excm.excm_cd                      = excsm.excsm_exch_cd                    
      AND    CLIA.CLIA_DELETED_IND             = 1                      
      AND    ISNULL(clisbam.clisba_deleted_ind,0) in (0,8)                       
      AND    clidpam.clidpa_deleted_ind        IN (0,8)                      
      AND    dpm.dpm_deleted_ind               = 1                      
      AND    excsm.excsm_deleted_ind           = 1                      
      AND    compm.compm_deleted_ind           = 1                      
      AND    excm.excm_deleted_ind             = 1                      
      --AND    citrus_usr.FN_GET_SINGLE_ACCESS( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc) <> 0                      
      AND    clia.clia_crn_no                  = @pa_crn_no                      
                      
      UNION                      
                      
    SELECT clidpam.clidpa_dpm_id                clidpa_dpm_id                      
           , dpm.dpm_name                        dpm_name                      
           , dpm.dpm_dpid                   dpm_dpid                      
           , clidpam.clidpa_dp_id                 clidpa_dp_id                      
           , clidpam.clidpa_name                  clidpa_name                      
           , clidpam.clidpa_flg & 1               poa_flg                      
           , clidpam.clidpa_flg & 2               def_flg                      
           , clidpam.clidpa_poa_type              clidpa_poa_type                      
           , compm.compm_id                      compm_id                      
           , compm.compm_short_name              compm_short_name                      
           , excsm.excsm_exch_cd                 excsm_exch_cd                      
           , excsm.excsm_seg_cd                  excsm_seg_cd                      
           , clia.clia_acct_no                   acct_no                      
, clisba.clisba_no                    clisba_no                      
           , excsm.excsm_id                      excsm_id                      
           , excm.excm_cd                        dpm_type                      
           , clisba.clisba_excpm_id              clisba_excpm_id                     , clisba.clisba_id                    clisba_id                       
      FROM   client_accounts                     clia     WITH (NOLOCK)                      
           , client_dp_accts_mak                 clidpam  WITH (NOLOCK)                      
           , client_sub_accts                    clisba   WITH (NOLOCK)                      
           , dp_mstr                             dpm      WITH (NOLOCK)                      
           , exchange_mstr                       excm     WITH (NOLOCK)                      
           , exch_seg_mstr                       excsm    WITH (NOLOCK)                      
           , company_mstr                  compm    WITH (NOLOCK)                      
           , excsm_prod_mstr                     excpm    WITH (NOLOCK)                      
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
      WHERE  compm.compm_id                    = excsm.excsm_compm_id                      
      AND    clisba.clisba_crn_no              = clia.clia_crn_no                      
      AND    clisba.clisba_acct_no             = clia.clia_acct_no                      
      AND    clidpam.clidpa_clisba_id          = clisba.clisba_id                      
      AND    dpm.dpm_id                        = clidpam.clidpa_dpm_id                      
      AND    excsm_list.excsm_id                 = excsm.excsm_id                   
      AND    clisba.clisba_excpm_id            = excpm.excpm_id                      
      AND    excsm.excsm_id                    = excpm.excpm_excsm_id                      
  --    AND    dpm.dpm_excsm_id                  = excsm.excsm_id                  
      AND    excm.excm_cd                      = excsm.excsm_exch_cd                  
      AND    CLIA.CLIA_DELETED_IND             = 1                      
      AND    ISNULL(clisba.clisba_deleted_ind, 1) = 1                      
      AND    clidpam.clidpa_deleted_ind        IN (0,8)                      
      AND    dpm.dpm_deleted_ind               = 1                      
      AND    excsm.excsm_deleted_ind           = 1                      
      AND    compm.compm_deleted_ind           = 1                     
      AND    excm.excm_deleted_ind           = 1                     
      AND    citrus_usr.FN_GET_SINGLE_ACCESS( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc) <> 0                      
      AND    clia.clia_crn_no                  = @pa_crn_no                      
                      
                      
                           
                      
                      
      SELECT clidpa_dpm_id                         
            ,dpm_name                              
            ,dpm_dpid                              
            ,clidpa_dp_id                        
            ,clidpa_name                       
            ,poa_flg                               
            ,def_flg             
            ,clidpa_poa_type                       
            ,compm_id                              
            ,compm_short_name                      
            ,excsm_exch_cd                         
            ,excsm_seg_cd                          
            ,acct_no                            
            ,clisba_no                             
            ,excsm_id                              
            ,dpm_type                      
            ,clisba_excpm_id                      
            ,clisba_id                      
      FROM   @t_dp_accts                      
                      
      UNION                      
                      
      SELECT clidpa.clidpa_dpm_id                clidpa_dpm_id                      
           , dpm.dpm_name                        dpm_name                      
           , dpm.dpm_dpid                        dpm_dpid                      
           , clidpa.clidpa_dp_id                 clidpa_dp_id                      
           , clidpa.clidpa_name          clidpa_name                      
           , clidpa.clidpa_flg & 1 poa_flg                      
           , clidpa.clidpa_flg & 2               def_flg                      
           , clidpa.clidpa_poa_type              clidpa_poa_type                      
           , compm.compm_id                      compm_id                      
           , compm.compm_short_name              compm_short_name                      
           , excsm.excsm_exch_cd                 excsm_exch_cd                      
           , excsm.excsm_seg_cd                  excsm_seg_cd                      
           , clia.clia_acct_no                   acct_no                      
           , clisba.clisba_no                    clisba_no                      
           , excsm.excsm_id                      excsm_id                      
         , excm.excm_cd                        dpm_type                      
           , clisba.clisba_excpm_id              clisba_excpm_id                      
           , clisba.clisba_id                    clisba_id                       
      FROM   client_accounts                     clia     WITH (NOLOCK)                      
           , client_dp_accts                     clidpa   WITH (NOLOCK)                      
           , client_sub_accts                    clisba   WITH (NOLOCK)                      
           , dp_mstr                             dpm      WITH (NOLOCK)                      
           , exchange_mstr                       excm     WITH (NOLOCK)                      
           , exch_seg_mstr                       excsm    WITH (NOLOCK)                      
           , company_mstr                        compm    WITH (NOLOCK)                      
           , excsm_prod_mstr                     excpm    WITH (NOLOCK)                      
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
      WHERE  compm.compm_id                    = excsm.excsm_compm_id                      
      AND    clisba.clisba_crn_no              = clia.clia_crn_no                      
      AND    clisba.clisba_acct_no             = clia.clia_acct_no                      
      AND    clidpa.clidpa_clisba_id           = clisba.clisba_id                      
      AND    excsm_list.excsm_id                 = excsm.excsm_id                   
      AND    dpm.dpm_id                        = clidpa.clidpa_dpm_id                      
      AND    clisba.clisba_excpm_id            = excpm.excpm_id                      
      AND    excsm.excsm_id                    = excpm.excpm_excsm_id                      
  --    AND    excsm.excsm_id                    = dpm.dpm_excsm_id                     
     AND    excsm.excsm_exch_cd               = excm.excm_cd                    
      AND    CLIA.CLIA_DELETED_IND             = 1                      
      AND    ISNULL(clisba.clisba_deleted_ind, 1) = 1                      
      AND    clidpa.clidpa_deleted_ind         = 1                      
      AND    dpm.dpm_deleted_ind               = 1                      
      AND    excsm.excsm_deleted_ind           = 1                      
      AND    compm.compm_deleted_ind           = 1                     
      AND    excm.excm_deleted_ind           = 1                     
      AND    citrus_usr.FN_GET_SINGLE_ACCESS( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc) <> 0                      
      AND   NOT EXISTS  (SELECT clidpam.clidpa_deleted_ind  clidpa_deleted_ind                       
                                                       FROM   client_dp_accts_mak         clidpam                      
                                                             ,client_sub_accts            clisba2                        
                       WHERE  clidpam.clidpa_clisba_id   =clisba2.clisba_id                      
                                                       AND    clidpam.clidpa_dpm_id     = clidpa.clidpa_dpm_id                      
                                                       AND    clidpam.clidpa_compm_id   = compm.compm_id                      
                                                       AND    clidpam.clidpa_dp_id      = clidpa.clidpa_dp_id                      
                                                       AND    clidpam.clidpa_clisba_id  = clidpa.clidpa_clisba_id                      
                                                       AND    clisba2.clisba_crn_no     = @pa_crn_no                      
                                                       AND    clidpam.clidpa_deleted_ind IN (0,4,8))                      
      AND   clia.clia_crn_no    = @pa_crn_no                       
    --                      
    END                      
    ELSE IF @pa_tab = 'ENTP'                      
    BEGIN                      
    --                      
      SELECT x.entpm_prop_id       entpm_prop_id                      
           --, x.entpm_clicm_id      entpm_clicm_id                      
           --, x.entp_id             entp_id                      
           --, x.entpm_enttm_id      entpm_enttm_id                      
           --, x.entpm_cd            entpm_cd                      
           , isnull(x.entpm_desc,'')                  entpm_desc                      
           , isnull(x.entp_value,'')                  entp_value                      
           , isnull(entdm.entdm_id,0)                entdm_id                      
           --, entdm.entdm_cd        entdm_cd                      
           , isnull(entpdM.entpd_value,'')             entpd_value                      
           , isnull(entdm.entdm_desc,'')              entdm_desc                      
           , x.entpm_mdty          entpm_mdty                      
           , CASE entdm.entdm_mdty WHEN 1 THEN 'M' ELSE 'N' END entdm_mdty                      
           , x.entpm_datatype      entpm_datatype                      
           , entdm.entdm_datatype  entdm_datatype
		   ,x.entpm_desc                      
      FROM (SELECT DISTINCT entpm.entpm_enttm_id      entpm_enttm_id                      
                , entpm.entpm_prop_id                 entpm_prop_id                      
                --, isnull(entpmak.entp_value,'')     entp_value                      
                , CASE WHEN entpm.entpm_cd = 'INTRODUCER' THEN ISNULL(entpmak.entp_value,'DIRECT') ELSE ISNULL(entpmak.entp_value,'') END entp_value                      
                , entpm.entpm_cd                      entpm_cd                      
                , isnull(entpm.entpm_desc,'')         entpm_desc                          
                , entpm.entpm_clicm_id          entpm_clicm_id                          
                , entpmak.entp_id                     entp_id                      
                , entpmak.entp_ent_id                 entp_ent_id                      
                , CASE entpm.entpm_mdty WHEN 1 THEN 'M' ELSE 'N' END entpm_mdty                      
                , entpm.entpm_datatype                entpm_datatype                      
            FROM  entity_property_mstr     entpm   WITH(NOLOCK)                          
                  left outer join                       
                  entity_properties_mak    entpmak    WITH(NOLOCK)                       
            ON    entpm.entpm_prop_id         = entpmak.entp_entpm_prop_id AND ISNULL(entp_ent_id, 0) =@pa_crn_no AND  isnull(entp_deleted_ind, 0)  IN (0,4,8)                        
            WHERE  entpm.entpm_deleted_ind              = 1                          
            AND   entpm_clicm_id                       = @pa_clicm_id                      
            AND   entpm_enttm_id                       = @pa_enttm_id                      
         )                        
         x                      
      LEFT  OUTER JOIN                      
            entpm_dtls_mstr           entdm        WITH(NOLOCK)                        
      ON    (x.entpm_prop_id   = entdm.entdm_entpm_prop_id )                      
      LEFT  OUTER JOIN                      
            entity_property_dtls_mak  entpdm       WITH(NOLOCK)                         
      ON    (entdm.entdm_id = entpdm.entpd_entdm_id)  AND entpdm.entpd_entp_id IN (SELECT entp_id FROM entity_properties_MAK  WITH (NOLOCK) WHERE ENTP_ENT_ID = @pa_crn_no AND ENTP_DELETED_IND IN (0,8))                      
                            
      WHERE ISNULL(entdm_deleted_ind,1)  = 1                       
      AND ISNULL(entpdm.entpd_deleted_ind, 0) IN (0,4,8)                      
                            
      UNION                      
                            
      SELECT x.entpm_prop_id                         entpm_prop_id                      
           --, x.entpm_clicm_id      entpm_clicm_id                      
           --, x.entp_id             entp_id                      
           --, x.entpm_enttm_id      entpm_enttm_id                      
           --, x.entpm_cd            entpm_cd                      
           , isnull(x.entpm_desc,'')                 entpm_desc                      
           , isnull(x.entp_value,'')                 entp_value                      
           , isnull(entdm.entdm_id,0)                entdm_id                      
           --, entdm.entdm_cd        entdm_cd                      
           , isnull(entpd.entpd_value,'')            entpd_value                      
           , isnull(entdm.entdm_desc,'')             entdm_desc                      
           , x.entpm_mdty                            entpm_mdty                      
           , CASE entdm.entdm_mdty WHEN 1 THEN 'M' ELSE 'N' END entdm_mdty                      
           , x.entpm_datatype                        entpm_datatype                      
           , entdm.entdm_datatype                    entdm_datatype    
			,x.entpm_desc                  
      FROM (SELECT DISTINCT entpm.entpm_enttm_id      entpm_enttm_id                      
                 , entpm.entpm_prop_id                 entpm_prop_id                      
                 --, isnull(entp.entp_value,'')          entp_value                      
                 , CASE WHEN entp.entp_entpm_cd = 'INDRODUCER' THEN ISNULL(entp.entp_value,'DIRECT') ELSE ISNULL(entp.entp_value,'') END entp_value                      
                 , entpm.entpm_cd                      entpm_cd                      
                 , isnull(entpm.entpm_desc,'')         entpm_desc                          
                 , entpm.entpm_clicm_id                entpm_clicm_id                          
                 , entp.entp_id                        entp_id                      
                 , entp.entp_ent_id                    entp_ent_id                      
                 , CASE entpm.entpm_mdty WHEN 1 THEN 'M' ELSE 'N' END entpm_mdty                      
                 , entpm.entpm_datatype                entpm_datatype                      
            FROM  entity_property_mstr    entpm   WITH(NOLOCK)                          
                  left outer join                       
                 entity_properties       entp    WITH(NOLOCK)                       
            ON    entpm.entpm_prop_id                  = entp.entp_entpm_prop_id AND ISNULL(entp_ent_id, 0) =@pa_crn_no                      
            WHERE isnull(entp_deleted_ind, 1)          = 1                        
            AND   entpm.entpm_deleted_ind              = 1                          
            AND   entpm_clicm_id                       = @pa_clicm_id                      
            AND   entpm_enttm_id                       = @pa_enttm_id)  x                      
      LEFT OUTER JOIN                      
            entpm_dtls_mstr       entdm     WITH(NOLOCK)                        
      ON    (x.entpm_prop_id   = entdm.entdm_entpm_prop_id )                      
      LEFT OUTER JOIN                      
            entity_property_dtls entpd      WITH(NOLOCK)                         
      ON    (entdm.entdm_id = entpd.entpd_entdm_id) AND entpd.entpd_entp_id IN (SELECT entp_id FROM entity_properties_MAK  WITH (NOLOCK) WHERE ENTP_ENT_ID = @pa_crn_no AND ENTP_DELETED_IND IN (0,8))                      
      WHERE ISNULL(entdm_deleted_ind,1)             = 1                        
      AND   ISNULL(entpd.entpd_deleted_ind, 1)      = 1                       
      AND   entp_value                              <> ''                      
      AND   ISNULL(x.entp_ent_id,0)                 NOT IN (SELECT entp_ent_id                       
                                                            FROM   entity_properties_mak    entpmak           
                                                                  ,entity_property_dtls_mak entpdm                      
                                                     WHERE  entpdm.entpd_entp_id= entpmak.entp_id                      
                                    AND    entpmak.entp_ent_id = @pa_crn_no                      
                                                            AND    entpmak.entp_deleted_ind IN (0,4,8)                      
                                                            AND    entpdm.entpd_deleted_ind IN (0,4,8))                      
                            
      ORDER BY x.entpm_desc                      
    --                      
    END                      
    ELSE IF @pa_tab = 'CLISBA'                      
    BEGIN                      
    --                      
      SELECT compm.compm_id                      compm_id                      
           , compm.compm_short_name              compm_short_name                      
           , excsm.excsm_id                      excsm_id                      
           , excsm.excsm_exch_cd                 excsm_exch_cd                      
           , excsm.excsm_seg_cd                  excsm_seg_cd                      
           , cliam.clia_acct_no                  acct_no                      
           , excpm.excpm_prom_id                 excpm_prom_id                      
           , prom.prom_desc                      prom_desc                      
           , stam.stam_desc                      stam_desc                      
           , brom.brom_desc                      brom_desc                        
           , clisbam.clisba_id                   clisba_id                      
           , isnull(clisbam.clisba_no, 0)        clisba_no                      
           , isnull(clisbam.clisba_name, 0)      clisba_name                      
                              
           , CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,excsm.excsm_id)+'|*~|'+cliam.clia_acct_no+'|*~|'+ISNULL(clisbam.clisba_no, 0)+'|*~|'+ISNULL(clisbam.clisba_name, 0)+'|*~|'+CONVERT(VARCHAR,excpm.excpm_id)+'|*~|'+ISNULL(stam.stam_cd,'')+
  
    
      
        
          
            
              
                
                  
'|*~|'+convert(varchar, isnull(Brom.brom_id,''))+'|*~|Q' value  --*|~*                      
      FROM   client_sub_accts_mak                clisbam  WITH (NOLOCK)                      
           , client_accounts_mak                 cliam    WITH (NOLOCK)                      
           , excsm_prod_mstr                     excpm    WITH (NOLOCK)                      
           , exch_seg_mstr                       excsm    WITH (NOLOCK)                      
           , product_mstr                        prom     WITH (NOLOCK)                      
           , company_mstr                        compm    WITH (NOLOCK)                      
           , status_mstr                         stam     WITH (NOLOCK)                      
           , brokerage_mstr                      brom     WITH (NOLOCK)                      
       , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
      WHERE  clisbam.clisba_crn_no              = cliam.clia_crn_no                      
      AND    clisbam.clisba_acct_no             = cliam.clia_acct_no                      
      AND    clisbam.clisba_excpm_id            = excpm.excpm_id                       
      AND    excsm_list.excsm_id                 = excsm.excsm_id                   
      AND    excsm.excsm_id                     = excpm.excpm_excsm_id                      
      AND CLIA_EXCSM_ID =   excsm.excsm_id
      AND    compm.compm_id                     = excsm.excsm_compm_id                      
      AND    prom.prom_id                       = excpm.excpm_prom_id                      
      AND    clisbam.clisba_access2             = stam.stam_id                      
      AND    clisbam.clisba_brom                = brom.brom_id                    
      AND    clisbam.clisba_excpm_id            = brom.brom_excpm_id                    
      --AND    ISNULL( citrus_usr.FN_GET_SINGLE_ACCESS( cliam.clia_crn_no, cliam.clia_acct_no, excsm.excsm_desc), 0) > 0                      
      AND    clisbam.clisba_deleted_ind         IN(0,8)                      
      AND    cliam.clia_deleted_ind             IN(0,8)                      
      AND    excpm.excpm_deleted_ind            = 1                      
      AND    excsm.excsm_deleted_ind            = 1                      
      AND    prom.prom_deleted_ind              = 1                      
      AND    compm.compm_deleted_ind            = 1                      
      AND    cliam.clia_crn_no                = @pa_crn_no                      
                            
      UNION                      
                            
      SELECT compm.compm_id                      compm_id                      
           , compm.compm_short_name              compm_short_name                      
           , excsm.excsm_id                      excsm_id                      
           , excsm.excsm_exch_cd                 excsm_exch_cd                      
           , excsm.excsm_seg_cd                  excsm_seg_cd                      
           , clia.clia_acct_no                   acct_no                      
           , excpm.excpm_prom_id                 excpm_prom_id                      
           , prom.prom_desc                      prom_desc                      
           , stam.stam_desc                      stam_desc                      
           , brom.brom_desc                     brom_desc              
           , clisbam.clisba_id                   clisba_id                                 
           , isnull(clisbam.clisba_no, 0)        clisba_no                      
           , isnull(clisbam.clisba_name, 0)      clisba_name                      
           , CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,excsm.excsm_id)+'|*~|'+clia.clia_acct_no+'|*~|'+ISNULL(clisbam.clisba_no, 0)+'|*~|'+ISNULL(clisbam.clisba_name, 0)+'|*~|'+CONVERT(VARCHAR,excpm.excpm_id)+'|*~|'+ISNULL(stam.stam_cd,'')+' 
 
     
      
        
         
|            
              
                
                  
*~|'+convert(varchar, isnull(Brom.brom_id,''))+'|*~|Q' value  --*|~*                      
      FROM   client_sub_accts_mak                clisbam  WITH (NOLOCK)                      
           , client_accounts                     clia     WITH (NOLOCK)                      
           , excsm_prod_mstr                     excpm    WITH (NOLOCK)                      
           , exch_seg_mstr                       excsm    WITH (NOLOCK)                      
           , product_mstr                        prom     WITH (NOLOCK)                      
           , company_mstr                        compm    WITH (NOLOCK)                      
           , status_mstr                         stam     WITH (NOLOCK)                      
           , brokerage_mstr                      brom     WITH (NOLOCK)                      
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
      WHERE  clisbam.clisba_crn_no              = clia.clia_crn_no                      
      AND    clisbam.clisba_acct_no             = clia.clia_acct_no            
      AND    clisbam.clisba_excpm_id            = excpm.excpm_id                       
      AND    excsm_list.excsm_id                 = excsm.excsm_id                   
      AND    excsm.excsm_id                     = excpm.excpm_excsm_id                      
      AND    compm.compm_id                     = excsm.excsm_compm_id                      
      AND    prom.prom_id                       = excpm.excpm_prom_id                      
      AND    clisbam.clisba_access2             = stam.stam_id                      
      AND    clisbam.clisba_excpm_id            = brom.brom_excpm_id                    
      AND    clisbam.clisba_brom             = brom.brom_id                  
      AND    ISNULL( citrus_usr.FN_GET_SINGLE_ACCESS( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc), 0) > 0                      
      AND    clisbam.clisba_deleted_ind         IN(0,8)                      
      AND    clia.clia_deleted_ind              = 1                      
      AND    excpm.excpm_deleted_ind            = 1                      
      AND    excsm.excsm_deleted_ind            = 1                      
      AND    prom.prom_deleted_ind              = 1                      
      AND    compm.compm_deleted_ind            = 1                      
      AND    clia.clia_crn_no                   = @pa_crn_no                      
                            
                            
      UNION                      
                            
      SELECT compm.compm_id               compm_id                      
           , compm.compm_short_name       compm_short_name                  
           , excsm.excsm_id               excsm_id                      
           , excsm.excsm_exch_cd          excsm_exch_cd                      
           , excsm.excsm_seg_cd           excsm_seg_cd                      
           , clia.clia_acct_no  acct_no                      
           , excpm.excpm_prom_id          excpm_prom_id                   
           , prom.prom_desc               prom_desc                      
           , stam.stam_desc               stam_desc                      
           , brom.brom_desc               brom_desc                        
           , clisba.clisba_id             clisba_id                      
           , ISNULL(clisba.clisba_no, 0)  clisba_no                      
           , ISNULL(clisba.clisba_name, 0)clisba_name             
           , CONVERT(VARCHAR,compm.compm_id)+'|*~|'+ CONVERT(VARCHAR,excsm.excsm_id)+'|*~|'+clia.clia_acct_no+'|*~|'+ISNULL(clisba.clisba_no, 0)+'|*~|'+ISNULL(clisba.clisba_name, 0)+'|*~|'+ CONVERT(VARCHAR,excpm.excpm_id)+'|*~|'+ISNULL(stam.stam_cd,'')+'
  
    
      
         
         
             
             
                 
                 
|*~|'+convert(varchar, isnull(Brom.brom_id,''))+'|*~|Q' value                          
      FROM   client_accounts             clia    WITH (NOLOCK)                      
           , excsm_prod_mstr             excpm   WITH (NOLOCK)                      
           , exch_seg_mstr               excsm   WITH (NOLOCK)                      
           , product_mstr                prom    WITH (NOLOCK)                      
           , company_mstr                compm   WITH (NOLOCK)                      
           , status_mstr                 stam    WITH (NOLOCK)                      
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
           , client_sub_accts            clisba  WITH (NOLOCK)                      
             left outer join                                    
             client_brokerage            clib    WITH (NOLOCK) on clisba_id          = clib_clisba_id                      
             left outer join                                    
             brokerage_mstr              brom    WITH (NOLOCK) on clib.clib_brom_id  = brom.brom_id                      
      WHERE  clisba.clisba_crn_no      = clia.clia_crn_no                      
      AND    clisba.clisba_acct_no     = clia.clia_acct_no                      
      AND    clisba.clisba_excpm_id    = excpm.excpm_id                       
      AND    excsm.excsm_id   = excpm.excpm_excsm_id                      
      AND excsm_list.excsm_id                 = excsm.excsm_id                   
      AND    compm.compm_id            = excsm.excsm_compm_id                      
      AND    prom.prom_id              = excpm.excpm_prom_id                   
      AND    clisba.clisba_access2     = stam.stam_id                      
      AND    clisba.clisba_excpm_id    = brom.brom_excpm_id                      
AND    ISNULL(citrus_usr.fn_get_single_access( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc), 0) > 0                      
      AND    clia.clia_deleted_ind     = 1                      
      AND    ISNULL(excsm.excsm_deleted_ind, 0) = 1                      
      AND    clisba.clisba_deleted_ind = 1                      
      AND    excpm.excpm_deleted_ind   = 1                      
      AND    prom.prom_deleted_ind     = 1                      
      AND    compm.compm_deleted_ind   = 1                      
      AND    clia.clia_crn_no          = @pa_crn_no                      
      AND    clisba.clisba_crn_no NOT IN ( SELECT clisbam.clisba_id             clisba_id                      
                                           FROM   client_sub_accts_mak          clisbam                      
                                           WHERE  clisbam.clisba_deleted_ind IN (0, 4, 8)                      
                                           AND    clisbam.clisba_crn_no       = @pa_crn_no                      
                                         )                      
                            
    --                      
    END                      
    ELSE IF @pa_tab = 'CLIP'                      
    BEGIN                      
    --                      
      SELECT x.excsm_exch_cd       excsm_exch_cd             
           , x.excsm_seg_cd        excsm_seg_cd                         
           , x.prom_id             prom_id                       
           , x.prom_desc           prom_desc                      
           , x.entpm_prop_id       entpm_prop_id                      
         --, x.entpm_clicm_id      entpm_clicm_id                      
         --, x.entp_id             entp_id                      
         --, x.entpm_enttm_id      entpm_enttm_id                      
         --, x.entpm_id            entpm_id                      
           , x.entpm_cd             entpm_cd                       
           , isnull(x.entpm_desc,'') entpm_desc                      
           , isnull(x.entp_value,'') entp_value                      
           , isnull(y.entdm_id,0)   entdm_id                      
           , y.entdm_cd            entdm_cd                      
           , isnull(y.entpd_value,'')         entpd_value                      
           , y.entdm_desc          entdm_desc                      
           , y.entdm_mdty          entdm_mdty                      
           , x.entpm_mdty          entpm_mdty                      
           , X.ENTPM_DATATYPE      ENTPM_DATATYPE                      
           , Y.ENTDM_DATATYPE      ENTDM_DATATYPE                      
           , X.ord1                ord1      
			 , x.entpm_desc                
        FROM (SELECT DISTINCT excsm.excsm_exch_cd        excsm_exch_cd                          
                   , excsm.excsm_seg_cd                  excsm_seg_cd                          
                   , prom.prom_id                        prom_id                       
                   , entpm.entpm_enttm_id                entpm_enttm_id                      
                   , isnull(prom.prom_desc,'')           prom_desc                        
                   --, isnull(entpmak.entp_value,'')       entp_value                      
                   , CASE WHEN entpm.entpm_cd  = 'INTRODUCER' THEN ISNULL(entpmak.entp_value,'DIRECT') ELSE ISNULL(entpmak.entp_value,'') END entp_value                      
                   , entpm.entpm_prop_id                 entpm_prop_id                      
                   , entpm.entpm_cd                      entpm_cd                   , isnull(entpm.entpm_desc,'')         entpm_desc                          
                   , entpm.entpm_clicm_id                entpm_clicm_id                          
                   , entpmak.entp_id                     entp_id                   , entpm.entpm_id                      entpm_id                      
                   , entpmak.entp_ent_id                 entp_ent_id                      
                   , CASE entpm.entpm_mdty  WHEN 1 THEN 'M' ELSE 'N' END entpm_mdty                      
                   , CASE excsm_exch_cd     WHEN 'BSE'THEN CONVERT(VARCHAR,1) WHEN 'NSE'THEN CONVERT(VARCHAR,2) ELSE CONVERT(VARCHAR,3) END  ord1                        
                   , entpm.entpm_datatype                entpm_datatype                      
        FROM  entity_property_mstr          entpm   WITH(NOLOCK)                          
              left outer join                              
              (select entp_id,entp_ent_id,entp_deleted_ind,entp_ENTPM_PROP_id,entp_value from entity_properties_mak WHERE ENTP_ENT_ID = @PA_CRN_NO union select entp_id,entp_ent_id,entp_deleted_ind,entp_ENTPM_PROP_id,entp_value from entity_properties WHERE ENTP_ENT_ID = @PA_CRN_NO )   entpmak 
        ON    entpm.entpm_prop_id         = entpmak.entp_entpm_prop_id AND   ISNULL(entpmak.entp_ent_id, 0)      = @pa_crn_no AND   ISNULL(entpmak.entp_deleted_ind, 0) IN (0,8)                      
              right outer join                       
              (SELECT clisba_excpm_id, clisba_crn_no FROM client_sub_accts_mak WHERE CLISBA_CRN_NO = @pa_crn_no    UNION SELECT clisba_excpm_id, clisba_crn_no FROM client_sub_accts WHERE CLISBA_CRN_NO = @PA_CRN_NO)           clisba  
              ON    clisba.clisba_excpm_id      = entpm.entpm_excpm_id         
              AND   clisba.clisba_crn_no        = @pa_crn_no        
            , exch_seg_mstr                 excsm   WITH(NOLOCK)                          
            , excsm_prod_mstr               excpm   WITH(NOLOCK)                          
            , product_mstr                  prom    WITH(NOLOCK)                          
            , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
        WHERE entpm.entpm_excpm_id        = excpm.excpm_id                          
        AND   prom.prom_id                = excpm.excpm_prom_id                 
        AND   excpm.excpm_excsm_id        = excsm.excsm_id                          
        AND   excpm.excpm_deleted_ind     = 1                          
        AND    excsm_list.excsm_id                 = excsm.excsm_id                                 
        AND   prom.prom_deleted_ind       = 1                          
        AND   excsm.excsm_deleted_ind     = 1                          
        AND   entpm.entpm_deleted_ind     = 1                          
        AND   entpm_clicm_id              = @pa_clicm_id                      
        AND   entpm_enttm_id              = @pa_enttm_id                      
        AND   entpmak.entp_ENTPM_PROP_id      NOT IN(SELECT ENTP_ENTPM_PROP_ID FROM ENTITY_PROPERTIES WHERE  ENTP_DELETED_IND = 1 AND ENTP_ENT_ID =@PA_CRN_NO)                      
       ) X                      
        LEFT OUTER JOIN                      
       (SELECT a.entdm_entpm_prop_id     entdm_entpm_id                      
             , b.entpd_entp_id           entpd_entp_id                      
             , a.entdm_cd                entdm_cd                      
             , a.entdm_id                entdm_id                      
             , b.entpd_value             entpd_value                      
             , a.entdm_desc              entdm_desc               
             , a.entdm_entpm_prop_id     entdm_entpm_prop_id                      
             , A.ENTDM_DATATYPE          ENTDM_DATATYPE                       
             , CASE a.entdm_mdty  WHEN 1 THEN 'M' ELSE 'N' END entdm_mdty                      
        FROM   entpm_dtls_mstr a         WITH (NOLOCK)                      
               left outer join                      
               (select entpd_entp_id, entpd_value, entpd_entdm_id , entpd_deleted_ind from entity_property_dtls_mak union select entpd_entp_id, entpd_value, entpd_entdm_id , entpd_deleted_ind  from entity_property_dtls) b 
                      
        ON  (a.entdm_id     = b.entpd_entdm_id) AND entpd_entp_id IN (SELECT entp_id FROM entity_properties_MAK  WITH (NOLOCK) WHERE ENTP_ENT_ID = @pa_crn_no AND ENTP_DELETED_IND IN (0,8))                      
        WHERE a.entdm_deleted_ind = 1 AND ISNULL(b.entpd_deleted_ind,0) IN(0,8)                      
       ) y                      
       ON (x.entpm_prop_id  = y.entdm_entpm_prop_id)                      
      union
      SELECT x.excsm_exch_cd       excsm_exch_cd                      
           , x.excsm_seg_cd        excsm_seg_cd                 
           , x.prom_id             prom_id                       
           , x.prom_desc           prom_desc                      
           , x.entpm_prop_id       entpm_prop_id                      
           --, x.entpm_clicm_id      entpm_clicm_id                      
           --, x.entp_id             entp_id                      
           --, x.entpm_enttm_id      entpm_enttm_id                      
           --, x.entpm_id            entpm_id                      
           , x.entpm_cd               entpm_cd                      
           , isnull(x.entpm_desc,'')  entpm_desc                      
           , isnull(x.entp_value,'')  entp_value                      
           , isnull(y.entdm_id,0)     entdm_id                      
           , y.entdm_cd               entdm_cd                      
           , isnull(y.entpd_value,'') entpd_value                      
           , y.entdm_desc          entdm_desc                      
           , y.entdm_mdty          entdm_mdty                      
           , x.entpm_mdty          entpm_mdty                      
           , X.entpm_datatype      entpm_datatype                      
           , Y.entdm_datatype      entdm_datatype                      
           , X.ord1                ord1     
			 , x.entpm_desc                 
        FROM (SELECT DISTINCT excsm.excsm_exch_cd        excsm_exch_cd                          
                   , excsm.excsm_seg_cd                  excsm_seg_cd                          
                   , prom.prom_id                        prom_id                       
                   , entpm.entpm_enttm_id                entpm_enttm_id                      
                   , isnull(prom.prom_desc,'')           prom_desc                        
                   --, isnull(entp.entp_value,'')          entp_value                      
                   , CASE WHEN entp.entp_entpm_cd = 'INDRODUCER' THEN ISNULL(entp.entp_value,'DIRECT') ELSE ISNULL(entp.entp_value,'') END entp_value                      
                   , entpm.entpm_prop_id      entpm_prop_id                      
                   , entpm.entpm_cd                      entpm_cd                      
                   , isnull(entpm.entpm_desc,'')         entpm_desc                          
                   , entpm.entpm_clicm_id                entpm_clicm_id                        
                   , entp.entp_id                        entp_id                      
                   , entpm.entpm_id                      entpm_id                      
                   , entp.entp_ent_id                    entp_ent_id                      
                   , CASE entpm.entpm_mdty  WHEN 1 THEN 'M' ELSE 'N' END entpm_mdty                      
                   , CASE excsm_exch_cd     WHEN 'BSE'THEN CONVERT(VARCHAR,1) WHEN 'NSE'THEN CONVERT(VARCHAR,2) ELSE CONVERT(VARCHAR,3) END  ord1                        
                   , ENTPM.ENTPM_DATATYPE                ENTPM_DATATYPE                      
        FROM  entity_property_mstr          entpm   WITH(NOLOCK)                          
              left outer join                              
              entity_properties             entp    WITH (NOLOCK)                      
        ON    entpm.entpm_prop_id         = entp.entp_entpm_prop_id AND   ISNULL(entp_ent_id, 0)      = @PA_CRN_NO                       
              right outer join                       
             -- (select  clisba_excpm_id   ,    clisba_crn_no   from client_sub_accts   union    
              -- select  clisba_excpm_id   ,    clisba_crn_no   from client_sub_accts_mak) clisba 
              client_sub_accts clisba
              ON    clisba.clisba_excpm_id      = entpm.entpm_excpm_id         
              AND   clisba.clisba_crn_no        = @PA_CRN_NO        
            , exch_seg_mstr         excsm   WITH(NOLOCK)                          
            , excsm_prod_mstr               excpm   WITH(NOLOCK)                          
            , product_mstr                  prom    WITH(NOLOCK)                          
          
        WHERE entpm.entpm_excpm_id        = excpm.excpm_id                          
        AND   prom.prom_id                = excpm.excpm_prom_id                          
        AND   excpm.excpm_excsm_id        = excsm.excsm_id                          
       
        AND   excpm.excpm_deleted_ind  = 1                          
        AND   isnull(entp_deleted_ind, 1) = 1                        
        AND   prom.prom_deleted_ind       = 1                          
        AND   excsm.excsm_deleted_ind     = 1                          
        AND   entpm.entpm_deleted_ind     = 1                          
        AND   entpm_clicm_id              = @PA_CLICM_ID                      
        AND   entpm_enttm_id              = @PA_ENTTM_ID                      
        AND   entp.entp_ENTPM_PROP_id      NOT IN(SELECT ENTP_ENTPM_PROP_ID FROM ENTITY_PROPERTIES_MAK WHERE  ENTP_DELETED_IND IN (0,8)  AND ENTP_ENT_ID =@PA_CRN_NO)                        
       ) X                      
        LEFT OUTER JOIN                      
       (SELECT a.entdm_entpm_prop_id     entdm_entpm_id                      
             , b.entpd_entp_id           entpd_entp_id                      
             , a.entdm_cd                entdm_cd                      
             , a.entdm_id                entdm_id                      
             , b.entpd_value             entpd_value                      
             , a.entdm_desc              entdm_desc                      
             , a.entdm_entpm_prop_id     entdm_entpm_prop_id                      
             , A.ENTDM_DATATYPE          ENTDM_DATATYPE                       
             , CASE a.entdm_mdty  WHEN 1 THEN 'M' ELSE 'N' END entdm_mdty                      
        FROM   entpm_dtls_mstr a         WITH (NOLOCK)                      
               left outer join                      
               entity_property_dtls_mak b    WITH (NOLOCK)                      
        ON  (a.entdm_id     = b.entpd_entdm_id) AND entpd_entp_id IN (SELECT entp_id FROM entity_properties  WITH (NOLOCK) WHERE ENTP_ENT_ID = @PA_CRN_NO AND ENTP_DELETED_IND = 1)                      
        WHERE a.entdm_deleted_ind = 1 AND isnull(b.entpd_deleted_ind,0) in (0,4,8)              
       ) y                      
  ON (x.entpm_prop_id  = y.entdm_entpm_prop_id) 
                       
      UNION                      
                          
      SELECT x.excsm_exch_cd       excsm_exch_cd                      
           , x.excsm_seg_cd        excsm_seg_cd                 
           , x.prom_id             prom_id                       
           , x.prom_desc           prom_desc                      
           , x.entpm_prop_id       entpm_prop_id                      
           --, x.entpm_clicm_id      entpm_clicm_id                      
           --, x.entp_id             entp_id                      
           --, x.entpm_enttm_id      entpm_enttm_id                      
           --, x.entpm_id            entpm_id                      
           , x.entpm_cd               entpm_cd                      
           , isnull(x.entpm_desc,'')  entpm_desc                      
           , isnull(x.entp_value,'')  entp_value                      
           , isnull(y.entdm_id,0)     entdm_id                      
           , y.entdm_cd               entdm_cd                      
           , isnull(y.entpd_value,'') entpd_value                      
           , y.entdm_desc          entdm_desc                      
           , y.entdm_mdty          entdm_mdty                      
           , x.entpm_mdty          entpm_mdty                      
           , X.entpm_datatype      entpm_datatype                      
           , Y.entdm_datatype      entdm_datatype                      
           , X.ord1                ord1       
			 , x.entpm_desc               
        FROM (SELECT DISTINCT excsm.excsm_exch_cd        excsm_exch_cd                          
                   , excsm.excsm_seg_cd                  excsm_seg_cd                          
                   , prom.prom_id                        prom_id                       
                   , entpm.entpm_enttm_id                entpm_enttm_id                      
                   , isnull(prom.prom_desc,'')           prom_desc                        
                   --, isnull(entp.entp_value,'')          entp_value                      
                   , CASE WHEN entp.entp_entpm_cd = 'INDRODUCER' THEN ISNULL(entp.entp_value,'DIRECT') ELSE ISNULL(entp.entp_value,'') END entp_value                      
                   , entpm.entpm_prop_id      entpm_prop_id                      
                   , entpm.entpm_cd                      entpm_cd                      
                   , isnull(entpm.entpm_desc,'')         entpm_desc                          
                   , entpm.entpm_clicm_id                entpm_clicm_id                        
                   , entp.entp_id                        entp_id                      
                   , entpm.entpm_id                      entpm_id                      
                   , entp.entp_ent_id                    entp_ent_id                      
                   , CASE entpm.entpm_mdty  WHEN 1 THEN 'M' ELSE 'N' END entpm_mdty                      
                   , CASE excsm_exch_cd     WHEN 'BSE'THEN CONVERT(VARCHAR,1) WHEN 'NSE'THEN CONVERT(VARCHAR,2) ELSE CONVERT(VARCHAR,3) END  ord1                        
                   , ENTPM.ENTPM_DATATYPE                ENTPM_DATATYPE                      
        FROM  entity_property_mstr          entpm   WITH(NOLOCK)                          
              left outer join                              
              entity_properties             entp    WITH (NOLOCK)                      
        ON    entpm.entpm_prop_id         = entp.entp_entpm_prop_id AND   ISNULL(entp_ent_id, 0)      = @pa_crn_no                       
              right outer join                       
             -- (select  clisba_excpm_id   ,    clisba_crn_no   from client_sub_accts   union    
              -- select  clisba_excpm_id   ,    clisba_crn_no   from client_sub_accts_mak) clisba 
              client_sub_accts clisba
              ON    clisba.clisba_excpm_id      = entpm.entpm_excpm_id         
              AND   clisba.clisba_crn_no        = @pa_crn_no        
            , exch_seg_mstr         excsm   WITH(NOLOCK)                          
            , excsm_prod_mstr               excpm   WITH(NOLOCK)                          
            , product_mstr                  prom    WITH(NOLOCK)                          
            , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
        WHERE entpm.entpm_excpm_id        = excpm.excpm_id                          
        AND   prom.prom_id                = excpm.excpm_prom_id                          
        AND   excpm.excpm_excsm_id        = excsm.excsm_id                          
        AND    excsm_list.excsm_id  = excsm.excsm_id                   
        AND   excpm.excpm_deleted_ind  = 1                          
        AND   isnull(entp_deleted_ind, 1) = 1                        
        AND   prom.prom_deleted_ind       = 1                          
        AND   excsm.excsm_deleted_ind     = 1                          
        AND   entpm.entpm_deleted_ind     = 1                          
        AND   entpm_clicm_id              = @pa_clicm_id                      
        AND   entpm_enttm_id              = @pa_enttm_id                      
        AND   entp.entp_ENTPM_PROP_id      NOT IN(SELECT ENTP_ENTPM_PROP_ID FROM ENTITY_PROPERTIES_MAK WHERE  ENTP_DELETED_IND IN (0,8)  AND ENTP_ENT_ID =@PA_CRN_NO)                        
        AND   entp.entp_id                 NOT IN(SELECT entpd_ENTP_ID FROM entity_property_dtls_mak WHERE  ENTPd_DELETED_IND IN (0,8)  )                        
       ) X                      
        LEFT OUTER JOIN                      
       (SELECT a.entdm_entpm_prop_id     entdm_entpm_id                      
             , b.entpd_entp_id           entpd_entp_id                      
             , a.entdm_cd                entdm_cd                      
             , a.entdm_id                entdm_id                      
             , b.entpd_value             entpd_value                      
             , a.entdm_desc              entdm_desc                      
             , a.entdm_entpm_prop_id     entdm_entpm_prop_id                      
             , A.ENTDM_DATATYPE          ENTDM_DATATYPE                       
             , CASE a.entdm_mdty  WHEN 1 THEN 'M' ELSE 'N' END entdm_mdty                      
        FROM   entpm_dtls_mstr a         WITH (NOLOCK)                      
               left outer join                      
               entity_property_dtls b    WITH (NOLOCK)                      
        ON  (a.entdm_id     = b.entpd_entdm_id) AND entpd_entp_id IN (SELECT entp_id FROM entity_properties  WITH (NOLOCK) WHERE ENTP_ENT_ID = @PA_CRN_NO AND ENTP_DELETED_IND = 1)                      
        WHERE a.entdm_deleted_ind = 1 AND isnull(b.entpd_deleted_ind,1) = 1              
       ) y                      
  ON (x.entpm_prop_id  = y.entdm_entpm_prop_id)                      


       ORDER BY ord1                        
              , x.excsm_exch_cd                      
              , x.excsm_seg_cd                        
              , x.prom_id                        
              , x.entpm_desc                       
                                    
    --                      
    END                      
    ELSE IF @PA_TAB = 'CLISBAENTR'                      
    BEGIN                      
    --                      
      /*SELECT compm.compm_short_name                      
         +' - '+excsm.excsm_exch_cd                      
         +' - '+excsm.excsm_seg_cd                      
         +' - '+clia.clia_acct_no                      
         +' - '+isnull(clisba.clisba_no, 0)  sba_val                      
         , CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,Excsm.excsm_id)+'|*~|'+clia.clia_acct_no+'|*~|'+ISNULL(clisba.clisba_no, 0)+'|*~|'+CONVERT(VARCHAR,CONVERT(DATETIME,entr.entr_from_dt,103))+'|*~|'+'HO|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENT
  
    
      
        
          
            
              
                
M                  
                    
(entr.entr_ho),'')+'|*~|RE|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_re),'')+'|*~|AR|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_ar),'')+'|*~|BR|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_br),'')+'|*~|SB|*~|'+ ISNULL(citrus_usr.FN_SELECT
  
    
      
        
          
            
              
                
                  
                    
_ENTM(entr.entr_sb),'')+'|*~|DL|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_dl),'')+'|*~|RM|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_rm),'')+'|*~|Q' rel_value                       
         , CONVERT(varchar,entr.entr_from_dt,103)   entr_from_dt             
     FROM   entity_relationship         entr     WITH (NOLOCK)                      
          , client_sub_accts            clisba   WITH (NOLOCK)                      
          , client_accounts             clia     WITH (NOLOCK)                      
          , exch_seg_mstr               excsm    WITH (NOLOCK)                      
          , company_mstr                compm    WITH (NOLOCK)                      
          ,excsm_prod_mstr             excpm                      
     WHERE  entr.entr_crn_no                   = clisba.clisba_crn_no                      
     AND    entr.entr_acct_no                  = clisba.clisba_acct_no                      
     AND    entr.entr_sba                      = clisba.clisba_no                      
     AND    clisba.clisba_crn_no             = clia.clia_crn_no                      
     AND    clisba.clisba_acct_no            = clia.clia_acct_no                      
     AND    clisba.clisba_excpm_id       = excpm.excpm_id                      
     AND    excpm.excpm_excsm_id   = excsm.excsm_id                      
     AND    compm.compm_id                     = excsm.excsm_compm_id                      
     AND    isnull( citrus_usr.fn_get_single_access( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc), 0) > 0                      
     --AND    excsm.excsm_id                     = excpm.excpm_excsm_id                      
     AND    entr.entr_deleted_ind              = 1                       
     AND    clisba.clisba_deleted_ind          = 1                      
     AND    clia.clia_deleted_ind              = 1                      
     AND    excsm.excsm_deleted_ind            = 1                      
     AND    compm.compm_deleted_ind            = 1                      
     AND    clia.clia_crn_no                   = @pa_crn_no                      
     ORDER  BY clisba_no                      
             , entr_from_dt DESC */                      
      SELECT compm.compm_short_name+' - '+excsm.excsm_exch_cd+' - '+excsm.excsm_seg_cd+' - '+entrm.entr_acct_no+' - '+isnull(entrm.entr_sba, 0)  sba_val                      
    --, CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,Excsm.excsm_id)+'|*~|'+cliam.clia_acct_no+'|*~|'+ISNULL(clisbam.clisba_no, 0)+'|*~|'+CONVERT(VARCHAR,CONVERT(DATETIME,entrm.entr_from_dt,103))+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_HO',entrm.entr_ho),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_ho),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RE',entrm.entr_re),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_re),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_AR',entrm.entr_ar),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_ar),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_BR',entrm.entr_br),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_br),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_SB',entrm.entr_sb),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_sb),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DL',entrm.entr_dl),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_dl),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RM',entrm.entr_rm),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_rm),'')+'|*~|Q' rel_value                        
            , CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,Excsm.excsm_id)+'|*~|'+cliam.clia_acct_no+'|*~|'+ISNULL(clisbam.clisba_no, 0)+'|*~|'+CONVERT(VARCHAR,CONVERT(DATETIME,entrm.entr_from_dt,103))+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_HO',entrm.entr_ho),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_ho),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RE',entrm.entr_re),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_re),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_AR',entrm.entr_ar),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_ar),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_BR',entrm.entr_br),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_br),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_SB',entrm.entr_sb),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_sb),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DL',entrm.entr_dl),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_dl),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RM',entrm.entr_rm),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_rm),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY1',entrm.ENTR_DUMMY1),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.ENTR_DUMMY1),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY2',entrm.ENTR_DUMMY2),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.ENTR_DUMMY2),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY3',entrm.ENTR_DUMMY3),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.ENTR_DUMMY3),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY4',entrm.ENTR_DUMMY4),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.ENTR_DUMMY4),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY5',entrm.ENTR_DUMMY5),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.ENTR_DUMMY5),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY6',entrm.ENTR_DUMMY6),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.ENTR_DUMMY6),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY7',entrm.ENTR_DUMMY7),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.ENTR_DUMMY7),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY8',entrm.ENTR_DUMMY8),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.ENTR_DUMMY8),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY9',entrm.ENTR_DUMMY9),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.ENTR_DUMMY9),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY10',entrm.ENTR_DUMMY10),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.ENTR_DUMMY10),'')+'|*~|Q' rel_value                       
            , CONVERT(DATETIME,entrm.entr_from_dt,103)   entr_from_dt                      
            , clisbam.clisba_no              clisba_no                      
      FROM   entity_relationship_mak     entrm    WITH (NOLOCK)                      
            , client_sub_accts_mak        clisbam  WITH (NOLOCK)                      
            , client_accounts_mak         cliam    WITH (NOLOCK)                      
            , exch_seg_mstr               excsm    WITH (NOLOCK)                      
            , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
            , company_mstr                compm    WITH (NOLOCK)                      
            , excsm_prod_mstr             excpm    WITH (NOLOCK)                      
      WHERE  entrm.entr_crn_no                  = clisbam.clisba_crn_no                      
      AND    entrm.entr_acct_no                 = clisbam.clisba_acct_no    
      AND    entrm.entr_sba                     = clisbam.clisba_no                      
      AND    clisbam.clisba_crn_no              = cliam.clia_crn_no                      
      AND    clisbam.clisba_acct_no             = cliam.clia_acct_no                      
      AND    excsm_list.excsm_id                 = excsm.excsm_id                   
      AND    compm.compm_id                     = excsm.excsm_compm_id                      
      AND    clisbam.clisba_excpm_id            = excpm.excpm_id                       
      AND    excpm.excpm_excsm_id               = excsm.excsm_id                     
      AND    entrm.entr_excpm_id                = clisbam.clisba_excpm_id       
      --AND    isnull( citrus_usr.fn_get_single_access( cliam.clia_crn_no, cliam.clia_acct_no, excsm.excsm_desc), 0) > 0                      
      AND    cliam.clia_excsm_id                =excsm.excsm_id                      
      AND    entrm.entr_deleted_ind             IN (0,8)                      
      AND    clisbam.clisba_deleted_ind         IN (0,8)                      
      AND    cliam.clia_deleted_ind             IN (0,8)                      
      AND    excsm.excsm_deleted_ind            = 1                      
      AND    compm.compm_deleted_ind            = 1                      
      AND    excpm.excpm_deleted_ind            = 1                      
      AND    cliam.clia_crn_no                  = @pa_crn_no                      
      --
      UNION
      --
      SELECT compm.compm_short_name+' - '+excsm.excsm_exch_cd+' - '+excsm.excsm_seg_cd+' - '+entrm.entr_acct_no+' - '+isnull(entrm.entr_sba, 0)  sba_val                      
    --, CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,Excsm.excsm_id)+'|*~|'+cliam.clia_acct_no+'|*~|'+ISNULL(clisbam.clisba_no, 0)+'|*~|'+CONVERT(VARCHAR,CONVERT(DATETIME,entrm.entr_from_dt,103))+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_HO',entrm.entr_ho),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_ho),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RE',entrm.entr_re),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_re),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_AR',entrm.entr_ar),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_ar),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_BR',entrm.entr_br),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_br),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_SB',entrm.entr_sb),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_sb),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DL',entrm.entr_dl),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_dl),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RM',entrm.entr_rm),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_rm),'')+'|*~|Q' rel_value                        
            , CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,Excsm.excsm_id)+'|*~|'+cliam.clia_acct_no+'|*~|'+ISNULL(clisbam.clisba_no, 0)+'|*~|'+CONVERT(VARCHAR,CONVERT(DATETIME,entrm.entr_from_dt,103))+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_HO',entrm.entr_ho),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_ho),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RE',entrm.entr_re),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_re),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_AR',entrm.entr_ar),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_ar),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_BR',entrm.entr_br),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_br),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_SB',entrm.entr_sb),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_sb),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DL',entrm.entr_dl),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_dl),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RM',entrm.entr_rm),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.entr_rm),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY1',entrm.ENTR_DUMMY1),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.ENTR_DUMMY1),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY2',entrm.ENTR_DUMMY2),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.ENTR_DUMMY2),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY3',entrm.ENTR_DUMMY3),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.ENTR_DUMMY3),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY4',entrm.ENTR_DUMMY4),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.ENTR_DUMMY4),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY5',entrm.ENTR_DUMMY5),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.ENTR_DUMMY5),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY6',entrm.ENTR_DUMMY6),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.ENTR_DUMMY6),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY7',entrm.ENTR_DUMMY7),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.ENTR_DUMMY7),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY8',entrm.ENTR_DUMMY8),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.ENTR_DUMMY8),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY9',entrm.ENTR_DUMMY9),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.ENTR_DUMMY9),'')+'|*~|'                      
             +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY10',entrm.ENTR_DUMMY10),'')+'|*~|'                      
             +ISNULL(citrus_usr.FN_SELECT_ENTM(entrm.ENTR_DUMMY10),'')+'|*~|Q' rel_value                       
            , CONVERT(DATETIME,entrm.entr_from_dt,103)   entr_from_dt                      
            , clisbam.clisba_no              clisba_no                      
      FROM   entity_relationship_mak     entrm    WITH (NOLOCK)                      
            , client_sub_accts           clisbam  WITH (NOLOCK)                      
            , client_accounts            cliam    WITH (NOLOCK)                      
            , exch_seg_mstr               excsm    WITH (NOLOCK)                      
            , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
            , company_mstr                compm    WITH (NOLOCK)                      
            , excsm_prod_mstr             excpm    WITH (NOLOCK)                      
      WHERE  entrm.entr_crn_no                  = clisbam.clisba_crn_no                      
      AND    entrm.entr_acct_no                 = clisbam.clisba_acct_no    
      AND    entrm.entr_sba                     = clisbam.clisba_no                      
      AND    clisbam.clisba_crn_no              = cliam.clia_crn_no                      
      AND    clisbam.clisba_acct_no             = cliam.clia_acct_no                      
      AND    excsm_list.excsm_id                 = excsm.excsm_id                   
      AND    compm.compm_id                     = excsm.excsm_compm_id                      
      AND    clisbam.clisba_excpm_id            = excpm.excpm_id                       
      AND    excpm.excpm_excsm_id               = excsm.excsm_id                     
      AND    entrm.entr_excpm_id                = clisbam.clisba_excpm_id       
      AND    isnull( citrus_usr.fn_get_single_access( cliam.clia_crn_no, cliam.clia_acct_no, excsm.excsm_desc), 0) > 0                      
      --AND    cliam.clia_excsm_id                =excsm.excsm_id                      
      AND    entrm.entr_deleted_ind             IN (0,8)                      
      AND    clisbam.clisba_deleted_ind         = 1                     
      AND    cliam.clia_deleted_ind             = 1                      
      AND    excsm.excsm_deleted_ind            = 1                      
      AND    compm.compm_deleted_ind            = 1                      
      AND    excpm.excpm_deleted_ind            = 1                      
      AND    cliam.clia_crn_no                  = @pa_crn_no                      
      --                      
      UNION                      
      --                      
      SELECT compm.compm_short_name+' - '+excsm.excsm_exch_cd+' - '+excsm.excsm_seg_cd+' - '+clia.clia_acct_no+' - '+isnull(clisba.clisba_no, 0)  sba_val                      
           --, CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,Excsm.excsm_id)+'|*~|'+clia.clia_acct_no+'|*~|'+ISNULL(clisba.clisba_no, 0)+'|*~|'+CONVERT(VARCHAR,CONVERT(DATETIME,entr.entr_from_dt,103))+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_HO',entr.entr_ho),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_ho),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RE',entr.entr_re),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_re),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_AR',entr.entr_ar),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_ar),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_BR',entr.entr_br),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_br),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_SB',entr.entr_sb),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_sb),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DL',entr.entr_dl),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_dl),'')+'|*~|'+ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RM',entr.entr_rm),'')+'|*~|'+ ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_rm),'')+'|*~|Q' rel_value                        
           , CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,Excsm.excsm_id)+'|*~|'+clia.clia_acct_no+'|*~|'+ISNULL(clisba.clisba_no, 0)+'|*~|'+CONVERT(VARCHAR,CONVERT(DATETIME,entr.entr_from_dt,103))+'|*~|'                      
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_HO',entr.entr_ho),'')+'|*~|'                      
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_ho),'')+'|*~|'                      
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RE',entr.entr_re),'')+'|*~|'                      
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_re),'')+'|*~|'                      
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_AR',entr.entr_ar),'')+'|*~|'                      
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_ar),'')+'|*~|'                      
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_BR',entr.entr_br),'')+'|*~|'                      
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_br),'')+'|*~|'                      
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_SB',entr.entr_sb),'')+'|*~|'                      
   +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_sb),'')+'|*~|'                      
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DL',entr.entr_dl),'')+'|*~|'                      
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_dl),'')+'|*~|'                      
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_RM',entr.entr_rm),'')+'|*~|'                      
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.entr_rm),'')+'|*~|'                      
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY1',entr.ENTR_DUMMY1),'')+'|*~|'                      
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY1),'')+'|*~|'                      
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY2',entr.ENTR_DUMMY2),'')+'|*~|'                      
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY2),'')+'|*~|'                      
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY3',entr.ENTR_DUMMY3),'')+'|*~|'                      
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY3),'')+'|*~|'                      
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY4',entr.ENTR_DUMMY4),'')+'|*~|'                      
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY4),'')+'|*~|'                      
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY5',entr.ENTR_DUMMY5),'')+'|*~|'                      
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY5),'')+'|*~|'                      
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY6',entr.ENTR_DUMMY6),'')+'|*~|'                      
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY6),'')+'|*~|'                      
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY7',entr.ENTR_DUMMY7),'')+'|*~|'                      
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY7),'')+'|*~|'                      
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY8',entr.ENTR_DUMMY8),'')+'|*~|'                      
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY8),'')+'|*~|'                      
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY9',entr.ENTR_DUMMY9),'')+'|*~|'                      
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY9),'')+'|*~|'                      
            +ISNULL(citrus_usr.TO_GET_ENTTM_CD('ENTR_DUMMY10',entr.ENTR_DUMMY10),'')+'|*~|'                      
            +ISNULL(citrus_usr.FN_SELECT_ENTM(entr.ENTR_DUMMY10),'')+'|*~|Q' rel_value                       
           , CONVERT(DATETIME,entr.entr_from_dt,103)   entr_from_dt                      
           , clisba.clisba_no              clisba_no                       
      FROM   entity_relationship         entr     WITH (NOLOCK)                      
           , client_sub_accts       clisba   WITH (NOLOCK)                      
           , client_accounts             clia     WITH (NOLOCK)                      
           , exch_seg_mstr               excsm    WITH (NOLOCK)                      
           , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
           , company_mstr                compm    WITH (NOLOCK)                      
           , excsm_prod_mstr             excpm    WITH (NOLOCK)                      
      WHERE  entr.entr_crn_no                   = clisba.clisba_crn_no                      
      AND    entr.entr_acct_no                  = clisba.clisba_acct_no                      
      AND    entr.entr_sba                      = clisba.clisba_no                      
      AND    clisba.clisba_crn_no               = clia.clia_crn_no                      
      AND    excsm_list.excsm_id                 = excsm.excsm_id                   
      AND    clisba.clisba_acct_no              = clia.clia_acct_no                      
      AND    compm.compm_id                     = excsm.excsm_compm_id                      
      AND    clisba.clisba_excpm_id             = excpm.excpm_id                       
      AND    excpm.excpm_excsm_id               = excsm.excsm_id                      
      AND    isnull( citrus_usr.fn_get_single_access( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc), 0) > 0                
      AND    entr.entr_deleted_ind              = 1                       
      AND    clisba.clisba_deleted_ind          = 1                      
      AND    clia.clia_deleted_ind              = 1                      
      AND    excsm.excsm_deleted_ind            = 1          AND    compm.compm_deleted_ind            = 1                      
      AND    excpm.excpm_deleted_ind            = 1                      
      AND    clia.clia_crn_no                   = @pa_crn_no                      
      AND    not exists (SELECT ENTR_CRN_NO FROM ENTITY_RELATIONSHIP_MAK WHERE ENTR_ACCT_NO = CLIA.CLIA_ACCT_NO AND  ENTR_SBA = CLISBA.CLISBA_NO AND ENTR_DELETED_IND IN (0,4,8))

      ORDER  BY clisba_no, entr_from_dt DESC                      
    --                      
    END                      
    --
    ELSE IF @pa_tab = 'CLIM_SHORT_NAME'              --CHANGED BY TUSHAR --28/05/07                      
    BEGIN   
      select 0                   
    --                      
--      IF ISNULL(@PA_CRN_NO,0) = 0                      
--      BEGIN                      
--      --  
--		SELECT SUM(T.cnt) cnt FROM 
--		(  		                        
--        SELECT count(clim_short_name) cnt                       
--        FROM   client_mstr_mak                       
--        WHERE  clim_short_name  = @pa_value                      
--        AND    clim_deleted_ind in (0,1,4,8,9)                       
--        union
--        SELECT count(clim_short_name) cnt                       
--        FROM   client_mstr
--        WHERE  clim_short_name  = @pa_value                      
--        AND    clim_deleted_ind = 1
--		) T
--      --                      
--      END                      
--      ELSE                      
--      BEGIN                      
--      -- 
--		SELECT SUM(T.cnt) cnt FROM 
--		(                       
--        SELECT count(clim_short_name) cnt                       
--        FROM   client_mstr_mak                       
--        WHERE  clim_short_name   = @pa_value                      
--        AND    clim_crn_no       <> @pa_crn_no                      
--        AND    clim_deleted_ind  IN (0,1,4,8,9)                      
--        union
--        SELECT count(clim_short_name) cnt                       
--        FROM   client_mstr                       
--        WHERE  clim_short_name   = @pa_value                      
--        AND    clim_crn_no       <> @pa_crn_no                      
--        AND    clim_deleted_ind   = 1  
--		) T 
--     --                      
--     END                      
--                        
    END                      
    ELSE IF @pa_tab = 'ENTM_SHORT_NAME'              --CHANGED BY TUSHAR --28/05/07                      
    BEGIN                      
    --                      
      IF ISNULL(@PA_CRN_NO,0) = 0                      
      BEGIN                      
      --                          
        SELECT count(entm_short_name) cnt                       
        FROM   entity_mstr_mak                       
        WHERE  entm_short_name  = @pa_value                      
        AND    entm_deleted_ind in (0,1,4,8,9)                      
      --                      
      END                          ELSE                      
      BEGIN                      
      --                        
        SELECT count(entm_short_name) cnt                       
        FROM   entity_mstr_mak                       
        WHERE  entm_short_name   = @pa_value                      
        AND    entm_id           <> @pa_crn_no                      
        AND    entm_deleted_ind  In (0,1,4,8,9)                      
     --                      
     END                      
    --                        
    END                      
    ELSE IF @pa_tab = 'SBA_APP_SELECT'              --CHANGED BY TUSHAR --20/07/07                      
        BEGIN                      
        --                      
            --exec pr_select_clisba_app @pa_crn_no ,''                      
                                  
            SELECT compm.compm_id                      compm_id                      
                , compm.compm_short_name              compm_short_name                      
                , excsm.excsm_id                      excsm_id                      
                , excsm.excsm_exch_cd                 excsm_exch_cd                      
                , excsm.excsm_seg_cd                  excsm_seg_cd                      
                , cliam.clia_acct_no                  acct_no                      
                , excpm.excpm_prom_id                 excpm_prom_id                     
                , prom.prom_desc                      prom_desc                      
                --, stam.stam_desc                      stam_desc                      
                --, brom.brom_desc                      brom_desc                        
                , clisbam.clisba_id                   clisba_id                      
                , isnull(clisbam.clisba_no, 0)        clisba_no                      
                , isnull(clisbam.clisba_name, 0)      clisba_name                      
                --, CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,excsm.excsm_id)+'|*~|'+cliam.clia_acct_no+'|*~|'+ISNULL(clisbam.clisba_no, 0)+'|*~|'+ISNULL(clisbam.clisba_name, 0)+'|*~|'+CONVERT(VARCHAR,excpm.excpm_prom_id)+'|*~|'+ISNULL(stam.stam_cd,'')+'|*~|Q' value  --*|~*                      
                , CASE clil.clim_ins_upd_del  WHEN 'I' THEN 'ADD'                      
                                              WHEN 'E' THEN 'EDIT'                      
                                              WHEN 'D' THEN 'DELETE'                                 
                                              END     Status                       
            FROM   client_sub_accts_mak                clisbam  WITH (NOLOCK)                   
                 , client_accounts_mak                 cliam    WITH (NOLOCK)                      
                 , excsm_prod_mstr                     excpm    WITH (NOLOCK)                      
                 , exch_seg_mstr                       excsm    WITH (NOLOCK)                      
                 , product_mstr                        prom     WITH (NOLOCK)                      
                 , company_mstr                        compm    WITH (NOLOCK)                      
                 , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
                 --, status_mstr                         stam     WITH (NOLOCK)                      
                 --, brokerage_mstr                      brom     WITH (NOLOCK)                      
                 , client_list                clil     WITH (NOLOCK)                      
            WHERE  clisbam.clisba_crn_no             = cliam.clia_crn_no                      
            AND    clisbam.clisba_acct_no            = cliam.clia_acct_no                      
            AND    clisbam.clisba_excpm_id           = excpm.excpm_id                       
            AND    excsm_list.excsm_id                 = excsm.excsm_id                   
            AND   excsm.excsm_id                    = excpm.excpm_excsm_id                      
            AND    compm.compm_id         = excsm.excsm_compm_id                      
            AND    prom.prom_id                      = excpm.excpm_prom_id                      
            --AND    clisbam.clisba_access2            = stam.stam_id                      
            --AND    clisbam.clisba_brom               = brom.brom_id                      
            AND    clisbam.clisba_id                 = clil.clisba_no                      
            AND    clisbam.clisba_crn_no             = clil.clim_crn_no                      
            --AND    ISNULL( citrus_usr.FN_GET_SINGLE_ACCESS( cliam.clia_crn_no, cliam.clia_acct_no, excsm.excsm_desc), 0) > 0                      
            AND    clisbam.clisba_deleted_ind        IN(0,8)                      
            AND    cliam.clia_deleted_ind            IN(0,8)                      
            AND    excpm.excpm_deleted_ind           = 1                      
            AND    excsm.excsm_deleted_ind           = 1                     
            AND    prom.prom_deleted_ind             = 1                      
            AND    compm.compm_deleted_ind           = 1                      
            AND    cliam.clia_crn_no                 = @pa_crn_no                                
            AND    clil.clim_status     = 1                      
            AND  clil.clim_deleted_ind             = 1                      
                                  
                      
            UNION                      
                      
            SELECT compm.compm_id                      compm_id                      
                 , compm.compm_short_name              compm_short_name                      
                 , excsm.excsm_id                      excsm_id                      
                 , excsm.excsm_exch_cd                 excsm_exch_cd                      
                 , excsm.excsm_seg_cd                  excsm_seg_cd                      
                 , clia.clia_acct_no                   acct_no                      
                 , excpm.excpm_prom_id                 excpm_prom_id                      
                 , prom.prom_desc                      prom_desc                      
                 --, stam.stam_desc                      stam_desc                      
                 --, brom.brom_desc                      brom_desc                       
                 , clisbam.clisba_id                   clisba_id                                 
                 , isnull(clisbam.clisba_no, 0)        clisba_no                      
                 , isnull(clisbam.clisba_name, 0)      clisba_name                      
                 --, CONVERT(VARCHAR,compm.compm_id)+'|*~|'+CONVERT(VARCHAR,excsm.excsm_id)+'|*~|'+clia.clia_acct_no+'|*~|'+ISNULL(clisbam.clisba_no, 0)+'|*~|'+ISNULL(clisbam.clisba_name, 0)+'|*~|'+CONVERT(VARCHAR,excpm.excpm_prom_id)+'|*~|'+ISNULL(stam.stam_cd,'')+'|*~|Q' value  --*|~*                      
                 , CASE clil.clim_ins_upd_del  WHEN 'I' THEN 'ADD'                      
                                               WHEN 'E' THEN 'EDIT'                      
                                               WHEN 'D' THEN 'DELETE'                                 
                                               END     Status                      
            FROM   client_sub_accts_mak                clisbam  WITH (NOLOCK)                      
                 , client_accounts                     clia     WITH (NOLOCK)                      
                 , excsm_prod_mstr                     excpm    WITH (NOLOCK)                      
                 , exch_seg_mstr                       excsm    WITH (NOLOCK)                      
                 , product_mstr                        prom     WITH (NOLOCK)                      
                 , company_mstr                        compm    WITH (NOLOCK)                      
                 , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
                 --, status_mstr                         stam     WITH (NOLOCK)              
                 --, brokerage_mstr                      brom     WITH (NOLOCK)                      
                 , client_list                         clil     WITH (NOLOCK)                      
            WHERE  clisbam.clisba_crn_no             = clia.clia_crn_no                      
            AND    clisbam.clisba_acct_no            = clia.clia_acct_no                      
            AND    clisbam.clisba_excpm_id           = excpm.excpm_id                       
            AND    excsm_list.excsm_id                 = excsm.excsm_id                   
            AND    excsm.excsm_id                    = excpm.excpm_excsm_id                      
            AND    compm.compm_id                    = excsm.excsm_compm_id                      
            AND    prom.prom_id                      = excpm.excpm_prom_id                      
            --AND    clisbam.clisba_access2            = stam.stam_id                      
            --AND    clisbam.clisba_brom               = brom.brom_id                      
            AND    clisbam.clisba_id                 = clil.clisba_no                      
            AND    clisbam.clisba_crn_no             = clil.clim_crn_no    
            AND    ISNULL( citrus_usr.FN_GET_SINGLE_ACCESS( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc), 0) > 0                      
            AND    clisbam.clisba_deleted_ind        IN(0,8)                      
            AND    clia.clia_deleted_ind             = 1                      
            AND    excpm.excpm_deleted_ind           = 1                      
            AND    excsm.excsm_deleted_ind           = 1                      
            AND    prom.prom_deleted_ind             = 1                      
            AND    compm.compm_deleted_ind           = 1                      
            AND    clia.clia_crn_no                  = @pa_crn_no                      
            AND    clil.clim_status                  = 1                      
            AND    clil.clim_deleted_ind             = 1                      
                                  
                      
                      
            UNION                      
                      
            SELECT compm.compm_id               compm_id                      
                 , compm.compm_short_name       compm_short_name                      
                 , excsm.excsm_id               excsm_id                      
                 , excsm.excsm_exch_cd          excsm_exch_cd                      
                 , excsm.excsm_seg_cd           excsm_seg_cd                      
                 , clia.clia_acct_no            acct_no                      
                 , excpm.excpm_prom_id          excpm_prom_id                      
                 , prom.prom_desc               prom_desc                      
                 --, stam.stam_desc               stam_desc                      
                 --, brom.brom_desc               brom_desc                        
                 , clisba.clisba_id             clisba_id                      
                 , ISNULL(clisba.clisba_no, 0)  clisba_no                      
                 , ISNULL(clisba.clisba_name, 0)clisba_name                      
                 --, CONVERT(VARCHAR,compm.compm_id)+'|*~|'+ CONVERT(VARCHAR,excsm.excsm_id)+'|*~|'+clia.clia_acct_no+'|*~|'+ISNULL(clisba.clisba_no, 0)+'|*~|'+ISNULL(clisba.clisba_name, 0)+'|*~|'+ CONVERT(VARCHAR,excpm.excpm_prom_id)+'|*~|'+ISNULL(stam.stam_cd,'')+'|*~|Q' value                          
                 , CASE clil.clim_ins_upd_del  WHEN 'I' THEN 'ADD'                      
                                               WHEN 'E' THEN 'EDIT'                      
                                               WHEN 'D' THEN 'DELETE'                                 
                                               END     Status                      
            FROM   client_accounts             clia    WITH (NOLOCK)                      
                 , excsm_prod_mstr             excpm  WITH (NOLOCK)                      
                 , exch_seg_mstr               excsm   WITH (NOLOCK)                      
                 , product_mstr                prom    WITH (NOLOCK)                      
                 , company_mstr                compm   WITH (NOLOCK)                      
                 , citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list                  
                 --, status_mstr                 stam    WITH (NOLOCK)                      
                 , client_list                 clil     WITH (NOLOCK)                      
                 , client_sub_accts            clisba  WITH (NOLOCK)                      
                   --left outer join                                    
                   --client_brokerage            clib    WITH (NOLOCK) on clisba_id          = clib_clisba_id                      
                   --left outer join                                    
                   -- brokerage_mstr              brom    WITH (NOLOCK) on clib.clib_brom_id  = brom.brom_id                      
            WHERE  clisba.clisba_crn_no      = clia.clia_crn_no                      
            AND    clisba.clisba_acct_no     = clia.clia_acct_no                      
            AND    clisba.clisba_excpm_id    = excpm.excpm_id                       
            AND    excsm.excsm_id            = excpm.excpm_excsm_id                      
            AND    compm.compm_id            = excsm.excsm_compm_id                      
            AND    excsm_list.excsm_id                 = excsm.excsm_id                   
            AND    prom.prom_id              = excpm.excpm_prom_id                      
            --AND    clisba.clisba_access2     = stam.stam_id                      
            AND    clisba.clisba_id          = clil.clisba_no                      
            AND    clisba.clisba_crn_no     = clil.clim_crn_no                      
            AND    ISNULL(citrus_usr.fn_get_single_access( clia.clia_crn_no, clia.clia_acct_no, excsm.excsm_desc), 0) > 0                      
            AND    clia.clia_deleted_ind     = 1                      
            AND    ISNULL(excsm.excsm_deleted_ind, 0) = 1                      
            AND    clisba.clisba_deleted_ind = 1                      
            AND    excpm.excpm_deleted_ind   = 1                      
            AND    prom.prom_deleted_ind     = 1                      
            AND    compm.compm_deleted_ind   = 1                      
            AND    clia.clia_crn_no          = @pa_crn_no                      
            AND    clil.clim_status          = 1                      
            AND    clil.clim_deleted_ind     = 1                      
    --                        
    END                      
  --                      
  END                      
  /*IF @pa_tab = 'dpam_prop'                      
  BEGIN                      
  --                      
    SELECT DISTINCT x.excsm_exch_cd       excsm_exch_cd                    
               , x.excsm_seg_cd                 excsm_seg_cd                         
               , x.prom_id                      prom_id                       
               , x.prom_desc                    prom_desc                      
               , x.entpm_prop_id                entpm_prop_id                      
               , x.entpm_cd                     entpm_cd                  
               , isnull(x.entpm_desc,'')        entpm_desc                      
               , isnull(x.entp_value,'')        entp_value                      
               , isnull(y.entdm_id,0)           entdm_id                      
               , y.entdm_cd                     entdm_cd                      
               , isnull(y.entpd_value,'')       entpd_value                      
               , y.entdm_desc                   entdm_desc                      
               , x.entpm_mdty                   entpm_mdty                      
               , y.entdm_mdty                   entdm_mdty                       
               , RTRIM(LTRIM(x.entpm_datatype)) entpm_datatype                      
               , y.entdm_datatype               entdm_datatype                      
               , x.ord1            ord1                       
    FROM (SELECT DISTINCT excsm.excsm_exch_cd        excsm_exch_cd                          
                     , excsm.excsm_seg_cd                  excsm_seg_cd                          
                     , prom.prom_id                        prom_id                       
                     , entpm.entpm_enttm_id                entpm_enttm_id                      
                     , isnull(prom.prom_desc,'')           prom_desc                       
                     , CASE WHEN entpm.entpm_cd  = 'INTRODUCER' THEN ISNULL(entp.entp_value,'DIRECT') ELSE ISNULL(entp.entp_value,'') END  entp_value                      
                     , entpm.entpm_prop_id                 entpm_prop_id                      
                     , entpm.entpm_cd                      entpm_cd                      
                     , isnull(entpm.entpm_desc,'')         entpm_desc                          
                     , entpm.entpm_clicm_id                entpm_clicm_id                          
                     , entp.entp_id                        entp_id                      
                     , entpm.entpm_id                      entpm_id                      
                     , entp.entp_ent_id                    entp_ent_id                      
                     , CASE entpm.entpm_mdty  WHEN 1 THEN 'M' ELSE 'N' END entpm_mdty                      
                     , CASE excsm_exch_cd     WHEN 'BSE'THEN CONVERT(VARCHAR,1) WHEN 'NSE'THEN CONVERT(VARCHAR,2) ELSE CONVERT(VARCHAR,3) END  ord1                        
                     , ISNULL(entpm.entpm_datatype,'')     entpm_datatype                      
 FROM  entity_property_mstr          entpm   WITH(NOLOCK)                          
                left outer join                              
                entity_properties             entp    WITH (NOLOCK)                      
          ON    entpm.entpm_prop_id         = entp.entp_entpm_prop_id                       
          AND   ISNULL(entp_ent_id, 0)      = @pa_crn_no                       
          AND   isnull(entp_deleted_ind, 1) = 1                        
                RIGHT OUTER JOIN                       
                DP_ACCT_MSTR                DPAM                      
          ON    DPAM.DPAM_CRN_NO            = @pa_crn_no                              
              , exch_seg_mstr                 excsm   WITH(NOLOCK)                          
              , excsm_prod_mstr               excpm   WITH(NOLOCK)                          
              , product_mstr       prom    WITH(NOLOCK)                       
              , CLIENT_CTGRY_MSTR             CLICM   WITH(NOLOCK)                       
              , ENTITY_TYPE_MSTR              ENTTM   WITH(NOLOCK)                       
          WHERE entpm.entpm_excpm_id        = excpm.excpm_id                          
          AND   prom.prom_id     = excpm.excpm_prom_id                          
          AND   excpm.excpm_excsm_id        = excsm.excsm_id                          
          AND   ENTTM.ENTTM_ID              = DPAM.DPAM_ENTTM_ID                      
          AND   CLICM.CLICM_CD              = DPAM.DPAM_CLICM_CD                      
          AND   DPAM.DPAM_EXCSM_ID          = EXCSM.EXCSM_ID                        
          AND   excpm.excpm_deleted_ind     = 1                          
                      
          AND   prom.prom_deleted_ind       = 1                          
          AND   excsm.excsm_deleted_ind     = 1                          
          AND   entpm.entpm_deleted_ind     = 1                          
                      
         ) X                      
          LEFT OUTER JOIN                      
         (SELECT a.entdm_entpm_prop_id       entdm_entpm_id                      
               , b.entpd_entp_id             entpd_entp_id                      
               , a.entdm_cd                  entdm_cd                      
               , a.entdm_id                  entdm_id                      
               , b.entpd_value               entpd_value                      
               , a.entdm_desc                entdm_desc                      
               , a.entdm_entpm_prop_id       entdm_entpm_prop_id                      
               , ISNULL(a.entdm_datatype,'') entdm_datatype                       
               , CASE a.entdm_mdty  WHEN 1 THEN 'M' ELSE 'N' END entdm_mdty                      
          FROM   entpm_dtls_mstr a         WITH (NOLOCK)                      
                 left outer join                      
                 entity_property_dtls b    WITH (NOLOCK)                      
          ON  (a.entdm_id     = b.entpd_entdm_id)                       
          AND entpd_entp_id IN (SELECT entp_id FROM entity_properties  WITH (NOLOCK) WHERE ENTP_ENT_ID = @pa_crn_no AND ENTP_DELETED_IND = 1)                       
          AND   ISNULL(b.entpd_deleted_ind,1)= 1                      
          WHERE a.entdm_deleted_ind = 1                       
                      
         ) y                      
         ON (x.entpm_prop_id  = y.entdm_entpm_prop_id)                      
         ORDER BY x.ord1                        
                , x.excsm_exch_cd                      
                , x.excsm_seg_cd                        
                , x.prom_id                        
                , x.entpm_desc                      
                                     
       SELECT DISTINCT excsm.excsm_exch_cd  excsm_exch_cd                      
            , excsm.excsm_seg_cd       excsm_seg_cd                       
            , entpm.entpm_prop_id      entpm_prop_id                      
            , entpm.entpm_cd           entpm_cd                      
            , entp.entp_value          entp_value                      
            , entpm.entpm_desc         entpm_desc                      
            , entdm.entdm_id           entdm_id                        
            , entdm.entdm_cd           entdm_cd                     
            , entpd.entpd_value        entpd_value                      
            , entdm.entdm_desc         entdm_desc                      
            , entdm.entdm_datatype     entdm_datatype                      
            , entpm.entpm_mdty         entpm_mdty                      
            , entdm.entdm_mdty         entdm_mdty                      
            , entpm.entpm_datatype     entpm_datatype                      
            , case excsm.excsm_exch_cd WHEN 'BSE'THEN convert(varchar,1) WHEN 'NSE'THEN convert(varchar,2) ELSE convert(varchar,3) END  ord1                        
            --, clicm.clicm_id  clicm_id                      
            --, dpam.dpam_enttm_id  dpam_enttm_id                      
            --, excpm.excpm_excsm_id  excpm_excsm_id                      
       FROM   dp_acct_mstr          dpam                      
            , exch_seg_mstr         excsm                      
            , excsm_prod_mstr       excpm                      
            , client_ctgry_mstr     clicm                      
            , entity_property_mstr  entpm        
              LEFT OUTER JOIN                      
              entpm_dtls_mstr       entdm on (entpm.entpm_prop_id = entdm.entdm_entpm_prop_id)                       
              LEFT OUTER JOIN                      
              entity_properties     entp  on (entp.entp_entpm_prop_id = entpm.entpm_prop_id ) and (entp.entp_ent_id = @pa_crn_no)                       
              LEFT OUTER JOIN                       
              entity_property_dtls  entpd on (entpd.entpd_entp_id = entp.entp_id) and (entpd.entpd_entdm_id = entdm.entdm_id)                      
      WHERE dpam.dpam_excsm_id       = excsm.excsm_id                      
      AND   excpm.excpm_excsm_id     = dpam.dpam_excsm_id                      
      AND   clicm.clicm_cd           = dpam.dpam_clicm_cd                       
      AND   entpm.entpm_clicm_id     = clicm.clicm_id                      
      AND   entpm.entpm_enttm_id     = dpam.dpam_enttm_id                      
      AND   entpm.entpm_excpm_id     = excpm.excpm_id                      
      AND   dpam.dpam_deleted_ind    = 1                      
      AND   excsm.excsm_deleted_ind  = 1                       
      AND   clicm.clicm_deleted_ind  = 1                      
      AND   entpm.entpm_deleted_ind  = 1                      
      AND   dpam.dpam_crn_no         = @pa_crn_no                      
      ORDER BY ord1, entpm.entpm_cd, entdm.entdm_cd                      
  --                                    
  END  */          
 IF @pa_tab = 'DPAM_FRMNO_CHK'          
  BEGIN          
  IF ISNULL(@PA_CRN_NO,0) = 0          
  BEGIN
     select sum(cnt)
     from(          
     SELECT COUNT(DPAM_ACCT_NO) cnt FROM DP_ACCT_MSTR_MAK  , dp_mstr        
     WHERE DPAM_DELETED_IND IN (0,8)        
     AND DPAM_ACCT_NO = @PA_VALUE        
     and  dpam_dpm_id = dpm_id
     and  DPM_DPID = @pa_ACCT_NO

     union 
     
     SELECT COUNT(DPAM_ACCT_NO) cnt FROM DP_ACCT_MSTR  , dp_mstr       
     WHERE DPAM_DELETED_IND = 1
     AND DPAM_ACCT_NO = @PA_VALUE
     and  dpam_dpm_id = dpm_id
     and  DPM_DPID = @pa_ACCT_NO) t
  END        
  ELSE
  BEGIN
     select sum(cnt)
     from(          
     SELECT COUNT(DPAM_ACCT_NO) cnt FROM DP_ACCT_MSTR_MAK  , dp_mstr        
     WHERE DPAM_DELETED_IND IN (0,8)        
     AND DPAM_ACCT_NO = @PA_VALUE        
     and  dpam_dpm_id = dpm_id
     and dpam_crn_no <> @pa_crn_no
     and  DPM_DPID = @pa_ACCT_NO

     union 
     
     SELECT COUNT(DPAM_ACCT_NO) cnt FROM DP_ACCT_MSTR  , dp_mstr       
     WHERE DPAM_DELETED_IND = 1
     AND DPAM_ACCT_NO = @PA_VALUE
     and  dpam_dpm_id = dpm_id
     and  dpam_crn_no <> @pa_crn_no
     and  DPM_DPID = @pa_ACCT_NO) t
  END        

  END                               
--                        
END

GO
