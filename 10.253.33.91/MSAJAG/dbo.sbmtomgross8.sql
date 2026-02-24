-- Object: PROCEDURE dbo.sbmtomgross8
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbmtomgross8    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomgross8    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomgross8    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomgross8    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomgross8    Script Date: 12/27/00 8:59:15 PM ******/

/*** file :gross8.asp
     report : mtom   ***/
CREATE PROCEDURE
sbmtomgross8
@subbroker varchar(15)
 AS
select m.party_code,m.short_name,m.clsdiff,m.grossamt 
from tblmtomdetail m,client2 c2,client1 c1 ,subbrokers sb
where m.party_code=c2.party_code and c2.cl_code =c1.cl_code  and sb.sub_broker=@subbroker and c1.sub_broker=sb.sub_broker 
and
(m.grossamt > 8 * c2.exposure_lim) and c2.exposure_lim <> 0 
order by m.grossamt desc

GO
