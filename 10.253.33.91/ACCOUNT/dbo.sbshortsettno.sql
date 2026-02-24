-- Object: PROCEDURE dbo.sbshortsettno
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbshortsettno    Script Date: 01/04/1980 1:40:43 AM ******/



/****** Object:  Stored Procedure dbo.sbshortsettno    Script Date: 11/28/2001 12:23:52 PM ******/

/****** Object:  Stored Procedure dbo.sbshortsettno    Script Date: 29-Sep-01 8:12:07 PM ******/

/****** Object:  Stored Procedure dbo.sbshortsettno    Script Date: 8/8/01 1:37:33 PM ******/

/****** Object:  Stored Procedure dbo.sbshortsettno    Script Date: 8/7/01 6:03:53 PM ******/

/****** Object:  Stored Procedure dbo.sbshortsettno    Script Date: 7/8/01 3:22:51 PM ******/

/****** Object:  Stored Procedure dbo.sbshortsettno    Script Date: 2/17/01 3:34:18 PM ******/


/****** Object:  Stored Procedure dbo.sbshortsettno    Script Date: 20-Mar-01 11:43:36 PM ******/

CREATE PROCEDURE sbshortsettno 
@subbroker varchar(15)
as
select distinct d.sett_no  from deliveryclt d ,subbrokers sb,client1 c1,client2 c2
where sb.sub_broker =@subbroker and sb.sub_broker=c1.sub_broker and d.party_code=c2.party_code and 
c1.cl_code=c2.cl_code
order by sett_no

GO
