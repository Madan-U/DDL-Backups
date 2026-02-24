-- Object: PROCEDURE citrus_usr.PR_INS_ROLC
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_INS_ROLC]
AS
BEGIN
--
   DECLARE @@C_ROLES           CURSOR
         , @@C_MDTRY           CURSOR
         , @@C_DISABLE         CURSOR
         , @@C_SCRC_SCR_ID     NUMERIC
         , @@C_SCRC_COMP_ID    NUMERIC
         , @@C_SCRC_COMP_NAME  VARCHAR(50)
         , @@L_MDTRY           NUMERIC
         , @@C_ROL_ID          NUMERIC
   --
   SET @@C_ROLES =  CURSOR FAST_FORWARD FOR
   SELECT ROL_ID
   FROM   ROLES  WITH(NOLOCK)
   WHERE  ROL_DELETED_IND = 1
   --
   OPEN @@C_ROLES
   FETCH NEXT FROM @@C_ROLES INTO @@C_ROL_ID
   --
   WHILE @@FETCH_STATUS = 0
   BEGIN--#C1
   --
     -----MANDARTRY----
     SET @@C_MDTRY =  CURSOR FAST_FORWARD FOR
     SELECT SCRC_SCR_ID
          , SCRC_COMP_ID
          , SCRC_COMP_NAME
     FROM   SCREEN_COMPONENT WITH(NOLOCK)
     WHERE  SCRC_COMP_NAME IN ('CONCM^RES_PH1^S')
     AND    SCRC_DELETED_IND = 1
     --
     OPEN @@C_MDTRY
     FETCH NEXT FROM @@C_MDTRY INTO @@C_SCRC_SCR_ID, @@C_SCRC_COMP_ID, @@C_SCRC_COMP_NAME
     --
     WHILE @@FETCH_STATUS = 0
     BEGIN--#C2
     --
       IF @@C_SCRC_COMP_NAME = 'CONCM^RES_PH1^S'
       BEGIN
       --
         SET @@L_MDTRY = 255
       --
       END
       --
       --
       INSERT INTO roles_components
       ( rolc_rol_id
       , rolc_scr_id
       , rolc_comp_id
       , rolc_mdtry
       , rolc_disable
       , rolc_created_by
       , rolc_created_dt
       , rolc_lst_upd_by
       , rolc_lst_upd_dt
       , rolc_deleted_ind
       )
       VALUES
       ( @@C_ROL_ID
       , @@C_SCRC_SCR_ID
       , @@C_SCRC_COMP_ID
       , @@L_MDTRY
       , 0
       , USER, GETDATE(), USER, GETDATE(), 1
       )
       --PRINT CONVERT(VARCHAR, @@C_ROL_ID) + '---' + CONVERT(VARCHAR, @@C_SCRC_SCR_ID) + '---' + CONVERT(VARCHAR, @@C_SCRC_COMP_ID)  + '---' + CONVERT(VARCHAR, @@L_MDTRY)
       --
       FETCH NEXT FROM @@C_MDTRY INTO @@C_SCRC_SCR_ID, @@C_SCRC_COMP_ID, @@C_SCRC_COMP_NAME
     --
     END  --#C2
     --
     CLOSE @@C_MDTRY
     DEALLOCATE @@C_MDTRY
     -----DISABLE----
     /*SET @@C_SCRC_SCR_ID    = NULL
     SET @@C_SCRC_COMP_ID   = NULL
     SET @@C_SCRC_COMP_NAME = NULL
     --
     SET @@C_disable =  CURSOR FAST_FORWARD FOR
     SELECT scrc_scr_id
           ,scrc_comp_id
           ,scrc_comp_name
     FROM   screen_component
     WHERE  scrc_deleted_ind = 1
     --
     OPEN @@C_disable
     FETCH NEXT FROM @@C_disable INTO @@C_SCRC_SCR_ID, @@C_SCRC_COMP_ID, @@C_SCRC_COMP_NAME
     --
     PRINT 'DISABLE'
     WHILE @@FETCH_STATUS = 0
     BEGIN--#C2
     --
       PRINT CONVERT(VARCHAR, @@C_ROL_ID) + '---' + CONVERT(VARCHAR, @@C_SCRC_SCR_ID) + '---' + CONVERT(VARCHAR, @@C_SCRC_COMP_ID)  + '---' + CONVERT(VARCHAR, @@L_MDTRY)
       --
       FETCH NEXT FROM @@C_disable INTO @@C_SCRC_SCR_ID, @@C_SCRC_COMP_ID, @@C_SCRC_COMP_NAME
     --
     END  --#C2
     --
     CLOSE @@C_disable
     DEALLOCATE @@C_disable*/
     --
     FETCH NEXT FROM @@C_ROLES INTO @@C_ROL_ID
   --
   END  --#C1
   --
   CLOSE @@C_ROLES
   DEALLOCATE @@C_ROLES
--
END

GO
