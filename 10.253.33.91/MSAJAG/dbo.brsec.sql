-- Object: PROCEDURE dbo.brsec
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brsec    Script Date: 3/17/01 9:55:47 PM ******/

/****** Object:  Stored Procedure dbo.brsec    Script Date: 3/21/01 12:50:03 PM ******/

/****** Object:  Stored Procedure dbo.brsec    Script Date: 20-Mar-01 11:38:46 PM ******/

/****** Object:  Stored Procedure dbo.brsec    Script Date: 2/5/01 12:06:09 PM ******/

/****** Object:  Stored Procedure dbo.brsec    Script Date: 12/27/00 8:58:45 PM ******/

CREATE PROCEDURE brsec
@settno varchar(7),
@setttype varchar(3)
AS
select Sec_Payin,Sec_Payout 
from sett_mst, client1 c1, client2 c2, branches b 
where sett_No =@settno and sett_type=@setttype

GO
