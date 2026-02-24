-- Object: PROCEDURE dbo.BBGAdjBalCursor2001
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BBGAdjBalCursor2001    Script Date: 01/04/1980 1:40:35 AM ******/



/****** Object:  Stored Procedure dbo.BBGAdjBalCursor2001    Script Date: 11/28/2001 12:23:40 PM ******/

/****** Object:  Stored Procedure dbo.BBGAdjBalCursor2001    Script Date: 29-Sep-01 8:12:02 PM ******/

/****** Object:  Stored Procedure dbo.BBGAdjBalCursor2001    Script Date: 8/8/01 1:37:29 PM ******/

/****** Object:  Stored Procedure dbo.BBGAdjBalCursor2001    Script Date: 8/7/01 6:03:47 PM ******/
/****** Object:  Stored Procedure dbo.BBGAdjBalCursor    Script Date: 7/8/01 3:22:48 PM ******/

/****** Object:  Stored Procedure dbo.BBGAdjBalCursor    Script Date: 2/17/01 3:34:13 PM ******/


/****** Object:  Stored Procedure dbo.BBGAdjBalCursor    Script Date: 20-Mar-01 11:43:32 PM ******/

/* this procedure is used to adjust the balances of the parties datewise  */
CREATE PROCEDURE  BBGAdjBalCursor2001 AS
declare    @@code varchar(12),
@@tcltcodecur cursor    
set @@tcltcodecur = cursor for 
                 select distinct cltcode from ledger 
                 open @@tcltcodecur
fetch next  from @@tcltcodecur into   @@code
while   @@fetch_status =0
begin
         exec spadjbalcursor2001 @@code
         fetch next  from @@tcltcodecur into   @@code
end
close @@tcltcodecur
deallocate @@tcltcodecur

GO
