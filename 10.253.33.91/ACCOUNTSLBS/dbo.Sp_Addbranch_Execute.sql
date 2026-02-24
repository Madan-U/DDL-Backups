-- Object: PROCEDURE dbo.Sp_Addbranch_Execute
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

--insert into delsegment select * from gunavatta.msajag.dbo.delsegment
  /****** Object:  Stored Procedure Dbo.Sp_Addbranch_Execute    Script Date: 01/15/2005 4:39:22 Pm ******/  
  
  
/****** Object:  Stored Procedure Dbo.Sp_Addbranch_Execute    Script Date: 12/16/2003 2:21:39 Pm ******/  
  
  
Create Proc Sp_Addbranch_Execute  
@Strsql Varchar(8000)  
As  
 Print @Strsql  
 Exec (@Strsql)

GO
