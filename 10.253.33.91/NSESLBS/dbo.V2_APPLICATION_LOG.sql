-- Object: PROCEDURE dbo.V2_APPLICATION_LOG
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  proc V2_APPLICATION_LOG  
(  
          @FromDate VARCHAR(11),              
          @ToDate VARCHAR(11),              
          @LoginName  VARCHAR(10),  
          @ReportType varchar(10)  
)              
  
AS              
              
/*              
  SET @FromDate = LEFT(CONVERT(DATETIME,REPLACE(REPLACE(@FromDate,'/',''),'-',''),112),11)              
  SET @ToDate = LEFT(CONVERT(DATETIME,REPLACE(REPLACE(@ToDate,'/',''),'-',''),112),11)              
*/  
  SET @FromDate = LEFT(CONVERT(DATETIME,@FromDate,105),11)              
  SET @ToDate = LEFT(CONVERT(DATETIME,@ToDate,105),11)              
  
  
if @ReportType = 'LOGIN LOG'  
begin  
 if @LoginName = ''  
 begin  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  SELECT  
   UserName [User Name],   
   StatusName [Status Name],   
   StatusID [Status ID],   
   IpAdd [IP Address],   
   [Action],   
   AddDt as [Activity Time]  
  FROM  
   V2_LOGIN_LOG (NOLOCK)  
  WHERE  
   ADDDT >= @FROMDATE  
   AND ADDDT <= @TODATE + ' 23:59:59'  
  Order by AddDt  
 end  
 else  
 begin  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  SELECT  
   UserName [User Name],   
   StatusName [Status Name],   
   StatusID [Status ID],   
   IpAdd [IP Address],   
   [Action],   
   AddDt as [Activity Time]  
  FROM  
   V2_LOGIN_LOG (NOLOCK)  
  WHERE  
   ADDDT >= @FROMDATE  
   AND ADDDT <= @TODATE + ' 23:59:59'  
   AND USERNAME LIKE @LoginName + '%'  
  Order by AddDt  
 end  
end  
  
if @ReportType = 'ACCESS LOG'  
begin  
 if @LoginName = ''  
 begin  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  SELECT  
   UserName [User Name],   
   StatusName [Status Name],   
   StatusID [Status ID],   
   IpAdd [IP Address],   
   RepPath [Report Path],   
   AddDt as [Activity Time]  
  FROM  
   V2_Report_Access_Log (NOLOCK)  
  WHERE  
   ADDDT >= @FROMDATE  
   AND ADDDT <= @TODATE + ' 23:59:59'  
  Order by AddDt  
 end  
 else  
 begin  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  SELECT  
   UserName [User Name],   
   StatusName [Status Name],   
   StatusID [Status ID],   
   IpAdd [IP Address],   
   RepPath [Report Path],   
   AddDt as [Activity Time]  
  FROM  
   V2_Report_Access_Log (NOLOCK)  
  WHERE  
   ADDDT >= @FROMDATE  
   AND ADDDT <= @TODATE + ' 23:59:59'  
   AND USERNAME LIKE @LoginName + '%'  
  Order by AddDt  
 end  
end

GO
