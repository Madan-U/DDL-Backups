-- Object: PROCEDURE dbo.rpt_LOGINACCESS
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------





CREATE  Procedure  [dbo].[rpt_LOGINACCESS]             
@fromdate as varchar(11),
@todate as varchar(11)


AS    
SET @fromdate = CONVERT(varchar,@fromdate,109)             
SET @todate = CONVERT(varchar,@todate,109)     
          
set transaction isolation level read uncommitted                
  
SELECT   
	   
	L.userId,   
	L.UserName,
	c.fldcategoryname,
	L.statusname,
	L.statusId,
	L.IPADD,
	L.Action,
	AddDt = CONVERT(varchar,L.AddDt,109) 
    	
    
FROM V2_Login_Log L(NOLOCK)  
	
	   
LEFT OUTER JOIN   
    tblcategory C(NOLOCK)     
    ON   
    (   
        L.Category = C.FldcategoryCode   
     ) 
where  
	AddDt >= @FROMDATE  
   	AND AddDt <= @TODATE + ' 23:59:59'  
Order by AddDt

GO
