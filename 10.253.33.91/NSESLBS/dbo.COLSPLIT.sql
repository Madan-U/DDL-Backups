-- Object: PROCEDURE dbo.COLSPLIT
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROC COLSPLIT  
@Exchange Varchar(3),      
@Segment Varchar(20),      
@REFNO INT,      
@PARTY_CODE VARCHAR(10),      
@SCRIP_CD VARCHAR(12),      
@SERIES VARCHAR(3),      
@QTY Numeric(10),      
@ISIN VARCHAR(20),      
@REMARK VARCHAR(50),      
@TransDate Varchar(11),      
@BDPTYPE VARCHAR(4),      
@BDPID VARCHAR(8),      
@BCLTDPID VARCHAR(16),      
@RecType Varchar(10)      
AS

DECLARE @DPTYPE VARCHAR(4),      
        @DPID VARCHAR(8),      
        @CLTDPID VARCHAR(16)

DECLARE @MEMBERCODE VARCHAR(15)      
SELECT @DpId = '', @CltDpId = '', @DpType = ''
      
SELECT @MEMBERCODE = MEMBERCODE FROM OWNER      
SELECT @DpId = BankId, @CltDpId = CltDpId, @DpType = Depository
From Client4 Where Party_Code = @Party_Code And DefDP = 1 

Insert Into C_SecuritiesMst      
Select @Exchange, @Segment, '', @PARTY_CODE, @BDpId, @BCltDpId, @BDpType, 'SEC', @ISIN, @SCRIP_CD, @SERIES, @QTY, 'D', '0', @TransDate,  
@BDpId, @BCltDpId, @BDpType, '1', Getdate(), '1', @REMARK, '1', '', @RecType, GetDate(), 'N', 'Party', '', '', '',''

--select top  1* from c_securitiesmst

GO
