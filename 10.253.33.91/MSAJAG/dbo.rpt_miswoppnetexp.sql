-- Object: PROCEDURE dbo.rpt_miswoppnetexp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_miswoppnetexp    Script Date: 04/27/2001 4:32:44 PM ******/

/****** Object:  Stored Procedure dbo.rpt_miswoppnetexp    Script Date: 3/21/01 12:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_miswoppnetexp    Script Date: 20-Mar-01 11:39:00 PM ******/



/*  report : misnews
     file : topclient_scripsett.asp
     calculates net exposure of a client for opposite saudas
*/

CREATE PROCEDURE rpt_miswoppnetexp

@wsettno varchar(7),
@clcode varchar(10)

as

select sell_buy, cl_code, netexp=sum(rate*tradeqty) from albmhist 
where sett_no=@wsettno and ser <> '01' and cl_code=@clcode
group by sett_no , cl_code, sell_buy

GO
