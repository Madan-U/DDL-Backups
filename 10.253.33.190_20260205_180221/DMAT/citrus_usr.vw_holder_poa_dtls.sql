-- Object: VIEW citrus_usr.vw_holder_poa_dtls
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE  view vw_holder_poa_dtls 
as
select distinct pc1.boid , 'Y' firstholderexists ,case when isnull(mainpc5.HolderNum,'') = '1' then 'Y' else 'N' end firstholderPOAExist
,case when isnull(pc2.Name,'') <> '' then 'Y' else 'N' end SecondHolderExist
, case when isnull(holderpc5.HolderNum,'') = '2' then 'Y' else 'N' end SecondHolderPOAExist
, case when isnull(pc3.Name,'') <> '' then 'Y' else 'N' end ThirdHolderExist
, case when isnull(holderpc5.HolderNum,'') = '3' then 'Y' else 'N' end ThirdHolderPOAExist
  from dps8_pc1  pc1 with(nolock)
left outer join dps8_pc2 pc2 with(nolock) on pc1.boid = pc2.boid and isnull(pc2.TypeOfTrans,'')<>'3'
left outer join dps8_pc3 pc3 with(nolock) on pc1.boid = pc3.boid and isnull(pc3.TypeOfTrans,'')<>'3'
left outer join dps8_pc5 mainpc5 with(nolock) on pc1.boid = mainpc5.boid and isnull(mainpc5.TypeOfTrans,'')<>'3' and mainpc5.HolderNum in (1)
and mainpc5.MasterPOAId in ('2201090400000015',
'2201090700000014',
'2201090900000017',
'2201091000000018',
'2201091900000015',
'2201091900000021',
'2201092400000011',
'2201092600000014',
'2201090000000398',
'2201090000000404',
'2201090000000423',
'2201090000000438'
)
left outer join dps8_pc5 holderpc5 with(nolock) on pc1.boid = holderpc5.boid and isnull(holderpc5.TypeOfTrans,'')<>'3' and holderpc5.HolderNum in (2,3)
and holderpc5.MasterPOAId in ('2201090400000015',
'2201090700000014',
'2201090900000017',
'2201091000000018',
'2201091900000015',
'2201091900000021',
'2201092400000011',
'2201092600000014',
'2201090000000398',
'2201090000000404',
'2201090000000423',
'2201090000000438'
)

where BOAcctStatus ='1'
and case when isnull(pc2.Name,'') <> '' then 'Y' else 'N' end ='Y'

GO
