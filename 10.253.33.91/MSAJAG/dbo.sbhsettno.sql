-- Object: PROCEDURE dbo.sbhsettno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbhsettno    Script Date: 3/17/01 9:56:07 PM ******/

/****** Object:  Stored Procedure dbo.sbhsettno    Script Date: 3/21/01 12:50:26 PM ******/

/****** Object:  Stored Procedure dbo.sbhsettno    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sbhsettno    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbhsettno    Script Date: 12/27/00 8:59:00 PM ******/

/*** file :hispositionmain.asp
     report :: history positon   ***/
CREATE PROCEDURE sbhsettno 
@subbroker varchar(15)
 AS
select distinct sett_no from history h,client1 c1,client2 c2,subbrokers sb
where c1.cl_code=c2.cl_code and c2.party_code=h.party_code and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
 group by sett_no

GO
