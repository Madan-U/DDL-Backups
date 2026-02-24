-- Object: PROCEDURE dbo.rpt_wopp
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_wopp    Script Date: 04/27/2001 4:32:51 PM ******/

/****** Object:  Stored Procedure dbo.rpt_wopp    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.rpt_wopp    Script Date: 20-Mar-01 11:39:04 PM ******/







/* report : misnews
    file : detailgrossexp.asp
    finds opposite entries for  current w type (including series '01')
*/

CREATE PROCEDURE rpt_wopp 
@clcode varchar(10),
@settno varchar(7)


as



select  amt=sum(tradeqty*rate) ,  tradeqty=sum(tradeqty), sell_buy, scrip_cd, series, ser  from albmhistsett where cl_code=@clcode and sett_no=@settno  
group by cl_code,scrip_cd,sell_buy, series,ser

GO
