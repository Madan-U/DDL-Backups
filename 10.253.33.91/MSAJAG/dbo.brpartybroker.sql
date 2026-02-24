-- Object: PROCEDURE dbo.brpartybroker
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brpartybroker    Script Date: 3/17/01 9:55:46 PM ******/

/****** Object:  Stored Procedure dbo.brpartybroker    Script Date: 3/21/01 12:50:02 PM ******/

/****** Object:  Stored Procedure dbo.brpartybroker    Script Date: 20-Mar-01 11:38:45 PM ******/

/****** Object:  Stored Procedure dbo.brpartybroker    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brpartybroker    Script Date: 12/27/00 8:58:45 PM ******/

CREATE PROCEDURE brpartybroker
@subbroker varchar(15),
@br varchar(3)
AS
select c2.party_code,s.sub_broker 
from client1 c1, client2 c2, subbrokers s, branches b
where c2.cl_code=c1.cl_code and b.short_name = c1.trader and 
s.sub_broker=@subbroker and c1.sub_broker=s.sub_broker and b.branch_cd=@br
order by c2.party_code

GO
