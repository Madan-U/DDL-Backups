-- Object: PROCEDURE dbo.COLBONUS
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC COLBONUS        
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
       
SELECT @SCRIP_CD = SCRIP_CD, @SERIES = SERIES FROM MULTIISIN WHERE ISIN = @ISIN AND VALID = 1 
        
insert into C_SecuritiesMst        
select @Exchange, @Segment, '', @PARTY_CODE, @BDpId, @BCltDpId, @BDpType, 'SEC', @ISIN, @SCRIP_CD, @SERIES, @QTY, 'C', '0', @TransDate,
   @BDpId, @BCltDpId, @BDpType, '1', Getdate(), '1', @REMARK, '1', '', @RecType, GetDate(), 'N', 'Party', '', '', '', ''

GO
