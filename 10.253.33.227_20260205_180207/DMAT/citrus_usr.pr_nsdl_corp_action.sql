-- Object: PROCEDURE citrus_usr.pr_nsdl_corp_action
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE procedure [citrus_usr].[pr_nsdl_corp_action](    
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
         
       DELETE FROM nsdl_corp_action_value    
       SET @@SSQL = 'BULK INSERT nsdl_corp_action_value FROM ''' + @pa_db_source +  ''' WITH    
          (    
            FIELDTERMINATOR=''\n'',    
            ROWTERMINATOR = ''\n''      
          )'    
              
       EXEC(@@SSQL)    
     --    
     END    

 	 insert into tmp_nsdl_corp_action
	 (Record_Type   
	 ,Line_Number   
	 ,DM_Order_No   
	 ,Entitlement_Ind   
	 ,Credit_Debit_Ind   
	 ,CA_Status    
	 ,ISIN   
	 ,Filler1   
	 ,Exec_Date   
	 ,CA_Desc   
	 ,Filler2 )
	 select SUBSTRING(VALUE,1,2)    
     ,SUBSTRING(VALUE,3,7)    
     ,SUBSTRING(VALUE,10,10)    
     ,SUBSTRING(VALUE,20,1)    
     ,SUBSTRING(VALUE,21,1)    
     ,SUBSTRING(VALUE,22,2)    
     ,SUBSTRING(VALUE,24,12)    
     ,SUBSTRING(VALUE,36,15)    
     ,SUBSTRING(VALUE,51,8)    
     ,SUBSTRING(VALUE,59,35)    
     ,SUBSTRING(VALUE,94,50)    
	 from nsdl_corp_action_value where left(value,2) <> '01'
 
              
    insert into nsdl_corp_action  
	 (Record_Type   
	 ,Line_Number   
	 ,DM_Order_No   
	 ,Entitlement_Ind   
	 ,Credit_Debit_Ind   
	 ,CA_Status    
	 ,ISIN   
	 ,Filler1   
	 ,Exec_Date   
	 ,CA_Desc   
	 ,Filler2)  
     select Record_Type   
	 ,Line_Number   
	 ,DM_Order_No   
	 ,Entitlement_Ind   
	 ,Credit_Debit_Ind   
	 ,CA_Status    
	 ,ISIN   
	 ,Filler1   
	 ,Exec_Date   
	 ,CA_Desc   
	 ,Filler2  
     FROM tmp_nsdl_corp_action t   
	 where not exists(select t.dm_order_no,t.isin,t.credit_debit_ind,t.exec_date
     from nsdl_corp_action m where m.dm_order_no = t.dm_order_no 
	 and m.exec_date = t.exec_date and m.isin = t.isin and m.credit_debit_ind=t.credit_debit_ind)


      
         
--    
end

GO
