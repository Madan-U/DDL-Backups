-- Object: VIEW citrus_usr.Vw_delivery_dp_BKP_02032023
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------


Create View [citrus_usr].[Vw_delivery_dp_BKP_02032023]

as



select dptype,dpid,dpcltno,description,accounttype,exchange,segment  from  (

select * from [196.1.115.197].msajag.dbo.Deliverydp  with(nolock) 

union all 

select * from [196.1.115.197].bsedb.dbo.Deliverydp  with(nolock)

 )A

GO
