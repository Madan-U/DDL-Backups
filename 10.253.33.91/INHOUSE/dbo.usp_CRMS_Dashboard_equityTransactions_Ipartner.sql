-- Object: PROCEDURE dbo.usp_CRMS_Dashboard_equityTransactions_Ipartner
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------

 ---EXEC usp_CRMS_Dashboard_equityTransactions_Ipartner   'ET','K6641','Apr 02 2022','Apr 01 2023'

CREATE procedure [dbo].[usp_CRMS_Dashboard_equityTransactions_Ipartner]  
(                  
 @SubBroker as varchar(50),  
 @Party_code as varchar(10),          
 @FromDate as datetime,          
 @ToDate as datetime,  
 @Scrip_Name as varchar(500)=NULL          
)              
AS   
BEGIN           
/*          
 EXEC crm.dbo.[usp_CRMS_Dashboard_equityTransactions] 'K148521','OCT 26 2020', 'OCT 28 2020'  
 EXEC crm.dbo.[usp_CRMS_Dashboard_equityTransactions] 'K148521','OCT 26 2020', 'OCT 28 2020'  
 EXEC crm.dbo.[usp_CRMS_Dashboard_equityTransactions_Ipartner] 'VRCBR','VRCBR1971','2022-05-02' , '2022-05-02' ,''     
 EXEC crm.dbo.[usp_CRMS_Dashboard_equityTransactions_Ipartner] 'AKJ','A121907','Apr 13 2022' , 'Apr 13 2022' ,''     
 EXEC crm.dbo.[usp_CRMS_Dashboard_equityTransactions_Ipartner] 'SWPG001','SWPG1077','Apr 01 2022' , 'Apr 18 2022' ,''     
 EXEC crm.dbo.[usp_CRMS_Dashboard_equityTransactions_Ipartner] 'JJWN','JJWN1016','Mar 20 2023', 'Mar 27 2023',''     
*/      
 Declare @@Party_code  varchar(10),          
   @@FromDate  datetime,          
   @@ToDate  datetime,  
   @IsSubBroker char(1) = 'N'  
         
 set @@FromDate=LEFT(@FromDate,11)+' 00:00'  
 set @@ToDate=LEFT(@ToDate,11)+' 23:59'  
 Set @@Party_code = @Party_code  
  
 
   SELECT tdate, sauda_date= convert(varchar, convert(datetime, sauda_date, 101), 101),  
     Settlement, party_code, party_name, scrip_cd, scrip_name, series,                                
     PQty, PRate, PValue, SQty, SRate, sValue,NQty, NRate, NValue, Brokerage, Other_tax, INS_CHRG,Turn_Tax,Sebi_Tax,Broker_Chrg,Service_Tax,Other_Chrg  
   FROM (      
   select tdate=sauda_DAte,          
   sauda_date=convert(varchar(11),sauda_date),                            
   Settlement= cast(sett_no as varchar)+'-'+sett_type,                            
   party_code, party_name, scrip_cd, scrip_name, series,                                
   PQty = sum(pqtytrd+pqtydel),                                
   PRate =(case when sum(pqtytrd+pqtydel) <> 0 then convert(decimal(14,2),(sum(pamttrd+pamtdel)/sum(pqtytrd+pqtydel))) else 0 end),                            
   PValue = convert(decimal(20,2),sum(pamttrd+pamtdel)),                                
   SQty = sum(sqtytrd+sqtydel),                                
   SRate =(case when sum(sqtytrd+sqtydel) <> 0 then convert(decimal(14,2),(sum(samttrd+samtdel)/sum(sqtytrd+sqtydel))) else 0 end),                                
   sValue = convert(decimal(20,2),sum(samttrd+samtdel)),    
   NQty = sum(pqtytrd+pqtydel-sqtytrd-sqtydel),                                
   NRate =(case when sum(pqtytrd+pqtydel-sqtytrd-sqtydel) <> 0 then convert(decimal(14,2),(sum(pamttrd+pamtdel-samttrd-samtdel)/sum(pqtytrd+pqtydel-sqtytrd-sqtydel))) else 0 end),                                
   NValue = convert(decimal(20,2),sum(pamttrd+pamtdel-samttrd-samtdel)),   
   Brokerage = convert(decimal(10,2),sum(pbrokdel+pbroktrd+sbrokdel+sbroktrd)),                                
   Other_tax = convert(decimal(8,2),sum(service_tax+broker_chrg+turn_tax+sebi_tax+ins_chrg)),  
   INS_CHRG = convert(decimal(8,2),sum(INS_CHRG)), Turn_Tax = convert(decimal(8,2),SUM(Turn_Tax)),   
   Sebi_Tax = convert(decimal(8,2),SUM(Sebi_Tax)), Broker_Chrg = convert(decimal(8,2),SUM(Broker_Chrg)),   
   Service_Tax = convert(decimal(8,2),SUM(Service_Tax)), Other_Chrg = convert(decimal(8,2),SUM(Other_Chrg))                            
   --from angelcs.DBO.CMBILLVALAN with(nolock ) --changed by Anand on Jul 25 2019 - Mail from Rahul Shah - Suggested by BG sir  
   --from [196.1.115.195].ReplicatedData.ANANDBSEDB_ABCMBILLVALAN with(nolock )   
   from ANGELBSECM.BSEDB_AB.dbo.CMBILLVALAN with(nolock )   
   where party_code = @@Party_code     and Sub_Broker=@SubBroker      
   and sauda_date >= @@FromDate        
   and sauda_date <= @@ToDate    ---and Scrip_Name= @Scrip_Name     
   group by sauda_date, sett_no,sett_type, party_code,party_name,scrip_cd,scrip_name,series                                
   union all                            
   select tdate = sauda_DAte,          
   sauda_date=convert(varchar(11),sauda_date),                            
   Settlement = sett_no+'-'+sett_type,                           
   party_code,party_name,scrip_cd,scrip_name,series,                                
   PQty = sum(pqtytrd+pqtydel),                                
   PRate = (case when sum(pqtytrd+pqtydel) <> 0 then convert(decimal(14,2),(sum(pamttrd+pamtdel)/sum(pqtytrd+pqtydel))) else 0 end),                            
   PValue = convert(decimal(20,2),sum(pamttrd+pamtdel)),                                
   SQty = sum(sqtytrd+sqtydel),                                
   SRate = (case when sum(sqtytrd+sqtydel) <> 0 then convert(decimal(14,2),(sum(samttrd+samtdel)/sum(sqtytrd+sqtydel))) else 0 end),                                
   sValue = convert(decimal(20,2),sum(samttrd+samtdel)),                                
   NQty = sum(pqtytrd+pqtydel-sqtytrd-sqtydel),                                
   NRate =(case when sum(pqtytrd+pqtydel-sqtytrd-sqtydel) <> 0 then convert(decimal(14,2),(sum(pamttrd+pamtdel-samttrd-samtdel)/sum(pqtytrd+pqtydel-sqtytrd-sqtydel))) else 0 end),                                
   NValue = convert(decimal(20,2),sum(pamttrd+pamtdel-samttrd-samtdel)), 
   Brokerage = convert(decimal(10,2),sum(pbrokdel+pbroktrd+sbrokdel+sbroktrd)),                                
   Other_tax = convert(decimal(8,2),sum(service_tax+broker_chrg+turn_tax+sebi_tax+ins_chrg)),  
   INS_CHRG = convert(decimal(8,2),sum(INS_CHRG)), Turn_Tax = convert(decimal(8,2),SUM(Turn_Tax)),   
   Sebi_Tax = convert(decimal(8,2),SUM(Sebi_Tax)), Broker_Chrg = convert(decimal(8,2),SUM(Broker_Chrg)),   
   Service_Tax = convert(decimal(8,2),SUM(Service_Tax)), Other_Chrg = convert(decimal(8,2),SUM(Other_Chrg))                            
   --from angelcs.DBO.nseCMBILLVALAN with(nolock) --changed by Anand on Jul 25 2019 - Mail from Rahul Shah - Suggested by BG sir  
   --from [196.1.115.195].ReplicatedData.dbo.ANAND1MSAJAGCMBILLVALAN with(nolock)  
   from MSAJAG.dbo.CMBILLVALAN with(nolock)  
   where party_code = @@Party_code    and Sub_Broker=@SubBroker           
   and sauda_date >= @@FromDate       
   and sauda_date <= @@ToDate ---and Scrip_Name= @Scrip_Name     
   group by sauda_date, sett_no, sett_type, party_code, party_name, scrip_cd, scrip_name, series     
   ) A                             
   order by tdate desc   
 
 END

GO
