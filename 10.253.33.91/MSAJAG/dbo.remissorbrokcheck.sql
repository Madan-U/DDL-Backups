-- Object: PROCEDURE dbo.remissorbrokcheck
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.remissorbrokcheck    Script Date: 05/20/2002 2:25:52 PM ******/
CREATE proc remissorbrokcheck 
@sett_no varchar(7),
@tosett_no varchar(7),
@sett_type varchar(2),
@scrip_cd varchar (12),
@party_code varchar (10)


as

select R.Party_code,Short_Name,scrip_cd,Series,Broker=sum(newbrokerage),Client=sum(oldbrokerage),
Remissor=sum(oldbrokerage-newbrokerage),r.sett_no,r.sett_type
from remissorvalan r, Client1 C1, Client2 C2

where C1.Cl_Code = C2.Cl_Code
And C2.Party_Code = R.Party_Code

And sett_no >= @sett_no and sett_no <= @tosett_no and sett_type = @sett_type
and scrip_cd like @scrip_cd
and R.Party_code like @party_code


group by R.party_code,Short_Name,scrip_cd,Series,r.sett_no,r.sett_type
order by r.sett_no,r.sett_type,R.party_code,Short_Name,scrip_cd,Series

GO
