-- Object: PROCEDURE dbo.Rpt_dateclosingrate
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_dateclosingrate    
@scripcdfrom Varchar(12),    
@scripcdto Varchar(12),    
@sdate Varchar(14)    
As    
Select Market ,scrip_cd,series,cl_rate   From Closing
Where Scrip_cd between @scripcdfrom and @scripcdto
And convert(varchar,sysdate,103) = @sdate    
Order By Scrip_cd, series

GO
