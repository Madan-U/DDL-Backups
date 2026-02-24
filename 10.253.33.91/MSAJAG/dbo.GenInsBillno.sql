-- Object: PROCEDURE dbo.GenInsBillno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.GenInsBillno    Script Date: 3/17/01 9:55:52 PM ******/

/****** Object:  Stored Procedure dbo.GenInsBillno    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.GenInsBillno    Script Date: 20-Mar-01 11:38:51 PM ******/

/****** Object:  Stored Procedure dbo.GenInsBillno    Script Date: 2/5/01 12:06:13 PM ******/

/****** Object:  Stored Procedure dbo.GenInsBillno    Script Date: 12/27/00 8:59:07 PM ******/

CREATE PROCEDURE GenInsBillno (@Sett_no varchar(7),@sett_Type varchar(2)) AS 
declare @@Party varchar(12),
        	@@BillNo varchar(7),
        	@@PartyCont Cursor    
	
	set @@PartyCont = cursor for 
	select Party_Code from ISettlement
   	where Sett_no = @Sett_no and sett_type = @Sett_type  
	group by Party_Code
	
	open @@PartyCont
	fetch next from @@PartyCont into @@Party
	select @@Billno = 0
	
	while @@fetch_status = 0
	begin
 		select @@BillNo = Convert(int,@@BillNo) + 1   
        		update Isettlement set billno = @@Billno where Sett_no = @Sett_no and sett_type = @Sett_type 
 		and Party_code = @@Party
 		fetch next from @@PartyCont into @@Party
	end
	close @@PartyCont
	deallocate @@PartyCont

GO
