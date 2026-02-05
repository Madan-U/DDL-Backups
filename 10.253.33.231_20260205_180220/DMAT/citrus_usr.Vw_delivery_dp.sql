-- Object: VIEW citrus_usr.Vw_delivery_dp
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------


CREATE View [citrus_usr].[Vw_delivery_dp]

as



select dptype,dpid,dpcltno,description,accounttype,exchange,segment  from  (

select * from ANGELDEMAT.msajag.dbo.Deliverydp  with(nolock) 

union all 

select * from ANGELDEMAT.bsedb.dbo.Deliverydp  with(nolock)

 )A

GO
