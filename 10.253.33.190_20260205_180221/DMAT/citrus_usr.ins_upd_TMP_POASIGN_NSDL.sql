-- Object: PROCEDURE citrus_usr.ins_upd_TMP_POASIGN_NSDL
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


CREATE procedure [citrus_usr].[ins_upd_TMP_POASIGN_NSDL]          
(          
  @TMPSIGN_REF_NO varchar(50),  
  @TMPSIGN_HLDR_IND varchar(50),          
  @TMPSIGN_AUTH_NM varchar(8),          
  @TMPSIGN_SBA_NO varchar(20),          
  @cli_image     varbinary(max)         
 
)          
AS          
    
BEGIN    

insert into TMP_POASIGN_NSDL values ( @TMPSIGN_REF_NO,@TMPSIGN_HLDR_IND,@TMPSIGN_AUTH_NM,@TMPSIGN_SBA_NO,@cli_image)
end

GO
