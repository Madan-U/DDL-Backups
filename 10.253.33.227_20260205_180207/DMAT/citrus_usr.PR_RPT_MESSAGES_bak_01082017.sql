-- Object: PROCEDURE citrus_usr.PR_RPT_MESSAGES_bak_01082017
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--select * from sysobjects order by 10 desc




--EXEC [PR_RPT_MESSAGES] 'STMT_NSDL',158
create PROC [citrus_usr].[PR_RPT_MESSAGES_bak_01082017]        
(        
 @RPT_NAME VARCHAR(250)      
,@RPT_FIX_LEN NUMERIC    
)        
AS        
BEGIN        
    --        
    IF @RPT_FIX_LEN <> 0   
    BEGIN  
     
    SELECT  PAGE_SPL_MSG
          ,[citrus_usr].[fn_splitstrin_byspace](PAGE_SPL_MSG_VIEW,'75','',1) PAGE_SPL_MSG_VIEW
          ,CITRUS_USR.FN_STRING_FOR_PRINT(PAGE_FOOTER_MSG,@RPT_FIX_LEN)    PAGE_FOOTER_MSG  
,'You can now hold your mutual fund investments in this demat account. Contact your Depository Participant or your stock broker for more information.' as Trxnewmsg  
    FROM  report_message        
    WHERE REPORT_NAME = @RPT_NAME        
    END   
    ELSE    
    BEGIN  
     
    SELECT  PAGE_SPL_MSG,PAGE_SPL_MSG_VIEW,PAGE_FOOTER_MSG   
,'You can now hold your mutual fund investments in this demat account. Contact your Depository Participant or your stock broker for more information.' as Trxnewmsg    
    FROM  report_message        
    WHERE REPORT_NAME = @RPT_NAME        
    END   
     
  
    --        
END

GO
