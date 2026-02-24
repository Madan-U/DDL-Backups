-- Object: PROCEDURE dbo.Usp_MfClient_Details_bk02122015
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

    
create proc Usp_MfClient_Details_bk02122015  
(                  
@access_to as varchar(50),                  
@access_code as varchar(50)                  
)                  
                  
as                   
                  
SET NOCOUNT ON                
           
-----------------------------Branchwise Access------------------------------------------------                            
--Declare @access_to AS VARCHAR(100)      
      
--Declare @access_code AS VARCHAR(100)      
DECLARE @STR AS VARCHAR(5000),@CONDITION AS VARCHAR(200)                                  
if @access_to= 'BRANCH'                                                                            
begin                                                                 
  SET @CONDITION='x.branch_cd ='''+@access_code+''''                                  
end                                                                 
if @access_to='Broker'                                                  
begin           
                                       
    SET  @CONDITION='x.branch_cd like ''%'''                                                                              
end                                                                                         
if @access_to='SB'                                                  
begin                                            
   SET   @CONDITION='x.sub_broker='''+@access_code+''' '                                                                              
end                                               
if @access_to='BRMAST'                                                  
begin                                            
  SET  @CONDITION='x.branch_cd in (select branch_cd from intranet.risk.dbo.branch_master  where brMast_cd='''+@access_code+''')'                                                                           
end                                                                  
if @access_to='SBMAST'                                                  
begin                                                                     
  SET   @CONDITION='x.sub_broker in (Select sub_Broker from intranet.risk.dbo.sb_master  where sbMast_cd ='''+@access_code+''')'                                  
end                                                                   
if @access_to='REGION'                                                  
begin                                            
   SET  @CONDITION='x.branch_cd in(Select code from intranet.risk.dbo.region  where reg_Code='''+@access_code+''')'                                                                             
end                                       
set @STR='select                  
Region=case when x.Region is null then y.Region else x.Region end,              
Branch=case when x.Branch_cd is null then y.Branch_cd else x.Branch_cd end,              
[Sub Broker]=case when x.Sub_Broker is null then y.Sub_Broker else x.Sub_Broker end,                
[party code]=case when x.party_code is null then y.party_code else x.party_code end,        
 z.subcode,                 
[party name]=case when x.party_name is null then y.party_name else x.party_name end,                  
NSE=isnull(x.BSE,''N''),                  
BSE=isnull(y.NSE,''N''),            
DOB=case when convert(varchar(11),x.DOB,103) is null then convert(varchar(11),y.DOB,103) else convert(varchar(11),x.DOB,103) end,                  
GENDER=case when x.GENDER is null then y.GENDER else x.GENDER end,                  
PAN_NO=case when x.PAN_NO is null then y.PAN_NO else x.PAN_NO end,                  
DP_TYPE=case when x.DP_TYPE is null then y.DP_TYPE else x.DP_TYPE end,                  
DPID=case when x.DPID is null then y.DPID else x.DPID end,                  
CLTDPID=case when x.CLTDPID is null then y.CLTDPID else x.CLTDPID end,                  
BANK_NAME=case when x.BANK_NAME is null then y.BANK_NAME else x.BANK_NAME end,                  
BANK_BRANCH=case when x.BANK_BRANCH is null then y.BANK_BRANCH else x.BANK_BRANCH end,                  
BANK_CITY=case when x.BANK_CITY is null then y.BANK_CITY else x.BANK_CITY end,                  
ACC_NO=case when x.ACC_NO is null then y.ACC_NO else x.ACC_NO end,                  
BANK_AC_TYPE=case when x.BANK_AC_TYPE is null then y.BANK_AC_TYPE else x.BANK_AC_TYPE end,                  
ADDR1=case when x.ADDR1 is null then y.ADDR1 else x.ADDR1 end,                  
ADDR2=case when x.ADDR2 is null then y.ADDR2 else x.ADDR2 end,                  
ADDR3=case when x.ADDR3 is null then y.ADDR3 else x.ADDR3 end,                  
CITY=case when x.CITY is null then y.CITY else x.CITY end,                  
STATE=case when x.STATE is null then y.STATE else x.STATE end,                  
ZIP=case when x.ZIP is null then y.ZIP else x.ZIP end,                  
NATION=case when x.NATION is null then y.NATION else x.NATION end,                  
OFFICE_PHONE=case when x.OFFICE_PHONE is null then y.OFFICE_PHONE else x.OFFICE_PHONE end,                  
RES_PHONE=case when x.RES_PHONE is null then y.RES_PHONE else x.RES_PHONE end,                  
MOBILE_NO=case when x.MOBILE_NO is null then y.MOBILE_NO else x.MOBILE_NO end,                  
EMAIL_ID=case when x.EMAIL_ID is null then y.EMAIL_ID else x.EMAIL_ID end,          
ADDEDON= case when convert(varchar(11),x.ADDEDON,103) is null then convert(varchar(11),y.ADDEDON,103) else convert(varchar(11),x.ADDEDON,103) end             
from                  
(select *,BSE=''Y'' from ANGELFO.NSEMFSS.DBO.MFSS_CLIENT )x                   
full outer join                   
(select *,NSE=''Y'' from ANGELFO.bsemfss.dbo.MFSS_CLIENT )y                  
on x.party_code = y.party_code         
left outer join        
(select glcode,subcode from [196.1.115.143].investment.dbo.sub_mast where subcode not like ''%0000'' and category not in(''E'',''L''))z        
on x.sub_broker=z.glcode         
where '+@CONDITION+''        
print (@str)      
exec (@str)        
set nocount off

GO
