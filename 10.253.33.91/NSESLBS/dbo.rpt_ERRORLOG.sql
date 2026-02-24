-- Object: PROCEDURE dbo.rpt_ERRORLOG
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE Procedure  rpt_ERRORLOG          
@fromdate as varchar(11),
@todate as varchar(11)


AS    
SET @fromdate = CONVERT(varchar,@fromdate,109)             
SET @todate = CONVERT(varchar,@todate,109)     
          
set transaction isolation level read uncommitted                
  
SELECT   
	Cname,
	Mname,
	Sname,
	Errstr,   
	Errdate = CONVERT(varchar,Errdate,109) 
	    
FROM Errorlog(NOLOCK)  

where  
	Errdate >= @FROMDATE  
   	AND Errdate <= @TODATE + ' 23:59:59'  
Order by Errdate

GO
