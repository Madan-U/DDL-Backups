-- Object: PROCEDURE citrus_usr.pr_insert_actions
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_insert_actions]
AS
BEGIN
--
  DECLARE CR_SCREENS_RECORD CURSOR FOR
  SELECT SCR_ID, SCR_CREATED_BY
  FROM   SCREENS
  WHERE  SCR_DELETED_IND = 1

  DECLARE @l_counter    NUMERIC
  , @l_act_cd     VARCHAR(25)
         , @l_act_desc   VARCHAR(200)
         , @l_scr_id     NUMERIC
         , @l_user VARCHAR(25)
         , @L_ACT_ID     NUMERIC

  SET @L_COUNTER = 1

  OPEN CR_SCREENS_RECORD
  FETCH NEXT FROM CR_SCREENS_RECORD INTO @L_scr_id , @L_USER
  WHILE (@@FETCH_STATUS <> -1)
  BEGIN
  --
    WHILE @L_COUNTER<>5
    BEGIN
    --
      SELECT @L_ACT_CD = CASE @L_COUNTER  WHEN 1 THEN 'READ'
                                          WHEN 2 THEN 'WRITE'
                                          WHEN 3 THEN 'PRINT'
                                          WHEN 4 THEN 'EXPORT' end
--                                          END
      SELECT @L_ACT_DESC = CASE @L_ACT_CD WHEN 'READ'  THEN 'This action allows the user to read'
                                          WHEN 'WRITE' THEN 'This action allows the user to write'
                                          WHEN 'PRINT' THEN 'This action allows the user to print'
                                          WHEN 'EXPORT'THEN 'This action allows the user to export' end

      SELECT @L_ACT_ID = ISNULL(MAX(ACT_ID),0)+1 FROM ACTIONS

      INSERT INTO ACTIONS
      ( act_id
      , act_cd
      , act_scr_id
      , act_desc
      , act_created_by
      , act_created_dt
      , act_lst_upd_by
      , act_lst_upd_dt
      , act_deleted_ind
      )
      VALUES
      ( @L_ACT_ID
      , @L_ACT_CD
      , @L_SCR_ID
      , @L_ACT_DESC
      , @L_USER, GETDATE(),@L_USER, GETDATE(), 1)
      --
      SET @L_COUNTER =@L_COUNTER + 1

    --
    END
    FETCH NEXT FROM CR_SCREENS_RECORD INTO @L_scr_id , @L_USER
    SET @L_COUNTER = 1
  --
  END
  CLOSE CR_SCREENS_RECORD
  DEALLOCATE CR_SCREENS_RECORD
--
END

GO
