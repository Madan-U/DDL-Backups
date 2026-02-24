-- Object: PROCEDURE dbo.BankDetAcNmPsP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BankDetAcNmPsP    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.BankDetAcNmPsP    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.BankDetAcNmPsP    Script Date: 20-Mar-01 11:38:43 PM ******/

/****** Object:  Stored Procedure dbo.BankDetAcNmPsP    Script Date: 2/5/01 12:06:06 PM ******/

/****** Object:  Stored Procedure dbo.BankDetAcNmPsP    Script Date: 12/27/00 8:58:43 PM ******/

CREATE PROCEDURE BankDetAcNmPsP
 AS
select distinct acname
 from acmast  
 where accat= '2'
order by acname

GO
