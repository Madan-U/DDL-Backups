-- Object: PROCEDURE citrus_usr.pr_select_acct_mstr
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_select_acct_mstr](@pa_id          VARCHAR(20)
                                     ,@pa_action      VARCHAR(20)
                                     ,@pa_login_name  VARCHAR(20)
                                     ,@pa_cd          VARCHAR(20)
                                     ,@pa_desc        VARCHAR(200)
                                     ,@pa_rmks        VARCHAR(200)
                                     ,@pa_values      VARCHAR(8000)
                                     ,@rowdelimiter   CHAR(4) = '*|~*'
                                     ,@coldelimiter   CHAR(4) = '|*~|'
                                     ,@pa_ref_cur     VARCHAR(20) output
                               )
  AS
  /*******************************************************************************
   System         : CLASS
   Module Name    : PR_SELECT_ACCT_MSTR
   Description    : Script to select data from the master tables
   Copyright(c)   : ENC Software Solutions Pvt. Ltd.
   Version History:
   Vers.  Author          Date         Reason
   -----  -------------   ----------   ------------------------------------------------
   1.0    Tushar          09-05-2007  Initial Version.
  **********************************************************************************/
    --
    --
  BEGIN
    --
    IF @pa_action = 'BITRM_ACCP_SEL' 
    BEGIN
    --
     SELECT  bitrm.bitrm_parent_cd      bitrm_parent_cd
           , bitrm.bitrm_child_cd       bitrm_child_cd
           , bitrm.bitrm_values         bitrm_values
      FROM   bitmap_ref_mstr            bitrm
      WHERE  bitrm.bitrm_deleted_ind  = 1
      AND    bitrm.bitrm_tab_type    IN ('ACCPM', 'ACCDM');
    --
    END 
    --
  
  END

GO
