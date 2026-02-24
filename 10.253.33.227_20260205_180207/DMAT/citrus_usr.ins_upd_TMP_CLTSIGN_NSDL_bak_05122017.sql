-- Object: PROCEDURE citrus_usr.ins_upd_TMP_CLTSIGN_NSDL_bak_05122017
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

create    procedure [citrus_usr].[ins_upd_TMP_CLTSIGN_NSDL_bak_05122017]          
(          
  @TMPSIGN_REF_NO varchar(50),  
  @TMPSIGN_HLDR_IND varchar(50),          
  @TMPSIGN_AUTH_NM varchar(8),          
  @TMPSIGN_SBA_NO varchar(135),          
  @cli_image     varbinary(max)         
 
)          
AS          
    
BEGIN    

insert into TMP_CLTSIGN_NSDL values ( @TMPSIGN_REF_NO,@TMPSIGN_HLDR_IND,@TMPSIGN_AUTH_NM,@TMPSIGN_SBA_NO,@cli_image)
end

GO
