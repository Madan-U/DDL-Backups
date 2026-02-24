-- Object: PROCEDURE dbo.RMS_data_without_MTF
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE Proc [dbo].[RMS_data_without_MTF]
as
DECLARE @vdt varchar(20)
SELECT @vdt = CONVERT(VARCHAR(11),MIN(sdtcur),106) FROM parameter WITH(NOLOCK)
WHERE curyear=1

select cltcode,Amount=sum(Amount)
from
(
select cltcode,sum(case when drcr='D' Then Vamt*-1 else Vamt End) Amount
from ledger_all with (nolock)
where vdt>=@vdt group by cltcode
)a group by cltcode

GO
