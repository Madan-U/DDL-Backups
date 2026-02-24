-- Object: PROCEDURE dbo.COLENTRY
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC COLENTRY  
@Sno Numeric(18,0),  
@Exchange Varchar(3),          
@Segment Varchar(20),          
@PARTY_CODE VARCHAR(10),          
@SCRIP_CD VARCHAR(12),          
@SERIES VARCHAR(3),          
@ISIN VARCHAR(20),          
@QTY Numeric(10),          
@REMARK VARCHAR(50),          
@TransDate Varchar(11),     
@DPTYPE VARCHAR(4),  
@DPID VARCHAR(8),  
@CLTDPID VARCHAR(16),  
@BDPTYPE VARCHAR(4),  
@BDPID VARCHAR(8),  
@BCLTDPID VARCHAR(16),  
@DrCr Varchar(1),  
@RecType Varchar(10)  
AS          
         
SELECT @SCRIP_CD = SCRIP_CD, @SERIES = SERIES FROM MULTIISIN WHERE ISIN = @ISIN AND VALID = 1   

if @RecType = 'ENTRY' 
begin
	IF LEN(LTRIM(RTRIM(@PARTY_CODE))) = 0 
		SELECT @PARTY_CODE = 'Party'
	
	IF (SELECT ISNULL(COUNT(1),0) FROM C_SecuritiesMstDemat WHERE EXCHANGE = @EXCHANGE AND SEGMENT = @SEGMENT 
	    AND Bankdpid = @DpId AND Dp_Acc_Code = @CltDpId
	    AND ISIN = @ISIN AND EFFDATE LIKE @TransDate + '%' AND DRCR = @DRCR AND TRANS_CODE = @SNO
	    AND B_Bankdpid = @BDpId AND B_Dp_Acc_Code = @BCltDpId) = 0
	BEGIN 
		IF (SELECT ISNULL(COUNT(1),0) FROM C_SecuritiesMst WHERE EXCHANGE = @EXCHANGE AND SEGMENT = @SEGMENT 
		    AND Bankdpid = @DpId AND Dp_Acc_Code = @CltDpId
		    AND ISIN = @ISIN AND EFFDATE LIKE @TransDate + '%' AND DRCR = @DRCR AND TRANS_CODE = @SNO
		    AND B_Bankdpid = @BDpId AND B_Dp_Acc_Code = @BCltDpId) = 0
		BEGIN
			Insert Into C_SecuritiesMstDemat          
			Select @Exchange, @Segment, '', @PARTY_CODE, @DpId, @CltDpId, @DpType, 'SEC', @ISIN, @SCRIP_CD, @SERIES, 
			@QTY, @DrCr, @Sno, @TransDate, @BDpId, @BCltDpId, @BDpType, '1', Getdate(), '1', @REMARK, '1', '', 
			@RecType, GetDate(), 'N', 'Party', '', '', '', ''
		END
	END
END
ELSE
BEGIN
	Insert Into C_SecuritiesMst
	Select @Exchange, @Segment, '', @PARTY_CODE, @DpId, @CltDpId, @DpType, 'SEC', @ISIN, @SCRIP_CD, @SERIES, 
	@QTY, @DrCr, @Sno, @TransDate, @BDpId, @BCltDpId, @BDpType, '1', Getdate(), '1', @REMARK, '1', '', 
	@RecType, GetDate(), 'N', 'Party', '', '', '', ''
END

GO
