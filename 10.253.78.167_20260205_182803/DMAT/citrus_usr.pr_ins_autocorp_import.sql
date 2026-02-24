-- Object: PROCEDURE citrus_usr.pr_ins_autocorp_import
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[pr_ins_autocorp_import](  
 @pa_login_name varchar(25)  
,@pa_task_id numeric  
,@pa_mode varchar(50)  
,@pa_db_source varchar(500)  
,@RowDelimiter varchar(10)  
,@ColDelimiter varchar(10)  
,@pa_errmsg varchar(20) output  
)        
as  
begin  
--  
  set nocount on  
        
      declare @l_dpmdpid varchar(50)        
            , @l_dpm_id  varchar(50)        
            , @l_holdin_dt datetime        
            , @l_max_holding_dt datetime        
            , @l_err_string varchar(8000)    
            , @@SSQL VARCHAR(8000)  
            , @@DP_ID VARCHAR(8)  
            , @@TRX_DT DATETIME  
              
     If @pa_mode='BULK'  
     Begin   
     -- bulk  
       
       DELETE FROM AUTOCORP_ACTION_EX_VALUE  
       SET @@SSQL = 'BULK INSERT AUTOCORP_ACTION_EX_VALUE FROM ''' + @pa_db_source +  ''' WITH  
          (  
            FIELDTERMINATOR=''\n'',  
            ROWTERMINATOR = ''\n''    
          )'  
            
       EXEC(@@SSQL)  
     --  
     END  
       
     delete from AUTOCORP_ACTION_EX_VALUE   where left(value,2) = '01' 
       
     insert into ACC_CORP_ACTION_EX  
     (RECORD_TYPE  
     ,LINE_NUMBER  
     ,SHR_ORD_NO  
     ,DM_ORD_NO  
     ,BASE_ISIN  
     ,DB_ISIN  
     ,CR_ISIN  
     ,MKT_TYPE  
     ,SETT_NO  
     ,ACA_TYPE  
     ,ACA_EXE_DT  
     ,CR_MULTI_FACTOR  
     ,DB_MULTI_FACTOR  
     ,ACA_DESC  
     ,ACA_STATUS  
     ,RECORD_DT  
     ,ALLOT_DT)  
     select SUBSTRING(VALUE,1,2)  
     ,SUBSTRING(VALUE,3,7)  
     ,SUBSTRING(VALUE,10,16)  
     ,SUBSTRING(VALUE,26,7)  
     ,SUBSTRING(VALUE,33,12)  
     ,SUBSTRING(VALUE,45,12)  
     ,SUBSTRING(VALUE,57,12)  
     ,SUBSTRING(VALUE,69,2)  
     ,SUBSTRING(VALUE,71,7)  
     ,SUBSTRING(VALUE,78,4)  
     ,SUBSTRING(VALUE,82,8)  
     ,SUBSTRING(VALUE,90,7)  
     ,SUBSTRING(VALUE,97,7)  
     ,SUBSTRING(VALUE,104,35)  
     ,SUBSTRING(VALUE,139,4)  
    ,CASE WHEN SUBSTRING(VALUE,143,8)  = '00000000' THEN '' ELSE SUBSTRING(VALUE,143,8) END
     ,CASE WHEN SUBSTRING(VALUE,151,8)  = '00000000' THEN '' ELSE SUBSTRING(VALUE,151,8) END
     FROM AUTOCORP_ACTION_EX_VALUE  
     where not exists(select   SHR_ORD_NO ,DM_ORD_NO  ,BASE_ISIN  ,DB_ISIN  ,CR_ISIN  ,MKT_TYPE  ,SETT_NO  ,ACA_TYPE  ,ACA_EXE_DT      from ACC_CORP_ACTION_EX where SUBSTRING(VALUE,10,16) =   SHR_ORD_NO
				 and SUBSTRING(VALUE,26,7)  =DM_ORD_NO
				 and SUBSTRING(VALUE,33,12)  =BASE_ISIN
				 and SUBSTRING(VALUE,45,12)  =DB_ISIN
				 and SUBSTRING(VALUE,57,12)  =CR_ISIN
				 and SUBSTRING(VALUE,69,2)  =MKT_TYPE
				 and SUBSTRING(VALUE,71,7)  =SETT_NO
				 and SUBSTRING(VALUE,78,4)  =ACA_TYPE
				 and SUBSTRING(VALUE,82,8)  = ACA_EXE_DT)
			       
       
    
       
       
       
       
--  
end

GO
