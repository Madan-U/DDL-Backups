-- Object: PROCEDURE dbo.Spx_GetMismatchReportForDPPOA_trading
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

-------- POA Not Available --94  
  
CREATE procedure [dbo].[Spx_GetMismatchReportForDPPOA_trading]  
  
as  
  
begin  
select * into #tempDetails  
 from  
 (  
  
  SELECT A.*,POA_STATUS,MASTER_POA FROM 
( SELECT CLIENT_CODE,NISE_PARTY_CODE,FIRST_HOLD_NAME,ACTIVE_DATE
FROM TBL_CLIENT_MASTER WHERE NISE_PARTY_CODE LIKE '98M73022%' AND STATUS ='ACTIVE' )A
LEFT OUTER JOIN 
TBL_CLIENT_POA P
ON A.CLIENT_CODE =P.CLIENT_CODE AND HOLDER_INDI =1 AND MASTER_POA ='2203320000000014'
AND POA_STATUS='A' 
WHERE POA_STATUS IS NULL

-----------------Exixting query----  
--SELECT A.* FROM   
--( SELECT CLIENT_CODE,NISE_PARTY_CODE,FIRST_HOLD_NAME,ACTIVE_DATE  
--FROM TBL_CLIENT_MASTER WHERE NISE_PARTY_CODE LIKE '98%' AND STATUS ='ACTIVE' )A  
--LEFT OUTER JOIN   
--TBL_CLIENT_POA P  
--ON A.CLIENT_CODE =P.CLIENT_CODE AND HOLDER_INDI =1  
--AND POA_STATUS='A'   
--WHERE POA_STATUS IS NULL  
) f  
  
  
Alter table #tempDetails add id int identity(1,1)  
  
 Declare @minId int ,@maxId int,@htmlText VARCHAR(MAX),@htmlHeaderText VARCHAR(MAX),@mainBody varchar(max)    
   ,@Client_code varchar(12),@NISE_PARTY_CODE varchar(16),@FIRST_HOLD_NAME Varchar(200) ,@ACTIVE_DATE varchar(50) --, @MDPS_POA_STATUS varchar(3),@MDP_PARTY varchar(12)  
                           
    
  set @minId=0                              
  set @maxId=0                              
  SET @htmlText=''                              
                                
  set @htmlHeaderText='<tr style="mso-yfti-irow:1">'+  
                             
        '<td align="center" align="center" style="width: 15.0%; background: #336699; padding:1.5pt 1.5pt 1.5pt 1.5pt" width="15%">'+                                            
         '<p align="center"><span style="font-size:10.5pt;font-family:Trebuchet MS , font-weight: normal;color:white">CLIENT_CODE</span></p>'+  
        '</td>'+   
        '<td align="center" align="center" style="width: 15.0%; background: #336699; padding: 1.5pt 1.5pt 1.5pt 1.5pt" width="15%">'+                                            
         '<p align="center"><span style="font-size:10.5pt;font-family:Trebuchet MS , font-weight: normal;color:white">NISE_PARTY_CODE</span></p>'+  
        '</td>'+  
        '<td align="center" align="center" style="width: 15.0%; background: #336699; padding: 1.5pt 1.5pt 1.5pt 1.5pt" width="15%">'+  
         '<p align="center"><span style="font-size:10.5pt;font-family:Trebuchet MS , font-weight: normal;color:white">FIRST_HOLD_NAME</span></p>'+  
        '</td>'+  
        '<td align="center" align="center" style="width: 15.0%; background: #336699; padding: 1.5pt 1.5pt 1.5pt 1.5pt" width="15%">'+  
         '<p align="center"><span style="font-size:10.5pt;font-family:Trebuchet MS , font-weight: normal;color:white">ACTIVE_DATE</span></p>'+   
        '</td>'+  
  
          
       '</tr>'  
  
    
  select @minId=MIN(Id),@maxId=MAX(Id) from #tempDetails  
    
    
  While(@minId<=@maxId)                              
   Begin                              
    select @htmlText=@htmlText+  
     '<tr>'+                                            
       
      '<td align="center" style="font-family: Trebuchet MS ; font-size: 10.5pt;  background: #B1CBE4;color:Black;font-weight:normal" width="15%">'+ISNULL(CLIENT_CODE,'')+'</td>'+  
      '<td align="center" style="font-family: Trebuchet MS ; font-size: 10.5pt;  background: #B1CBE4;color:Black;font-weight:normal" width="15%">'+cast (ISNULL(NISE_PARTY_CODE,'') as char(16))+'</td>'+  
      '<td align="center" style="font-family: Trebuchet MS ; font-size: 10.5pt;  background: #B1CBE4;color:Black;font-weight:normal" width="15%">'+ISNULL(FIRST_HOLD_NAME,'')+'</td>'+  
      '<td align="center" style="font-family: Trebuchet MS ; font-size: 10.5pt;  background: #B1CBE4;color:Black;font-weight:normal" width="15%">'+Cast (ISNULL(ACTIVE_DATE,'') as char(50))+'</td>'+  
   
     '</tr>'   
    from #tempDetails where ID=@minId       
  
    set @minId=@minId+1     
   end    
     
   set @mainBody ='<table>'+@htmlHeaderText+@htmlText+'</table>'    
     
   Declare @body Varchar(Max)  
   Set @body='Dear Dhanesh and KYC team,<br/>'+  
    'Please find below exception report for Angel Gold DP account without POA  in Trading Back office and DP Back Office <br/>'+  
    'Request you to take appropriate actions to avoid pay-in issues in future.'  
      
   Set @body=@body + '<br/><br/>'+  @mainBody        
   if @maxId<>0                              
   begin                      
    exec msdb.dbo.sp_send_dbmail                                                                                                                                                                           
    @profile_name = 'DBA',   
    @recipients = 'bi.dba@angelbroking.com;dhanesh.magodia@angelbroking.com;suresh.raut@angelbroking.com;bhaskar.goud@angelbroking.com;deepak.redekar@angelbroking.com;rajesh.jain@angelbroking.com;kuldip.ghosh@angelbroking.com',  
                                        
    @subject = 'Exception Report for DP account without POA in DP and Trading ( only AG )',    
                    
    @body = @body,                              
    @body_format ='html'                           
                    
   end   
     
     
     
   drop table #tempDetails  
     
   end  
     
     
   --select * from msdb..sysmail_allitems where recipients like 'bi%' order by sent_date desc

GO
