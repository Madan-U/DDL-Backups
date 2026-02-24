-- Object: PROCEDURE citrus_usr.pr_upd_fingroup_priority
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create PROCEDURE [citrus_usr].[pr_upd_fingroup_priority]
AS
BEGIN
--
		SET NOCOUNT ON
		DECLARE	@level int
									, @line char(20)
									, @@priorctr int
									, @current char(20)
									
		SET @current = 1
		
		CREATE TABLE #stack
		(item char(20)
		, level int
		,Group_code int NULL
		,Subgroup_code int NULL
		,Group_name varchar(100) NULL
		,Subgroup_name varchar(100) NULL
		)
		INSERT INTO #stack 
		(item
		,level
		) 
		VALUES
		(@current
		, 1
		)
		
		SELECT @level = 1
		SELECT @@priorctr = 0
		
		WHILE @level > 0
		BEGIN
		--
				IF EXISTS (SELECT * FROM #stack WHERE level = @level)
				BEGIN
    --
						SELECT @current = item
						FROM #stack
						WHERE level = @level
										
						SET @@priorctr = @@priorctr + 1
							
						Update fin_group_trans
						SET fingt_reclevel= @level where fingt_sub_group_code=@current AND fingt_deleted_ind = 1
						
						Update fin_group_trans
						SET fingt_prority= @@priorctr where fingt_sub_group_code=@current AND fingt_deleted_ind = 1

						DELETE FROM #stack
						WHERE level = @level
						AND item = @current
						
					 INSERT #stack
						SELECT fingt_sub_group_code
												, @level + 1
												,fingt_group_code
												,fingt_sub_group_code
												,fingt_group_name
												,fingt_sub_group_name
						FROM fin_group_trans
						WHERE fingt_group_code = @current
							
						IF @@ROWCOUNT > 0
						BEGIN
						--
								SELECT @level = @level + 1
						--							
						END
				--
				END
				ELSE
				BEGIN
				--
							SELECT @level = @level - 1
				--
						END
	--		
	END         
--
END

GO
