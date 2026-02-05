-- Object: TABLE citrus_usr.followup_no
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[followup_no]
(
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [date] DATETIME NULL,
    [count_no] VARCHAR(8000) NULL,
    [followupNo] NUMERIC(18, 0) NULL
);

GO
