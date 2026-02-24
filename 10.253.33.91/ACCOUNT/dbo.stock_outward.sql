-- Object: PROCEDURE dbo.stock_outward
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

--stock_outward  '2000000','2000000'   
  
CREATE proc stock_outward    
    
(    
@fromsett_no varchar(15),    
@tosett_no   varchar (15)    
)as begin     
    
select SNo,Party_Code,C1.Long_name as party_name,c1.cl_type,C1.Branch_cd as Branch_Cd,B.Branch as branch_name,    
C1.Sub_Broker,S.Name as SubBroker_Name,Sett_No,Sett_type,d.scrip_cd,s1.long_name,d.series,D.TrType,Qty,    
CertNo,HolderName,Reason,DrCr,Delivered,DpType,DpId,CltDpId,SlipNo,BatchNo,ISett_No,ISett_Type,    
TransDate,BDpType,BDpId,BCltDpId     
from  [AngelDemat].msajag.dbo.deltrans D (nolock)      
left join [AngelDemat].msajag.dbo.scrip2 s2 (nolock) on s2.scrip_cd = d.scrip_cd and s2.series = d.series      
left join [AngelDemat].msajag.dbo.scrip1 s1 (nolock) on s1.co_code = s2.co_code and s2.series = s1.series      
left join [AngelDemat].msajag.dbo.client1 c1 (nolock) on c1.cl_code = d.party_code      
left join [AngelDemat].msajag.dbo.branch b (nolock) on c1.branch_cd = b.branch_code      
left join [AngelDemat].msajag.dbo.subbrokers s (nolock) on c1.sub_broker = s.sub_broker      
where  
-- transdate >= 'Feb 22 2012 00:00:00' and transdate <=  'Feb 23 2012 23:59:59' and  
 Sett_No >= @fromsett_no and Sett_No <=  @tosett_no    
and d.party_code >= LTRIM(RTRIM( '00')) and d.Party_Code <= LTRIM(RTRIM( 'zz'))     
and d.Scrip_cd >= LTRIM(RTRIM( '00')) and d.Scrip_cd <= LTRIM(RTRIM( 'zz'))     
and C1.branch_cd >= LTRIM(RTRIM( '00')) and C1.branch_cd <= LTRIM(RTRIM( 'zz'))     
and C1.sub_broker >= LTRIM(RTRIM( '00')) and C1.sub_broker <= LTRIM(RTRIM( 'zz'))     
and TrType = '904' and  DRCR = 'D' and Delivered = 'G'     
and party_code not in  ( 'Deltest' , 'Broker')    
UNION     
select SNo,Party_Code,C1.Long_name as party_name,c1.cl_type,C1.Branch_cd as Branch_Cd,B.Branch as branch_name,    
C1.Sub_Broker,S.Name as SubBroker_Name,Sett_No,Sett_type,d.scrip_cd,s1.long_name,d.series,D.TrType,Qty,    
CertNo,HolderName,Reason,DrCr,Delivered,DpType,DpId,CltDpId,SlipNo,BatchNo,ISett_No,ISett_Type,    
TransDate,BDpType,BDpId,BCltDpId     
from [AngelDemat].msajag.dbo.deltrans_report D (nolock)  left join [AngelDemat].msajag.dbo.scrip2 s2 (nolock) on s2.scrip_cd = d.scrip_cd and s2.series = d.series     
left join [AngelDemat].msajag.dbo.scrip1 s1 (nolock) on s1.co_code = s2.co_code and s2.series = s1.series    
left join [AngelDemat].msajag.dbo.client1 c1 (nolock) on c1.cl_code = d.party_code      
left join [AngelDemat].msajag.dbo.branch b (nolock) on c1.branch_cd = b.branch_code      
left join [AngelDemat].msajag.dbo.subbrokers s (nolock) on c1.sub_broker = s.sub_broker      
where  
-- transdate >= 'Feb 22 2012 00:00:00' and transdate <=  'Feb 23 2012 23:59:59' and  
Sett_No >= @fromsett_no and Sett_No <=  @tosett_no     
and d.party_code >= LTRIM(RTRIM( '00')) and d.Party_Code <= LTRIM(RTRIM( 'zz'))      
and d.Scrip_cd >= LTRIM(RTRIM( '00')) and d.Scrip_cd <= LTRIM(RTRIM( 'zz'))     
and C1.branch_cd >= LTRIM(RTRIM( '00')) and C1.branch_cd <= LTRIM(RTRIM( 'zz'))     
and C1.sub_broker >= LTRIM(RTRIM( '00')) and C1.sub_broker <= LTRIM(RTRIM( 'zz'))     
and TrType = '904' and  DRCR = 'D' and Delivered = 'G'     
and party_code not in  ( 'Deltest' , 'Broker')    
Order By transdate,Party_Code,TrType    
end

GO
