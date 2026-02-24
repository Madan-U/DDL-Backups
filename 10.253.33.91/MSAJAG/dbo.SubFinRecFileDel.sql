-- Object: PROCEDURE dbo.SubFinRecFileDel
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SubFinRecFileDel    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.SubFinRecFileDel    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.SubFinRecFileDel    Script Date: 20-Mar-01 11:39:11 PM ******/

/****** Object:  Stored Procedure dbo.SubFinRecFileDel    Script Date: 2/5/01 12:06:30 PM ******/

/****** Object:  Stored Procedure dbo.SubFinRecFileDel    Script Date: 12/27/00 8:59:04 PM ******/

CREATE procedure SubFinRecFileDel ( @settno  varchar (7) , @sett_type char(2) ) as
Exec SubFinRecFile  @settno,@sett_type  
drop table SubFinRecPos
select  sett_no ,sett_type , scrip_cd , series , partiPantCode,abs(sum(pqty)-sum(sqty)) 'tradeqty',inout = case
  when (sum(pqty)-sum(sqty)) > 0
  then
  "O"
    when (sum(pqty)-sum(sqty))< 0
     then 
  "I"
    else
  "N"
    end
into SubFinRecPos 
 from SubFinRec where sett_no = @settno and sett_Type =  @sett_type  
Group By sett_no ,sett_type , scrip_cd , series , PartiPantCode

GO
