-- Object: PROCEDURE dbo.sbnextl
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbnextl    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbnextl    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.sbnextl    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.sbnextl    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbnextl    Script Date: 12/27/00 8:59:01 PM ******/

CREATE PROCEDURE sbnextl
@broker varchar(15),
@settno varchar(7)
 AS
select distinct  sett_no,sett_no+1 from settlement sett ,client1 c1,client2 c2,subbrokers sb
where c1.cl_code=c2.cl_code and c1.sub_broker=sb.sub_broker and c2.party_code=sett.party_code
and sb.sub_broker=ltrim(@broker) and sett.sett_no=ltrim(@settno)
order by sett_no

GO
