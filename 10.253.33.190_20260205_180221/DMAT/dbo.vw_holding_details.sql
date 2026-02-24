-- Object: VIEW dbo.vw_holding_details
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


Create view vw_holding_details
as 
select BOID= hld_ac_code,
Scrip_Name =SecurityName,
ISIN=hld_isin_code,
QTY=free_qty,
rate,
Valuation,
HOLDINGDT,
Party_code=tradingid  
 from dmat.citrus_usr.holding h (nolock)
where isnull(tradingid,'')<>''

GO
