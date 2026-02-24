-- Object: PROCEDURE dbo.PROC_COMMON_CONTRACT_AUTOGEN
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [dbo].[PROC_COMMON_CONTRACT_AUTOGEN]                             
(                            
  @SAUDA_DATE VARCHAR(11),                            
  @FILE_FOR VARCHAR(50),                  
  @FROMPARTY VARCHAR(10),                  
  @TOPARTY  VARCHAR(10),              
  @SNO      NUMERIC(18,0)=0                      
)                            
AS                            
                  
-- EXEC PROC_COMMON_CONTRACT_AUTOGEN  @SAUDA_DATE = 'OCT  6 2016', @FILE_FOR = 'COMBINE_MARGIN', @FROMPARTY='A000000001', @TOPARTY='A111'                            
            
DECLARE                              
  @MYURL      VARCHAR(MAX),                             
  @MYOUTPUT     VARCHAR(MAX),                            
  @URL      VARCHAR(MAX),                             
  @PROCESS_URL    VARCHAR(MAX),                             
  @INTERNAL_URL    VARCHAR(MAX),                             
  @PROCESS_URL_FILE   VARCHAR(100),                            
  @CMD      VARCHAR(MAX),                            
  @URL_DWLOAD_MAP_DRIVE  VARCHAR(100),                            
  @URL_DWLOAD_USERID   VARCHAR(100),                            
  @URL_DWLOAD_PWD    VARCHAR(100),                            
  @URL_DWLOAD_LOCATION  VARCHAR(200),                            
  @FILE_DWLOAD_NAME   VARCHAR(200),                            
  @FILE_COPY_TEMP_LOCATION VARCHAR(200),                            
  @FILE_FOLDER_NAME   VARCHAR(200),                            
  @URL_DWLOAD_FILE_LOC  VARCHAR(200),                            
  @PROCESS_URL_FILE_ACTUAL VARCHAR(200),                            
  @COPY_DWLOAD_MAP_DRIVE  VARCHAR(100),                            
  @COPY_DWLOAD_USERID   VARCHAR(100),                            
  @COPY_DWLOAD_PWD   VARCHAR(100),                            
  @COPY_DWLOAD_LOCATION  VARCHAR(200),                            
  @CLIENT_CODE_LOCATION  INT,                            
  @SEPERATOR     VARCHAR(10),          
  @FILENAME  VARCHAR(200)                                      
                           
SELECT                             
 @PROCESS_URL = replace(replace(PRADNYA.DBO.fn_CLASS_Auto_Process_Replace(PROCESS_URL,@SAUDA_DATE,'','',''),'fromparty',@FROMPARTY),'toparty',@TOPARTY),                  
 @PROCESS_URL_FILE = CONVERT(VARCHAR,@SNO) + CONVERT(VARCHAR,GETDATE(),112) + REPLACE(CONVERT(VARCHAR,GETDATE(),108),':','') + '_' + PROCESS_URL_FILE,                  
 @INTERNAL_URL = INTERNAL_URL,                            
 @URL_DWLOAD_MAP_DRIVE = URL_DWLOAD_MAP_DRIVE,                            
 @URL_DWLOAD_USERID = URL_DWLOAD_USERID,                            
 @URL_DWLOAD_PWD = URL_DWLOAD_PWD,                            
 @FILE_COPY_TEMP_LOCATION = PRADNYA.DBO.fn_CLASS_Auto_Process_Replace(FILE_COPY_TEMP_LOCATION,@SAUDA_DATE,'','',''),                            
 @URL_DWLOAD_LOCATION = PRADNYA.DBO.fn_CLASS_Auto_Process_Replace(URL_DWLOAD_LOCATION,@SAUDA_DATE,'','',''),                        
 @URL_DWLOAD_FILE_LOC = PRADNYA.DBO.fn_CLASS_Auto_Process_Replace(URL_DWLOAD_FILE_LOC,@SAUDA_DATE,'','',''),                            
 @PROCESS_URL_FILE_ACTUAL = PROCESS_URL_FILE_ACTUAL,                            
 @COPY_DWLOAD_MAP_DRIVE = COPY_DWLOAD_MAP_DRIVE,                            
 @COPY_DWLOAD_USERID = COPY_DWLOAD_USERID,                            
 @COPY_DWLOAD_PWD = COPY_DWLOAD_PWD,                            
 @COPY_DWLOAD_LOCATION = COPY_DWLOAD_LOCATION,                            
 @CLIENT_CODE_LOCATION = CLIENT_CODE_LOCATION,                            
 @SEPERATOR = SEPERATOR                            
FROM                             
 CLASS_AUTO_PROCESS_SETTING                            
WHERE FILE_FOR = @FILE_FOR                            
          
if @FILE_FOR = 'COMMON_CONTRACT' OR @FILE_FOR = 'CURR_COMMON_CONTRACT' OR @FILE_FOR = 'COMMON_CONTRACT_NON' OR @FILE_FOR = 'CURR_COMMON_CONTRACT_NON'  
BEGIN          
 SET @MYURL = @INTERNAL_URL + @PROCESS_URL + '&FILENAME=' + @PROCESS_URL_FILE                 
               
 SET @MYURL = @PROCESS_URL + '&FILENAME=' + @PROCESS_URL_FILE                            
                                    
 EXEC HTTP_REQUEST @MYURL, @MYOUTPUT                      
               
 UPDATE TBL_CHECKCONT SET FLAG = CONVERT(VARCHAR,@SNO)              
 WHERE AUTOFILENAME = @PROCESS_URL_FILE  AND FLAG = 'END'              
               
 SET @PROCESS_URL_FILE_ACTUAL = @PROCESS_URL_FILE               
 SET @PROCESS_URL_FILE = replace(@PROCESS_URL_FILE,'.txt', '.tmp')               
                                            
 SET @CMD = 'EXEC XP_CMDSHELL ''net use ' + @URL_DWLOAD_FILE_LOC + ' /USER:' + @URL_DWLOAD_USERID + ' ' + @URL_DWLOAD_PWD + ' /persistent:Y'' , NO_OUTPUT'                            
 EXEC (@CMD)                            
                             
 SET @CMD = 'EXEC XP_CMDSHELL ''net use ' + ' ' + @COPY_DWLOAD_LOCATION + ' /USER:' + @COPY_DWLOAD_USERID + ' ' + @COPY_DWLOAD_PWD + ' /persistent:Y'' , NO_OUTPUT'                            
 EXEC (@CMD)                                 
                
 SET @CMD = 'EXEC XP_CMDSHELL ''Copy ' + @URL_DWLOAD_FILE_LOC + '\' + @PROCESS_URL_FILE_ACTUAL + ' ' + @COPY_DWLOAD_LOCATION + '\' + @PROCESS_URL_FILE + ''', NO_OUTPUT'                            
 EXEC (@CMD)                               
               
 SET @CMD = 'EXEC XP_CMDSHELL ''Del ' + @COPY_DWLOAD_LOCATION + '\' + @PROCESS_URL_FILE_ACTUAL + ''', NO_OUTPUT'                            
 EXEC (@CMD)                
               
 SET @CMD = 'EXEC XP_CMDSHELL ''Rename ' + @COPY_DWLOAD_LOCATION + '\' + @PROCESS_URL_FILE + ' ' + @PROCESS_URL_FILE_ACTUAL + ''', NO_OUTPUT'                            
 EXEC (@CMD)                               
                             
 SET @CMD = 'EXEC XP_CMDSHELL ''net use ' + @URL_DWLOAD_FILE_LOC + ' /delete'', NO_OUTPUT'                            
 EXEC (@CMD)                            
                             
 SET @CMD = 'EXEC XP_CMDSHELL ''net use ' + @COPY_DWLOAD_LOCATION + ' /delete'', NO_OUTPUT'                            
 EXEC (@CMD)                            
END          
ELSE IF @FILE_FOR = 'COMMON_CONTRACT_STATUS'          
BEGIN          
 DECLARE @FS INT,  @FILEID INT                    
                     
 SET @CMD = 'EXEC XP_CMDSHELL ''net use ' + ' ' + @COPY_DWLOAD_LOCATION + ' /USER:' + @COPY_DWLOAD_USERID + ' ' + @COPY_DWLOAD_PWD + ' /persistent:Y'' , NO_OUTPUT'                            
 EXEC (@CMD)               
           
 SET @PROCESS_URL_FILE = 'ECN_' + CONVERT(VARCHAR,CONVERT(DATETIME,@SAUDA_DATE),112) + '.tmp'          
 SET @PROCESS_URL_FILE_ACTUAL = 'ECN_' + CONVERT(VARCHAR,CONVERT(DATETIME,@SAUDA_DATE),112) + '.done'          
           
 SET @FILENAME = @COPY_DWLOAD_LOCATION + '\' + @PROCESS_URL_FILE          
           
 EXECUTE  MASTER..SP_OACREATE 'SCRIPTING.FILESYSTEMOBJECT', @FS OUT                    
 EXECUTE  MASTER..SP_OAMETHOD @FS, 'CREATETEXTFILE', @FILEID OUT, @FILENAME,TRUE                    
 EXECUTE  MASTER..SP_OAMETHOD @FS, 'OPENTEXTFILE', @FILEID OUT, @FILENAME, 8, 1                    
           
 EXECUTE  MASTER..SP_OAMETHOD @FILEID, 'CLOSE'                     
 EXECUTE  MASTER..SP_OADESTROY @FILEID                    
 EXECUTE  MASTER..SP_OADESTROY @FS           
           
 SET @CMD = 'EXEC XP_CMDSHELL ''Rename ' + @FILENAME+ ' ' + @PROCESS_URL_FILE_ACTUAL + ''', NO_OUTPUT'                            
 EXEC (@CMD)              
           
 SET @CMD = 'EXEC XP_CMDSHELL ''net use ' + @COPY_DWLOAD_LOCATION + ' /delete'', NO_OUTPUT'                            
 EXEC (@CMD)            
END           
if @FILE_FOR = 'COMBINE_MARGIN' OR  @FILE_FOR = 'COMBINE_MARGIN_ECN'  OR  @FILE_FOR = 'COMBINE_MARGIN_NONECN'         
BEGIN          
 SET @MYURL = @INTERNAL_URL + @PROCESS_URL + '&FILENAME=' + @PROCESS_URL_FILE                            
               
 SET @MYURL = @PROCESS_URL + '&FILENAME=' + @PROCESS_URL_FILE                            
                             
 EXEC HTTP_REQUEST @MYURL, @MYOUTPUT                            
    
 UPDATE TBL_CHECKCONT SET FLAG = CONVERT(VARCHAR,@SNO)              
 WHERE AUTOFILENAME = @PROCESS_URL_FILE  AND FLAG = 'END'              
               
 SET @PROCESS_URL_FILE_ACTUAL = @PROCESS_URL_FILE               
 SET @PROCESS_URL_FILE = replace(@PROCESS_URL_FILE,'.txt', '.tmp')       
            
 SET @CMD = 'EXEC XP_CMDSHELL ''net use ' + @URL_DWLOAD_FILE_LOC + ' /USER:' + @URL_DWLOAD_USERID + ' ' + @URL_DWLOAD_PWD + ' /persistent:Y'' , NO_OUTPUT'                            
 EXEC (@CMD)                            
                             
 SET @CMD = 'EXEC XP_CMDSHELL ''net use ' + ' ' + @COPY_DWLOAD_LOCATION + ' /USER:' + @COPY_DWLOAD_USERID + ' ' + @COPY_DWLOAD_PWD + ' /persistent:Y'' , NO_OUTPUT'                            
 EXEC (@CMD)                                 
                
 SET @CMD = 'EXEC XP_CMDSHELL ''Copy ' + @URL_DWLOAD_FILE_LOC + '\' + @PROCESS_URL_FILE_ACTUAL + ' ' + @COPY_DWLOAD_LOCATION + '\' + @PROCESS_URL_FILE + ''', NO_OUTPUT'                            
 EXEC (@CMD)                               
               
 SET @CMD = 'EXEC XP_CMDSHELL ''Del ' + @COPY_DWLOAD_LOCATION + '\' + @PROCESS_URL_FILE_ACTUAL + ''', NO_OUTPUT'                            
 EXEC (@CMD)                
               
 SET @CMD = 'EXEC XP_CMDSHELL ''Rename ' + @COPY_DWLOAD_LOCATION + '\' + @PROCESS_URL_FILE + ' ' + @PROCESS_URL_FILE_ACTUAL + ''', NO_OUTPUT'                            
 EXEC (@CMD)                               
                             
 SET @CMD = 'EXEC XP_CMDSHELL ''net use ' + @URL_DWLOAD_FILE_LOC + ' /delete'', NO_OUTPUT'                            
 EXEC (@CMD)                            
                             
 SET @CMD = 'EXEC XP_CMDSHELL ''net use ' + @COPY_DWLOAD_LOCATION + ' /delete'', NO_OUTPUT'                            
 EXEC (@CMD)       
end

GO
