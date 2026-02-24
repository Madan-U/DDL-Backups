-- Object: PROCEDURE dbo.Sp_Addclient_Execute
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

--insert into clientmaster select * from gunavatta.msajag.dbo.clientmaster
 /****** Object:  Stored Procedure Dbo.Sp_Addclient_Execute    Script Date: 01/15/2005 4:39:23 Pm ******/  
  
  
/****** Object:  Stored Procedure Dbo.Sp_Addclient_Execute    Script Date: 12/16/2003 2:21:39 Pm ******/  
  
Create Proc Sp_Addclient_Execute  
@Strsql Varchar(8000)  
As  
 Print @Strsql  
 Exec (@Strsql)

GO
