-- Object: PROCEDURE dbo.UK
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

Create Proc UK
as


CREATE 
Clustered  INDEX [Cl_inx] ON [dbo].[Client_Brok_Details] ([Cl_Code], [Status], [Imp_Status])

CREATE 
Clustered INDEX [Cl_Inx] ON [dbo].[Client_Details] ([cl_code], [Status], [Imp_Status])

Exec Add_Client_Share_Proc_Update 'NSE','FUTURES','%','0','ZZZZZZZZZZ','May 27 2006  5:01:35:153PM','May 27 2006  5:16:47:013PM'

GO
