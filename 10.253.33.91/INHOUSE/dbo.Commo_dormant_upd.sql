-- Object: PROCEDURE dbo.Commo_dormant_upd
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

   
CREATE procedure Commo_dormant_upd          
as          
set nocount on          
          
update msajag.dbo.client_brok_details       
set /* Inactive_from = getdate(), --  commented by manesh on 07/08/2012 as requested by Rahul Shah*/    
--Inactive_from = getdate(), -- un commented by Amit Singh on 09/07/2014 as requested by Rahul Shah     
Deactive_value='D',Deactive_Remarks='Dormant client',Imp_status=0,Status='U',modifiedon=GETDATE(),modifiedby='DormantCommodity'                                            
where Exchange = 'MCX' and cl_code in  (select cltcode from mis.upload.dbo.Vw_commo_dormant_mcdx with (nolock))          
and Inactive_from > getdate()    
                                    
update msajag.dbo.client_brok_details       
set /*Inactive_from = getdate(), -- commented by manesh on 07/08/2012 as requested by Rahul Shah*/  
--Inactive_from = getdate(), -- un commented by Amit Singh on 09/07/2014 as requested by Rahul Shah         
Deactive_value='D',Deactive_Remarks='Dormant client',Imp_status=0,Status='U' ,modifiedon=GETDATE(),modifiedby='DormantCommodity'                                                 
where Exchange = 'NCX' and cl_code in  (select cltcode from mis.upload.dbo.Vw_commo_dormant_ncdx with (nolock))          
and Inactive_from > getdate()    
          
set nocount off

GO
