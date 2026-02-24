-- Object: PROCEDURE dbo.DP_CLient_TradingBOID
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc [dbo].[DP_CLient_TradingBOID](@partycode varchar(15))        
as        
SET NOCOUNT ON;      
/*select cm_blsavingcd,cm_cd from DPClient_Master with (nolock) where cm_active in ('01','1') and ISNULL(cm_blsavingcd,'')=@partycode */    
select distinct * from   
(  
select cm_blsavingcd,cm_cd from DPClient_Master with (nolock)   
where (cm_active ='01' OR cm_active='1') and ISNULL(cm_blsavingcd,'')=@partycode  
union all  
select Party_code,(CASE WHEN DPTYPE='NSDL' THEN DPID+CLTDPNO ELSE CLTDPNO END) from msajag.dbo.MultiCltId  where party_Code=@partycode  
union all   
select Party_code,(CASE WHEN DPTYPE='NSDL' THEN DPID+CLTDPNO ELSE CLTDPNO END) as sm_cd from [AngelBSECM].bsedb_AB.dbo.MultiCltId  where party_Code=@partycode    
)A  
SET NOCOUNT OFF;

GO
