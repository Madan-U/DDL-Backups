-- Object: PROCEDURE dbo.GenSubBillno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.GenSubBillno    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.GenSubBillno    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.GenSubBillno    Script Date: 20-Mar-01 11:38:51 PM ******/

/****** Object:  Stored Procedure dbo.GenSubBillno    Script Date: 2/5/01 12:06:13 PM ******/

/****** Object:  Stored Procedure dbo.GenSubBillno    Script Date: 12/27/00 8:59:07 PM ******/

CREATE PROCEDURE GenSubBillno (@Sett_no varchar(7),@sett_Type varchar(2)) AS 
declare @@PartiPantCode varchar(15),
        @@BillNo varchar(7),
        @@PartiPantCodeCont Cursor    
set @@PartiPantCodeCont = cursor for 
                 select PartiPantCode from TrdBackUp
   where Sett_no = @Sett_no and sett_type = @Sett_type  
                 group by PartiPantCode 
                 open @@PartiPantCodeCont
fetch next from @@PartiPantCodeCont into @@PartiPantCode
select @@Billno = 0
while @@fetch_status = 0
begin
 select @@BillNo = Convert(int,@@BillNo) + 1   
        update TrdBackUp set billno = @@Billno where Sett_no = @Sett_no and sett_type = @Sett_type 
 and PartiPantCode = @@PartiPantCode
 fetch next from @@PartiPantCodeCont into @@PartiPantCode
end
close @@PartiPantCodeCont
deallocate @@PartiPantCodeCont

GO
