-- Object: PROCEDURE dbo.sbmtomlist
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbmtomlist    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomlist    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomlist    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomlist    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbmtomlist    Script Date: 12/27/00 8:59:15 PM ******/

/*** FILE :LIST.Asp
     report : mtom  ***/
CREATE PROCEDURE
sbmtomlist
@subbroker varchar(15)
 AS
select  distinct m.party_code,m.short_name,m.clsdiff,m.grossamt,c2.exposure_lim,m.LedgerAmt
 from tblmtomdetail m,client2 c2,client1 c1 ,subbrokers sb
where m.party_code=c2.party_code and c2.cl_code =c1.cl_code 
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@subbroker  and m.clsdiff <= -10000 
order by m.clsdiff

GO
