-- Object: PROCEDURE dbo.SpBrokslab
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SpBrokslab    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.SpBrokslab    Script Date: 3/21/01 12:50:31 PM ******/

/****** Object:  Stored Procedure dbo.SpBrokslab    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.SpBrokslab    Script Date: 2/5/01 12:06:28 PM ******/

/****** Object:  Stored Procedure dbo.SpBrokslab    Script Date: 12/27/00 8:59:04 PM ******/

CREATE PROCEDURE   SpBrokslab ( @startamt numeric (13, 2) , @EndAmt numeric (13,2)  ,@slab1 varchar (2), @slab2 varchar(2)   ) AS
select party_code,Short_name,tran_cat,Amount = sum(amount),table_no,sub_tableno,newTable_no = @slab2,NewSub_TableNo=@slab1 from brokslab 
where table_no  not like ( @slab1)  and table_no  not like ( @slab2)  group by party_code , short_name ,tran_cat, table_no,sub_tableno 
having sum(amount) > @startamt and 
sum(amount) <=( case when  @endamt <> 0 then @endamt else 9999999999999 end )

GO
