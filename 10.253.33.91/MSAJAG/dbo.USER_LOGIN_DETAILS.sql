-- Object: PROCEDURE dbo.USER_LOGIN_DETAILS
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

       
      
      
      
          
                
                 
--USER_LOGIN_DETAILS  'E54873'               
                  
CREATE PROC [dbo].[USER_LOGIN_DETAILS]                    
(                
  @userid VARCHAR(20)               
                     
 )                             
 AS                    
 BEGIN                    
           
    CREATE TABLE #TEMP            
    (            
     [FLDUSERNAME] [VARCHAR](10) NOT NULL,            
     [fldfirstname] [VARCHAR](50) NOT NULL,            
 [fldlastname] [VARCHAR](50) NULL,            
 [EXCHANGE] [varchar](15) NOT NULL)      
             
          
  INSERT INTO #TEMP                
SELECT fldusername AS USERID,fldfirstname AS USERNAME,fldlastname AS LASTNAME,'NSE'AS EXCHANGE FROM tblPradnyausers WITH(NOLOCK)WHERE fldusername=@userid      
UNION ALL      
SELECT fldusername AS USERID,fldfirstname AS USERNAME,fldlastname AS LASTNAME,'BSE'AS EXCHANGE FROM [AngelBSECM].BSEDB_AB.DBO.tblPradnyausers WITH(NOLOCK)WHERE fldusername=@userid      
UNION ALL      
SELECT fldusername AS USERID,fldfirstname AS USERNAME,fldlastname AS LASTNAME,'NSEFO'AS EXCHANGE FROM [AngelFO].NSEFO.DBO.tblPradnyausers WITH(NOLOCK)WHERE fldusername=@userid      
UNION ALL      
SELECT fldusername AS USERID,fldfirstname AS USERNAME,fldlastname AS LASTNAME,'BSEMFSS'AS EXCHANGE FROM [AngelFO].BSEMFSS.DBO.tblPradnyausers WITH(NOLOCK)WHERE fldusername=@userid      
UNION ALL      
SELECT fldusername AS USERID,fldfirstname AS USERNAME,fldlastname AS LASTNAME,'NSX'AS EXCHANGE FROM [AngelFO].NSECURFO.DBO.tblPradnyausers WITH(NOLOCK)WHERE fldusername=@userid      
UNION ALL      
SELECT fldusername AS USERID,fldfirstname AS USERNAME,fldlastname AS LASTNAME,'MCDX'AS EXCHANGE FROM [AngelCommodity].MCDX.DBO.tblPradnyausers WITH(NOLOCK)WHERE fldusername=@userid      
UNION ALL      
SELECT fldusername AS USERID,fldfirstname AS USERNAME,fldlastname AS LASTNAME,'MCD'AS EXCHANGE FROM [AngelCommodity].MCDXCDS.DBO.tblPradnyausers WITH(NOLOCK)WHERE fldusername=@userid      
UNION ALL      
SELECT fldusername AS USERID,fldfirstname AS USERNAME,fldlastname AS LASTNAME,'NCDX'AS EXCHANGE FROM [AngelCommodity].NCDX.DBO.tblPradnyausers WITH(NOLOCK)WHERE fldusername=@userid      
               
                    
   SELECT * FROM #TEMP            
                     
END

GO
