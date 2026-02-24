-- Object: PROCEDURE dbo.Usp_GetPartyCodeInfo_NXT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
  
  
--Server:- AngelNseCM  
--Database :- msajag  
  
--select top 1000 Party_code,l_city,l_state  
--from msajag.dbo.client_details a   
--where party_code='ALWR1937'  
  
CREATE procedure [dbo].[Usp_GetPartyCodeInfo_NXT]  
(  
@Partycode varchar(100)  
)  
as  
begin  
  
--EXEC Usp_GetPartyCodeInfo_NXT 'ALWR1937'  
--EXEC Usp_GetPartyCodeInfo_NXT 'ALWR2144'  
  
  
select Party_code,long_name,l_city,l_state,mobile_pager  
into #test  
from msajag.dbo.client_details a   
where party_code=@Partycode--'ALWR1937'  
UNION  
select Party_code,long_name,l_city,l_state,mobile_pager  
from INTRANET.risk.dbo.client_details a   
where party_code=@Partycode--'ALWR1937'  
  
  
  
  
alter table #test  
add gross_income varchar(100)  
  
alter table #test  
add occupation varchar(100)  
  
update #test set gross_income=a.GROSS_INCOME from msajag.dbo.CLIENT_MASTER_UCC_DATA a  with (nolock) right outer join #test t  
on a.PARTY_CODE=t.party_code  
  
update #test set gross_income=DESCRIPTION from msajag.dbo.CLIENT_STATIC_CODES a   with (nolock)  right outer join #test t  
on a.code=t.gross_income collate database_default WHERE CATEGORY ='INCOMESLAB_NONIND'AND kra_type='CDSL'   
  
update #test set occupation=a.occupation from  msajag.dbo.CLIENT_MASTER_UCC_DATA a with (nolock)  right outer join #test t  
on a.PARTY_CODE=t.party_code  
  
update #test set occupation=DESCRIPTION from msajag.dbo.CLIENT_STATIC_CODES a  with (nolock)  right outer join #test t  
on a.code=t.occupation collate database_default WHERE CATEGORY LIKE '%OCCUPATION%' AND kra_type='CDSL'  
  
  
select   
Party_code,long_name,l_city,l_state,mobile_pager,gross_income,isnull(occupation,'Other') occupation  
  
 from #test   
where party_code=@Partycode  
  
drop table #test  
  
  
END

GO
