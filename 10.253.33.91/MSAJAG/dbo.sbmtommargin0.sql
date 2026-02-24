-- Object: PROCEDURE dbo.sbmtommargin0
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbmtommargin0    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbmtommargin0    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbmtommargin0    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbmtommargin0    Script Date: 2/5/01 12:06:25 PM ******/

/****** Object:  Stored Procedure dbo.sbmtommargin0    Script Date: 12/27/00 8:59:15 PM ******/

/***   file: mragin0.asp 
       report : mtom   ***/
CREATE PROCEDURE
sbmtommargin0
@subbroker varchar(15)
AS
select m.party_code,m.short_name,m.clsdiff,m.grossamt
 from tblmtomdetail m,client2 c2,client1 c1 ,subbrokers sb
where m.party_code=c2.party_code and c2.cl_code =c1.cl_code and c2.exposure_lim = 0
and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker  and m.clsdiff < -10000 
order by m.clsdiff

GO
