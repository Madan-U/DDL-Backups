-- Object: PROCEDURE dbo.sbshdeposit
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbshdeposit    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbshdeposit    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbshdeposit    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbshdeposit    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbshdeposit    Script Date: 12/27/00 8:59:01 PM ******/

/*** file :positionreport.asp
     report :client position 
displays details of asettlement for a particular client
**/
/* displays total buy and sell (qty and amt) of a particular subbroker till today */
CREATE PROCEDURE sbshdeposit
@subbroker varchar(15)
AS
select c.party_code,convert(varchar,date,103),c.scrip_cd, 
c.series, c.qty,c.fromno,c.tono,c.reason,c.certno,c.foliono,c.holdername,
demat=isnull((select distinct scrip_cd from scrip2 s2, scrip1 s1 where s1.demat_date<=getdate() 
and s1.co_code=s2.co_code and s2.scrip_cd=c.scrip_cd ),'')
from certinfo c , client1 c1, client2 c2, subbroker sb  where sett_type='no' and sett_no=0 and
c1.cl_code=c2.cl_code and c.party_code=c2.party_code and sb.sub_broker=c1.sub_broker 
and sb.sub_broker=@subbroker
order by scrip_cd, series, party_code

GO
