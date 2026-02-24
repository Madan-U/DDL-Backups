-- Object: PROCEDURE citrus_usr.pr_select_acct
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE  [citrus_usr].[pr_select_acct](@pa_id             VARCHAR(20)
                               ,@pa_acct_type      VARCHAR(20) 
                               ,@pa_tab            VARCHAR(20) 
                               ,@pa_login_name     VARCHAR(25)
                               ,@pa_clisba_id      NUMERIC
                               ,@pa_acct_no        VARCHAR(20)
                               ,@pa_excpm_id       NUMERIC
                               ,@pa_clicm_id       NUMERIC
                               ,@pa_enttm_id       NUMERIC
                               ,@pa_chk_yn         NUMERIC
                               ,@rowdelimiter      CHAR(4)
                               ,@coldelimiter      CHAR(4)
                               ,@pa_ref_cur        VARCHAR(8000) OUT
                                )
                                
                                
AS
/*
*********************************************************************************
 SYSTEM         : CITRUS
 MODULE NAME    : pr_select_acct
 DESCRIPTION    : This procedure will select data related to client_account
 COPYRIGHT(C)   : Marketplacetechnologies pvt ltd
 VERSION HISTORY:
 VERS.  AUTHOR             DATE        REASON
 -----  -------------      ----------  -------------------------------------------------
 1.0    TUSHAR             04-MAY-2007 INITIAL VERSION.
--------------------------------------------------------------------------------------*/
BEGIN
--
  print 'pending'
--
END

GO
