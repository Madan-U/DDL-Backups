-- Object: PROCEDURE dbo.Usp_Amd_sb_client_details_Insert
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


CREATE procedure Usp_Amd_sb_client_details_Insert
as
begin


select * into #sb_client_details from [172.31.16.95].NXT.dbo.sb_client_details A with(nolock) 


INSERT INTO [sb_client_details] 
select A.* from #sb_client_details A
left join [sb_client_details] B  with(nolock) 
ON A.party_code=B.party_code 
where B.party_code is null

Drop table #sb_client_details 

END

GO
