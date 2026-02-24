-- Object: PROCEDURE citrus_usr.pr_select_dp_acct_details_BAK_13102016
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------



--[pr_select_dp_acct_details]	'0','DP','DP_ACCP','HO',64154,'96','0','24','54719','1','*|~*','|*~|','PROP'




CREATE  PROCEDURE [citrus_usr].[pr_select_dp_acct_details_BAK_13102016](@pa_id             VARCHAR(20)
                                          ,@pa_acct_type      VARCHAR(20) 
                                          ,@pa_tab            VARCHAR(20) 
                                          ,@pa_login_name     VARCHAR(25)
                                          ,@pa_clisba_id      NUMERIC
                                          ,@pa_acct_no        VARCHAR(20)
                                          ,@pa_excpm_id       NUMERIC
                                          ,@pa_clicm_id       NUMERIC
                                          ,@pa_enttm_id       NUMERIC
                                          ,@pa_chk_yn         NUMERIC
                                          ,@rowdelimiter      CHAR(4) 
                                          ,@coldelimiter      CHAR(4)
                                          ,@pa_ref_cur        VARCHAR(8000) OUT
                                           )
AS
/*
**********************************************************************************
SYSTEM         : CITRUS
MODULE NAME    : pr_select_dp_acct_details
DESCRIPTION    : This procedure will select data related to client_account/dp_account
COPYRIGHT(C)   : Marketplace Technologies pvt ltd
VERSION HISTORY:
VERS.  AUTHOR             DATE        REASON
-----  -------------      ----------  --------------------------------------------
1.0    SUKHVINDER         20-AUG-2007 Initial
----------------------------------------------------------------------------------
**********************************************************************************
*/
BEGIN
--
   DECLARE @values1            varchar(8000)
         , @values2            varchar(8000)
         , @c_access_cursor   CURSOR
         , @desc               varchar(50)
   --
   SET @values1 = ''
   SET @values2 = ''
   SET @rowdelimiter ='*|~*'
   SET @coldelimiter ='|*~|'
   --
   IF @pa_chk_yn = 0 OR @pa_chk_yn = 2
   BEGIN--chk_0_2
   --
     IF @pa_tab = 'DP_ACCT_ADDR'
     BEGIN
     --
        SET    @c_access_cursor =  CURSOR fast_forward FOR
        /*SELECT  concm.concm_cd+@coldelimiter+isnull(a.adr_1,' ')+@coldelimiter+isnull(a.adr_2,' ')+@coldelimiter+isnull(a.adr_3,' ')+@coldelimiter+isnull(a.adr_city,' ')+@coldelimiter+isnull(a.adr_state,' ')+@coldelimiter+isnull(a.adr_country,' ')+@coldelimiter+isnull(a.adr_zip,' ')+@coldelimiter+isnull(concm.concm_desc,' ')+@coldelimiter+@rowdelimiter  value
        FROM  (SELECT accac.accac_concm_id      concm_id
                    , adr.adr_1                 adr_1
                    , adr.adr_2                 adr_2
                    , adr.adr_3                 adr_3
                    , adr.adr_city              adr_city
                    , adr.adr_state             adr_state
                    , adr.adr_country           adr_country
                    , adr.adr_zip               adr_zip
               FROM   addresses                 adr    WITH (NOLOCK)
                    , account_adr_conc          accac  WITH (NOLOCK)
               WHERE  accac.accac_adr_conc_id = adr.adr_id
               --AND    accac.accac_clisba_id   = @pa_clisba_id
               AND    accac.accac_acct_no     = convert(varchar, @pa_acct_no)
               AND    adr.adr_deleted_ind     = 1
               AND    accac.accac_deleted_ind = 1
              ) a
               RIGHT OUTER JOIN
               conc_code_mstr                   concm  WITH (NOLOCK)
               ON concm.concm_id              = a.concm_id
        WHERE  concm.concm_deleted_ind        = 1
        AND    1 & concm.concm_cli_yn         = 1
        AND    2 & concm.concm_cli_yn         = 0
        ORDER  BY concm.concm_desc*/
        SELECT ltrim(rtrim(concm.concm_cd))+'|*~|'+isnull(ltrim(rtrim(a.adr_1)),'')+'|*~|'+ISNULL(ltrim(rtrim(a.adr_2)),'')+'|*~|'+ISNULL(ltrim(rtrim(a.adr_3)),'')+'|*~|'+ISNULL(ltrim(rtrim(a.adr_city)),'')+'|*~|'+ISNULL(ltrim(rtrim(a.adr_state)),'')+'|*~|'+ISNULL(ltrim(rtrim(a.adr_country)),'')+'|*~|'+ISNULL(ltrim(rtrim(a.adr_zip)),'')+'|*~|'+ltrim(rtrim(concm.concm_desc))+'|*~|'+'*|~*' value
								FROM  (SELECT DISTINCT accac.accac_concm_id      concm_id
																				, adr.adr_1                 adr_1
																				, adr.adr_2                 adr_2
																				, adr.adr_3                 adr_3
																				, adr.adr_city              adr_city
																				, adr.adr_state             adr_state
																				, adr.adr_country           adr_country
																				, adr.adr_zip               adr_zip
																				, convert(varchar,accac.accac_concm_id)+'|*~|'+adr.adr_1+'|*~|'+adr.adr_2+'|*~|'+adr.adr_3+'|*~|'+adr.adr_city+'|*~|'+adr.adr_state+'|*~|'+adr.adr_country+'|*~|'+adr.adr_zip value
															FROM   addresses                 adr    WITH (NOLOCK)
																				, account_adr_conc          accac  WITH (NOLOCK)
															WHERE  accac.accac_adr_conc_id = adr.adr_id
															--AND    accac.accac_clisba_id   = @pa_clisba_id
											                AND    accac.accac_acct_no     = convert(varchar, @pa_acct_no)
															AND    adr.adr_deleted_ind     = 1
															AND    accac.accac_deleted_ind = 1
                                                            AND    ISNULL(adr.adr_1,'') <> ''

														) a
															RIGHT OUTER JOIN
															conc_code_mstr                   concm  WITH (NOLOCK)
															ON concm.concm_id              = a.concm_id
													, bitmap_ref_mstr
													, business_mstr
								WHERE  concm.concm_deleted_ind        = 1
								AND    substring(bitrm_parent_cd,5,len(bitrm_parent_cd))  = busm_cd
								AND    power(2,bitrm_bit_location-1)& concm_cli_yn = power(2,bitrm_bit_location-1)
								AND    busm_cd = 'ACCDEPOSITORY'
								--AND    isnull(a.value,'') <> ''
								AND    1 & concm.concm_cli_yn         = 1  
        AND    2 & concm.concm_cli_yn         = 0  
        and    isnull(a.adr_1,'') <> ''
       ORDER  BY concm.concm_desc
        
        --
        OPEN @c_access_cursor
        FETCH NEXT FROM @c_access_cursor INTO @values1
        --
        WHILE @@fetch_status = 0
        BEGIN
         --
         SET @values2 = ISNULL(@values1,'') +@values2
         FETCH NEXT FROM @c_access_cursor INTO @values1
         --
        END
        --
        CLOSE @c_access_cursor
        deallocate @c_access_cursor
        --
        SELECT @values2 value
     --
     END
     --
     IF @pa_tab = 'DP_ACCT_CONC'
     BEGIN
     --
       SET    @c_access_cursor =  CURSOR fast_forward FOR
       SELECT concm.concm_cd+@coldelimiter+isnull(ltrim(rtrim(a.conc_value)),' ')+@coldelimiter+isnull(concm.concm_desc,' ')+@coldelimiter+@rowdelimiter   value
       FROM  (SELECT DISTINCT accac.accac_concm_id      concm_id
                   , conc.conc_value           conc_value
              FROM   contact_channels          conc  WITH (NOLOCK)
                   , account_adr_conc          accac WITH (NOLOCK)
              WHERE  accac.accac_adr_conc_id = conc.conc_id
              --AND    accac.accac_clisba_id   = @pa_clisba_id 
              AND    accac.accac_acct_no     = convert(varchar, @pa_acct_no)
              AND    conc.conc_deleted_ind   = 1
              AND    accac.accac_deleted_ind = 1
             ) a
              RIGHT OUTER JOIN
              conc_code_mstr                     concm  WITH (NOLOCK)
              ON concm.concm_id=a.concm_id
       WHERE  concm.concm_deleted_ind        = 1
       AND    1 & concm.concm_cli_yn         = 1
       AND    2 & concm.concm_cli_yn         = 2
       ORDER  BY concm.concm_desc
       --
       OPEN @c_access_cursor
       FETCH NEXT FROM @c_access_cursor INTO @values1
       --
       WHILE @@fetch_status = 0
       BEGIN
        --
        SET @values2 = ISNULL(@values1,'') +@values2
        FETCH NEXT FROM @c_access_cursor INTO @values1
        --
       END
       --
       close @c_access_cursor
       deallocate @c_access_cursor
       --
       SELECT @values2 value
     --
     END
IF @pa_tab = 'DP_ACCT_CONC_MOD'
     BEGIN
      --
--       IF @pa_id = 'N'
--	   BEGIN
--       SET    @c_access_cursor =  CURSOR fast_forward FOR
--	   --
--		   SELECT concm.concm_cd+@coldelimiter+isnull(ltrim(rtrim(a.conc_value)),' ')+@coldelimiter+isnull(concm.concm_desc,' ')+@coldelimiter+@rowdelimiter   value
--		   FROM  (SELECT DISTINCT accac.accac_concm_id      concm_id
--					   , conc.conc_value           conc_value
--				  FROM   contact_channels          conc  WITH (NOLOCK)
--					   , account_adr_conc          accac WITH (NOLOCK)
--				  WHERE  accac.accac_adr_conc_id = conc.conc_id
--				  --AND    accac.accac_clisba_id   = @pa_clisba_id 
--				  AND    accac.accac_acct_no     = convert(varchar, @pa_acct_no)
--				  AND    conc.conc_deleted_ind   = 1
--				  AND    accac.accac_deleted_ind = 1
--				 ) a
--				  RIGHT OUTER JOIN
--				  conc_code_mstr                     concm  WITH (NOLOCK)
--				  ON concm.concm_id=a.concm_id
--		   WHERE  concm.concm_deleted_ind        = 1
--		   AND    1 & concm.concm_cli_yn         = 1
--		   AND    2 & concm.concm_cli_yn         = 2
--		   AND    CONCM_CD IN ('NOMINEE_RES','NOMINEE_OFF','NOMINEE_MOB','NOMINEE_MAIL')   
--		   ORDER  BY concm.concm_desc
--       END
--       ELSE IF @pa_id = 'NG'
--       BEGIN
--		   SET    @c_access_cursor =  CURSOR fast_forward FOR
--	       --	
--		   SELECT concm.concm_cd+@coldelimiter+isnull(ltrim(rtrim(a.conc_value)),' ')+@coldelimiter+isnull(concm.concm_desc,' ')+@coldelimiter+@rowdelimiter   value
--		   FROM  (SELECT DISTINCT accac.accac_concm_id      concm_id
--					   , conc.conc_value           conc_value
--				  FROM   contact_channels          conc  WITH (NOLOCK)
--					   , account_adr_conc          accac WITH (NOLOCK)
--				  WHERE  accac.accac_adr_conc_id = conc.conc_id
--				  --AND    accac.accac_clisba_id   = @pa_clisba_id 
--				  AND    accac.accac_acct_no     = convert(varchar, @pa_acct_no)
--				  AND    conc.conc_deleted_ind   = 1
--				  AND    accac.accac_deleted_ind = 1
--				 ) a
--				  RIGHT OUTER JOIN
--				  conc_code_mstr                     concm  WITH (NOLOCK)
--				  ON concm.concm_id=a.concm_id
--		   WHERE  concm.concm_deleted_ind        = 1
--		   AND    1 & concm.concm_cli_yn         = 1
--		   AND    2 & concm.concm_cli_yn         = 2
--		   AND    CONCM_CD IN ('NOM_GUARD_RES','NOM_GUARD_OFF','NOM_GUARD_MOB','NOM_GUARD_MAIL')
--		   ORDER  BY concm.concm_desc
--       END
--       ELSE
--	   BEGIN
--		   SET    @c_access_cursor =  CURSOR fast_forward FOR
--	       --
--		   SELECT concm.concm_cd+@coldelimiter+isnull(ltrim(rtrim(a.conc_value)),' ')+@coldelimiter+isnull(concm.concm_desc,' ')+@coldelimiter+@rowdelimiter   value
--		   FROM  (SELECT DISTINCT accac.accac_concm_id      concm_id
--					   , conc.conc_value           conc_value
--				  FROM   contact_channels          conc  WITH (NOLOCK)
--					   , account_adr_conc          accac WITH (NOLOCK)
--				  WHERE  accac.accac_adr_conc_id = conc.conc_id
--				  --AND    accac.accac_clisba_id   = @pa_clisba_id 
--				  AND    accac.accac_acct_no     = convert(varchar, @pa_acct_no)
--				  AND    conc.conc_deleted_ind   = 1
--				  AND    accac.accac_deleted_ind = 1
--				 ) a
--				  RIGHT OUTER JOIN
--				  conc_code_mstr                     concm  WITH (NOLOCK)
--				  ON concm.concm_id=a.concm_id
--		   WHERE  concm.concm_deleted_ind        = 1
--		   AND    1 & concm.concm_cli_yn         = 1
--		   AND    2 & concm.concm_cli_yn         = 2
--		   AND    CONCM_CD IN ('GUARD_RES','GUARD_OFF','GUARD_MOB','GUARD_EMAIL') 
--		   ORDER  BY concm.concm_desc
--       END
	   SET    @c_access_cursor =  CURSOR fast_forward FOR
	   SELECT concm.concm_cd+@coldelimiter+isnull(ltrim(rtrim(a.conc_value)),' ')+@coldelimiter+isnull(concm.concm_desc,' ')+@coldelimiter+@rowdelimiter   value
		   FROM  (SELECT DISTINCT accac.accac_concm_id      concm_id
					   , conc.conc_value           conc_value
				  FROM   contact_channels          conc  WITH (NOLOCK)
					   , account_adr_conc          accac WITH (NOLOCK)
				  WHERE  accac.accac_adr_conc_id = conc.conc_id
				  --AND    accac.accac_clisba_id   = @pa_clisba_id 
				  AND    accac.accac_acct_no     = convert(varchar, @pa_acct_no)
				  AND    conc.conc_deleted_ind   = 1
				  AND    accac.accac_deleted_ind = 1
				 ) a
				  RIGHT OUTER JOIN
				  conc_code_mstr                     concm  WITH (NOLOCK)
				  ON concm.concm_id=a.concm_id
		   WHERE  concm.concm_deleted_ind        = 1
		   AND    1 & concm.concm_cli_yn         = 1
		   AND    2 & concm.concm_cli_yn         = 2
		   AND    CONCM_CD IN ('NOMINEE_RES','NOMINEE_OFF','NOMINEE_MOB','NOMINEE_MAIL','NOM_GUARD_RES','NOM_GUARD_OFF','NOM_GUARD_MOB','NOM_GUARD_MAIL','GUARD_RES','GUARD_OFF','GUARD_MOB','GUARD_EMAIL','SH_MOBILE','SH_EMAIL1','TH_MOBILE','TH_EMAIL1')   
		   --ORDER  BY concm.concm_desc
		   order by CONCM_CD
       --
       OPEN @c_access_cursor
       FETCH NEXT FROM @c_access_cursor INTO @values1
       --
       WHILE @@fetch_status = 0
       BEGIN
        --
        SET @values2 = ISNULL(@values1,'') +@values2
        FETCH NEXT FROM @c_access_cursor INTO @values1
        --
       END
       --
       close @c_access_cursor
       deallocate @c_access_cursor
       --
       SELECT @values2 value
     --
     END
     IF @pa_tab = 'DP_ACCP'
     BEGIN
 
     --
     
     PRINT 'DFSDFDSFSDDF'
       SELECT DISTINCT a.accpm_prop_id                accpm_prop_id
              , a.accpm_prop_desc                     accpm_prop_desc
              , a.accpm_prop_cd                     accpm_prop_cd
              , ISNULL(a.accp_value, ' ')             accp_value
              , a.accpm_datatype                      accpm_datatype
              , a.accpm_mdty                          accpm_mdty
              , b.accdm_mdty                          accdm_mdty
              , ISNULL(b.accdm_id,0)                  accdm_id
              , ISNULL(b.accdm_desc,'')               accdm_desc
              , ISNULL(b.accpd_value, ' ')            accpd_value
              , ISNULL(LTRIM(RTRIM(b.accdm_datatype)),'') accdm_datatype
       FROM  (SELECT DISTINCT accpm.accpm_prop_desc   accpm_prop_desc
                   , accpm.accpm_prop_id              accpm_prop_id
                   , accpm.accpm_prop_cd                     accpm_prop_cd
                   , CASE accpm.accpm_mdty WHEN 1 THEN 'M' ELSE 'N' END accpm_mdty
                   , accp.accp_value                  accp_value
                   , accpm.accpm_datatype             accpm_datatype
              FROM   account_properties               accp
                     right outer join
                     account_property_mstr            accpm 
              ON     accp.accp_accpm_prop_id          = accpm.accpm_prop_id
              --AND    ISNULL(accp.accp_acct_no, '')    = ISNULL(convert(varchar, @pa_acct_no), '')
              AND    accp.accp_clisba_id              = @pa_clisba_id
              AND    ISNULL(accp.accp_deleted_ind, 1) = 1
                    , excsm_prod_mstr                 excpm
              WHERE   accpm.accpm_deleted_ind         = 1
              AND     excpm.excpm_deleted_ind         = 1  and ACCPM_DELETED_IND = 1 
              AND     accpm.accpm_clicm_id            = @pa_clicm_id         
              AND     accpm.accpm_enttm_id            = @pa_enttm_id         
              AND     accpm.accpm_acct_type           = @pa_acct_type 
              ) a 
              left outer join 
              (SELECT accdm_id
                    , accdm_desc
                    , accpd_value
                    , accdm_datatype 
                    , accdm_accpm_prop_id
                    , CASE accdm.accdm_mdty WHEN 1 THEN 'M' ELSE 'N' END accdm_mdty
               FROM   accpm_dtls_mstr accdm 
                      left outer join 
                      account_property_dtls accpd 
               ON     accdm.accdm_id = accpd.accpd_accdm_id 
               AND    accpd_accp_id IN (SELECT accp_id FROM account_properties  WITH (NOLOCK) WHERE accp_clisba_id = @pa_clisba_id AND accp_deleted_ind = 1)
               AND    accpd.accpd_deleted_ind = 1
               WHERE  accdm.accdm_deleted_ind = 1 
               ) b
               ON     a.accpm_prop_id = b.accdm_accpm_prop_id 
     --         
     END
     --
     IF @pa_tab = 'DP_ACCP_MOD'
	 BEGIN
		DECLARE @DPAM_ID INTEGER
		--DECLARE @DPAM_ACCT_NO VARCHAR(16)
		SELECT @DPAM_ID = DPAM_ID FROM DP_ACCT_MSTR WHERE DPAM_SBA_NO = @PA_ACCT_NO
		SELECT distinct ACCP_ACCPM_PROP_CD,ACCP_VALUE,ACCP_ACCT_NO,accpm_prop_id FROM ACCOUNT_PROPERTIES,account_property_mstr 
		WHERE ACCP_ACCPM_PROP_CD IN ('RGESS_FLAG','BSDA','SMS_FLAG','ADHAARFLAG','ADHAARSECHLDR','ADHAARTHRDHLDR','CONFIRMATION','EMAIL_ST_FLAG','CAS_FLAG','RTA_EMAIL','SLT')
		--AND ACCP_ACCT_NO = ''--'I10151'
		AND ACCP_CLISBA_ID = @DPAM_ID
		AND accp_accpm_prop_id  = accpm_prop_id
		AND ACCP_DELETED_IND = 1
		AND ACCPM_DELETED_IND = 1
     END
     --
     --IF @pa_tab = 'DP_ACCD'
     --BEGIN
     --print 'pankaj1'
     ----
     --  SELECT DISTINCT isnull(accd.accd_doc_path,'')  accd_doc_path  
     --       , isnull(accd.accd_remarks,'')            accd_remarks    
     --       , accdocm.accdocm_doc_id                  accdocm_doc_id  
     --       , isnull(accdocm.accdocm_desc,'')         accdocm_desc  
     --       , CASE accdocm.accdocm_mdty WHEN 1 THEN 'M' ELSE 'N' END accdocm_mdty  
     --       , isnull(accd.accd_valid_yn,0)            accd_valid_yn
     --       , CAST(accd_binary_image AS VARBINARY(8000))    cli_image 
     --  FROM   account_document_mstr  accdocm     WITH(NOLOCK)  
     --         LEFT OUTER JOIN
     --         account_documents      accd        WITH(NOLOCK)   
     --  ON     (accdocm.accdocm_doc_id          = accd.accd_accdocm_doc_id 
     --  AND     accd.accd_clisba_id             = isnull(@pa_clisba_id,0)
     --  AND     accd.accd_acct_type             = isnull(@pa_acct_type,'')
     --         )
     --       , exch_seg_mstr          excsm       WITH(NOLOCK)  
     --  WHERE  accdocm.accdocm_clicm_id         = @pa_clicm_id
     --  AND    accdocm.accdocm_enttm_id         = @pa_enttm_id
     --  AND    isnull(accd_deleted_ind, 1)      = 1
     --  AND    excsm.excsm_deleted_ind          = 1  
     --  AND    accdocm.accdocm_deleted_ind      = 1  
     --  ORDER BY accdocm_desc
     ----
     --END
  --
  
  IF @pa_tab = 'DP_ACCD'
     BEGIN
     print 'pankaj1'
    
       create table #signature (sig_doc_path varchar(200),sig_remks varchar(250),sig_doc_id numeric,sig_desc varchar(100),sig_mdty VARCHAR, sig_valid_yn smallint, sig_path image )

insert into #signature
SELECT  isnull(accd.accd_doc_path,'')  accd_doc_path  
            , isnull(accd.accd_remarks,'')            accd_remarks    
            , accdocm.accdocm_doc_id                  accdocm_doc_id  
            , isnull(accdocm.accdocm_desc,'')         accdocm_desc  
            , CASE accdocm.accdocm_mdty WHEN 1 THEN 'M' ELSE 'N' END accdocm_mdty  
            , isnull(accd.accd_valid_yn,0)            accd_valid_yn
             --, CAST(accd_binary_image AS VARBINARY(8000))    cli_image
             ,accd_binary_image  as cli_image
       FROM   account_document_mstr  accdocm     WITH(NOLOCK)  
              LEFT OUTER JOIN
              account_documents      accd        WITH(NOLOCK)   
       ON     (accdocm.accdocm_doc_id          = accd.accd_accdocm_doc_id 
       AND     accd.accd_clisba_id             = isnull(@pa_clisba_id,0)
       AND     accd.accd_acct_type             = isnull(@pa_acct_type,'')
              )
            , exch_seg_mstr          excsm       WITH(NOLOCK) 
--, ACCD_BINARY_IMAGE 
       WHERE  accdocm.accdocm_clicm_id         = @pa_clicm_id
       AND    accdocm.accdocm_enttm_id         = @pa_enttm_id
       AND    isnull(accd_deleted_ind, 1)      = 1
       AND    excsm.excsm_deleted_ind          = 1  
       AND    accdocm.accdocm_deleted_ind      = 1  
       ORDER BY accdocm_desc       
       
       select top 1 * into #signature_final from #signature
   where sig_desc = 'BO SIGNATURE'

   insert into #signature_final 
   select top 1 * from #signature
   where sig_desc = 'POA SIGNATURE'
   
   insert into #signature_final 
   select top 1 * from #signature
   where sig_desc = 'PAN / GIR NO'
   
   select sig_doc_path as accd_doc_path ,sig_remks as accd_remarks,sig_doc_id as accdocm_doc_id,sig_desc as accdocm_desc,sig_mdty as accdocm_mdty , sig_valid_yn as accd_valid_yn, sig_path as cli_image from #signature_final order by sig_desc
     --
     END
  --
	IF @pa_tab = 'DP_ACCD_MOD'
     BEGIN
     print 'pankaj1'
    
       create table #signature1 (sig_doc_path varchar(200),sig_remks varchar(250),sig_doc_id numeric,sig_desc varchar(100),sig_mdty VARCHAR, sig_valid_yn smallint, sig_path image )

insert into #signature1
SELECT  isnull(accd.accd_doc_path,'')  accd_doc_path  
            , isnull(accd.accd_remarks,'')            accd_remarks    
            , accdocm.accdocm_doc_id                  accdocm_doc_id  
            , isnull(accdocm.accdocm_desc,'')         accdocm_desc  
            , CASE accdocm.accdocm_mdty WHEN 1 THEN 'M' ELSE 'N' END accdocm_mdty  
            , isnull(accd.accd_valid_yn,0)            accd_valid_yn
             --, CAST(accd_binary_image AS VARBINARY(8000))    cli_image
             ,accd_binary_image  as cli_image
       FROM   account_document_mstr  accdocm     WITH(NOLOCK)  
              LEFT OUTER JOIN
              account_documents      accd        WITH(NOLOCK)   
       ON     (accdocm.accdocm_doc_id          = accd.accd_accdocm_doc_id 
       AND     accd.accd_clisba_id             = isnull(@pa_clisba_id,0)
       AND     accd.accd_acct_type             = isnull(@pa_acct_type,'')
              )
            , exch_seg_mstr          excsm       WITH(NOLOCK) 
--, ACCD_BINARY_IMAGE 
       WHERE  accdocm.accdocm_clicm_id         = @pa_clicm_id
       AND    accdocm.accdocm_enttm_id         = @pa_enttm_id
       AND    isnull(accd_deleted_ind, 1)      = 1
       AND    excsm.excsm_deleted_ind          = 1  
       AND    accdocm.accdocm_deleted_ind      = 1  
       ORDER BY accdocm_desc       
       
       select top 1 * into #signature_final1 from #signature1
   where sig_desc = 'BO SIGNATURE'

   --insert into #signature_final 
   --select top 1 * from #signature
   --where sig_desc = 'POA SIGNATURE'
   
   --insert into #signature_final 
   --select top 1 * from #signature
   --where sig_desc = 'PAN / GIR NO'
   
   select sig_doc_path as accd_doc_path ,sig_remks as accd_remarks,sig_doc_id as accdocm_doc_id,sig_desc as accdocm_desc,sig_mdty as accdocm_mdty , sig_valid_yn as accd_valid_yn, sig_path as cli_image from #signature_final1 order by sig_desc
     --
     END
  
  END
  
  
  --
  
  
  --select * from conc_acct_mak
  --select * from addr_acct_mak
  IF @pa_chk_yn = 1
  BEGIN--chk_1
  --
    IF @pa_tab = 'DP_ACCT_ADDR'
    BEGIN--dp_acct_addr
    --
      SET    @c_access_cursor =  CURSOR fast_forward FOR
      SELECT ltrim(rtrim(addam.adr_concm_cd))+@coldelimiter+isnull(ltrim(rtrim(addam.adr_1)),' ')+@coldelimiter+isnull(ltrim(rtrim(addam.adr_2)),' ')+@coldelimiter+isnull(ltrim(rtrim(addam.adr_3)),' ')+@coldelimiter+isnull(ltrim(rtrim(addam.adr_city)),' ')+@coldelimiter+isnull(ltrim(rtrim(addam.adr_state)),' ')+@coldelimiter+isnull(ltrim(rtrim(addam.adr_country)),' ')+@coldelimiter+isnull(convert(varchar, ltrim(rtrim(addam.adr_zip))),'')+@coldelimiter+isnull(ltrim(rtrim(concm.concm_desc)),' ')+@coldelimiter+@rowdelimiter  value
           , concm.concm_desc             concm_desc
      FROM   addr_acct_mak                addam
             right outer join
             conc_code_mstr               concm ON concm.concm_id=addam.adr_concm_id  AND addam.adr_deleted_ind IN (0, 8) AND  addam.adr_acct_no = convert(varchar, @pa_acct_no)
      WHERE  concm.concm_deleted_ind      = 1
      AND    1 & concm.concm_cli_yn       = 1
      AND    2 & concm.concm_cli_yn       = 0
      UNION 
      SELECT  ltrim(rtrim(concm.concm_cd))+@coldelimiter+isnull(ltrim(rtrim(a.adr_1)),'')+@coldelimiter+ISNULL(ltrim(rtrim(a.adr_2)),'')+@coldelimiter+ISNULL(ltrim(rtrim(a.adr_3)),'')+@coldelimiter+ISNULL(ltrim(rtrim(a.adr_city)),'')+@coldelimiter+ISNULL(ltrim(rtrim(a.adr_state)),'')+@coldelimiter+ISNULL(ltrim(rtrim(a.adr_country)),'')+@coldelimiter+ISNULL(ltrim(rtrim(a.adr_zip)),'')+@coldelimiter+isnull(ltrim(rtrim(concm.concm_desc)),' ')+@coldelimiter+@rowdelimiter  value
            , concm.concm_desc                 concm_desc
       FROM  (SELECT accac.accac_concm_id      concm_id
                   , adr.adr_1                 adr_1
                   , adr.adr_2                 adr_2
                   , adr.adr_3                 adr_3
                   , adr.adr_city              adr_city
                   , adr.adr_state             adr_state
                   , adr.adr_country           adr_country
                   , adr.adr_zip               adr_zip

              FROM   addresses                 adr    WITH (NOLOCK)
                   , account_adr_conc          accac  WITH (NOLOCK)
              WHERE  accac.accac_adr_conc_id = adr.adr_id
              --AND    accac.accac_clisba_id   = @pa_clisba_id
              AND    accac.accac_acct_no     = convert(varchar, @pa_acct_no)
              AND    adr.adr_deleted_ind     = 1
              AND    accac.accac_deleted_ind = 1
              AND    ISNULL(adr.adr_1,'') <> ''
             ) a
              RIGHT OUTER JOIN
              conc_code_mstr                   concm  WITH (NOLOCK)
              ON concm.concm_id              = a.concm_id
       WHERE  concm.concm_deleted_ind        = 1
       AND    1 & concm.concm_cli_yn         = 1
       AND    2 & concm.concm_cli_yn         = 0
       AND    concm.concm_id NOT IN ( SELECT addam.adr_concm_id       adr_concm_id
                                      FROM   addr_acct_mak            addam
                                      --WHERE  addam.adr_clisba_id  = @pa_clisba_id
                                      WHERE  addam.adr_acct_no      = convert(varchar, @pa_acct_no)
                                      AND    addam.adr_deleted_ind IN (0, 4, 8)
                                    )
      ORDER  BY concm.concm_desc
      --
      OPEN @c_access_cursor
      --
      FETCH NEXT FROM @c_access_cursor INTO @values1, @desc
      --
      WHILE @@fetch_status = 0
      BEGIN
       --
       SET @values2 = isnull(@values1,'')+@values2
       --
       FETCH NEXT FROM @c_access_cursor INTO @values1, @desc
       --
      END
      --
      close @c_access_cursor
      deallocate @c_access_cursor
      --
      SELECT @values2 value
    --  
    END--dp_acct_addr
    --
    IF @pa_tab = 'DP_ACCT_CONC'
    BEGIN--dp_acct_conc
    --



      SET    @c_access_cursor =  CURSOR fast_forward FOR
      SELECT concm.concm_cd+@coldelimiter+isnull(concam.conc_value,' ')+@coldelimiter+isnull(concm.concm_desc,' ')+@coldelimiter+@rowdelimiter   value
           , concm.concm_desc                concm_desc--,concm.concm_cli_yn,concm.concm_rmks
      FROM   conc_acct_mak                   concam
             RIGHT OUTER JOIN
             conc_code_mstr                  concm  WITH (NOLOCK)
             ON concm.concm_id = concam.conc_concm_id AND concam.conc_acct_no = convert(varchar, @pa_acct_no) AND concam.conc_deleted_ind IN (0, 8)
      WHERE  concm.concm_deleted_ind        = 1
      AND    1 & concm.concm_cli_yn         = 1
      AND    2 & concm.concm_cli_yn         = 2
      UNION
      SELECT concm.concm_cd+@coldelimiter+isnull(ltrim(rtrim(a.conc_value)),' ')+@coldelimiter+isnull(concm.concm_desc,' ')+@coldelimiter+@rowdelimiter   value
           , concm.concm_desc                 concm_desc--,concm.concm_cli_yn,concm.concm_rmks
      FROM  (SELECT accac.accac_concm_id      concm_id
                  , conc.conc_value           conc_value
             FROM   contact_channels          conc  WITH (NOLOCK)
                  , account_adr_conc          accac WITH (NOLOCK)
             WHERE  accac.accac_adr_conc_id = conc.conc_id
             --AND    accac.accac_clisba_id   = @pa_clisba_id 
             AND    accac.accac_acct_no     = convert(varchar, @pa_acct_no)
             AND    conc.conc_deleted_ind   = 1
             AND    accac.accac_deleted_ind = 1
            ) a
             RIGHT OUTER JOIN
             conc_code_mstr                     concm  WITH (NOLOCK)
             ON concm.concm_id=a.concm_id
      WHERE  concm.concm_deleted_ind        = 1
      AND    1 & concm.concm_cli_yn         = 1
      AND    2 & concm.concm_cli_yn         = 2
      AND    concm.concm_id NOT IN (SELECT concam.conc_concm_id     conc_concm_id
                                    FROM   conc_acct_mak           concam
                                    --WHERE  concam.conc_clisba_id   = @pa_clisba_id
                                    WHERE  concam.conc_acct_no       = @pa_acct_no
                                    AND    concam.conc_deleted_ind IN (0, 4, 8)
                                   ) 
      ORDER  BY concm.concm_desc
      --
      OPEN @c_access_cursor
      --
      FETCH NEXT FROM @c_access_cursor INTO @values1, @desc
      --
      WHILE @@fetch_status = 0
      BEGIN
      --
        SET @values2 = isnull(@values1,'') +@values2
        --
        FETCH NEXT FROM @c_access_cursor INTO @values1, @desc
      --
      END
      --
      close @c_access_cursor
      deallocate @c_access_cursor
      --
      SELECT @values2 value
    --
    END--dp_acct_conc
    --
    --IF @pa_tab = 'DP_ACCD'
    --BEGIN--dp_accd
    --    print 'pankaj2'
    ----
    --  SELECT DISTINCT ISNULL(accd.accd_doc_path,'')    accd_doc_path  
    --       , isnull(accd.accd_remarks,'')              accd_remarks    
    --       , accdocm.accdocm_doc_id                    accdocm_doc_id  
    --       , isnull(accdocm.accdocm_desc,'')           accdocm_desc  
    --       , case accdocm.accdocm_mdty when 1 then 'M' else 'N' end accdocm_mdty  
    --       , isnull(accd.accd_valid_yn,0)              accd_valid_yn
    --  FROM   account_document_mstr accdocm             WITH(NOLOCK)
    --         left outer join   
    --         accd_mak              accd                WITH(NOLOCK)   
    --    on   accdocm.accdocm_doc_id                  = accd.accd_accdocm_doc_id 
    --    and  accd_clisba_id                          = @pa_clisba_id
    --    AND  accd.accd_acct_type                     = isnull(@pa_acct_type,'')
    --    AND  isnull(accd_deleted_ind, 0)            IN (0,4,8)
    --        , exch_seg_mstr         excsm               WITH(NOLOCK)  
    --  WHERE  accdocm.accdocm_clicm_id                = @pa_clicm_id
    --  AND    accdocm.accdocm_enttm_id                = @pa_enttm_id
    --  AND    isnull(accdocm_doc_id,0) NOT IN (SELECT accd_accdocm_doc_id FROM ACCOUNT_DOCUMENTS  WHERE accd_clisba_id = @pa_clisba_id AND accd_deleted_ind =1)
    --  AND    excsm.excsm_deleted_ind                 = 1  
    --  AND    accdocm.accdocm_deleted_ind             = 1  
    --  UNION
    --  SELECT DISTINCT ISNULL(accd.accd_doc_path,'')    accd_doc_path  
    --       , isnull(accd.accd_remarks,'')              accd_remarks    
    --       , accdocm.accdocm_doc_id                    accdocm_doc_id  
    --       , isnull(accdocm.accdocm_desc,'')           accdocm_desc  
    --       , case accdocm.accdocm_mdty when 1 then 'M' else 'N' end accdocm_mdty  
    --       , isnull(accd.accd_valid_yn,0)              accd_valid_yn
    --  FROM   account_document_mstr accdocm             WITH (NOLOCK)  
    --        ,account_documents     accd                WITH  (NOLOCK)   
     
    --       , exch_seg_mstr         excsm               WITH  (NOLOCK)  
    --  WHERE  accdocm.accdocm_clicm_id                = @pa_clicm_id
    --  AND    accdocm.accdocm_enttm_id                = @pa_enttm_id
    --  AND    accdocm.accdocm_doc_id                  = accd.accd_accdocm_doc_id 
    --  and    accd_clisba_id                          = @pa_clisba_id
    --  AND    accd.accd_acct_type                     = isnull(@pa_acct_type,'')
    --  AND    excsm.excsm_deleted_ind                 = 1  
    --  AND    accdocm.accdocm_deleted_ind             = 1  
    --  --AND    accd.accd_acct_no                       = convert(varchar, @pa_acct_no)
      
    --  AND    isnull(accd_deleted_ind, 1)             = 1
      
    --  ORDER  BY accdocm_desc
    ----
    --END--dp_accd
    
--    IF @pa_tab = 'DP_ACCD'
--    BEGIN--dp_accd
--    --
--	declare @accd_accdocm_doc_id numeric,@accd_accdocm_doc_id_mod numeric
--	select @accd_accdocm_doc_id  = accd_accdocm_doc_id from accd_mak where accd_clisba_id = @pa_clisba_id and accd_deleted_ind in ( 0,4,8)
	
--	--select distinct @accd_accdocm_doc_id_mod=clic_mod_dpam_sba_no  from client_list_modified ,dp_acct_mstr where DPAM_SBA_NO=clic_mod_dpam_sba_no
--	--and DPAM_ID=@pa_clisba_id and clic_mod_action='SIGNATURE' and clic_mod_deleted_ind=0

--	PRINT @accd_accdocm_doc_id
--    if isnull(@accd_accdocm_doc_id,'0')='0' -- and isnull(@accd_accdocm_doc_id_mod,'0')='0'-- IS NULL
--	begin
	
--		SELECT DISTINCT ISNULL(accd.accd_doc_path,'')    accd_doc_path  
--           , isnull(accd.accd_remarks,'')              accd_remarks    
--           , accdocm.accdocm_doc_id                    accdocm_doc_id  
--           , isnull(accdocm.accdocm_desc,'')           accdocm_desc  
--           , case accdocm.accdocm_mdty when 1 then 'M' else 'N' end accdocm_mdty  
--           , isnull(accd.accd_valid_yn,0)              accd_valid_yn,ACCD_LST_UPD_DT
--           , CAST(accd_binary_image AS VARBINARY(8000))    cli_image 
--      FROM   account_document_mstr accdocm             WITH(NOLOCK)
--             left outer join   
--             accd_mak              accd                WITH(NOLOCK)   
--        on   accdocm.accdocm_doc_id                  = accd.accd_accdocm_doc_id 
--        and  accd_clisba_id                          = @pa_clisba_id
--        AND  accd.accd_acct_type                     = isnull(@pa_acct_type,'')
--        AND  isnull(accd_deleted_ind, 0)            IN (0,4,8)
--            , exch_seg_mstr         excsm               WITH(NOLOCK)  
--      WHERE  accdocm.accdocm_clicm_id                = @pa_clicm_id
--      AND    accdocm.accdocm_enttm_id                = @pa_enttm_id
--      AND    isnull(accdocm_doc_id,0) NOT IN (SELECT accd_accdocm_doc_id FROM accd_mak  WHERE accd_clisba_id = @pa_clisba_id AND accd_deleted_ind =1)
--      AND    excsm.excsm_deleted_ind                 = 1  
--      AND    accdocm.accdocm_deleted_ind             = 1  
--      UNION
--      SELECT DISTINCT ISNULL(accd.accd_doc_path,'')    accd_doc_path  
--           , isnull(accd.accd_remarks,'')              accd_remarks    
--           , accdocm.accdocm_doc_id                    accdocm_doc_id  
--           , isnull(accdocm.accdocm_desc,'')           accdocm_desc  
--           , case accdocm.accdocm_mdty when 1 then 'M' else 'N' end accdocm_mdty  
--           , isnull(accd.accd_valid_yn,0)              accd_valid_yn,ACCD_LST_UPD_DT
--           , CAST(accd_binary_image AS VARBINARY(8000))    cli_image 
--      FROM   account_document_mstr accdocm             WITH (NOLOCK)  
--            ,account_documents     accd                WITH  (NOLOCK)   
     
--           , exch_seg_mstr         excsm               WITH  (NOLOCK)  
--      WHERE  accdocm.accdocm_clicm_id                = @pa_clicm_id
--      AND    accdocm.accdocm_enttm_id                = @pa_enttm_id
--      AND    accdocm.accdocm_doc_id                  = accd.accd_accdocm_doc_id 
--      and    accd_clisba_id                          = @pa_clisba_id
--      AND    accd.accd_acct_type                     = isnull(@pa_acct_type,'')
--      AND    excsm.excsm_deleted_ind                 = 1  
--      AND    accdocm.accdocm_deleted_ind             = 1  
--      --AND    accd.accd_acct_no                       = convert(varchar, @pa_acct_no)
      
--      AND    isnull(accd_deleted_ind, 1)             = 1
      
--      ORDER  BY ACCD_LST_UPD_DT desc,accdocm_desc
--END
--ELSE
--BEGIN
--	print 'tup'
--      SELECT DISTINCT ISNULL(accd.accd_doc_path,'')    accd_doc_path  
--           , isnull(accd.accd_remarks,'')              accd_remarks    
--           , accdocm.accdocm_doc_id                    accdocm_doc_id  
--           , isnull(accdocm.accdocm_desc,'')           accdocm_desc  
--           , case accdocm.accdocm_mdty when 1 then 'M' else 'N' end accdocm_mdty  
--           , isnull(accd.accd_valid_yn,0)              accd_valid_yn
--           , CAST(accd_binary_image AS VARBINARY(8000))    cli_image 
--      FROM   account_document_mstr accdocm             WITH(NOLOCK)
--             left outer join   
--             accd_mak              accd                WITH(NOLOCK)   
--        on   accdocm.accdocm_doc_id                  = accd.accd_accdocm_doc_id 
--        and  accd_clisba_id                          = @pa_clisba_id
--        AND  accd.accd_acct_type                     = isnull(@pa_acct_type,'')
--        AND  isnull(accd_deleted_ind, 0)            IN (0,4,8)
--            , exch_seg_mstr         excsm               WITH(NOLOCK)  
--      WHERE  accdocm.accdocm_clicm_id                = @pa_clicm_id
--      AND    accdocm.accdocm_enttm_id                = @pa_enttm_id
--      --AND    isnull(accdocm_doc_id,0) NOT IN (SELECT accd_accdocm_doc_id FROM ACCOUNT_DOCUMENTS  WHERE accd_clisba_id = @pa_clisba_id AND accd_deleted_ind =1)
--      AND    excsm.excsm_deleted_ind                 = 1  
--      AND    accdocm.accdocm_deleted_ind             = 1  
--	  --and accd_accdocm_doc_id not in(select accd_accdocm_doc_id from accd_mak where accd_clisba_id = @pa_clisba_id and accd_deleted_ind = 0)
--	  and accd_accdocm_doc_id 
--	  in (select accd_accdocm_doc_id from accd_mak where accd_clisba_id = @pa_clisba_id and accd_deleted_ind = 0)
--      UNION
--      SELECT DISTINCT ISNULL(accd.accd_doc_path,'')    accd_doc_path  
--           , isnull(accd.accd_remarks,'')              accd_remarks    
--           , accdocm.accdocm_doc_id                    accdocm_doc_id  
--           , isnull(accdocm.accdocm_desc,'')           accdocm_desc  
--           , case accdocm.accdocm_mdty when 1 then 'M' else 'N' end accdocm_mdty  
--           , isnull(accd.accd_valid_yn,0)              accd_valid_yn
--           , CAST(accd_binary_image AS VARBINARY(8000))    cli_image 
--      FROM   account_document_mstr accdocm             WITH (NOLOCK)  
--            --,account_documents     accd                WITH  (NOLOCK)   
--            left outer join accd_mak              accd                WITH(NOLOCK)
--      on     accdocm.accdocm_doc_id                  = accd.accd_accdocm_doc_id 
--      and    accd_clisba_id                          = @pa_clisba_id
--      AND    accd.accd_acct_type                     = isnull(@pa_acct_type,'')
--      AND    accdocm.accdocm_deleted_ind             = 1  
--	  and accd_accdocm_doc_id not in
--	  (select accd_accdocm_doc_id from accd_mak where accd_clisba_id = @pa_clisba_id and accd_deleted_ind = 1)
--            AND    isnull(accd_deleted_ind, 1)             in ('0','4','8')

--           , exch_seg_mstr         excsm               WITH  (NOLOCK)  
--      WHERE  accdocm.accdocm_clicm_id                = @pa_clicm_id
--      AND    accdocm.accdocm_enttm_id                = @pa_enttm_id      
--      AND    excsm.excsm_deleted_ind                 = 1       
--	  --and accd_accdocm_doc_id not in(select accd_accdocm_doc_id from accd_mak where accd_clisba_id = @pa_clisba_id and accd_deleted_ind = 8)
--      --AND    accd.accd_acct_no                       = convert(varchar, @pa_acct_no)
    
      
--      ORDER  BY accdocm_desc
--    --
--		END
--    END--dp_accd
    --
    IF @pa_tab = 'DP_ACCD'
    BEGIN--dp_accd
    
 print '1'
 --PRINT 'YOGESH'
 create table #signature_1 (sig_doc_path varchar(200),sig_remks varchar(250),sig_doc_id numeric,sig_desc varchar(100),sig_mdty varchar, sig_valid_yn smallint, sig_path image )

insert into #signature_1
 SELECT  ISNULL(accd.accd_doc_path,'')    accd_doc_path  
           , isnull(accd.accd_remarks,'')              accd_remarks    
           , accdocm.accdocm_doc_id                    accdocm_doc_id  
           , isnull(accdocm.accdocm_desc,'')           accdocm_desc  
           , case accdocm.accdocm_mdty when 1 then 'M' else 'N' end accdocm_mdty  
           , isnull(accd.accd_valid_yn,0)              accd_valid_yn
           --, CAST(accd_binary_image as varbinary (8000))  cli_image 
           ,accd_binary_image  as cli_image
      FROM   account_document_mstr accdocm             WITH(NOLOCK)
             left outer join   
             accd_mak              accd                WITH(NOLOCK)   
        on   accdocm.accdocm_doc_id                  = accd.accd_accdocm_doc_id 
        and  accd_clisba_id                          = @pa_clisba_id
        AND  accd.accd_acct_type                     = isnull(@pa_acct_type,'')
        AND  isnull(accd.ACCD_DELETED_IND, 0)            IN (0,4,8)
            , exch_seg_mstr         excsm               WITH(NOLOCK)  
      WHERE  accdocm.accdocm_clicm_id                = @pa_clicm_id
      AND    accdocm.accdocm_enttm_id                = @pa_enttm_id
      --AND    isnull(accdocm_doc_id,0) NOT IN (SELECT accd_accdocm_doc_id FROM ACCOUNT_DOCUMENTS  WHERE accd_clisba_id = @pa_clisba_id AND accd_deleted_ind =1)
      AND    excsm.excsm_deleted_ind                 = 1  
      AND    accdocm.accdocm_deleted_ind             = 1  
      UNION ALL
      SELECT  ISNULL(accd.accd_doc_path,'')    accd_doc_path  
           , isnull(accd.accd_remarks,'')              accd_remarks    
           , accdocm.accdocm_doc_id                    accdocm_doc_id  
           , isnull(accdocm.accdocm_desc,'')           accdocm_desc  
           , case accdocm.accdocm_mdty when 1 then 'M' else 'N' end accdocm_mdty  
           , isnull(accd.accd_valid_yn,0)              accd_valid_yn
           --,CAST(accd_binary_image as varbinary (8000))  cli_image 
           ,accd_binary_image  as cli_image
      FROM   account_document_mstr accdocm             WITH (NOLOCK)  
            ,account_documents     accd                WITH  (NOLOCK)   
     
           , exch_seg_mstr         excsm               WITH  (NOLOCK)  
      WHERE  accdocm.accdocm_clicm_id                = @pa_clicm_id
      AND    accdocm.accdocm_enttm_id                = @pa_enttm_id
      AND    accdocm.accdocm_doc_id                  = accd.accd_accdocm_doc_id 
      and    accd_clisba_id                          = @pa_clisba_id
      AND    accd.accd_acct_type                     = isnull(@pa_acct_type,'')
      AND    excsm.excsm_deleted_ind                 = 1  
      AND    accdocm.accdocm_deleted_ind             = 1  
      --AND    accd.accd_acct_no                       = convert(varchar, @pa_acct_no)      
      AND    isnull(accd_deleted_ind, 1)             = 1      
      ORDER  BY accdocm_desc
   select top 1 * into #signature_final_1 from #signature_1
   where sig_desc = 'BO SIGNATURE'

   insert into #signature_final_1 
   select top 1 * from #signature_1
   where sig_desc = 'POA SIGNATURE'
   
   insert into #signature_final_1 
   select top 1 * from #signature_1
   where sig_desc = 'PAN / GIR NO'
   
   select sig_doc_path as accd_doc_path ,sig_remks as accd_remarks,sig_doc_id as accdocm_doc_id,sig_desc as accdocm_desc,sig_mdty as accdocm_mdty , sig_valid_yn as accd_valid_yn, sig_path as cli_image from #signature_final_1 order by sig_desc
END

IF @pa_tab = 'DP_ACCD_MOD'
    BEGIN--dp_accd
    
 print '1'
 create table #signature_2 (sig_doc_path varchar(200),sig_remks varchar(250),sig_doc_id numeric,sig_desc varchar(100),sig_mdty varchar, sig_valid_yn smallint, sig_path image )

insert into #signature_2
 SELECT  ISNULL(accd.accd_doc_path,'')    accd_doc_path  
           , isnull(accd.accd_remarks,'')              accd_remarks    
           , accdocm.accdocm_doc_id                    accdocm_doc_id  
           , isnull(accdocm.accdocm_desc,'')           accdocm_desc  
           , case accdocm.accdocm_mdty when 1 then 'M' else 'N' end accdocm_mdty  
           , isnull(accd.accd_valid_yn,0)              accd_valid_yn
           --, CAST(accd_binary_image as varbinary (8000))  cli_image 
           ,accd_binary_image  as cli_image
      FROM   account_document_mstr accdocm             WITH(NOLOCK)
             left outer join   
             accd_mak              accd                WITH(NOLOCK)   
        on   accdocm.accdocm_doc_id                  = accd.accd_accdocm_doc_id 
        and  accd_clisba_id                          = @pa_clisba_id
        AND  accd.accd_acct_type                     = isnull(@pa_acct_type,'')
        AND  isnull(accd_deleted_ind, 0)            IN (0,4,8)
            , exch_seg_mstr         excsm               WITH(NOLOCK)  
      WHERE  accdocm.accdocm_clicm_id                = @pa_clicm_id
      AND    accdocm.accdocm_enttm_id                = @pa_enttm_id
      AND    isnull(accdocm_doc_id,0) NOT IN (SELECT accd_accdocm_doc_id FROM ACCOUNT_DOCUMENTS  WHERE accd_clisba_id = @pa_clisba_id AND accd_deleted_ind =1)
      AND    excsm.excsm_deleted_ind                 = 1  
      AND    accdocm.accdocm_deleted_ind             = 1  
      UNION ALL
      SELECT  ISNULL(accd.accd_doc_path,'')    accd_doc_path  
           , isnull(accd.accd_remarks,'')              accd_remarks    
           , accdocm.accdocm_doc_id                    accdocm_doc_id  
           , isnull(accdocm.accdocm_desc,'')           accdocm_desc  
           , case accdocm.accdocm_mdty when 1 then 'M' else 'N' end accdocm_mdty  
           , isnull(accd.accd_valid_yn,0)              accd_valid_yn
           --,CAST(accd_binary_image as varbinary (8000))  cli_image 
           ,accd_binary_image  as cli_image
      FROM   account_document_mstr accdocm             WITH (NOLOCK)  
            ,account_documents     accd                WITH  (NOLOCK)   
     
           , exch_seg_mstr         excsm               WITH  (NOLOCK)  
      WHERE  accdocm.accdocm_clicm_id                = @pa_clicm_id
      AND    accdocm.accdocm_enttm_id                = @pa_enttm_id
      AND    accdocm.accdocm_doc_id                  = accd.accd_accdocm_doc_id 
      and    accd_clisba_id                          = @pa_clisba_id
      AND    accd.accd_acct_type                     = isnull(@pa_acct_type,'')
      AND    excsm.excsm_deleted_ind                 = 1  
      AND    accdocm.accdocm_deleted_ind             = 1  
      --AND    accd.accd_acct_no                       = convert(varchar, @pa_acct_no)      
      AND    isnull(accd_deleted_ind, 1)             = 1      
      ORDER  BY accdocm_desc
   select top 1 * into #signature_final_2 from #signature_2
   where sig_desc = 'BO SIGNATURE'

   --insert into #signature_final_1 
   --select top 1 * from #signature_1
   --where sig_desc = 'POA SIGNATURE'
   
   --insert into #signature_final_1 
   --select top 1 * from #signature_1
   --where sig_desc = 'PAN / GIR NO'
   
   select sig_doc_path as accd_doc_path ,sig_remks as accd_remarks,sig_doc_id as accdocm_doc_id,sig_desc as accdocm_desc,sig_mdty as accdocm_mdty , sig_valid_yn as accd_valid_yn, sig_path as cli_image from #signature_final_2 order by sig_desc
END
    IF @pa_tab = 'DP_ACCP'
    BEGIN
    --
      declare  @l_temp_prop table(accpm_enttm_id int       
					   , accp_value      varchar(250)      
					   , accpm_prop_id   int     
					   , accpm_cd        varchar(25)      
					   , accpm_desc      varchar(200)      
					   , accpm_clicm_id  numeric     
					   , accp_id         numeric    
					   , accp_clisba_id     numeric    
					   , accpm_mdty       char(1)    
					   , accpm_datatype  varchar(5)    
					   , priority        int
					   )    
	    
	 --sp_help account_property_dtls   
	 --sp_help account_document_mstr
	declare @l_temp_dtls table(accpd_accp_id numeric    
			, accdm_id        numeric                    
			, accdm_accpm_prop_id    int    
			, accdm_cd        varchar(25)                    
			, accpd_value     varchar(250)                       
			, accdm_desc      varchar(200)                                         
			, accdm_mdty       char(1)                      
			, accdm_datatype  varchar(5)    
			, priority        int )    
	    
	    
	    
	    
	insert into @l_temp_prop(accpm_enttm_id   
					   , accp_value      
					   , accpm_prop_id   
					   , accpm_cd        
					   , accpm_desc      
					   , accpm_clicm_id  
					   , accp_id         
					   , accp_clisba_id   
					   , accpm_mdty      
					   , accpm_datatype  
					   , priority        
					
					   )    
	  SELECT DISTINCT      accpm.accpm_enttm_id    accpm_enttm_id
			 , isnull(accp.accp_value,'')          accp_value       
			 , accpm.accpm_prop_id                 accpm_prop_id         
			 , accpm.accpm_prop_cd                 accpm_prop_cd        
			 , isnull(accpm.accpm_prop_desc,'')    accpm_prop_desc
			 , accpm.accpm_clicm_id                accpm_clicm_id            
			 , accp.accp_id                        accp_id        
			 , accp.accp_clisba_id                 accp_clisba_id
			 , CASE accpm.accpm_mdty  WHEN 1 THEN   'M' ELSE 'N' END   accpm_mdty         
			 , ISNULL(accpm.accpm_datatype,'')     accpm_datatype        
			 , 0    
             
          
		FROM  account_property_mstr          accpm   WITH(NOLOCK)            
			 ,account_properties             accp    WITH (NOLOCK)        
		WHERE accpm.accpm_prop_id         = accp.accp_accpm_prop_id         
		AND   ISNULL(accp_clisba_id, 0)    = @pa_clisba_id  
		AND   ISNULL(accp_deleted_ind, 1) = 1        
		and   accpm.accpm_deleted_ind     = 1              and ACCPM_DELETED_IND = 1 
        and   accpm.accpm_enttm_id        = @pa_enttm_id
        and   accpm.accpm_clicm_id        = @pa_clicm_id    
	    
	insert into @l_temp_prop(accpm_enttm_id   
					   , accp_value      
					   , accpm_prop_id   
					   , accpm_cd        
					   , accpm_desc      
					   , accpm_clicm_id  
					   , accp_id         
					   , accp_clisba_id   
					   , accpm_mdty      
					   , accpm_datatype  
					   , priority        
					  
					   )    
	    SELECT DISTINCT  accpm.accpm_enttm_id     accpm_enttm_id
			 , isnull(accp.accp_value,'')          accp_value
			 , accpm.accpm_prop_id                 accpm_prop_id         
			 , accpm.accpm_prop_cd                 accpm_prop_cd
			 , isnull(accpm.accpm_prop_desc,'')    accpm_prop_desc
			 , accpm.accpm_clicm_id                accpm_clicm_id            
			 , accp.accp_id                        accp_id        
			 , accp.accp_clisba_id                 accp_clisba_id
			 , CASE accpm.accpm_mdty  WHEN 1 THEN  'M'  ELSE   'N'  END   accpm_mdty        
			 , ISNULL(accpm.accpm_datatype,'')     accpm_datatype        
		   	 , 1    
	         
		FROM  account_property_mstr          accpm   WITH(NOLOCK)            
			 ,accp_mak                       accp    WITH (NOLOCK)        
		WHERE accpm.accpm_prop_id         = accp.accp_accpm_prop_id         
		AND   ISNULL(accp_clisba_id, 0)      = @pa_clisba_id
		AND   ISNULL(accp_deleted_ind, 0) in (0,4,8)    
		and   accpm.accpm_deleted_ind     = 1
        and   accpm.accpm_enttm_id        = @pa_enttm_id
        and   accpm.accpm_clicm_id        = @pa_clicm_id                
	    
	  --sp_help accpm_dtls_mstr  
	--    
	delete from @l_temp_prop where accpm_prop_id in (select accpm_prop_id from @l_temp_prop where priority = 1)  and priority = 0     
	 --   
	 --   
	insert into @l_temp_dtls (accpd_accp_id 
			, accdm_id        
			, accdm_accpm_prop_id  
			, accdm_cd        
			, accpd_value     
			, accdm_desc      
			, accdm_mdty      
			, accdm_datatype  
			, priority        
            )    
	select accpd.accpd_accp_id     
	   , accdm.accdm_id         
	   , accdm.accdm_accpm_prop_id   
	   , accdm.accdm_cd          
	   , accpd.accpd_value       
	   , accdm.accdm_desc        
	   , CASE accdm.accdm_mdty  WHEN 1 THEN  'M' ELSE 'N' END accdm_mdty        
	   , accdm.accdm_datatype   
	   , 0    
	from account_property_dtls   accpd    
	   , accpm_dtls_mstr         accdm   
       , @l_temp_prop            a
	where accpd.accpd_accdm_id = accdm.accdm_id     
    and   accpd.accpd_accp_id = a.accp_id 
	and   accpd_deleted_ind =1     
	and   accdm_deleted_ind =1     
	--    
	--sp_help account_property_dtls
    --
	insert into @l_temp_dtls (accpd_accp_id 
			, accdm_id        
			, accdm_accpm_prop_id  
			, accdm_cd        
			, accpd_value     
			, accdm_desc      
			, accdm_mdty      
			, accdm_datatype  
			, priority        
			)    
--sp_help accpm_dtls_mstr
	select accpd_accp_id     
	   , accdm_id          
	   , accdm_accpm_prop_id    
	   , accdm_cd          
	   , accpd_value       
	   , accdm_desc        
	   ,CASE accdm.accdm_mdty  WHEN 1 THEN  'M' ELSE   'N'  END    accdm_mdty      
	   , accdm_datatype    
	   , 1    
	from accpd_mak         accpd    
	   , accpm_dtls_mstr   accdm   
        ,@l_temp_prop      a
	where accpd.accpd_accdm_id = accdm.accdm_id     
    
	and   accpd.accpd_accp_id = a.accp_id     
	and   accpd_deleted_ind in (0,4,8)     
	and   accdm_deleted_ind = 1     
	--    
	--    
	delete from @l_temp_dtls where accpd_accp_id  in (select accpd_accp_id  from @l_temp_dtls where priority = 1) and priority = 0     
	--
    --
    -- 
	select  distinct--excsm_exch_cd                       
	   --, excsm_seg_cd                                  
	    a.accpm_prop_id          accpm_prop_id
	   , a.accpm_prop_cd          accpm_prop_cd
	   , ISNULL(a.accp_value,'')  accp_value
	   , a.accpm_prop_desc        accpm_prop_desc
	   , isnull(b.accdm_id,0)   accdm_id
	   , isnull(b.accdm_cd,'')  accdocm_cd
	   , isnull(b.accpd_value,'')      accpd_value
	   , isnull(b.accdm_desc        ,'')     accdm_desc
	   , isnull(b.accdm_datatype,'')         accdm_datatype                      
	   , a.accpm_mdty                      
	   , b.accdm_mdty                      
	   , a.accpm_datatype         accpm_datatype
	   , ord1
        
	from     
	(select distinct excsm.excsm_exch_cd     
	   , excsm.excsm_seg_cd               
	   , accpm_enttm_id     
	   , accp_value          
	   , accpm_prop_id       
	   , accpm_prop_cd           
	   , accpm_prop_desc          
	   , accpm_clicm_id      
	   , accp_id             
	   , accp_clisba_id         
	   , CASE accpm.accpm_mdty  WHEN 1 THEN 'M' ELSE 'N' END accpm_mdty      
	   , accpm_datatype      
	  , 0     d    
	, case excsm.excsm_exch_cd WHEN 'CDSL' THEN convert(varchar,1) WHEN 'NSDL' THEN convert(varchar,2) ELSE convert(varchar,1) END  ord1                        
	from account_property_mstr   accpm    
		 left outer join     
		 account_properties      accp    
		 on accp.accp_accpm_prop_id = accpm.accpm_prop_id    
		 and  isnull(accp.accp_clisba_id,'') = @pa_clisba_id     
	, (select dpam_crn_no,dpam_enttm_cd,dpam_clicm_cd,dpam_deleted_ind,dpam_excsm_id,dpam_id from dp_acct_mstr   where dpam_deleted_ind = 1 and dpam_id = @pa_clisba_id    
	   union    
	   select dpam_crn_no,dpam_enttm_cd,dpam_clicm_cd,dpam_deleted_ind,dpam_excsm_id,dpam_id from dp_acct_mstr_mak where dpam_deleted_ind in (0,8) and dpam_id = @pa_clisba_id ) dpam     
	   left outer join     
	   exch_seg_mstr             excsm                  on dpam.dpam_excsm_id        = excsm.excsm_id       
	, client_ctgry_mstr          clicm     
	, entity_type_mstr           enttm
    --, dp_acct_mstr               dpam 
	--, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list            
	, excsm_prod_mstr            excpm
	WHERE dpam.dpam_clicm_cd = clicm.clicm_cd     
	and   dpam.dpam_enttm_cd = enttm.enttm_cd     
	and   accpm.accpm_clicm_id = clicm.clicm_id    
	and   accpm.accpm_enttm_id = enttm.enttm_id   
	--AND   excsm_list.excsm_id = dpam.dpam_excsm_id    
	 --and   excpm_excsm_id = excsm_list.excsm_id   
	AND   clicm_deleted_ind =1     
	AND   enttm_deleted_ind =1    and ACCPM_DELETED_IND = 1   
	and isnull(dpam.dpam_id,'') = @pa_clisba_id    
	and accpm.accpm_prop_id not in (select distinct accpm_prop_id from @l_temp_prop)    
    and   accpm.accpm_enttm_id        = @pa_enttm_id
    and   accpm.accpm_clicm_id        = @pa_clicm_id    
	    
	union     
	    
	select distinct excsm.excsm_exch_cd        excsm_exch_cd                      
	   , excsm.excsm_seg_cd           excsm_seg_cd          
	   , accpm.accpm_enttm_id     
	   , accp_value          
	   , accpm.accpm_prop_id       
	   , accpm.accpm_prop_cd           
	   , accpm.accpm_prop_desc
	   , accpm.accpm_clicm_id      
	   , accp_id             
	   , accp_clisba_id         
	   , CASE accpm.accpm_mdty  WHEN 1 THEN 'M' ELSE 'N' END accpm_mdty    
	   , accpm.accpm_datatype      
	   , priority           
	, case excsm.excsm_exch_cd WHEN 'CDSL' THEN convert(varchar,1) WHEN 'NSDL' THEN convert(varchar,2) ELSE convert(varchar,1) END  ord1                        
	from @l_temp_prop  a    
	, dp_acct_mstr              dpam     
	  left outer join     
	  exch_seg_mstr             excsm                  on dpam.dpam_excsm_id        = excsm.excsm_id       
	, client_ctgry_mstr         clicm     
	, entity_type_mstr          enttm 
	--, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list            
      , account_property_mstr                   accpm
	where dpam.dpam_clicm_cd         = clicm.clicm_cd     
	and dpam.dpam_enttm_cd           = enttm.enttm_cd     
	--AND    excsm_list.excsm_id       = dpam.dpam_excsm_id    
	and  accpm.accpm_clicm_id       = clicm.clicm_id    
	and  accpm.accpm_enttm_id        = enttm.enttm_id
    and  a.accpm_prop_id            = accpm.accpm_prop_id    
	AND   clicm_deleted_ind          = 1     
	AND   enttm_deleted_ind          = 1       and ACCPM_DELETED_IND = 1 
	and dpam_deleted_ind             = 1     
	and dpam.dpam_id                      = @pa_clisba_id    
	and   accpm.accpm_enttm_id        = @pa_enttm_id
    and   accpm.accpm_clicm_id        = @pa_clicm_id        
	union    
	    
	select distinct excsm.excsm_exch_cd     
		   , excsm.excsm_seg_cd      
		   ,accpm.accpm_enttm_id     
		   ,  accp.accp_value          
		   , accpm.accpm_prop_id       
		   , accpm.accpm_prop_cd            
		   , accpm.accpm_prop_desc            
		   , accpm.accpm_clicm_id      
		   , accp.accp_id             
		   , accp.accp_clisba_id         
		   , CASE accpm.accpm_mdty  WHEN 1 THEN 'M' ELSE 'N' END accpm_mdty        
		   , accpm.accpm_datatype      
		   , priority         
	, case excsm.excsm_exch_cd WHEN 'CDSL' THEN convert(varchar,1) WHEN 'NSDL' THEN convert(varchar,2) ELSE convert(varchar,1) END  ord1                         
	 from @l_temp_prop         accp
	, dp_acct_mstr_mak         dpam     
	  left outer join     
	  exch_seg_mstr             excsm                  on dpam.dpam_excsm_id        = excsm.excsm_id       
	, client_ctgry_mstr         clicm     
	, entity_type_mstr          enttm
    , account_property_mstr     accpm
    --, account_properties        accp
	--, citrus_usr.fn_exch_list(@pa_roles,@pa_scr_id) excsm_list    

	where dpam_clicm_cd = clicm_cd     
	and dpam_enttm_cd = enttm_cd     
	--AND    excsm_list.excsm_id                 = dpam.dpam_excsm_id    
	and  accpm.accpm_clicm_id = clicm.clicm_id  
    and  accp.accpm_prop_id            = accpm.accpm_prop_id      
	and  accpm.accpm_enttm_id = enttm.enttm_id  
	AND   clicm_deleted_ind =1     
	AND   enttm_deleted_ind =1     
	and dpam_deleted_ind in(0,8)    
	and dpam_id = @pa_clisba_id   and ACCPM_DELETED_IND = 1 
    and   accpm.accpm_enttm_id        = @pa_enttm_id
    and   accpm.accpm_clicm_id        = @pa_clicm_id     
   ) a    
	    
	left outer join     
	    
	--sp_help accpm_dtls_mstr    
	(select  accpd_accp_id     
		, accdm.accdm_id          
		, accdm.accdm_accpm_prop_id    
		, accdm.accdm_cd          
		, accpd.accpd_value       
		, accdm.accdm_desc        
		, CASE accdm_mdty  WHEN 1 THEN 'M' ELSE 'N' END      accdm_mdty      
		, accdm.accdm_datatype    
		   , 0    b    
	from accpm_dtls_mstr    accdm    
	left outer join     
	account_property_dtls    accpd  
	on accdm.accdm_id = accpd.accpd_accdm_id     
	and accpd.accpd_accp_id in (select accp_id from @l_temp_prop)    
	where accdm.accdm_id not in(select accdm_id from @l_temp_dtls)    
	    
	union    
	    
	select distinct accpd_accp_id     
		, accdm_id 
		,  accdm_accpm_prop_id
		, accdm_cd
		, accpd_value
		, accdm_desc
		, accdm_mdty
		,  accdm_datatype
		, priority    
	from @l_temp_dtls) b    
	on a.accpm_prop_id =  b.accdm_accpm_prop_id    
	ORDER BY ord1 
    --
    END
  --
  END--chk_1
--   
END

GO
