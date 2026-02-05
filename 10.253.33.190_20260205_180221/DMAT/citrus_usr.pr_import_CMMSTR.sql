-- Object: PROCEDURE citrus_usr.pr_import_CMMSTR
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


--[pr_import_dp] '','NSDL','21/12/2009','21/12/2009','N','76',3,'HO',''   
CREATE PROCeDURE [citrus_usr].[pr_import_CMMSTR](                   
                              @pa_exch          VARCHAR(20)  
											,@pa_login_name    VARCHAR(20)  
											,@pa_mode          VARCHAR(10)  																																
											,@pa_db_source     VARCHAR(250)  
											,@rowdelimiter     CHAR(4) =     '*|~*'    
											,@coldelimiter     CHAR(4) =     '|*~|'    
											,@pa_errmsg        VARCHAR(8000) output  
																			)               
AS                   
BEGIN                  
--    

INSERT INTO CM_MSTR
(
Cm_Date
,Cm_Name1
,CM_Name2
,CM_Name3
,Stock_Exch_ID
,Clearing_House_ID
,CM_ID
,Trade_ID
,Principal_Account
,Unified_Settlement_AcUSA
,CM_Inv_Sec_AcCISA
,Ep_Account
,Address1
,Address2
,Address3
,City
,State
,Country
,Pin_Code
,SP_Reg_Flag

,cm_created_by
,cm_created_dt
,cm_lst_upd_by
,cm_lst_upd_dt
,CM_DELETED_IND
)         
select 
Tmp_Cm_Date
,Tmp_Cm_Name1
,Tmp_CM_Name2
,Tmp_CM_Name3
,Tmp_Stock_Exch_ID
,Tmp_Clearing_House_ID
,Tmp_CM_ID
,Tmp_Trade_ID
,Tmp_Principal_Account
,Tmp_Unified_Settlement_AcUSA
,Tmp_CM_Inv_Sec_AcCISA
,Tmp_Ep_Account
,Tmp_Address1
,Tmp_Address2
,Tmp_Address3
,Tmp_City
,Tmp_State
,Tmp_Country
,Tmp_Pin_Code
,Tmp_SP_Reg_Flag
,@pa_login_name
,getdate()
,@pa_login_name
,GETDATE()
,1

from Tmp_CM_Mstr
where not exists (select Tmp_CM_ID from  CM_MSTR where CM_ID=Tmp_CM_ID)   
   
--                  
END

GO
