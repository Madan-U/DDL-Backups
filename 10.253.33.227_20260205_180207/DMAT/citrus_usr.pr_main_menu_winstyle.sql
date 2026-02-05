-- Object: PROCEDURE citrus_usr.pr_main_menu_winstyle
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--pr_main_menu 'SS','28','1*|~*42*|~*','*|~*','|*~|',''        
Create  PROCEDURE  [citrus_usr].[pr_main_menu_winstyle] (@pa_login_name    VARCHAR(20)              
                               ,@pa_ent_id        VARCHAR(20)              
                               ,@pa_rol_ids       VARCHAR(200)           
                               ,@pa_ver_no        VARCHAR(20)         
                               ,@rowdelimiter     CHAR(4) = '*|~*'        
                               ,@coldelimiter     CHAR(4) = '|*~|'        
                               ,@pa_ref_cur       VARCHAR(8000) OUTPUT              
                               )              
               
 AS              
 /***********************************************************************************              
  SYSTEM           : CLASS              
  MODULE NAME      : PR_MAIN_MENU              
  DESCRIPTION      : SCRIPT TO AUTHENTICATE USER              
  COPYRIGHT(C)     : ENC SOFTWARE SOLUTIONS PVT. LTD.              
  VERSION HISTORY  :              
  VERS.  AUTHOR          DATE         REASON              
  -----  -------------   ----------   ------------------------------------------------              
  1.0    TUSHAR PATEL    06-JAN-2007  INITIAL VERSION.              
  **********************************************************************************/              
  --              
  BEGIN              
  --              
    SET NOCOUNT ON              
    --              
          
  
      DECLARE  @tblrol               TABLE (rol_id NUMERIC)        
      DECLARE  @@remainingstring_id  VARCHAR(200)        
              ,@@foundat             INTEGER        
              ,@@currstring_id       VARCHAR(20)        
              ,@@delimeterlength_id  INTEGER        
              ,@delimeter_id         char(4)        
              ,@l_rol_id             VARCHAR(200)        
              
      SET   @@remainingstring_id  = @pa_rol_ids        
      SET   @delimeter_id         ='%'+ @rowdelimiter + '%'        
      SET   @@delimeterlength_id  = LEN(@rowdelimiter)        
      WHILE @@remainingstring_id <> ''        
      BEGIN        
      --        
        SET @@foundat = 0        
        SET @@foundat =  PATINDEX('%'+@delimeter_id+'%',@@remainingstring_id)        
        --        
        IF  @@foundat > 0        
        BEGIN        
        --        
          SET @@currstring_id      = SUBSTRING(@@remainingstring_id, 0,@@foundat)        
          SET @@remainingstring_id = SUBSTRING(@@remainingstring_id, @@foundat+@@delimeterlength_id,LEN(@@remainingstring_id)- @@foundat+@@delimeterlength_id)        
        --        
        END        
        ELSE        
        BEGIN        
        --        
          SET @@currstring_id      = @@remainingstring_id        
          SET @@remainingstring_id = ''        
        --        
        END        
        --        
        IF @@currstring_id <> ''        
        BEGIN        
        --        
          INSERT INTO @tblrol values (CONVERT(NUMERIC,@@currstring_id))        
        --        
        END        
        --        
      END        
                      
      --        
        --SELECT @l_rol_id = REPLACE(substring(@pa_rol_ids,0,len(@pa_rol_ids)-3),'*|~*',',')        
      --        
   if not exists(select clim_crn_no from client_mstr where clim_crn_no = @pa_ent_id )   
   begin   
			select ACT_SCR_ID,SCR_DESC,SCR_PARENT_ID=isnull(SCR_PARENT_ID,0),SCR_URL,SCR_ORDER_BY
			from
			(
					  SELECT        act.act_scr_id     ACT_SCR_ID              
									, scr.scr_desc       SCR_DESC              
									, scr.scr_parent_id  SCR_PARENT_ID              
									, ISNULL(SCR.SCR_URL,'') + '?SCRID=' + ISNULL(CONVERT(VARCHAR,act.act_scr_id),'') + '&MKRCHKR=' + ISNULL(CONVERT(VARCHAR,scr.scr_checker_yn),'0')  + '&vno=' + ISNULL(CONVERT(VARCHAR,@pa_ver_no),'0') SCR_URL              
									, scr.scr_ord_by    SCR_ORDER_BY        
					  FROM            actions            act    WITH(NOLOCK)              
									, roles_actions      rola   WITH(NOLOCK)          
									, screens            scr    WITH(NOLOCK)              
					  WHERE  rola.rola_act_id          = act.act_id              
					  AND    scr.scr_id                = act.act_scr_id              
					  AND    act.act_deleted_ind       = 1              
					  AND    rola.rola_deleted_ind     = 1              
					  AND    scr.scr_deleted_ind       = 1              
					  AND   rola.rola_rol_id          IN (SELECT rol_id FROM @tblrol)  
					  UNION      
					  SELECT        99999                ACT_SCR_ID              
									, 'Event Calander'       SCR_DESC              
									, Null    SCR_PARENT_ID              
									,  'Reports\rpt_eod.aspx'  SCR_URL              
									, 99999              SCR_ORDER_BY    
				      
					  UNION      
					  SELECT        999999                ACT_SCR_ID              
									, 'Change View'       SCR_DESC              
									, Null    SCR_PARENT_ID              
									,  'ChangeView.aspx'  SCR_URL              
									, 999999              SCR_ORDER_BY        
					  UNION      
					  SELECT        9999999                ACT_SCR_ID              
									, 'Log Off    '       SCR_DESC              
									, Null    SCR_PARENT_ID              
									,  'Logoff_Internal.aspx'  SCR_URL              
									, 9999999              SCR_ORDER_BY
			)  tmpview
			UNION      
			SELECT        0       ACT_SCR_ID              
            , 'Start D-mat'       SCR_DESC              
            , Null    SCR_PARENT_ID              
            ,  'blank.aspx'  SCR_URL              
            , 0         SCR_ORDER_BY   
      
			ORDER BY SCR_ORDER_BY,scr_desc   
 end  
 else  
 begin  
  
    
  SELECT        1                ACT_SCR_ID              
    , 'Client Personal Details'       SCR_DESC              
    , Null    SCR_PARENT_ID              
    ,  'ClientLoginScreen\PERSONAL_DTLS_CLTSCR.ASPX'  SCR_URL              
    , 1              SCR_ORDER_BY        
  UNION      
  SELECT        2                ACT_SCR_ID              
    , 'Holding Statement'       SCR_DESC              
    , Null    SCR_PARENT_ID              
    ,  'ClientLoginScreen\HOLDING_REPORT_CLTSCR.ASPX'  SCR_URL              
    , 2              SCR_ORDER_BY        
  UNION     
  SELECT        3                ACT_SCR_ID              
    , 'Transaction Statement'       SCR_DESC              
    , Null    SCR_PARENT_ID              
    ,  'ClientLoginScreen\DP_STATEMENT_CLTSCR.ASPX'  SCR_URL              
    , 3              SCR_ORDER_BY        
  UNION    
  SELECT        4                ACT_SCR_ID              
    , 'Client Ledger'       SCR_DESC              
    , Null    SCR_PARENT_ID              
    ,  'ClientLoginScreen\DP_LEDGER_CLTSCR.ASPX?scrid=4&MKRCHKR=0&vno=0'  SCR_URL              
    , 4              SCR_ORDER_BY     
  UNION  
  SELECT        5                ACT_SCR_ID              
    , 'Bill Statement'       SCR_DESC              
    , Null    SCR_PARENT_ID              
    ,  'ClientLoginScreen\DP_BILL_CLTSCR.ASPX'  SCR_URL              
    , 5              SCR_ORDER_BY     

UNION    
  SELECT        6                ACT_SCR_ID                
    , 'Bill Summary'       SCR_DESC                
    , Null    SCR_PARENT_ID                
    ,  'ClientLoginScreen\DP_BILL_Summary_CLTSCR.ASPX'  SCR_URL                
    , 6              SCR_ORDER_BY       
  
  
  UNION      

  SELECT        7                ACT_SCR_ID                
    , 'Holding - Graphs & Charts'       SCR_DESC                
    , Null    SCR_PARENT_ID                
    ,  'ClientLoginScreen\DP_HLDG_GRAPH_CLTSCR.ASPX'  SCR_URL                
    , 7              SCR_ORDER_BY       

  UNION    
  SELECT  TOP 1  8                ACT_SCR_ID                
    , 'Digital Signer'       SCR_DESC                
    , Null    SCR_PARENT_ID                
    ,  'Digital_Signature\DigitalSigner.ASPX'  SCR_URL                
    , 8              SCR_ORDER_BY 
	FROM LOGIN_NAMES,ALLOWED_SIGNATORY
	WHERE LOGN_NAME = ALWD_USER_NAME
	AND LOGN_NAME = @pa_login_name
	AND GETDATE() BETWEEN ALWD_FROM_DT AND ALWD_TO_DT
	AND ALWD_DELETED_IND = 1
	AND LOGN_DELETED_IND = 1
  
  UNION    
    
     SELECT        999999                ACT_SCR_ID              
                   , 'Change View'       SCR_DESC              
                   , Null    SCR_PARENT_ID              
                   ,  'ChangeView.aspx'  SCR_URL              
                   , 999999              SCR_ORDER_BY        
     UNION      
     SELECT        9999999                ACT_SCR_ID              
                   , 'Log Off    '       SCR_DESC              
                   , Null    SCR_PARENT_ID              
                   ,  'Logoff_Internal.aspx'  SCR_URL              
                   , 9999999              SCR_ORDER_BY        
       
       
  
       
  
 end  
        
           
      
      
      
           
  --              
  END

GO
