-- Object: PROCEDURE dbo.brshdeposit
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brshdeposit    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brshdeposit    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brshdeposit    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brshdeposit    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brshdeposit    Script Date: 12/27/00 8:58:46 PM ******/

/* report : Shares deposited
file : shdeposit
displays list of shares deposited with us in advance
*/
CREATE PROCEDURE brshdeposit
@br varchar(3)
AS
select c.party_code,convert(varchar,date,103),c.scrip_cd, 
c.series, c.qty,c.fromno,c.tono,c.reason,c.certno,c.foliono,c.holdername,
demat=isnull((select distinct scrip_cd from scrip2 s2, scrip1 s1 where s1.demat_date<=getdate() 
and s1.co_code=s2.co_code and s2.scrip_cd=c.scrip_cd ),'')
from certinfo c , client1 c1, client2 c2, branches b  where sett_type='no' and sett_no=0 and
c1.cl_code=c2.cl_code and c.party_code=c2.party_code and b.short_name=c1.trader 
and b.branch_cd=@br 
order by c.scrip_cd, c.series, c.party_code

GO
