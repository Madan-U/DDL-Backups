-- Object: PROCEDURE dbo.insertnodel
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.insertnodel    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.insertnodel    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.insertnodel    Script Date: 20-Mar-01 11:38:51 PM ******/

/****** Object:  Stored Procedure dbo.insertnodel    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.insertnodel    Script Date: 12/27/00 8:58:51 PM ******/

create procedure insertnodel
@srno int,
@scrip_cd char(12) ,
@series char(6) ,
@sett_no varchar(10),
@sett_type varchar(2),
@start_date smalldatetime ,
@end_date smalldatetime ,
@settledin char(9) 
as 
insert into nodel values(@srno,@scrip_cd,@series,@sett_no,@sett_type,@start_date,@end_date,@settledin)

GO
