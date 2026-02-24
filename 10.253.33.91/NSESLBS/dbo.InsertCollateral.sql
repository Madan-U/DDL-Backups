-- Object: PROCEDURE dbo.InsertCollateral
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc InsertCollateral  
(@Exchange Varchar(5),  
 @Segment Varchar(8),  
 @ShareDate Varchar(11),  
 @TransNo Int,  
 @Qty Int,  
 @DrCr Varchar(1),  
 @DpID Varchar(8),  
 @CltDpId Varchar(16),  
 @DpType Varchar(4),  
 @Scrip_CD Varchar(12),  
 @Series Varchar(3),  
 @IsIn Varchar(12),  
 @BDpId Varchar(8),  
 @BCltDpID Varchar(16),  
 @BDpType Varchar(4)) 
As  
  
Insert into C_SecuritiesMstTemp Values (@Exchange,@Segment,'','PARTY',@DpId,@CltDpId,@DpType,'SEC',@IsIn,@Scrip_Cd,@Series,  
@Qty,@DrCr,@TransNo,@ShareDate,@BDpId,@BCltDpId,@BDpType,1,GetDate(),1,'From DP File',1,'','',GetDate(),'N','Party','','','','')

GO
