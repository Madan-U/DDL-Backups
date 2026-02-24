-- Object: PROCEDURE dbo.Delivery_MultiClientID
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

--EXEC Delivery_MultiClientID '0','zzz'  
CREATE PROC Delivery_MultiClientID    
(  
 @Del_CodeFROM VARCHAR(10),  
 @Del_CodeTO   VARCHAR(10)  
   
)  
AS  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
IF @Del_CodeFROM = '' BEGIN SET @Del_CodeFROM = '0' END  
IF @Del_CodeTO = '' BEGIN SET @Del_CodeTO = 'ZZZ' END  
  
BEGIN  
 Select   
   Party_Code,Cltdpno,Dpid,Introducer,Dptype,(Case When Def = 1 Then 'Default' Else null End) as Def
 From   
  MultiCltId (nolock)  
 Where   
  Party_Code >= @Del_CodeFROM 
  And Party_Code <= @Del_CodeTO  
END

GO
