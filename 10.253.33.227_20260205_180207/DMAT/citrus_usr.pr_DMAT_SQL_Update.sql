-- Object: PROCEDURE citrus_usr.pr_DMAT_SQL_Update
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROC [citrus_usr].[pr_DMAT_SQL_Update]		  (@pa_1  varchar(500)  
                                   ,@pa_2      varchar(500)   
                                   ,@pa_3      varchar(500)  
                                   ,@pa_4	   varchar(500)  
                                   ,@pa_5      varchar(500)   
                                   ,@pa_6		varchar(500)  
                                   ,@pa_7       varchar(500)   
)
--WITH ENCRYPTION --MUST BE  ENCRYPTED 
AS
/*
*********************************************************************************
 system         : D-MAT
 module name    : DMAT_SQL_Update
 description    : this procedure will update key
 copyright(c)   : MarketPlace Technolgies Pvt. Ltd.
 version history: 1.0
 VERS.  AUTHOR          DATE          REASON
 -----  -------------   ----------    --------------------------------------------
 1.0    Gourav			04-Aug-2009   New Add-in.
 ---------------------------------------------------------------------------------
 *********************************************************************************
*/
BEGIN  


if not exists ( select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='DMAT_SETTING' and COLUMN_NAME='DMAT_Err_log' )
begin                
alter table citrus_usr.DMAT_SETTING add   DMAT_Err_log varchar(300)
end

if not exists ( select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='DMAT_SETTING' and COLUMN_NAME='DMAT_List_log' )
begin        
 
alter table citrus_usr.DMAT_SETTING add DMAT_List_log1 varchar(300)
end



update [DMAT_SETTING]
set  DMAT_Err_log  = @pa_5 ,
	DMAT_List_log =@pa_4	
   
Print 'Updation Successful'
End

GO
