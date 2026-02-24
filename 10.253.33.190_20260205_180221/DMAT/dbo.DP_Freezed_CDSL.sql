-- Object: PROCEDURE dbo.DP_Freezed_CDSL
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

  CREATE PROCEDURE  [dbo].[DP_Freezed_CDSL] 
 as
Select Distinct BOID,	freezeid,	FreezeIniDt,	FreezeIniBy,	FreezeStatus,	FreezeRmks  into #Freezed_Not_Seeded from [10.253.33.189].DMAT.citrus_usr.DPS8_pC4  WITH (NOLOCK)   where 
FreezeStatus ='A'

insert into #Freezed_Not_Seeded 
Select Distinct BOID,	freezeid,	FreezeIniDt,	FreezeIniBy,	FreezeStatus,	FreezeRmks   from  citrus_usr.DPS8_pC4 WITH (NOLOCK)   where 
FreezeStatus ='A'
 
  
insert into #Freezed_Not_Seeded 
Select Distinct BOID,	freezeid,	FreezeIniDt,	FreezeIniBy,	FreezeStatus,	FreezeRmks   from [10.253.33.227].DMAT.citrus_usr.DPS8_pC4 WITH (NOLOCK)  where 
FreezeStatus ='A'
 

Select client_code ,nise_party_code,FIRST_HOLD_PAN, SECOND_HOLD_ITPAN, THIRD_HOLD_ITPAN  into #DP from [10.253.33.189].DMAT.DBO.tbl_client_master WITH (NOLOCK)   where client_code in   (select BOID from  #Freezed_Not_Seeded )

insert into #DP
Select client_code, nise_party_code,FIRST_HOLD_PAN, SECOND_HOLD_ITPAN, THIRD_HOLD_ITPAN   from  tbl_client_master WITH (NOLOCK)  where client_code in   (select BOID from  #Freezed_Not_Seeded )
 
 insert into #DP
Select client_code, nise_party_code,FIRST_HOLD_PAN, SECOND_HOLD_ITPAN, THIRD_HOLD_ITPAN   from [10.253.33.227].DMAT.DBO.tbl_client_master WITH (NOLOCK)  where client_code in   (select BOID from  #Freezed_Not_Seeded )
 
 
delete from [10.253.65.29].[UCC_Data].[dbo].[freezed_all]

 insert  into   [10.253.65.29].[UCC_Data].[dbo].[freezed_all]
select fre.*, nise_party_code,FIRST_HOLD_PAN, SECOND_HOLD_ITPAN, THIRD_HOLD_ITPAN   from #Freezed_Not_Seeded  fre left outer join  #DP d on fre.BOID =d.client_code

GO
