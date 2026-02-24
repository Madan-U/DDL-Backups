-- Object: PROCEDURE dbo.PremiumCalculation_NSe
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





CREATE PROCEDURE PremiumCalculation_NSe (@saudadatefrom varchar(10), @saudadateto varchar(10))  AS

Select
/* left(convert(varchar,sauda_date,105),10),*/
party_code,
/*inst_type,
symbol,
option_type,
strike_price,
markettype,*/
isnull(sum(PremiumReceivable),0) PremiumReceivable,
 isnull(sum(PremiumPayable),0) PremiumPayable,
isnull(Sum(NetPremium),0) NetPremium,
/*sec_name,*/
isnull(sum(pqty),0) pqty,
isnull(sum(sqty),0) sqty
from PremiumCalView
where 
left (convert(datetime,sauda_date,105),10) >= left(convert(datetime,@saudadatefrom,105),10)
and left (convert(datetime,sauda_date,105),10) <=  left(convert(datetime,@saudadateto,105),10)
/*group by left(convert(varchar,sauda_date,105),10),party_code,inst_type,symbol,option_type,strike_price,markettype,sec_name*/
group by party_code

GO
