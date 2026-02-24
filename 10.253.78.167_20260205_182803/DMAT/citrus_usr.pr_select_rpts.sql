-- Object: PROCEDURE citrus_usr.pr_select_rpts
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_select_rpts](@pa_cd    VARCHAR(50)
                               ) 
AS
/*
*********************************************************************************
 SYSTEM         : CITRUS
 MODULE NAME    : pr_select_rpts
 DESCRIPTION    : 
 COPYRIGHT(C)   : marketplace technologies pvt. ltd.
 VERSION HISTORY:
 VERS.  AUTHOR             DATE        REASON
 -----  -------------      ----------  -------------------------------------------------
 1.0    TUSHAR             23-APR-2007 INITIAL VERSION.
--------------------------------------------------------------------------------------*/

BEGIN
--
  DECLARE @l_entm_id        NUMERIC
        , @l_name           VARCHAR(50)
        , @l_trade_name     VARCHAR(50)
        , @l_dob            VARCHAR(11)
        , @l_fth_name       VARCHAR(50)
        , @l_cont_pers      VARCHAR(50)
        , @l_qual           VARCHAR(50)
        , @l_no_of_fax      NUMERIC
        , @l_no_of_phone    NUMERIC
        , @l_no_of_telex    NUMERIC
        , @l_no_of_pc       NUMERIC
        , @l_off_addr       VARCHAR(250)
        , @l_phone_list     VARCHAR(100)
        , @l_mobile         VARCHAR(15)
        , @l_fax_list       VARCHAR(100)
        , @l_telex_list     VARCHAR(100)
        , @l_res_addr       VARCHAR(250)
        , @l_res_phone_list VARCHAR(100)
        , @l_no_of_emp      NUMERIC
        , @l_no_of_br       NUMERIC
        , @l_location       VARCHAR(50)
        , @l_phone_no       VARCHAR(25)
        , @l_telex          VARCHAR(25)
        , @l_fax            VARCHAR(25)
        , @l_email          VARCHAR(500)
        , @l_pan_gir_no     VARCHAR(500)
        , @l_clicm_cd       VARCHAR(25)
        , @l_director1      VARCHAR(100)
        , @l_director2      VARCHAR(100)
        , @l_director3      VARCHAR(100) 
        , @l_clicm_desc     VARCHAR(100) 

  DECLARE @l_details TABLE(name               varchar(50)
                          ,trade_name         varchar(50)
                          ,dob                varchar(11)
                          ,fth_name           varchar(50)
                          ,contact_person     varchar(50)
                          ,qualification      varchar(50)
                          ,no_of_fax          numeric
                          ,no_of_phone        numeric
                          ,no_of_telex        numeric
                          ,no_of_pc           numeric
                          ,o_adr1             varchar(25) 
                          ,o_adr_2            varchar(25)
                          ,o_adr_3            varchar(25)
                          ,o_adr_city         varchar(25)
                          ,o_adr_state        varchar(25)
                          ,o_adr_country      varchar(25)
                          ,o_adr_zip          varchar(10) --isnull(adr_1,'')+'|*~|'+isnull(adr_2,'')+'|*~|'+isnull(adr_3,'')+'|*~|'+isnull(adr_city,'')+'|*~|'+isnull(adr_state,'')+'|*~|'+isnull(adr_country,'')+'|*~|'+CONVERT(VARCHAR, isnull(adr_zip,''))+'|*~|'  
                          ,mobile_no          varchar(15) 
                          ,phone_list         varchar(250)
                          ,fax_list           varchar(250)
                          ,telex_list         varchar(250)
                          ,r_adr1             varchar(25)
                          ,r_adr2             varchar(25)
                          ,r_adr3             varchar(25)
                          ,r_adr_city         varchar(25)
                          ,r_adr_state        varchar(25)
                          ,r_adr_country      varchar(25)
                          ,r_adr_zip          varchar(10)
                          ,res_phone_list     varchar(250)
                          ,no_of_emp          numeric
                          ,no_of_branch_off   numeric
                          ,location           varchar(50)
                          ,tele_no            varchar(25)
                          ,telex              varchar(25)
                          ,fax                varchar(25)
                          ,email              varchar(500)
                          ,pan_gir_no         varchar(25)
                          ,s_date             varchar(25)
                          ,director1          varchar(100)
                          ,director2          varchar(100)
                          ,director3          varchar(100)
                           )
                           
                           
  SELECT @l_entm_id  = entm_id , @l_clicm_cd = entm_clicm_cd , @l_name = entm_name1 + isnull(entm_name2,'')+isnull(entm_name3,''), @l_clicm_desc = clicm.clicm_desc
		FROM   entity_mstr        entm
		     , client_ctgry_mstr  clicm   
		WHERE  entm.entm_clicm_cd = clicm.clicm_cd
		AND    entm_short_name = @pa_cd 
  AND    entm_deleted_ind = 1  
  
  IF (@l_clicm_desc = 'INDIVIDUAL' OR @l_clicm_desc = 'CORPORATE' OR @l_clicm_desc = 'PARTNERSHIP')  
  BEGIN
  --
    SET @l_trade_name = citrus_usr.fn_ucc_entp(@l_entm_id,'TRADE_NAME','')
    SET @l_dob        = citrus_usr.fn_ucc_entp(@l_entm_id,'DOB','')
    SET @l_fth_name   = citrus_usr.fn_ucc_entp(@l_entm_id,'FTH_NAME','') 
    SET @l_cont_pers  = citrus_usr.fn_ucc_entp(@l_entm_id,'CONTACT_PERSON','') 
    SET @l_qual       = citrus_usr.fn_ucc_entp(@l_entm_id,'EQ','') 
    SET @l_pan_gir_no = citrus_usr.fn_ucc_entp(@l_entm_id,'PAN_GIR_NO','') 
    SET @l_director1  = citrus_usr.fn_ucc_entp(@l_entm_id,'DIRECTOR1','') 
    SET @l_director2  = citrus_usr.fn_ucc_entp(@l_entm_id,'DIRECTOR2','') 
    SET @l_director3  = citrus_usr.fn_ucc_entp(@l_entm_id,'DIRECTOR3','') 
    
  
    SET @l_no_of_fax    = citrus_usr.ufn_countstring(citrus_usr.fn_conc_value(@l_entm_id , 'FAX1'),',')
    SET @l_no_of_phone  = citrus_usr.ufn_countstring(citrus_usr.fn_conc_value(@l_entm_id , 'OFF_PH1'),',')
    SET @l_no_of_telex  = citrus_usr.ufn_countstring(citrus_usr.fn_conc_value(@l_entm_id , 'TELEX'),',')
    SET @l_no_of_pc     = citrus_usr.ufn_countstring(citrus_usr.fn_conc_value(@l_entm_id , 'PC'),',')
    
    
    
    
    SET @l_off_addr        = citrus_usr.fn_addr_value(@l_entm_id , 'OFF_ADR1')
    SET @l_phone_list      = citrus_usr.fn_conc_value(@l_entm_id , 'OFF_PH1')
    SET @l_mobile          = citrus_usr.fn_conc_value(@l_entm_id , 'MOBILE')
    SET @l_fax_list        = citrus_usr.fn_conc_value(@l_entm_id , 'FAX1')
    SET @l_telex_list      = citrus_usr.fn_conc_value(@l_entm_id , 'TELEX')
    SET @l_res_addr        = citrus_usr.fn_addr_value(@l_entm_id , 'PER_ADR1')
    SET @l_res_phone_list  = citrus_usr.fn_conc_value(@l_entm_id , 'PHONE')
    SET @l_email           = citrus_usr.fn_conc_value(@l_entm_id , 'email')
    
    IF citrus_usr.ufn_countstring(@l_phone_list,',') = 1
    BEGIN
    --
      SET @l_phone_list = REPLACE(@l_phone_list,',','')
    --
    END
    IF citrus_usr.ufn_countstring(@l_mobile,',') = 1
    BEGIN
    --
      SET @l_mobile = REPLACE(@l_mobile,',','')
    --
    END
    IF citrus_usr.ufn_countstring(@l_fax_list,',') = 1
    BEGIN
    --
      SET @l_fax_list = REPLACE(@l_fax_list,',','')
    --
    END
    IF citrus_usr.ufn_countstring(@l_telex_list,',') = 1
    BEGIN
    --
      SET @l_telex_list = REPLACE(@l_telex_list,',','')
    --
    END
    IF citrus_usr.ufn_countstring(@l_res_phone_list,',') = 1
    BEGIN
    --
      SET @l_res_phone_list = REPLACE(@l_res_phone_list,',','')
    --
    END
    IF citrus_usr.ufn_countstring(@l_email,',') = 1
    BEGIN
    --
      SET @l_email = REPLACE(@l_email,',','')
    --
    END
    
    
    
                     
SELECT  @l_clicm_desc                                          clicm_desc
							,@l_name                                                  name
							,isnull(@l_trade_name,'')                                 trade_name
							,isnull(@l_clicm_cd,'')                                   client_ctgry
							,isnull(@l_dob,'')                                        dob
							,isnull(@l_fth_name,'')                                   fth_name
							,isnull(@l_cont_pers,'')                                  contact_person
							,isnull(@l_qual,'')                                       qualification
							,isnull(@l_no_of_fax,0)                                   no_of_fax
							,isnull(@l_no_of_phone,0)                                 no_of_phone
							,isnull(@l_no_of_telex,0)                                 no_of_telex
							,isnull(@l_no_of_pc,0)                                    no_of_pc
							,isnull(citrus_usr.fn_splitval(@l_off_addr,1),'')         o_adr1
							,isnull(citrus_usr.fn_splitval(@l_off_addr,2),'')         o_adr_2
							,isnull(citrus_usr.fn_splitval(@l_off_addr,3),'')         o_adr_3
							,isnull(citrus_usr.fn_splitval(@l_off_addr,4),'')         o_adr_city
							,isnull(citrus_usr.fn_splitval(@l_off_addr,5),'')         o_adr_state
							,isnull(citrus_usr.fn_splitval(@l_off_addr,6),'')         o_adr_country
							,isnull(citrus_usr.fn_splitval(@l_off_addr,7),'')         o_adr_zip--isnull(adr_1,'')+
							,isnull(@l_mobile,'')                                     mobile_no
							,isnull(@l_phone_list,'')                                 phone_list
							,isnull(@l_fax_list ,'')                                  fax_list
							,isnull(@l_telex_list  ,'')                               telex_list
							,isnull(citrus_usr.fn_splitval(@l_res_addr,1) ,'')        r_adr1
							,isnull(citrus_usr.fn_splitval(@l_res_addr,2)  ,'')       r_adr2
							,isnull(citrus_usr.fn_splitval(@l_res_addr,3) ,'')        r_adr3
							,isnull(citrus_usr.fn_splitval(@l_res_addr,4) ,'')        r_adr_city
							,isnull(citrus_usr.fn_splitval(@l_res_addr,5) ,'')        r_adr_state
							,isnull(citrus_usr.fn_splitval(@l_res_addr,6) ,'')        r_adr_country
							,isnull(citrus_usr.fn_splitval(@l_res_addr,7) ,'')        r_adr_zip
							,isnull(@l_res_phone_list,'')                             res_phone_list
							,isnull(@l_email,'')                                      email 
							,isnull(@l_pan_gir_no ,'')                                 pan_gir_no
							,0                                                        no_of_emp
							,0                                                        no_of_branch_off
							,''                                                       location
							,''                                                       tele_no
							,''                                                       telex
							,''                                                       fax
							,convert(varchar,getdate(),106)                           s_date
							,ISNULL(@l_director1,'')                                  director1
							,ISNULL(@l_director2,'')                                  director2
							,ISNULL(@l_director3,'')                                  director3
  --
  END
--
END

GO
