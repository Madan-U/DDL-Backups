-- Object: PROCEDURE dbo.V2_Offline_Master_Check
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC V2_offline_master_check
AS

-----------------------------------
-- Now Checking & Updating State
-----------------------------------

  SET TRANSACTION ISOLATION LEVEL READ Uncommitted
  SELECT Branch_cd,
         Party_code,
         L_city,
         L_state
  FROM   Client_details_uppili
  WHERE  L_state NOT IN (SELECT State
                         FROM   State_master (Nolock ))

-----------------------------------
-- Now Checking & Updating Region
-----------------------------------

  SET TRANSACTION ISOLATION LEVEL READ Uncommitted
  SELECT Du.Branch_cd,
         Du.Party_code,
         Du.Region
  FROM   Client_details_uppili Du
         LEFT OUTER JOIN Region R
                      ON (R.Branch_code = Du.Branch_cd)
  WHERE  ISNULL(R.Regioncode,
                '') = ''
          OR ISNULL(Du.Region,
                    '') = ''

GO
