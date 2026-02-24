-- Object: PROCEDURE dbo.shdeposit
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.shdeposit    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.shdeposit    Script Date: 3/21/01 12:50:30 PM ******/

/****** Object:  Stored Procedure dbo.shdeposit    Script Date: 20-Mar-01 11:39:09 PM ******/

/****** Object:  Stored Procedure dbo.shdeposit    Script Date: 2/5/01 12:06:28 PM ******/

/****** Object:  Stored Procedure dbo.shdeposit    Script Date: 12/27/00 8:59:03 PM ******/

CREATE PROCEDURE shdeposit
AS
select c.party_code,convert(varchar,date,103),c.scrip_cd, 
c.series, c.qty,c.fromno,c.tono,c.reason,c.certno,c.foliono,c.holdername,
demat=isnull((select distinct scrip_cd from scrip2 s2, scrip1 s1 where s1.demat_date<=getdate() 
and s1.co_code=s2.co_code and s2.scrip_cd=c.scrip_cd ),'')
from certinfo c where sett_type='no' and sett_no=0 
order by scrip_cd, series, party_code

GO
