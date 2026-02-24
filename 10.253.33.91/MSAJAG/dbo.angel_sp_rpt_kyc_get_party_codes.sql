-- Object: PROCEDURE dbo.angel_sp_rpt_kyc_get_party_codes
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
 CREATE  proc    
 [dbo].[angel_sp_rpt_kyc_get_party_codes] (   
  @strPartyCodeFrom varchar(10),   
  @strPartyCodeTo varchar(10),  
  @strStatusID varchar(50),  
  @strStatusName varchar(100)  
 )  
  
as   
  
set @strPartyCodeFrom = upper(ltrim(rtrim(@strPartyCodeFrom)))  
set @strPartyCodeTo = upper(ltrim(rtrim(@strPartyCodeTo)))  
set @strStatusID = upper(ltrim(rtrim(@strStatusID)))  
set @strStatusName = upper(ltrim(rtrim(@strStatusName)))  
  
/*  
 angel_sp_rpt_kyc_get_party_codes 'N668', 'N668', '', ''  
*/  
  
if (  
  ( len( ltrim( rtrim( isnull( @strStatusID, '' ) ) ) ) = 0 )  
  OR  
  ( len( ltrim( rtrim( isnull( @strStatusName, '' ) ) ) ) = 0 )  
 ) begin  
 select  
  bsecm_party_code = null,  
  nsecm_party_code = null,  
  nsefo_party_code = null,  
  ncdex_party_code = null,  
  mcx_party_code = null,  
  nsx_party_code = null,  
  mcd_party_code = null  
 return  
end  
  
select   
 bsecm_party_code = max(isnull(case when exchangesegment = 'BSECM' then c1.party_code else null end, '')),  
 nsecm_party_code = max(isnull(case when exchangesegment = 'NSECM' then c1.party_code else null end, '')),  
 nsefo_party_code = max(isnull(case when exchangesegment = 'NSEFO' then c1.party_code else null end, '')),  
 ncdex_party_code = max(isnull(case when exchangesegment = 'NCDX' then c1.party_code else null end, '')),  
 mcx_party_code = max(isnull(case when exchangesegment = 'MCDX' then c1.party_code else null end, '')),  
 nsx_party_code = max(isnull(case when exchangesegment = 'NSX' then c1.party_code else null end, '')),  
 mcd_party_code = max(isnull(case when exchangesegment = 'MCD' then c1.party_code else null end, ''))  
from   
 mimansa.angelcs.dbo.angelclient1 c1 with (nolock),  
 mimansa.angelcs.dbo.angelclient2 c2 with (nolock)  
where   
 c1.party_code = c2.party_code and  
 c1.party_code >= @strPartyCodeFrom and  
 c1.party_code <= @strPartyCodeTo and  
  
 region like case when @strStatusID = 'REGION' then @strStatusName else '%' end and  
 area like case when @strStatusID = 'AREA' then @strStatusName else '%' end and  
 branch_cd like case when @strStatusID = 'BRANCH' then @strStatusName else '%' end and  
 c1.sub_broker like case when @strStatusID = 'SUBBROKER' then @strStatusName else '%' end and  
 c1.trader like case when @strStatusID = 'TRADER' then @strStatusName else '%' end and  
 c1.family like case when @strStatusID = 'FAMILY' then @strStatusName else '%' end and  
 c1.party_code like case when @strStatusID = 'CLIENT' then @strStatusName else '%' end and  
 len(ltrim(rtrim(isnull(c1.party_code, '')))) > 0  
group by   
 c1.party_code  
order by  
 c1.party_code

GO
