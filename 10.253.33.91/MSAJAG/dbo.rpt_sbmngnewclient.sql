-- Object: PROCEDURE dbo.rpt_sbmngnewclient
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_sbmngnewclient    Script Date: 04/27/2001 4:32:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbmngnewclient    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbmngnewclient    Script Date: 20-Mar-01 11:39:02 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbmngnewclient    Script Date: 2/5/01 12:06:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbmngnewclient    Script Date: 12/27/00 8:58:57 PM ******/

/* report : misnews
   file : newclients.asp
*/
CREATE PROCEDURE 
rpt_sbmngnewclient
@subbroker varchar(15)
 AS
 select distinct t.party_code from trade4432 t,client1 c1,client2 c2,subbrokers sb
 where t.party_code not in (select party_code from client2) 
and c1.cl_code=c2.cl_code and sb.sub_broker=c1.sub_broker and sb.sub_broker=@subbroker

GO
