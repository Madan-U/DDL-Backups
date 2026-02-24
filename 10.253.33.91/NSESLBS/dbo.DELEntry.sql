-- Object: PROCEDURE dbo.DELEntry
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC DELEntry  
@SETT_NO VARCHAR(7),    
@SETT_TYPE VARCHAR(2),    
@REFNO INT,    
@PARTY_CODE VARCHAR(10),    
@SCRIP_CD VARCHAR(12),    
@SERIES VARCHAR(3),     
@DpType Varchar(4),  
@DpId Varchar(8), 
@CltDpId Varchar(16),  
@QTY INT,    
@ISIN VARCHAR(12),    
@REMARK VARCHAR(50),    
@TransDate Varchar(11),    
@BDPTYPE VARCHAR(4),    
@BDPID VARCHAR(8),    
@BCLTDPID VARCHAR(16),    
@RecType Varchar(10)     
AS     
    
DECLARE   
@MEMBERCODE VARCHAR(15)  
    
SELECT @MEMBERCODE = MEMBERCODE FROM OWNER    
    
If @DpType Is Null   
 Select @DpType = ''  
  
If @DpId Is Null   
 Select @DpId = ''  
  
If @CltDpId Is Null   
 Select @CltDpId = ''  
  
insert into deltrans    
select @SETT_NO,@SETT_TYPE,@REFNO,'0',904,@PARTY_CODE,@SCRIP_CD,@SERIES,@QTY,'0','0',@ISIN,'0',@REMARK,@REMARK,'C',    
'0',@Qty, @DpType, @DpId, @CltDpId,'HO',@MEMBERCODE,'0','0','','','DEMAT',@TransDate,@RecType,1,'',@BDpType,@BDpId,@BCltDpId,'',''    
    
insert into deltrans    
select @SETT_NO,@SETT_TYPE,@REFNO,'0',904,@PARTY_CODE,@SCRIP_CD,@SERIES,@QTY,'0','0',@ISIN,'0',@REMARK,@REMARK,'D',    
'0',@Qty,@DpType, @DpId, @CltDpId,'HO',@MEMBERCODE,'0','0','','','DEMAT',@TransDate,@RecType,1,'',@BDpType,@BDpId,@BCltDpId,'',''

GO
